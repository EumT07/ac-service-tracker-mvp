-- Data to insert into DB and test its functionality

-- ====================
-- 1. USERS/TECHNICIANS
-- ====================

-- 2 Admins
INSERT INTO users (id, first_name, last_name, email, phone, gender, address, password, role, hourly_rate) 
VALUES
    ('ADM001', 'Carlos', 'Rodriguez', 'carlos.rodriguez.admin@gmail.com', '809-111-0001', 'Male', 'Av. Principal #123, Santo Domingo', 'hashed_password_1', 'admin', 45.00),
    ('ADM002', 'Ana', 'Martinez', 'ana.martinez.admin@hotmail.com', '809-111-0002', 'Female', 'Calle Las Flores #45, Santiago', 'hashed_password_2', 'admin', 42.00);

-- 3 Operators
INSERT INTO users (id, first_name, last_name, email, phone, gender, address, password, role, hourly_rate) 
VALUES
    ('OPR001', 'Miguel', 'Santos', 'miguel.santos.operator@gmail.com', '809-222-0001', 'Male', 'Sector Los Ríos, Santo Domingo', 'hashed_password_3', 'operator', 25.00),
    ('OPR002', 'Laura', 'Garcia', 'laura.garcia.operator@hotmail.com', '809-222-0002', 'Female', 'Urbanización Bella Vista, Santo Domingo', 'hashed_password_4', 'operator', 24.00),
    ('OPR003', 'Roberto', 'Hernandez', 'roberto.hernandez.operator@gmail.com', '809-222-0003', 'Male', 'Zona Universitaria, Santiago', 'hashed_password_5', 'operator', 26.00);

-- 6 Technicians (4 Male, 2 Female)
INSERT INTO users (id, first_name, last_name, email, phone, gender, address, password, role, hourly_rate) 
VALUES
-- Male Technicians
    ('TEC001', 'Jose', 'Perez', 'jose.perez.tech@gmail.com', '809-333-0001', 'Male', 'Calle 27 de Febrero #67, Santo Domingo', 'hashed_password_6', 'technician', 30.00),
    ('TEC002', 'Luis', 'Ramirez', 'luis.ramirez.tech@hotmail.com', '809-333-0002', 'Male', 'Sector Los Jardines, La Vega', 'hashed_password_7', 'technician', 28.00),
    ('TEC003', 'Pedro', 'Gomez', 'pedro.gomez.tech@gmail.com', '809-333-0003', 'Male', 'Av. George Washington #234, Santo Domingo', 'hashed_password_8', 'technician', 32.00),
    ('TEC004', 'Juan', 'Diaz', 'juan.diaz.tech@hotmail.com', '809-333-0004', 'Male', 'Calle Duarte #89, San Cristóbal', 'hashed_password_9', 'technician', 29.00),
-- Female Technicians
    ('TEC005', 'Maria', 'Lopez', 'maria.lopez.tech@gmail.com', '809-333-0005', 'Female', 'Sector Los Prados, Santo Domingo', 'hashed_password_10', 'technician', 31.00),
    ('TEC006', 'Sofia', 'Castillo', 'sofia.castillo.tech@hotmail.com', '809-333-0006', 'Female', 'Zona Colonial, Santo Domingo', 'hashed_password_11', 'technician', 30.00);

-- =====================
-- 2. MAINTENANCE TYPES
-- =====================

INSERT INTO maintenance_types (id, code, name, frequency_days, description) 
VALUES
    ('MT001', 'PM', 'Preventive Maintenance - Cleaning', 150, 'Routine cleaning and inspection every 5 months'),
    ('MT002', 'CM', 'Corrective Maintenance - Pressure Monitoring', 14, 'Pressure monitoring for critical equipment every 2 weeks'),
    ('MT003', 'CM', 'Compressor Replacement', NULL, 'Emergency compressor replacement'),
    ('MT004', 'CM', 'Refrigerant Recharge', NULL, 'Refrigerant system recharge'),
    ('MT005', 'PM', 'Capacitor Replacement', 180, 'Preventive capacitor replacement every 6 months'),
    ('MT006', 'CM', 'Capillary Tube Replacement', NULL, 'Capillary tube system replacement');

-- =================
-- 3. FAILURE TYPES
-- =================

