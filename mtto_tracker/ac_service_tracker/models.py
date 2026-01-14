# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models


class ClientEquipment(models.Model):
    id = models.CharField(primary_key=True, max_length=50)
    client = models.ForeignKey('Clients', models.DO_NOTHING)
    equipment_name = models.CharField(max_length=100)
    brand = models.CharField(max_length=100)
    model = models.CharField(max_length=100)
    serial_number = models.CharField(max_length=100, blank=True, null=True)
    equipment_type = models.CharField(max_length=50, blank=True, null=True)
    capacity_btu = models.IntegerField(blank=True, null=True)
    location = models.CharField(max_length=100, blank=True, null=True)
    installation_date = models.DateField(blank=True, null=True)
    warranty_expiration = models.DateField(blank=True, null=True)
    status = models.CharField(max_length=50, blank=True, null=True)
    description = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.client}"

    class Meta:
        managed = False
        db_table = 'client_equipment'

class Clients(models.Model):
    id = models.CharField(primary_key=True, max_length=50)
    first_name = models.CharField(max_length=50, blank=True, null=True)
    last_name = models.CharField(max_length=50, blank=True, null=True)
    email = models.CharField(unique=True, max_length=255, blank=True, null=True)
    gender = models.CharField(max_length=50, blank=True, null=True)
    phone = models.CharField(unique=True, max_length=50)
    address = models.TextField(blank=True, null=True)
    client_type = models.CharField(max_length=50, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

    class Meta:
        managed = False
        db_table = 'clients'

class EquipmentFailures(models.Model):
    id = models.CharField(primary_key=True, max_length=50)
    maintenance_order = models.ForeignKey('MaintenanceOrders', models.DO_NOTHING)
    failure_type = models.ForeignKey('FailureTypes', models.DO_NOTHING)
    equipment = models.ForeignKey(ClientEquipment, models.DO_NOTHING)
    detected_date = models.DateField()
    resolved_date = models.DateField(blank=True, null=True)
    severity_actual = models.CharField(max_length=50, blank=True, null=True)
    repair_notes = models.TextField(blank=True, null=True)
    repair_hours_actual = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"Failure: {self.failure_type} | Order: {self.maintenance_order}"

    class Meta:
        managed = False
        db_table = 'equipment_failures'


class FailureTypes(models.Model):
    id = models.CharField(primary_key=True, max_length=50)
    category = models.CharField(max_length=100)
    name = models.CharField(unique=True, max_length=255)
    severity = models.CharField(max_length=50, blank=True, null=True)
    estimated_repair_hours = models.IntegerField(blank=True, null=True)
    common_causes = models.TextField(blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.category}"

    class Meta:
        managed = False
        db_table = 'failure_types'


class Inspections(models.Model):
    id = models.CharField(primary_key=True, max_length=50)
    client = models.ForeignKey(Clients, models.DO_NOTHING)
    equipment = models.ForeignKey(ClientEquipment, models.DO_NOTHING)
    user = models.ForeignKey('Users', models.DO_NOTHING)
    inspection_date = models.DateField()
    pressure_suction = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    temp_supply = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    temp_return = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    amps_reading = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    general_notes = models.TextField(blank=True, null=True)
    findings_summary = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=50, blank=True, null=True)
    converted_to_maintenance_order = models.OneToOneField('MaintenanceOrders', models.DO_NOTHING, blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"Technician: {self.user}"

    class Meta:
        managed = False
        db_table = 'inspections'


class MaintenanceOrders(models.Model):
    id = models.CharField(primary_key=True, max_length=50)
    client = models.ForeignKey(Clients, models.DO_NOTHING)
    user = models.ForeignKey('Users', models.DO_NOTHING)
    equipment = models.ForeignKey(ClientEquipment, models.DO_NOTHING)
    type = models.ForeignKey('MaintenanceTypes', models.DO_NOTHING)
    status = models.CharField(max_length=50)
    scheduled_date = models.DateField()
    completed_date = models.DateField(blank=True, null=True)
    technician_notes = models.TextField(blank=True, null=True)
    customer_feedback = models.TextField(blank=True, null=True)
    customer_rating = models.IntegerField(blank=True, null=True)
    labor_hours = models.DecimalField(max_digits=5, decimal_places=2, blank=True, null=True)
    labor_cost = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    parts_cost = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    total_cost = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    next_maintenance_date = models.DateField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.type}"

    class Meta:
        managed = False
        db_table = 'maintenance_orders'


class MaintenanceTypes(models.Model):
    id = models.CharField(primary_key=True, max_length=50)
    code = models.CharField(max_length=10)
    name = models.CharField(max_length=100)
    frequency_days = models.IntegerField(blank=True, null=True)
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"{self.name} | {self.code}"

    class Meta:
        managed = False
        db_table = 'maintenance_types'


class Users(models.Model):
    id = models.CharField(primary_key=True, max_length=50)
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    email = models.CharField(unique=True, max_length=255)
    phone = models.CharField(unique=True, max_length=50)
    gender = models.CharField(max_length=50, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    password = models.CharField(max_length=255)
    role = models.CharField(max_length=50, blank=True, null=True)
    hourly_rate = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    is_active = models.BooleanField(blank=True, null=True)
    created_at = models.DateTimeField(blank=True, null=True)
    updated_at = models.DateTimeField(blank=True, null=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

    class Meta:
        managed = False
        db_table = 'users'
