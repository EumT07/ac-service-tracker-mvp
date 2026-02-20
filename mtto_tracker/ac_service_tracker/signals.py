from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.db.models import F,Sum
from .models import OrderPartsUsed, OrderLaborLog, WorkOrders, Bills, Services, EmployeeInvoices, Leads, Clients, Employees
from datetime import date, timedelta
import calendar

@receiver(post_save, sender=Leads)
def create_bill_on_lead_conversion(sender, instance, created, **kwargs):
    services_cost = None

    if instance.lead_type.lower() == 'residential':
        services_cost = {
            'inspection': 50.00,
            'installation': 150.00,
            'maintenance': 40.00
        }
    elif instance.lead_type.lower() == 'commercial':
        services_cost = {
            'inspection': 80.00,
            'installation': 220.00,
            'maintenance': 70.00
        }

    try:
        if instance.status.lower() == 'scheduled':

            client, created = Clients.objects.get_or_create(
                email=instance.email,
                defaults={
                    'first_name': instance.first_name,
                    'last_name': instance.last_name,
                    'gender': instance.gender,
                    'phone': instance.phone,
                    'client_type': instance.lead_type
                }
            )
            service, s_created = Services.objects.get_or_create(
                client=client,
                service_type=instance.service_type,
                notes__icontains=f"Lead ID: {instance.id}", 
                defaults={
                    'status': 'Pending',
                    'cost': services_cost.get(instance.service_type.lower()), #type: ignore
                    'notes': f"Provisional - Lead ID: {instance.id}. Call to confirm."
                }
            )

            if s_created:
                new_note = f"\nClient {client.id} created/linked."
                Leads.objects.filter(pk=instance.pk).update(notes=instance.notes + new_note)
                
            return
        
    except Exception as e:
        print(f"Error creating client on lead conversion: {e}")

@receiver(post_save, sender=Services)
def services_update_bill_workOrder(sender, instance,**kwargs):
    bill = None
    work_order = None
    code  = {'installation': 'INST','inspection': 'INSP'}
    
    try:
        work_order = WorkOrders.objects.filter(services=instance).first()
        bill = Bills.objects.filter(service=instance.id).first()
        if instance.status.lower() == 'approved' :

            work_order, wo_created = WorkOrders.objects.get_or_create(
                services=instance,
                defaults={
                    'client': instance.client,
                    'lead_technician': instance.lead_technician,
                    'client_equipment': instance.client_equipment,
                    'code': code.get(instance.service_type.lower(),'PM'),
                    'status': 'Scheduled',
                    'notes': f'Work order for service {instance.id} - {instance.service_type}'
                }
            )

            if not bill:
                Bills.objects.create(
                    service=instance,
                    work_order=work_order,
                    client=instance.client, 
                    service_fee=instance.cost, 
                    status='Unpaid')
            else:
                if bill.service_fee != instance.cost:
                    bill.service_fee = instance.cost
                    bill.save(update_fields=['service_fee'])

        elif instance.status.lower() in ['pending','rejected']:
            if work_order:#type: ignore
                has_labor = OrderLaborLog.objects.filter(work_order=work_order).exists()
                if not has_labor:
                    work_order.delete()

            if bill:
                bill.delete()

    except Bills.DoesNotExist:
            print("Error")
    except Exception as e:
            print(f"Unexpected error Bill: {e}")

def get_pay_period(date):
    """Retorn days to pay period based on day of months."""
    if date.day <= 15:
        start = date.replace(day=1)
        end = date.replace(day=15)
    else:
        start = date.replace(day=16)
        # Last month's day
        last_day = calendar.monthrange(date.year, date.month)[1]
        end = date.replace(day=last_day)
    return start, end

@receiver([post_save, post_delete], sender=OrderPartsUsed)
def update_order_parts_total(sender, instance, **kwargs):
    order = instance.work_order
    
    if order:
        total = OrderPartsUsed.objects.filter(work_order=order).aggregate(
            total=Sum(F('quantity') * F('unit_price'))
        )['total'] or 0
    
        order.total_parts_cost = total
        order.save(update_fields=['total_parts_cost'])

@receiver([post_save, post_delete], sender=OrderLaborLog)
def update_order_labor_total(sender, instance, **kwargs):
    order = instance.work_order

    if not instance.hourly_rate_at_time and instance.technician:
        rate = instance.technician.cost_hourly_rate
        OrderLaborLog.objects.filter(pk=instance.pk).update(hourly_rate_at_time=rate)
        instance.hourly_rate_at_time = rate
    
    if order:
        total = OrderLaborLog.objects.filter(work_order=order).aggregate(
            total=Sum(F('hours_worked') * F('hourly_rate_at_time'))
        )['total'] or 0
    
        order.total_labor_cost = total
        order.save(update_fields=['total_labor_cost'])


@receiver(post_save, sender=WorkOrders)
def update_bill_totals_on_order_change(sender, instance, **kwargs):
    order = instance
    status = order.status.lower()
    try:
        if status in ['in progress', 'completed']:
            bill = Bills.objects.filter(work_order=order).first()
            if bill:
                bill.total_labor_cost = order.total_labor_cost
                bill.total_parts_cost = order.total_parts_cost
                bill.save(update_fields=['total_labor_cost', 'total_parts_cost'])

        if status == 'completed':
            instance.completed_date = date.today()
            instance.save(update_fields=['completed_date'])
            p_start, p_end = get_pay_period(date.today())

            logs = OrderLaborLog.objects.filter(work_order=order)

            for log in logs:
                #Create Invoice
                invoice, created = EmployeeInvoices.objects.get_or_create(
                    employee=log.technician,
                    status='Draft',
                    period_start=p_start,
                    period_end=p_end,
                    defaults={'notes': f"Bills from {p_start} to {p_end}"})

                OrderLaborLog.objects.filter(pk=log.pk).update(employee_invoice=invoice)

                totales_invoice = OrderLaborLog.objects.filter(employee_invoice=invoice).aggregate(
                    h_total=Sum('hours_worked'),
                    p_total=Sum(F('hours_worked') * F('hourly_rate_at_time'))
                )

                total_hours = totales_invoice['h_total'] or 0

                invoice.total_hours_worked = total_hours
                invoice.employee_hourly_rate = log.technician.employee_hourly_rate # type: ignore
                invoice.save(update_fields=['total_hours_worked','employee_hourly_rate'])


    except Bills.DoesNotExist:
            print("Error Bills")

    except Exception as e:
        print(f"Error updating bill totals: {e}")