INSERT INTO failure_types (id, category, name, severity, estimated_repair_hours, common_causes) 
VALUES
-- Electrical Failures
    ('FT001', 'Electrical', 'Compressor Electrical Failure', 'Critical', 4, 'Electrical short circuit, burnt windings'),
    ('FT002', 'Electrical', 'Capacitor Failure', 'Medium', 1, 'Age, power surges, overheating'),
    ('FT003', 'Electrical', 'Fan Motor Electrical Failure', 'High', 2, 'Burnt windings, electrical overload'),

-- Mechanical Failures
    ('FT004', 'Mechanical', 'Fan Motor High Vibration', 'Medium', 2, 'Unbalanced blades, bearing wear, misalignment'),
    ('FT005', 'Mechanical', 'Compressor Mechanical Failure', 'Critical', 5, 'Seized components, bearing failure'),
    ('FT006', 'Mechanical', 'Bearing Wear', 'Medium', 2, 'Lack of lubrication, normal wear'),

-- Refrigeration Failures
    ('FT007', 'Refrigeration', 'Refrigerant Leak', 'High', 3, 'Corrosion, poor connections, physical damage'),
    ('FT008', 'Refrigeration', 'Low Refrigerant Charge', 'Medium', 2, 'Slow leaks, improper initial charge'),
    ('FT009', 'Refrigeration', 'Capillary Tube Blockage', 'High', 3, 'Moisture, debris, oil sludge'),

-- Airflow Failures
    ('FT010', 'Airflow', 'Dirty Evaporator Coil', 'Low', 1, 'Dust accumulation, lack of maintenance'),
    ('FT011', 'Airflow', 'Dirty Condenser Coil', 'Low', 1, 'Outdoor debris, lack of cleaning'),
-- Control System Failures
    ('FT012', 'Control System', 'Thermostat Malfunction', 'Medium', 1, 'Battery failure, calibration issues'),

-- Noise/Vibration
    ('FT013', 'Noise/Vibration', 'Abnormal Compressor Noise', 'High', 3, 'Internal damage, mounting issues');

-- ===========
-- 4. CLIENTS
-- ===========

-- 10 Clients with equipment in good condition
INSERT INTO clients (id, first_name, last_name, email, gender, phone, address, client_type) 
VALUES
    ('CLI001', 'Roberto', 'Alvarez', 'roberto.alvarez.client@gmail.com', 'Male', '809-444-0001', 'Calle Principal #100, Santo Domingo Este', 'Residential'),
    ('CLI002', 'Elena', 'Morales', 'elena.morales.client@hotmail.com', 'Female', '809-444-0002', 'Av. San Martín #200, Santiago', 'Residential'),
    ('CLI003', 'Ricardo', 'Pena', 'ricardo.pena.client@gmail.com', 'Male', '809-444-0003', 'Sector Los Molinos, Santo Domingo', 'Commercial'),
    ('CLI004', 'Carmen', 'Reyes', 'carmen.reyes.client@hotmail.com', 'Female', '809-444-0004', 'Calle 5 #45, San Pedro de Macorís', 'Residential'),
    ('CLI005', 'Fernando', 'Ortiz', 'fernando.ortiz.client@gmail.com', 'Male', '809-444-0005', 'Urbanización Miramar, Santo Domingo', 'Residential'),
    ('CLI006', 'Patricia', 'Silva', 'patricia.silva.client@hotmail.com', 'Female', '809-444-0006', 'Zona Industrial, Santiago', 'Commercial'),
    ('CLI007', 'Alberto', 'Mendez', 'alberto.mendez.client@gmail.com', 'Male', '809-444-0007', 'Sector Los Jardines, La Romana', 'Residential'),
    ('CLI008', 'Diana', 'Torres', 'diana.torres.client@hotmail.com', 'Female', '809-444-0008', 'Calle El Sol #78, Higüey', 'Residential'),
    ('CLI009', 'Gabriel', 'Cruz', 'gabriel.cruz.client@gmail.com', 'Male', '809-444-0009', 'Av. Bolívar #321, Santo Domingo', 'Commercial'),
    ('CLI010', 'Isabel', 'Vasquez', 'isabel.vasquez.client@hotmail.com', 'Female', '809-444-0010', 'Sector Villa Mella, Santo Domingo', 'Residential');

