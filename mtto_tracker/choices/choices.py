ROLE_CHOICES = [
        ('Admin', 'Admin'),
        ('Technician', 'Technician'),
        ('Operator', 'Operator'),
        ('Trainer', 'Trainer')
    ]

GENDER_CHOICES = [
        ('Male', 'Male'),
        ('Female', 'Female')
    ]

CLIENT_TYPE_CHOICES = [
        ('Residential', 'Residential'),
        ('Commercial', 'Commercial')
    ]

EMPLOYEE_STATUS_CHOICES = [
        ('Draft', 'Draft'),
        ('Approved', 'Approved'),
        ('Paid', 'Paid'),
        ('Disputed', 'Disputed'),
        ('Cancelled', 'Cancelled')
    ]

CLIENT_STATUS_CHOICES = [
        ('Operational', 'Operational'),
        ('Requires Repair', 'Requires Repair'),
        ('Under Maintenance', 'Under Maintenance'),
        ('Out of Service', 'Out of Service'),
    ]

CLIENT_CONDITIONS_CHOICES = [
        ('New', 'New'),
        ('Refurbished', 'Refurbished'),
        ('Used', 'Used'),
        ('For Parts', 'For Parts'),
    ]

EQUIPMENT_BTU_CHOICES = [
        (9000, '9,000 BTU'),
        (12000, '12,000 BTU'),
        (18000, '18,000 BTU'),
        (24000, '24,000 BTU'),
        (30000, '30,000 BTU'),
        (36000, '36,000 BTU'),
        (48000, '48,000 BTU'),
        (60000, '60,000 BTU'),
    ]

BRANDS_CHOICES = [
        ('Carrier', 'Carrier'),
        ('Trane', 'Trane'),
        ('York', 'York'),
        ('Daikin', 'Daikin'),
        ('Samsung', 'Samsung'),
        ('LG', 'LG'),
        ('McQuay', 'McQuay'),
        ('Lennox', 'Lennox'),
        ('Goodman', 'Goodman'),
        ('Daewoo', 'Daewoo'),
        ('Mitsubishi Electric', 'Mitsubishi Electric'),
        ('Hitachi', 'Hitachi'),
        ('Toshiba', 'Toshiba'),
        ('Rheem', 'Rheem'),
        ('Bryant', 'Bryant'),
        ('Other', 'Other')
    ]

EQUIPMENT_CHOICES = [
        ('Split Wall Mounted', 'Split Wall Mounted'),
        ('Multi-Split', 'Multi-Split'),
        ('Chiller Air Cooled', 'Chiller Air Cooled'), 
        ('Chiller Water Cooled', 'Chiller Water Cooled'),
        ('Package Unit', 'Package Unit'),
        ('Fan Coil Unit', 'Fan Coil Unit'),
        ('Ducted System', 'Ducted System'),
        ('Window Unit', 'Window Unit'),
        ('Portable Unit', 'Portable Unit'),
        ('Central AC System', 'Central AC System'),
        ('Furnace', 'Furnace'),
        ('Heat Pump', 'Heat Pump'),
        ('Ventilation System', 'Ventilation System'),
        ('Dehumidifier', 'Dehumidifier'),
        ('Air Purifier', 'Air Purifier'),
        ('VRF System', 'VRF System'),
        ('Other', 'Other')
    ]

SERVICE_STATUS_CHOICES = [
        ('Pending', 'Pending'),
        ('Approved', 'Approved'),
        ('Rejected', 'Rejected'),
    ]

SERVICE_TYPE_CHOICES = [
        ('Inspection','Inspection' ),
        ('Installation' ,'Installation'),
        ('Maintenance','Maintenance')
    ]

SERVICE_TYPE_COST_CHOICES = [
        (50.00, 'Residential-Ins: $ 50.00'),
        (150.00, 'Residential-Installation: $ 150.00'),
        (40.00, 'Residential-Maintenance: $ 40.00'),
        (80.00, 'Commercial-Ins: $ 80.00'),
        (220.00, 'Commercial-Installation: $ 220.00'),
        (70.00, 'Commercial-Maintenance: $ 70.00')
    ]

MAINTENANCE_STATUS_CHOICES = [
        ('Scheduled', 'Scheduled'), 
        ('In Progress', 'In Progress'), 
        ('Completed', 'Completed'), 
        ('Cancelled', 'Cancelled')
    ]
MAINTENANCE_CODE_CHOICES = [
        ('PM', 'Preventive Maintenance'),
        ('CM', 'Corrective Maintenance'),
        ('PdM', 'Predictive Maintenance'),
        ('INSP', 'Inspection'),
        ('INST', 'Installation')
    ]

# Equipment failures
SEVERITY_CHOICES = [
        ('Low', 'Low'),
        ('Medium', 'Medium'),
        ('High', 'High'),
        ('Critical', 'Critical')
    ]
CATEGORY_CHOICES = [
        ('Electrical', 'Electrical'),
        ('Mechanical', 'Mechanical'),
        ('Refrigeration Cycle', 'Refrigeration Cycle'),
        ('Control System', 'Control System'),
        ('Airflow', 'Airflow'),
        ('Leaks', 'Leaks'),
        ('Drainage', 'Drainage'),
        ('Noise/Vibration', 'Noise/Vibration'),
        ('Other', 'Other')
    ]

LEADS_STATUS_CHOICES = [
        ('New', 'New'),
        ('Contacted', 'Contacted'),
        ('Follow-up', 'Follow-up'),
        ('Scheduled', 'Scheduled'),
        ('Lost', 'Lost'),
    ]
LEADS_SERVICES_CHOICES = [
        ('Inspection', 'Inspection'),
        ('Installation', 'Installation'),
        ('Maintenance', 'Maintenance')
    ]

PAYMENT_CHOICES = [
        ('Paid', 'Paid'),
        ('Unpaid', 'Unpaid'),
        ('Overdue', 'Overdue')]

PAYMENT_METHOD_CHOICES = [
        ('Cash', 'Cash'),
        ('Debit Card', 'Debit Card'),
        ('Credit Card', 'Credit Card'),
        ('Bank Transfer', 'Bank Transfer'),
        ('Other', 'Other')]
