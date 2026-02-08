from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.db.models import F,Sum
from .models import OrderPartsUsed, OrderLaborLog, WorkOrders, Bills, Services, EmployeeInvoices, Leads, Clients


@receiver([post_save, post_delete], sender=OrderPartsUsed)
def update_order_parts_total(sender, instance, **kwargs):
    order = instance.maintenance_order
    
    if order:
        total = OrderPartsUsed.objects.filter(maintenance_order=order).aggregate(
        total=Sum(F('quantity') * F('unit_price'))
        )['total'] or 0
    
        order.total_parts_cost = total
        order.save(update_fields=['total_parts_cost'])

@receiver([post_save, post_delete], sender=OrderLaborLog)
def update_order_labor_total(sender, instance, **kwargs):
    order = instance.maintenance_order
    
    if order:
        total = OrderLaborLog.objects.filter(maintenance_order=order).aggregate(
        total=Sum(F('hours_worked') * F('hourly_rate_at_time'))
        )['total'] or 0
    
        order.total_labor_cost = total
        order.save(update_fields=['total_labor_cost'])

@receiver(post_save, sender=Services)
def update_inspection_fee_in_bill(sender, instance,**kwargs):
    bill = Bills.objects.filter(service=instance.id).first()
    try:
        if instance.status.lower() in ['to maintenance', 'to service'] :
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
        bill = Bills.objects.get(maintenance_order=order)
        if bill:
            bill.total_labor_cost = order.total_labor_cost
            bill.total_parts_cost = order.total_parts_cost
            bill.save(update_fields=['total_labor_cost', 'total_parts_cost'])

        if order.status == 'completed':
            logs_sin_pagar = OrderLaborLog.objects.filter(maintenance_order=order, employee_invoice__isnull=True)

            for log in logs_sin_pagar:
                employee = log.user_id # type: ignore

                invoice, created = EmployeeInvoices.objects.get_or_create(employee=employee,status='draft')
                pay_for_this_log = log.hours_worked * invoice.employee_hourly_rate
                invoice.total_hours_worked += log.hours_worked
                invoice.employee_hourly_rate += pay_for_this_log
                invoice.save(update_fields=['total_hours_worked','employee_hourly_rate'])

                log.employee_invoice = invoice
                log.save(update_fields=['employee_invoice'])

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