-- 5 Clients with equipment needing corrective maintenance
INSERT INTO clients (id, first_name, last_name, email, gender, phone, address, client_type) 
VALUES
    ('CLI011', 'Oscar', 'Medina', 'oscar.medina.client@gmail.com', 'Male', '809-444-0011', 'Calle Las Palmas #23, San Cristóbal', 'Residential'),
    ('CLI012', 'Laura', 'Guzman', 'laura.guzman.client@hotmail.com', 'Female', '809-444-0012', 'Sector Los Cacicazgos, Santo Domingo', 'Commercial'),
    ('CLI013', 'Raul', 'Castillo', 'raul.castillo.client@gmail.com', 'Male', '809-444-0013', 'Av. México #456, Santo Domingo', 'Residential'),
    ('CLI014', 'Monica', 'Rojas', 'monica.rojas.client@hotmail.com', 'Female', '809-444-0014', 'Calle Juan Pablo Duarte #67, La Vega', 'Residential'),
    ('CLI015', 'Victor', 'Moreno', 'victor.moreno.client@gmail.com', 'Male', '809-444-0015', 'Urbanización Paraíso, Santiago', 'Commercial');

-- 10 Clients with 1-3 equipment needing various maintenance
INSERT INTO clients (id, first_name, last_name, email, gender, phone, address, client_type) VALUES
    ('CLI016', 'Sandra', 'Jimenez', 'sandra.jimenez.client@hotmail.com', 'Female', '809-444-0016', 'Sector Los Restauradores, Santo Domingo', 'Residential'),
    ('CLI017', 'Jorge', 'Navarro', 'jorge.navarro.client@gmail.com', 'Male', '809-444-0017', 'Calle San Antonio #89, Moca', 'Residential'),
    ('CLI018', 'Beatriz', 'Molina', 'beatriz.molina.client@hotmail.com', 'Female', '809-444-0018', 'Av. Circunvalación, San Francisco de Macorís', 'Commercial'),
    ('CLI019', 'Hector', 'Rios', 'hector.rios.client@gmail.com', 'Male', '809-444-0019', 'Sector Los Frailes, Santo Domingo Este', 'Residential'),
    ('CLI020', 'Lucia', 'Castro', 'lucia.castro.client@hotmail.com', 'Female', '809-444-0020', 'Calle El Conde #123, Santo Domingo', 'Residential'),
    ('CLI021', 'Francisco', 'Romero', 'francisco.romero.client@gmail.com', 'Male', '809-444-0021', 'Urbanización Las Caobas, Santiago', 'Commercial'),
    ('CLI022', 'Rosa', 'Herrera', 'rosa.herrera.client@hotmail.com', 'Female', '809-444-0022', 'Sector Los Alcarrizos, Santo Domingo', 'Residential'),
    ('CLI023', 'Daniel', 'Vargas', 'daniel.vargas.client@gmail.com', 'Male', '809-444-0023', 'Calle Pedro Henríquez Ureña #234, Santo Domingo', 'Residential'),
    ('CLI024', 'Adriana', 'Mendoza', 'adriana.mendoza.client@hotmail.com', 'Female', '809-444-0024', 'Zona Universitaria, Santiago', 'Commercial'),
    ('CLI025', 'Manuel', 'Cordero', 'manuel.cordero.client@gmail.com', 'Male', '809-444-0025', 'Sector Los Guandules, Santo Domingo', 'Residential');

-- 5 Clients with inspection orders
INSERT INTO clients (id, first_name, last_name, email, gender, phone, address, client_type) 
VALUES
    ('CLI026', 'Teresa', 'Leon', 'teresa.leon.client@hotmail.com', 'Female', '809-444-0026', 'Calle Las Mercedes #56, Baní', 'Residential'),
    ('CLI027', 'Pablo', 'Miranda', 'pablo.miranda.client@gmail.com', 'Male', '809-444-0027', 'Av. 27 de Febrero #789, Santo Domingo', 'Commercial'),
    ('CLI028', 'Eva', 'Soto', 'eva.soto.client@hotmail.com', 'Female', '809-444-0028', 'Sector Los Peralejos, Santo Domingo', 'Residential'),
    ('CLI029', 'Rodrigo', 'Fuentes', 'rodrigo.fuentes.client@gmail.com', 'Male', '809-444-0029', 'Urbanización El Portal, Santiago', 'Commercial'),
    ('CLI030', 'Natalia', 'Espinoza', 'natalia.espinoza.client@hotmail.com', 'Female', '809-444-0030', 'Calle San Juan #34, La Romana', 'Residential');

