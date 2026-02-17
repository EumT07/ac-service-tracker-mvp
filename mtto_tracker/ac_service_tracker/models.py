# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
import uuid
from datetime import date
from django.core.validators import MinValueValidator
from choices.choices import ROLE_CHOICES, GENDER_CHOICES, CLIENT_TYPE_CHOICES, EMPLOYEE_STATUS_CHOICES, CLIENT_STATUS_CHOICES, CLIENT_CONDITIONS_CHOICES, EQUIPMENT_BTU_CHOICES, BRANDS_CHOICES, EQUIPMENT_CHOICES,SERVICE_STATUS_CHOICES, SERVICE_TYPE_CHOICES, MAINTENANCE_STATUS_CHOICES, MAINTENANCE_CODE_CHOICES, SEVERITY_CHOICES, CATEGORY_CHOICES, LEADS_STATUS_CHOICES, LEADS_SERVICES_CHOICES, PAYMENT_CHOICES, PAYMENT_METHOD_CHOICES
from decimal import Decimal


class Employees(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    email = models.EmailField(unique=True, max_length=255)
    phone = models.CharField(unique=True, max_length=50)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    password = models.CharField(max_length=255) 
    role = models.CharField(max_length=50, choices=ROLE_CHOICES, default='Technician')
    employee_hourly_rate = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, validators=[MinValueValidator(0)]) # type: ignore
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    @property
    def cost_hourly_rate(self):
        if self.employee_hourly_rate is not None:
            rate_cost_services = (self.employee_hourly_rate * Decimal('0.5')) + self.employee_hourly_rate
            return rate_cost_services


    def __str__(self):
        if self.is_active:
            return f"{self.first_name} {self.last_name} ({self.role})"
        else:
            return f"{self.first_name} {self.last_name} ({self.role}) - Inactive"

    class Meta:
        managed = False
        db_table = 'employees'

class Clients(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    first_name = models.CharField(max_length=50,blank=True, null=True)
    last_name = models.CharField(max_length=50,blank=True, null=True)
    email = models.EmailField(unique=True, max_length=255)
    gender = models.CharField(max_length=50, choices=GENDER_CHOICES)
    phone = models.CharField(unique=True, max_length=50)
    address = models.TextField(blank=True, null=True)
    client_type = models.CharField(max_length=50, choices=CLIENT_TYPE_CHOICES, default='Residential')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name}: {self.phone}"

    class Meta:
        managed = False
        db_table = 'clients'

class EmployeeInvoices(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    employee = models.ForeignKey(Employees, on_delete=models.RESTRICT, db_column='employee_id')
    period_start = models.DateField()
    period_end = models.DateField()
    total_hours_worked = models.DecimalField(max_digits=10, decimal_places=2, default=0.00) # type: ignore
    employee_hourly_rate = models.DecimalField(max_digits=10, decimal_places=2, default=0.00) # type: ignore
    bonuses = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)# type: ignore
    reimbursements = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)# type: ignore
    deductions = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)# type: ignore
    payment_date = models.DateField(null=True, blank=True)
    payment_reference = models.CharField(max_length=100, null=True, blank=True)
    status = models.CharField(max_length=20, choices=EMPLOYEE_STATUS_CHOICES, default='Draft')
    notes = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        managed = False
        db_table = 'employee_invoices'

class ClientEquipment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    client = models.ForeignKey(Clients, on_delete=models.CASCADE, db_column='client_id')
    brand = models.CharField(max_length=100,choices=BRANDS_CHOICES,blank=True, null=True)
    equipment_type = models.CharField(max_length=100,choices=EQUIPMENT_CHOICES,blank=True, null=True)
    model = models.CharField(max_length=100, blank=True, null=True)
    serial_number = models.CharField(max_length=100, blank=True, null=True)
    location = models.CharField(max_length=255, blank=True, null=True)
    installation_date = models.DateField(blank=True, null=True)
    warranty_expiration = models.DateField(blank=True, null=True)
    capacity_btu = models.PositiveIntegerField(blank=True, choices=EQUIPMENT_BTU_CHOICES, null=True)
    status = models.CharField(max_length=50,choices=CLIENT_STATUS_CHOICES, default='Operational')
    equipment_condition = models.CharField(max_length=50, choices=CLIENT_CONDITIONS_CHOICES, default='New')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.client.first_name} {self.client.last_name}: {self.client.phone} | {self.model}"
    
    class Meta:
        managed = False
        db_table = 'client_equipment'

