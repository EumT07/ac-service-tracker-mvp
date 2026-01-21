INSERT INTO equipment_brands (name) 
VALUES 
        ('Carrier'),
        ('Trane'),
        ('York'),
        ('Daikin'),
        ('Samsung'),
        ('LG'),
        ('McQuay'),
        ('Lennox'),
        ('Goodman'),
        ('Daewoo'),
        ('Mitsubishi Electric'),
        ('Hitachi'),
        ('Toshiba'),
        ('Rheem'),
        ('Bryant');

INSERT INTO equipment_types (name) 
VALUES 
        ('Split Wall Mounted'),
        ('Multi-Split'),
        ('Chiller Air Cooled'), 
        ('Chiller Water Cooled'),
        ('Package Unit'),
        ('Fan Coil Unit'),
        ('Ducted System'),
        ('Window Unit'),
        ('Portable Unit'),
        ('Central AC System'),
        ('Furnace'),
        ('Heat Pump'),
        ('Ventilation System'),
        ('Dehumidifier'),
        ('Air Purifier'),
        ('VRF System');

INSERT INTO failure_categories (name) 
VALUES 
        ('Electrical'),
        ('Mechanical'),
        ('Refrigeration Cycle'),
        ('Control System'),
        ('Airflow'),
        ('Leaks'),
        ('Drainage'),
        ('Noise/Vibration'),
        ('Other');

INSERT INTO maintenance_types (code, name, frequency_days, description) 
VALUES 
        ('PM', 'Preventive Maintenance', 90, 'Routine checkup and cleaning'),
        ('CM', 'Corrective Maintenance', NULL, 'Repair after a failure has occurred'),
        ('PdM', 'Predictive Maintenance', 180, 'Advanced analysis to predict future failures'),
        ('PM', 'Preventive Maintenance', NULL, 'First time equipment assessment'),
        ('PdM', 'Predictive Maintenance', NULL, 'Upgrading equipment components or software'),
        ('CM', 'Corrective Maintenance', NULL, 'Emergency repair services'),
        ('PM', 'Preventive Maintenance', 180, 'Seasonal maintenance before peak usage periods'),
        ('PdM', 'Predictive Maintenance', 365, 'Annual performance evaluation and tuning'),
        ('CM', 'Corrective Maintenance', NULL, 'Post-warranty repair services'),
        ('PM', 'Preventive Maintenance', 60, 'Monthly system inspection and calibration'),
        ('PdM', 'Predictive Maintenance', 90, 'Vibration analysis and monitoring'),
        ('CM', 'Corrective Maintenance', NULL, 'On-site troubleshooting and repair'),
        ('PM', 'Preventive Maintenance', 120, 'Quarterly filter replacement and cleaning'),
        ('PdM', 'Predictive Maintenance', 240, 'Thermographic inspections and analysis'),
        ('CM', 'Corrective Maintenance', NULL, 'Component replacement and upgrades');

INSERT INTO failure_types (category_id, name, severity)
VALUES 
        ((SELECT id FROM failure_categories WHERE name = 'Electrical'), 'Compressor Motor Burnout', 'Critical'),
        ((SELECT id FROM failure_categories WHERE name = 'Refrigeration Cycle'), 'Low Refrigerant Charge', 'Medium'),
        ((SELECT id FROM failure_categories WHERE name = 'Mechanical'), 'Blower Wheel Imbalance', 'Low'),
        ((SELECT id FROM failure_categories WHERE name = 'Control System'), 'Thermostat Communication Error', 'Medium'),
        ((SELECT id FROM failure_categories WHERE name = 'Leaks'), 'Water Condensate Overflow', 'Low'),
        ((SELECT id FROM failure_categories WHERE name = 'Airflow'), 'Clogged Air Filters', 'Low'),
        ((SELECT id FROM failure_categories WHERE name = 'Noise/Vibration'), 'Unusual Operational Noises', 'Medium'),
        ((SELECT id FROM failure_categories WHERE name = 'Electrical'), 'Capacitor Failure', 'High'),
        ((SELECT id FROM failure_categories WHERE name = 'Mechanical'), 'Fan Motor Failure', 'High'),
        ((SELECT id FROM failure_categories WHERE name = 'Refrigeration Cycle'), 'Evaporator Coil Freeze-Up', 'Medium'),
        ((SELECT id FROM failure_categories WHERE name = 'Control System'), 'Control Board Malfunction', 'High'),
        ((SELECT id FROM failure_categories WHERE name = 'Leaks'), 'Refrigerant Leak', 'Critical'),
        ((SELECT id FROM failure_categories WHERE name = 'Airflow'), 'Ductwork Leaks', 'Medium'),
        ((SELECT id FROM failure_categories WHERE name = 'Noise/Vibration'), 'Vibration Issues', 'Low'),
        ((SELECT id FROM failure_categories WHERE name = 'Other'), 'Miscellaneous Issues', 'Low');