-- ====================
-- 5. CLIENT EQUIPMENT
-- ====================

-- Equipment for clients (Good condition)
INSERT INTO client_equipment (id, client_id, equipment_name, brand, model, serial_number, equipment_type, capacity_btu, location, installation_date, warranty_expiration, status) 
VALUES
    ('EQ001', 'CLI001', 'Split AC Living Room', 'LG', 'LS123ER', 'LG2023AC001', 'Split AC', 12000, 'Living Room', '2023-01-15', '2026-01-15', 'Operational'),
    ('EQ002', 'CLI002', 'Window AC Master Bedroom', 'Samsung', 'AR12TGH', 'SAM2023AC002', 'Window AC', 10000, 'Master Bedroom', '2023-02-20', '2026-02-20', 'Operational'),
    ('EQ003', 'CLI003', 'Central AC System', 'Carrier', '24ABC648', 'CAR2023AC003', 'Central AC', 18000, 'Office Area', '2023-03-10', '2026-03-10', 'Operational'),
    ('EQ004', 'CLI004', 'Split AC Dining Room', 'Midea', 'MS12FN', 'MID2023AC004', 'Split AC', 12000, 'Dining Room', '2023-01-25', '2026-01-25', 'Operational'),
    ('EQ005', 'CLI005', 'Heat Pump System', 'Daikin', 'FTXS09LVJU', 'DAI2023AC005', 'Heat Pump', 15000, 'Living Area', '2023-04-05', '2026-04-05', 'Operational');
-- Equipment for clients (Need corrective maintenance - compressor/refrigerant issues)
INSERT INTO client_equipment (id, client_id, equipment_name, brand, model, serial_number, equipment_type, capacity_btu, location, installation_date, warranty_expiration, status) VALUES
    ('EQ006', 'CLI011', 'Split AC Office', 'LG', 'LS180ER', 'LG2022AC006', 'Split AC', 18000, 'Office Room', '2022-05-15', '2025-05-15', 'Requires Repair'),
    ('EQ007', 'CLI012', 'Window AC Production', 'Samsung', 'AR18TGH', 'SAM2022AC007', 'Window AC', 18000, 'Production Area', '2022-06-20', '2025-06-20', 'Out of Service'),
    ('EQ008', 'CLI013', 'Split AC Bedroom', 'Midea', 'MS18FN', 'MID2022AC008', 'Split AC', 18000, 'Main Bedroom', '2022-07-10', '2025-07-10', 'Requires Repair'),
    ('EQ009', 'CLI014', 'Central AC System', 'Carrier', '24ABC648', 'CAR2021AC009', 'Central AC', 24000, 'Store Area', '2021-08-15', '2024-08-15', 'Out of Service'),
    ('EQ010', 'CLI015', 'Heat Pump Office', 'Daikin', 'FTXS12LVJU', 'DAI2021AC010', 'Heat Pump', 15000, 'Executive Office', '2021-09-20', '2024-09-20', 'Requires Repair');

-- Equipment for clients (Multiple equipment needing various maintenance)
INSERT INTO client_equipment (id, client_id, equipment_name, brand, model, serial_number, equipment_type, capacity_btu, location, installation_date, warranty_expiration, status) 
VALUES
-- Client with 3 equipment
    ('EQ011', 'CLI016', 'Split AC Living Room', 'LG', 'LS123ER', 'LG2022AC011', 'Split AC', 12000, 'Living Room', '2022-03-15', '2025-03-15', 'Requires Repair'),
    ('EQ012', 'CLI016', 'Window AC Bedroom', 'Samsung', 'AR09TGH', 'SAM2022AC012', 'Window AC', 9000, 'Bedroom 1', '2022-04-10', '2025-04-10', 'Operational'),
    ('EQ013', 'CLI016', 'Split AC Kitchen', 'Midea', 'MS09FN', 'MID2023AC013', 'Split AC', 9000, 'Kitchen Area', '2023-01-20', '2026-01-20', 'Requires Repair'),

-- Client with 2 equipment
    ('EQ014', 'CLI017', 'Window AC Living', 'LG', 'LW1216HR', 'LG2021AC014', 'Window AC', 12000, 'Living Room', '2021-11-15', '2024-11-15', 'Requires Repair'),
    ('EQ015', 'CLI017', 'Split AC Bedroom', 'Samsung', 'AR12TGH', 'SAM2022AC015', 'Split AC', 12000, 'Master Bedroom', '2022-12-10', '2025-12-10', 'Operational'),