class Services(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    client = models.ForeignKey(Clients, on_delete=models.RESTRICT, db_column='client_id')
    client_equipment = models.ForeignKey(ClientEquipment, on_delete=models.RESTRICT, db_column='client_equipment_id')
    lead_technician = models.ForeignKey(Employees, on_delete=models.RESTRICT, db_column='lead_technician_id')
    service_type = models.CharField(max_length=50, choices=SERVICE_TYPE_CHOICES, default='Inspection')
    service_date = models.DateField(default=date.today)
    status = models.CharField(max_length=50, choices=SERVICE_STATUS_CHOICES, default='Pending')
    notes = models.TextField(blank=True, null=True)
    cost = models.DecimalField(max_digits=10, decimal_places=2, default=40.00)# type: ignore
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Service: {self.service_type} | Client: {self.client.first_name} {self.client.last_name} : {self.client.phone}"

    class Meta:
        managed = False
        db_table = 'services'

class WorkOrders(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    services = models.ForeignKey(Services, on_delete=models.RESTRICT, null=True, blank=True)
    client = models.ForeignKey(Clients, on_delete=models.SET_NULL, null=True, blank=True, db_column='client_id')
    lead_technician = models.ForeignKey(Employees, on_delete=models.RESTRICT, null=True,blank=True, db_column='lead_technician_id')
    client_equipment = models.ForeignKey(ClientEquipment, on_delete=models.CASCADE,null=True,blank=True,db_column='client_equipment_id')
    code = models.CharField(max_length=20, choices=MAINTENANCE_CODE_CHOICES, null=True, blank=True)
    pressure_suction = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    temperature_in = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    temperature_out = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    amps_reading = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    voltage_reading = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    scheduled_date = models.DateField()
    completed_date = models.DateField(null=True, blank=True)
    next_work_date = models.DateField(null=True, blank=True)
    total_parts_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, editable=False) # type: ignore
    total_labor_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, editable=False) # type: ignore
    status = models.CharField(max_length=20, choices=MAINTENANCE_STATUS_CHOICES, default='Scheduled')
    notes = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Order {self.code} for {self.client.first_name} - {self.client_equipment.model}" # type: ignore

    class Meta:
        managed = False
        db_table = 'work_orders'

class OrderPartsUsed(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    work_order = models.ForeignKey(WorkOrders, on_delete=models.CASCADE, db_column='work_order_id')
    part_name = models.CharField(max_length=150)
    quantity = models.DecimalField(max_digits=10, decimal_places=2, default=1.00) # type: ignore
    unit_price = models.DecimalField(max_digits=10, decimal_places=2, default=0.00) # type: ignore
    created_at = models.DateTimeField(auto_now_add=True)

    @property
    def line_total(self):
        if self.quantity is not None and self.unit_price is not None:
            return self.quantity * self.unit_price
        return 0

    class Meta:
        managed = False
        db_table = 'order_parts_used'

class OrderLaborLog(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    work_order = models.ForeignKey(WorkOrders, on_delete=models.CASCADE, db_column='work_order_id')
    technician = models.ForeignKey(Employees, on_delete=models.SET_NULL, null= True,blank=True, db_column='technician_id')
    employee_invoice = models.ForeignKey(EmployeeInvoices, on_delete=models.SET_NULL, null= True,blank=True, db_column='employee_invoice_id')
    hours_worked = models.DecimalField(max_digits=10, decimal_places=2)
    hourly_rate_at_time = models.DecimalField(max_digits=10, decimal_places=2, editable=False)
    labor_description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    @property
    def line_total(self):
        if self.hours_worked is not None and self.hourly_rate_at_time is not None:
            return self.hours_worked * self.hourly_rate_at_time
        return 0
    
    class Meta:
        managed = False
        db_table = 'order_labor_log'

class EquipmentFailures(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    work_order = models.ForeignKey(WorkOrders, on_delete=models.SET_NULL, null=True, blank=True, db_column='work_order_id')
    client_equipment = models.ForeignKey(ClientEquipment, on_delete=models.CASCADE, db_column='client_equipment_id')
    failure_category = models.CharField(max_length=100, choices=CATEGORY_CHOICES, blank=True, null=True)
    failure_description = models.CharField(max_length=100,blank=True, null=True)
    detected_date = models.DateField(default=date.today)
    resolved_date = models.DateField(blank=True, null=True)
    severity = models.CharField(max_length=50, choices=SEVERITY_CHOICES, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    notes = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Falla: {self.failure_category} en {self.client_equipment.model}"

    class Meta:
        managed = False
        db_table = 'equipment_failures'

class Leads(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    employee = models.ForeignKey(Employees, on_delete=models.SET_NULL, null=True, blank=True, db_column='employee_id')
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    gender = models.CharField(max_length=50, choices=GENDER_CHOICES, blank=True, null=True)
    email = models.EmailField(max_length=255)
    phone = models.CharField(max_length=50)
    service_type = models.CharField(max_length=50, choices=LEADS_SERVICES_CHOICES )
    lead_type = models.CharField(max_length=20, choices=CLIENT_TYPE_CHOICES, default='Residential')
    status = models.CharField(max_length=50, choices=LEADS_STATUS_CHOICES, default='New')
    notes = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Lead: {self.first_name} {self.last_name}"

    class Meta:
        managed = False
        db_table = 'leads'

class Bills(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    work_order = models.ForeignKey(WorkOrders, on_delete=models.SET_NULL, null=True, blank=True, db_column='work_order_id')
    service = models.ForeignKey(Services, on_delete=models.SET_NULL, null=True, blank=True, db_column='service_id')
    client = models.ForeignKey(Clients, on_delete=models.SET_NULL, null=True, blank=True,db_column='client_id')
    bill_date = models.DateField(default=date.today)
    total_labor_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0.00) # type: ignore
    total_parts_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0.00) # type: ignore
    service_fee = models.DecimalField(max_digits=10, decimal_places=2, default=0.00) # type: ignore
    status = models.CharField(max_length=50, choices=PAYMENT_CHOICES, default='Unpaid')
    payment_method = models.CharField(max_length=100,choices=PAYMENT_METHOD_CHOICES,blank=True, null=True)
    payment_reference = models.CharField(max_length=100, null=True, blank=True)
    notes = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # @property
    # def total_amount(self):
    #     if self.total_labor_cost is not None and self.total_parts_cost is not None and self.inspection_fee is not None:
    #         return self.total_labor_cost + self.total_parts_cost + self.inspection_fee
    #     return 0

    def __str__(self):
        return f"Bill {self.id}: - {self.client}"
    
    class Meta:
        managed = False
        db_table = 'bills'