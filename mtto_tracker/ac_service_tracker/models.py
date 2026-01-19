# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models
import uuid

# Master Tables
class EquipmentType(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    def __str__(self): return self.name
    class Meta:
        managed = False
        db_table = 'equipment_types'

class EquipmentBrand(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    def __str__(self): return self.name
    class Meta:
        managed = False
        db_table = 'equipment_brands'

class FailureCategory(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=100, unique=True)
    def __str__(self): return self.name
    class Meta:
        managed = False
        db_table = 'failure_categories'

class MaintenanceTypes(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    code = models.CharField(max_length=10, unique=True)
    name = models.CharField(max_length=100)
    frequency_days = models.IntegerField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"{self.name} ({self.code})"

    class Meta:
        managed = False
        db_table = 'maintenance_types'

class Users(models.Model):
    ROLE_CHOICES = [
        ('admin', 'Admin'),
        ('technician', 'Technician'),
        ('operator', 'Operator'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    email = models.EmailField(unique=True, max_length=255)
    phone = models.CharField(unique=True, max_length=50)
    gender = models.CharField(max_length=10, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    password = models.CharField(max_length=255) # Hash de contraseña
    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='technician')
    hourly_rate = models.DecimalField(max_digits=10, decimal_places=2, default=0.00) # type: ignore
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.role})"

    class Meta:
        managed = False
        db_table = 'users'

class Clients(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    email = models.EmailField(unique=True, max_length=255, blank=True, null=True)
    gender = models.CharField(max_length=10, blank=True, null=True)
    phone = models.CharField(unique=True, max_length=50)
    address = models.TextField(blank=True, null=True)
    client_type = models.CharField(max_length=20, default='Residential')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

    class Meta:
        managed = False
        db_table = 'clients'

class ClientEquipment(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    client = models.ForeignKey(Clients, on_delete=models.CASCADE)
    equipment_name = models.CharField(max_length=100)
    brand = models.ForeignKey(EquipmentBrand, on_delete=models.PROTECT)
    equipment_type = models.ForeignKey(EquipmentType, on_delete=models.PROTECT)
    model = models.CharField(max_length=100)
    serial_number = models.CharField(max_length=100, blank=True, null=True)
    capacity_btu = models.IntegerField(blank=True, null=True)
    location = models.CharField(max_length=100, blank=True, null=True)
    installation_date = models.DateField(blank=True, null=True)
    status = models.CharField(max_length=50, default='Operational')
    
    class Meta:
        managed = False
        db_table = 'client_equipment'

class FailureTypes(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    category = models.ForeignKey(FailureCategory, on_delete=models.PROTECT)
    name = models.CharField(unique=True, max_length=255)
    severity = models.CharField(max_length=20)
    estimated_repair_hours = models.DecimalField(max_digits=5, decimal_places=2, default=1.0) #type: ignore
    
    class Meta:
        managed = False
        db_table = 'failure_types'

class MaintenanceOrders(models.Model):
    STATUS_CHOICES = [('scheduled', 'Scheduled'), ('in_progress', 'In Progress'), ('completed', 'Completed'), ('cancelled', 'Cancelled')]
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    client = models.ForeignKey(Clients, on_delete=models.CASCADE)
    user = models.ForeignKey('Users', on_delete=models.PROTECT)
    equipment = models.ForeignKey(ClientEquipment, on_delete=models.CASCADE)
    type = models.ForeignKey('MaintenanceTypes', on_delete=models.PROTECT)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='scheduled')
    scheduled_date = models.DateField()
    labor_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0) # type: ignore
    parts_cost = models.DecimalField(max_digits=10, decimal_places=2, default=0) # type: ignore
    total_cost = models.DecimalField(max_digits=10, decimal_places=2, editable=False)

    class Meta:
        managed = False
        db_table = 'maintenance_orders'

class EquipmentFailures(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    maintenance_order = models.ForeignKey(
        'MaintenanceOrders', 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True
    )
    failure_type = models.ForeignKey(FailureTypes, on_delete=models.PROTECT)
    equipment = models.ForeignKey(ClientEquipment, on_delete=models.CASCADE)
    detected_date = models.DateField(auto_now_add=True)
    resolved_date = models.DateField(blank=True, null=True)
    severity_actual = models.CharField(max_length=50, blank=True, null=True)
    repair_notes = models.TextField(blank=True, null=True)
    repair_hours_actual = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Falla: {self.failure_type.name} en {self.equipment.equipment_name}"

    class Meta:
        managed = False
        db_table = 'equipment_failures'

class Inspections(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('approved', 'Approved'),
        ('rejected', 'Rejected'),
        ('converted', 'Converted to Order'),
    ]

    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    client = models.ForeignKey(Clients, on_delete=models.CASCADE)
    equipment = models.ForeignKey(ClientEquipment, on_delete=models.CASCADE)
    user = models.ForeignKey(Users, on_delete=models.PROTECT)
    inspection_date = models.DateField(auto_now_add=True)
    pressure_suction = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    temp_supply = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    temp_return = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    amps_reading = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    general_notes = models.TextField(blank=True, null=True)
    findings_summary = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=50, choices=STATUS_CHOICES, default='Pending')

    converted_to_maintenance_order = models.OneToOneField(
        'MaintenanceOrders', 
        on_delete=models.SET_NULL, 
        blank=True, 
        null=True,
        related_name='source_inspection'
    )
    
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Inspección {self.id} - {self.equipment}"

    class Meta:
        managed = False
        db_table = 'inspections'