-- Client with 3 equipment
    ('EQ016', 'CLI018', 'Central AC Main', 'Carrier', '24ABC636', 'CAR2020AC016', 'Central AC', 18000, 'Main Hall', '2020-08-20', '2023-08-20', 'Requires Repair'),
    ('EQ017', 'CLI018', 'Split AC Office 1', 'Daikin', 'FTXS09LVJU', 'DAI2022AC017', 'Split AC', 9000, 'Office 1', '2022-09-15', '2025-09-15', 'Operational'),
    ('EQ018', 'CLI018', 'Split AC Office 2', 'Midea', 'MS12FN', 'MID2022AC018', 'Split AC', 12000, 'Office 2', '2022-10-05', '2025-10-05', 'Requires Repair');

-- Equipment for clients (Inspection orders)
INSERT INTO client_equipment (id, client_id, equipment_name, brand, model, serial_number, equipment_type, capacity_btu, location, installation_date, warranty_expiration, status) 
VALUES
    ('EQ019', 'CLI026', 'Split AC Living', 'LG', 'LS123ER', 'LG2021AC019', 'Split AC', 12000, 'Living Room', '2021-06-15', '2024-06-15', 'Operational'),
    ('EQ020', 'CLI027', 'Central AC System', 'Carrier', '24ABC648', 'CAR2020AC020', 'Central AC', 24000, 'Office Building', '2020-07-20', '2023-07-20', 'Requires Repair'),
    ('EQ021', 'CLI028', 'Window AC Room', 'Samsung', 'AR12TGH', 'SAM2022AC021', 'Window AC', 12000, 'Guest Room', '2022-08-10', '2025-08-10', 'Operational'),
    ('EQ022', 'CLI029', 'Heat Pump System', 'Daikin', 'FTXS18LVJU', 'DAI2021AC022', 'Heat Pump', 18000, 'Main Office', '2021-09-25', '2024-09-25', 'Requires Repair'),
    ('EQ023', 'CLI030', 'Split AC Bedroom', 'Midea', 'MS09FN', 'MID2023AC023', 'Split AC', 9000, 'Master Bedroom', '2023-03-15', '2026-03-15', 'Operational');

-- ======================
-- 6. MAINTENANCE ORDERS
-- ======================

-- Maintenance orders for equipment needing cleaning (PM)
INSERT INTO maintenance_orders (id, client_id, user_id, equipment_id, type_id, status, scheduled_date, completed_date, technician_notes, labor_hours, labor_cost, parts_cost, total_cost, next_maintenance_date) 
VALUES
    ('MO001', 'CLI001', 'TEC001', 'EQ001', 'MT001', 'completed', '2024-01-15', '2024-01-15', 'Routine cleaning performed. Coils cleaned, filters replaced.', 1.5, 45.00, 15.00, 60.00, '2024-06-15'),
    ('MO002', 'CLI002', 'TEC002', 'EQ002', 'MT001', 'completed', '2024-01-20', '2024-01-20', 'Preventive maintenance completed. System running efficiently.', 1.0, 28.00, 12.00, 40.00, '2024-06-20'),
    ('MO003', 'CLI016', 'TEC003', 'EQ012', 'MT001', 'completed', '2024-02-10', '2024-02-10', 'Cleaning and inspection. No issues found.', 1.2, 38.40, 10.00, 48.40, '2024-07-10');

-- Maintenance orders for corrective maintenance (compressor/refrigerant issues)
INSERT INTO maintenance_orders (id, client_id, user_id, equipment_id, type_id, status, scheduled_date, completed_date, technician_notes, labor_hours, labor_cost, parts_cost, total_cost, next_maintenance_date) 
VALUES
    ('MO004', 'CLI011', 'TEC004', 'EQ006', 'MT003', 'completed', '2024-02-15', '2024-02-15', 'Compressor replaced due to electrical failure. System recharged and tested.', 4.5, 130.50, 450.00, 580.50, '2024-05-15'),
    ('MO005', 'CLI012', 'TEC005', 'EQ007', 'MT004', 'in_progress', '2024-03-01', NULL, 'Refrigerant leak detected. System evacuation in progress.', 2.0, 62.00, 120.00, 182.00, NULL),
    ('MO006', 'CLI013', 'TEC001', 'EQ008', 'MT004', 'scheduled', '2024-03-10', NULL, 'Scheduled for refrigerant recharge and pressure testing.', 0, 0, 0, 0, NULL);

