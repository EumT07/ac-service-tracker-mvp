from django.contrib import admin
from .models import Clients, Employees, ClientEquipment, EquipmentFailures, WorkOrders, Services,OrderPartsUsed, OrderLaborLog, Leads, Bills, EmployeeInvoices
# Register your models here.
class OrderPartsInline(admin.TabularInline):
    model = OrderPartsUsed
    extra = 1
    readonly_fields = ('display_line_total',)

    @admin.display(description='Subtotal', ordering='line_total')
    def display_line_total(self, obj):
        if not obj.id or obj.quantity is None or obj.unit_price is None:
            return "$0.00"
        return f"$ {obj.line_total:,.2f}"

class OrderLaborInline(admin.TabularInline):
    model = OrderLaborLog
    extra = 1
    readonly_fields = ('display_line_total',)

    @admin.display(description='Subtotal', ordering='line_total')
    def display_line_total(self, obj):
        if not obj.id or obj.hours_worked is None or obj.hourly_rate_at_time is None:
            return "$0.00"
        return f"$ {obj.line_total:,.2f}"

class WorkOrderInline(admin.TabularInline):
    model = WorkOrders
    extra = 0
    fields = ['status', 'lead_technician']
    readonly_fields = ['status','lead_technician']
    can_delete = False

class BillsInline(admin.TabularInline):
    model = Bills
    extra = 0
    fields = ['status', 'service_fee', 'total_amount']
    readonly_fields = ['status', 'service_fee', 'total_amount']
    can_delete = False

    @admin.display(description='Total Amount', ordering='total_parts_cost')
    def total_amount(self, obj):
        return f"$ {obj.total_parts_cost + obj.total_labor_cost + obj.service_fee:,.2f}"

@admin.register(Leads)
class LeadsAdmin(admin.ModelAdmin):
    list_display = ('id', 'first_name', 'last_name', 'email', 'phone', 'employee','service_type', 'status')
    search_fields = ('first_name', 'last_name', 'email', 'phone')
    list_display_links = ('id', 'phone')
    list_filter = ('status','service_type')

@admin.register(Clients)
class ClientsAdmin(admin.ModelAdmin):
    list_display = ('id', 'full_name', 'email', 'phone', 'client_type')
    search_fields = ('first_name', 'last_name', 'email', 'phone')
    list_display_links = ('id', 'phone')
    list_filter = ('client_type', 'gender')
    inlines = [WorkOrderInline, BillsInline]

    @admin.display(description='Full Name', ordering='first_name')
    def full_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"

@admin.register(Employees)
class EmployeesAdmin(admin.ModelAdmin):
    readonly_fields = ('role','rate_hourly','cost_services','profit_margin')
    list_display = ('id', 'full_name', 'role','rate_hourly', 'is_active')
    search_fields = ('first_name', 'last_name', 'email')
    list_display_links = ('id', 'role')
    list_filter = ('role', 'is_active')

    @admin.display(description='Full Name', ordering='full name')
    def full_name(self, obj):
        return f"{obj.first_name} {obj.last_name}"
    
    @admin.display(description='Employee Rate', ordering='employee_hourly_rate')
    def rate_hourly(self, obj):
        return f"$ {obj.employee_hourly_rate:,.2f}"
    
    @admin.display(description='Cost Hourly Services', ordering='cost_services')
    def cost_services(self, obj):
        return f"$ {obj.cost_hourly_rate:,.2f}"

    @admin.display(description="Profit Margin", ordering='profit_margin')
    def profit_margin(self,obj):
        if obj.employee_hourly_rate is not None:
            margin = obj.cost_hourly_rate - obj.employee_hourly_rate
            return f"$ {margin:.2f}"
        return "N/A"
    
@admin.register(ClientEquipment)
class ClientEquipmentAdmin(admin.ModelAdmin):
    # 'brand' y 'equipment_type' now are objects
    list_display = ('id', 'client', 'brand', 'equipment_type', 'status')
    # Searching foreign keys __
    search_fields = ('client__first_name', 'brand', 'equipment_type', 'serial_number')
    list_display_links = ('id', 'client')
    list_filter = ('brand', 'equipment_type', 'status')

@admin.register(EquipmentFailures)
class EquipmentFailuresAdmin(admin.ModelAdmin):
    list_display = ('id', 'client_equipment', 'failure_category','failure_description', 'detected_date', 'resolved_date' ,'severity')
    search_fields = ('client_equipment__equipment_name', 'failure_description')
    list_filter = ('failure_category', 'severity', 'detected_date')

@admin.register(WorkOrders)
class WorkOrdersAdmin(admin.ModelAdmin):
    list_display = (
        'code', 'client','scheduled_date','next_work_date', 'total_parts_cost', 'total_labor_cost', 'get_total', 'status'
    )
    # total_cost is readonly  (PostgreSQL)
    readonly_fields = ('total_parts_cost', 'total_labor_cost','get_total')
    search_fields = ('code', 'client__first_name', 'client_equipment__equipment_name')
    list_filter = ('status', 'lead_technician', 'scheduled_date')
    inlines = [OrderPartsInline, OrderLaborInline]

    @admin.display(description='Total Order Cost', ordering='total_parts_cost')
    def get_total(self, obj):
        return f"$ {obj.total_parts_cost + obj.total_labor_cost:,.2f}"

@admin.register(Services)
class ServicesAdmin(admin.ModelAdmin):
    list_display = ('id','client__first_name', 'service_type', 'cost','status', 'is_active' )
    search_fields = ('client__first_name', 'client_equipment__model', 'status')
    list_filter = ('status', 'lead_technician', 'service_date')

@admin.register(Bills)
class BillsAdmin(admin.ModelAdmin):
    list_display = ('id', 'client', 'bill_date', 'total_labor_cost', 'total_parts_cost', 'service_fee', 'total_amount', 'status', 'payment_method')
    readonly_fields = ('total_labor_cost', 'total_parts_cost', 'service_fee', 'total_amount')
    search_fields = ('client__first_name', 'client__last_name', 'id')
    list_filter = ('status', 'payment_method', 'bill_date')

    @admin.display(description='Total Amount', ordering='total_parts_cost')
    def total_amount(self, obj):
        return f"$ {obj.total_parts_cost + obj.total_labor_cost + obj.service_fee:,.2f}"

@admin.register(EmployeeInvoices)
class EmployeeInvoicesAdmin(admin.ModelAdmin):
    list_display = ('id', 'employee', 'payment_date', 'total_payment', 'status', 'payment_reference')
    readonly_fields = ('total_payment',)
    search_fields = ('employee__first_name', 'employee__last_name', 'id')
    list_filter = ('status', 'payment_date')

    @admin.display(description='Total Payment')
    def total_payment(self, obj):    
        return f"$ { (obj.total_hours_worked * obj.employee_hourly_rate )+ obj.bonuses + obj.reimbursements - obj.deductions:,.2f}"