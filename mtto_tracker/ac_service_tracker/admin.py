from django.contrib import admin
from .models import Clients, Users, ClientEquipment, FailureTypes, EquipmentFailures, MaintenanceOrders, MaintenanceTypes, Inspections,EquipmentType,EquipmentBrand,FailureCategory
# Register your models here.


# Master TAbles:
@admin.register(EquipmentType)
class EquipmentTypeAdmin(admin.ModelAdmin):
    list_display = ('name',)

@admin.register(EquipmentBrand)
class EquipmentBrandAdmin(admin.ModelAdmin):
    list_display = ('name',)

@admin.register(FailureCategory)
class FailureCategoryAdmin(admin.ModelAdmin):
    list_display = ('name',)

@admin.register(Clients)
class ClientsAdmin(admin.ModelAdmin):
    list_display = ('id', 'first_name', 'last_name', 'email', 'phone', 'client_type')
    search_fields = ('first_name', 'last_name', 'email', 'phone')
    list_display_links = ('id', 'first_name')
    list_filter = ('client_type', 'gender')

@admin.register(Users)
class UsersAdmin(admin.ModelAdmin):
    list_display = ('id', 'first_name', 'last_name', 'email', 'role', 'is_active')
    search_fields = ('first_name', 'last_name', 'email')
    list_display_links = ('id', 'role')
    list_filter = ('role', 'is_active')

@admin.register(ClientEquipment)
class ClientEquipmentAdmin(admin.ModelAdmin):
    # 'brand' y 'equipment_type' now are objects
    list_display = ('id', 'client', 'equipment_name', 'brand', 'equipment_type', 'status')
    # Searching foreign keys __
    search_fields = ('equipment_name', 'client__first_name', 'brand__name', 'equipment_type__name', 'serial_number')
    list_display_links = ('id', 'equipment_name')
    list_filter = ('brand', 'equipment_type', 'status')

@admin.register(FailureTypes)
class FailureTypesAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'category', 'severity')
    search_fields = ('name', 'category__name', 'severity')
    list_filter = ('category', 'severity')

@admin.register(EquipmentFailures)
class EquipmentFailuresAdmin(admin.ModelAdmin):
    list_display = ('id', 'equipment', 'failure_type', 'detected_date', 'severity_actual')
    search_fields = ('equipment__equipment_name', 'failure_type__name')
    list_filter = ('failure_type__category', 'severity_actual', 'detected_date')

@admin.register(MaintenanceOrders)
class MaintenanceOrdersAdmin(admin.ModelAdmin):
    list_display = ('id', 'client', 'equipment', 'status', 'scheduled_date', 'total_cost', 'user')
    # total_cost is readonly  (PostgreSQL)
    readonly_fields = ('total_cost',)
    search_fields = ('client__first_name', 'equipment__equipment_name', 'status')
    list_filter = ('status', 'user', 'type__name', 'scheduled_date')

@admin.register(MaintenanceTypes)
class MaintenanceTypesAdmin(admin.ModelAdmin):
    list_display = ('code', 'name', 'frequency_days', 'description')
    search_fields = ('code', 'name')
    list_filter = ('name',)

@admin.register(Inspections)
class InspectionsAdmin(admin.ModelAdmin):
    list_display = ('id', 'client', 'equipment', 'status', 'inspection_date', 'user')
    search_fields = ('client__first_name', 'equipment__equipment_name', 'status')
    list_filter = ('status', 'user', 'inspection_date')