-- Maintenance orders for capacitor and capillary tube replacements
INSERT INTO maintenance_orders (id, client_id, user_id, equipment_id, type_id, status, scheduled_date, completed_date, technician_notes, labor_hours, labor_cost, parts_cost, total_cost, next_maintenance_date) 
VALUES
    ('MO007', 'CLI016', 'TEC002', 'EQ011', 'MT005', 'completed', '2024-02-20', '2024-02-20', 'Capacitor replaced. Motor running smoothly now.', 1.0, 28.00, 25.00, 53.00, '2024-08-20'),
    ('MO008', 'CLI017', 'TEC003', 'EQ014', 'MT006', 'completed', '2024-02-25', '2024-02-25', 'Capillary tube replaced. System pressure normalized.', 3.0, 96.00, 85.00, 181.00, '2024-05-25'),
    ('MO009', 'CLI018', 'TEC004', 'EQ016', 'MT005', 'completed', '2024-03-05', '2024-03-05', 'Dual capacitor replacement. Compressor starting properly.', 1.5, 43.50, 35.00, 78.50, '2024-09-05');

-- ======================
-- 7. EQUIPMENT FAILURES
-- ======================

INSERT INTO equipment_failures (id, maintenance_order_id, failure_type_id, equipment_id, detected_date, resolved_date, severity_actual, repair_notes, repair_hours_actual) 
VALUES
-- Compressor failures
    ('EF001', 'MO004', 'FT001', 'EQ006', '2024-02-10', '2024-02-15', 'Critical', 'Compressor windings burnt. Complete replacement required.', 4.5),
    ('EF002', 'MO005', 'FT007', 'EQ007', '2024-02-28', NULL, 'High', 'Refrigerant leak at evaporator coil connection.', 2.0),

-- Fan motor and vibration issues
    ('EF003', 'MO007', 'FT004', 'EQ011', '2024-02-18', '2024-02-20', 'Medium', 'Fan motor high vibration due to unbalanced blades. Rebalanced and tested.', 1.0),
    ('EF004', 'MO009', 'FT002', 'EQ016', '2024-03-01', '2024-03-05', 'Medium', 'Capacitor failure causing hard starting. Replaced with OEM part.', 1.5),
-- Refrigeration issues
    ('EF005', 'MO008', 'FT009', 'EQ014', '2024-02-20', '2024-02-25', 'High', 'Capillary tube blockage causing high pressure. Replaced entire capillary assembly.', 3.0),
    ('EF006', 'MO006', 'FT008', 'EQ008', '2024-03-05', NULL, 'Medium', 'Low refrigerant charge detected during inspection.', 0);

-- ===============
-- 8. INSPECTIONS
-- ===============

INSERT INTO inspections (id, client_id, equipment_id, user_id, inspection_date, pressure_suction, temp_supply, temp_return, amps_reading, general_notes, findings_summary, status) 
VALUES
    ('INS001', 'CLI026', 'EQ019', 'TEC005', '2024-03-01', 68.5, 55.2, 75.8, 8.2, 'Routine performance check', 'System operating within normal parameters. Good temperature differential.', 'Pending'),
    ('INS002', 'CLI027', 'EQ020', 'TEC006', '2024-03-02', 45.2, 62.1, 78.5, 12.5, 'Customer reported poor cooling', 'High suction pressure detected. Possible refrigerant overcharge or non-condensables.', 'Converted to Maintenance'),
    ('INS003', 'CLI028', 'EQ021', 'TEC001', '2024-03-03', 72.3, 56.8, 76.2, 7.8, 'Pre-season inspection', 'System in good condition. Normal operating pressures and temperatures.', 'Pending'),
    ('INS004', 'CLI029', 'EQ022', 'TEC002', '2024-03-04', 38.7, 65.4, 79.1, 14.2, 'Abnormal noise complaint', 'Low suction pressure, high amp draw. Possible compressor issues.', 'Converted to Maintenance'),
    ('INS005', 'CLI030', 'EQ023', 'TEC003', '2024-03-05', 70.1, 54.9, 74.3, 6.9, 'New installation follow-up', 'Excellent performance. All parameters within specifications.', 'Pending');