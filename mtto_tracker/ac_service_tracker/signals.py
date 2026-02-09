from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.db.models import F,Sum
from .models import OrderPartsUsed, OrderLaborLog, WorkOrders, Bills, Services, EmployeeInvoices, Leads, Clients, Employees
from datetime import date, timedelta
import calendar

def get_pay_period(d):
    """Retorna (period_start, period_end) para la quincena de la fecha d"""
    if d.day <= 15:
        start = d.replace(day=1)
        end = d.replace(day=15)
    else:
        start = d.replace(day=16)
        # Last month's day
        last_day = calendar.monthrange(d.year, d.month)[1]
        end = d.replace(day=last_day)
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
        rate = instance.technician.employee_hourly_rate
        OrderLaborLog.objects.filter(pk=instance.pk).update(hourly_rate_at_time=rate)
        instance.hourly_rate_at_time = rate
    
    if order:
        total = OrderLaborLog.objects.filter(work_order=order).aggregate(
        total=Sum(F('hours_worked') * F('hourly_rate_at_time'))
        )['total'] or 0
    
        order.total_labor_cost = total
        order.save(update_fields=['total_labor_cost'])

@receiver(post_save, sender=Services)
def update_inspection_fee_in_bill(sender, instance,**kwargs):
    bill = Bills.objects.filter(service=instance.id).first()
    try:
        if instance.status.lower() == 'approved' :

            if not bill:
                Bills.objects.create(
                    service=instance, 
                    client=instance.client, 
                    service_fee=instance.cost, 
                    status='Unpaid')
            else:
                if bill.service_fee != instance.cost:
                    bill.service_fee = instance.cost
                    bill.save(update_fields=['service_fee'])
        elif instance.status.lower() in ['pending','rejected']:
            if bill:
                bill.delete()

    except Bills.DoesNotExist:
            print("Error")
    except Exception as e:
            print(f"Unexpected error Bill: {e}")

@receiver(post_save, sender=WorkOrders)
def update_bill_totals_on_order_change(sender, instance, **kwargs):
    order = instance
    try:
        bill = Bills.objects.filter(work_order=order).first()
        if bill:
            bill.total_labor_cost = order.total_labor_cost
            bill.total_parts_cost = order.total_parts_cost
            bill.save(update_fields=['total_labor_cost', 'total_parts_cost'])

        if order.status.lower() == 'completed':
            completion_date = instance.completed_date or date.today()
            p_start, p_end = get_pay_period(completion_date)
            logs = OrderLaborLog.objects.filter(work_order=order, employee_invoice__isnull=True,technician__isnull=False)

            for log in logs:

                #Create Invoice
                invoice, created = EmployeeInvoices.objects.get_or_create(
                    employee=log.technician,
                    status='Draft',
                    period_start=p_start,
                    period_end=p_end,
                    defaults={
                    'notes': f"Factura acumulativa quincena {p_start} al {p_end}"
                    })
                log.employee_invoice = invoice
                log.save(update_fields=['employee_invoice'])

                totales_invoice = OrderLaborLog.objects.filter(employee_invoice=invoice).aggregate(
                    h_total=Sum('hours_worked'),
                    p_total=Sum(F('hours_worked') * F('hourly_rate_at_time'))
                )

                total_hours = totales_invoice['h_total'] or 0
                total_money = totales_invoice['p_total'] or 0

                if total_hours > 0:
                    sql_rate = total_money / total_hours
                else:
                    sql_rate = instance.technician.employee_hourly_rate

                invoice.total_hours_worked = total_hours
                invoice.employee_hourly_rate = sql_rate
                invoice.save(update_fields=['total_hours_worked','employee_hourly_rate'])

    except Bills.DoesNotExist:
            print("Error Bills")

    except Exception as e:
        print(f"Error updating bill totals: {e}")

@receiver(post_save, sender=Leads)
def create_bill_on_lead_conversion(sender, instance, created, **kwargs):

    try:
        if instance.status.lower() == 'scheduled':
            services_cost = {
                'inspection': 40.00,
                'installation': 150.00,
                'maintenance': 20.00
            }
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
                    'cost': services_cost.get(instance.service_type.lower()),
                    'notes': f"Provisional - Lead ID: {instance.id}. Call to confirm."
                }
            )

            if s_created:
                new_note = f"\nClient {client.id} created/linked."
                Leads.objects.filter(pk=instance.pk).update(notes=instance.notes + new_note)
                
            return
        
    except Exception as e:
        print(f"Error creating client on lead conversion: {e}")