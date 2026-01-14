from django.contrib import admin
from .models import Clients, Users, ClientEquipment, FailureTypes, EquipmentFailures, MaintenanceOrders, MaintenanceTypes, Inspections
# Register your models here.

@admin.register(Clients)
class ClientsAdmin(admin.ModelAdmin):
    list_display = ('id','first_name', 'last_name', 'email','gender', 'phone', 'client_type')
    search_fields = ('id','first_name', 'last_name', 'email', 'phone')
    list_display_links = ('id','phone')
    list_filter = (
        'client_type',
        'gender'
    )

@admin.register(Users)
class UsersAdmin(admin.ModelAdmin):
    list_display = ('id','first_name', 'last_name', 'email', 'role', 'gender', 'is_active')
    search_fields = ('id', 'first_name', 'last_name', 'email',)
    list_display_links = ('id','role')
    list_filter = (
        'role',
        ('created_at', admin.DateFieldListFilter),
    )

@admin.register(ClientEquipment)
class ClientEquipmentAdmin(admin.ModelAdmin):
    list_display = ('id','client', 'equipment_type', 'brand', 'model', 'serial_number')
    search_fields = ('client__first_name', 'equipment_type', 'brand', 'model', 'serial_number')
    list_display_links = ('id','serial_number','client')
    list_filter = (
        'equipment_type',
        ('created_at', admin.DateFieldListFilter),
    )

@admin.register(FailureTypes)
class FailureTypesAdmin(admin.ModelAdmin):
    list_display = ('id','name','category', 'severity')
    search_fields = ('id','name', 'severity')
    list_display_links = ('id','name')
    list_filter = (
        'category',
        'severity'
    )

@admin.register(EquipmentFailures)
class EquipmentFailuresAdmin(admin.ModelAdmin):
    list_display = ('id','maintenance_order', 'failure_type', 'equipment', 'detected_date', 'resolved_date')
    search_fields = ('id',
                     'equipment__client__first_name','equipment__client__last_name')
    list_display_links = ('id','equipment')
    list_filter = (
        ('failure_type',admin.RelatedOnlyFieldListFilter),
        ('detected_date', admin.DateFieldListFilter),
        ('resolved_date', admin.DateFieldListFilter),
    )

@admin.register(MaintenanceOrders)
class MaintenanceOrdersAdmin(admin.ModelAdmin):
    list_display = ('id','client', 'equipment', 'type', 'scheduled_date', 'status', 'user' )
    search_fields = ('client', 'equipment', 'type', 'status')
    list_display_links = ('id','client')
    list_filter = (
        'status',
        'user',
        ('scheduled_date', admin.DateFieldListFilter),
    )

@admin.register(MaintenanceTypes)
class MaintennanceTypesAdmin(admin.ModelAdmin):
    list_display = ('id','name', 'description', 'code', 'frequency_days')
    search_fields = ('id','name','code')
    list_display_links = ('id','name')
    list_filter = (
        'code',
    )


@admin.register(Inspections)
class InspectionsAdmin(admin.ModelAdmin):
    list_display = ('id','client', 'inspection_date', 'general_notes', 'status','converted_to_maintenance_order', 'user')
    search_fields = ('id','inspection_date', 'client__first_name' ,'user__first_name', 'status')
    list_display_links = ('id','client')
    list_filter = (
        'status',
        'user',
        ('inspection_date', admin.DateFieldListFilter),
    )
