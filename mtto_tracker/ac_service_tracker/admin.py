from django.contrib import admin
from .models import Clients, Users, ClientEquipment, FailureTypes, EquipmentFailures, MaintenanceOrders, MaintenanceTypes, Inspections
# Register your models here.


admin.site.register(Clients)
admin.site.register(Users)
admin.site.register(ClientEquipment)
admin.site.register(FailureTypes)
admin.site.register(EquipmentFailures)
admin.site.register(MaintenanceOrders)
admin.site.register(MaintenanceTypes)
admin.site.register(Inspections)