SELECT * FROM bills;
SELECT * FROM services;
DELETE FROM services WHERE id = 'd5dc1f64-0f83-4733-a7dd-d2a48fc5c5d4';


-- Active Users
INSERT INTO employees (first_name, last_name, email, phone, gender, address, password, role, employee_hourly_rate)
VALUES 
    ('Juan', 'Pérez', 'juanperez@gmail.com', '+58-400-111-0001', 'Male', 'Av. Francisco de Miranda, Caracas, Distrito Capital', 'hashed_password_123', 'Admin', 20.50),
    ('María', 'González', 'mariagonzalez@hotmail.com', '+58-400-111-0002', 'Female', 'Calle 72, Maracaibo, Zulia', 'hashed_password_123', 'Admin', 23.00),
    ('Carlos', 'Rodríguez', 'carlosrodriguez@outlook.com', '+58-400-111-0003', 'Male', 'Av. Bolívar, Valencia, Carabobo', 'hashed_password_123', 'Technician', 28.50),
    ('José', 'López', 'joselopez@gmail.com', '+58-400-111-0004', 'Male', 'Calle 5, Barquisimeto, Lara', 'hashed_password_123', 'Technician', 30.00),
    ('Francisco', 'Silva', 'franciscosilva@outlook.com', '+58-400-111-0009', 'Male', 'Av. Páez, Caracas, Distrito Capital', 'hashed_password_123', 'Trainer', 18.00),
    ('Manuel', 'Rodríguez', 'manuelrodriguez@gmail.com', '+58-400-111-0013', 'Male', 'Calle 72, Maracaibo, Zulia', 'hashed_password_123', 'Trainer', 15.00),
    ('Pedro', 'García', 'pedrogarcia2@hotmail.com', '+58-400-111-0017', 'Male', 'Calle 10, Maracay, Aragua', 'hashed_password_123', 'Operator', 18.50),
    ('Carmen', 'Silva', 'carmensilva@outlook.com', '+58-400-111-0018', 'Female', 'Av. Lara, Barquisimeto, Lara', 'hashed_password_123', 'Operator', 16.75);
-- False Users
INSERT INTO employees (first_name, last_name, email, phone, gender, address, password, role, employee_hourly_rate, is_active)
VALUES
    ('Adrian', 'Carrillo', 'adriancarrillo@gmail.com', '+58-400-111-0023', 'Male', 'Calle 1, Caracas, Distrito Capital', 'hashed_password_123', 'Technician', 25.00, False),
    ('Patricia', 'González', 'patriciagonzalez@gmail.com', '+58-400-111-0022', 'Female', 'Av. Circunvalación, Valencia, Carabobo', 'hashed_password_123', 'Operator', 20.00, False),
    ('Rafael', 'Rojas', 'rafaelrojas@gmail.com', '+58-400-111-0010', 'Male', 'Calle 20, Maracaibo, Zulia', 'hashed_password_123', 'Trainer', 33.25, False);

INSERT INTO clients (first_name, last_name, email, gender, phone, address, client_type) VALUES
    ('Juan', 'Pérez', 'juanperez1@gmail.com', 'Male', '+58-401-123-4567', 'Av. Bolívar, Caracas, Distrito Capital', 'Residential'),
    ('María', 'González', 'mariagonzalez2@hotmail.com', 'Female', '+58-402-234-5678', 'Calle El Recreo, Maracaibo, Zulia', 'Residential'),
    ('Carlos', 'Rodríguez', 'carlosrodriguez3@outlook.com', 'Male', '+58-403-345-6789', 'Av. Universidad, Valencia, Carabobo', 'Residential'),
    ('Ana', 'López', 'analopez4@gmail.com', 'Female', '+58-404-456-7890', 'Calle 72, Barquisimeto, Lara', 'Residential'),
    ('José', 'Martínez', 'josemartinez5@hotmail.com', 'Male', '+58-405-567-8901', 'Av. Circunvalación, Maracay, Aragua', 'Residential'),
    ('Carmen', 'García', 'carmengarcia6@outlook.com', 'Female', '+58-406-678-9012', 'Calle Libertad, Barcelona, Anzoátegui', 'Residential'),
    ('Luis', 'Hernández', 'luishernandez7@gmail.com', 'Male', '+58-407-789-0123', 'Av. Principal, Maturín, Monagas', 'Residential'),
    ('Isabel', 'Sánchez', 'isabelsanchez8@hotmail.com', 'Female', '+58-408-890-1234', 'Calle Comercio, Ciudad Guayana, Bolívar', 'Residential'),
    ('Miguel', 'Ramírez', 'miguelramirez9@outlook.com', 'Male', '+58-409-901-2345', 'Av. Paseo, San Cristóbal, Táchira', 'Residential'),
    ('Patricia', 'Torres', 'patriciatorres10@gmail.com', 'Female', '+58-410-012-3456', 'Calle Jardín, Cumaná, Sucre', 'Residential'),
    ('Pedro', 'Pérez', 'pedroperez11@hotmail.com', 'Male', '+58-411-112-2334', 'Av. Bolívar, Caracas, Distrito Capital', 'Residential'),
    ('Sofía', 'González', 'sofiagonzalez12@outlook.com', 'Female', '+58-412-223-3445', 'Calle El Recreo, Maracaibo, Zulia', 'Residential'),
    ('Antonio', 'Rodríguez', 'antoniorodriguez13@gmail.com', 'Male', '+58-413-334-4556', 'Av. Universidad, Valencia, Carabobo', 'Residential'),
    ('Valentina', 'López', 'valentinalopez14@hotmail.com', 'Female', '+58-414-445-5667', 'Calle 72, Barquisimeto, Lara', 'Residential'),
    ('Francisco', 'Martínez', 'franciscomartinez15@outlook.com', 'Male', '+58-415-556-6778', 'Av. Circunvalación, Maracay, Aragua', 'Residential'),
    ('Gabriela', 'García', 'gabrielagarcia16@gmail.com', 'Female', '+58-416-667-7889', 'Calle Libertad, Barcelona, Anzoátegui', 'Residential'),
    ('Jorge', 'Hernández', 'jorgehernandez17@hotmail.com', 'Male', '+58-417-778-8990', 'Av. Principal, Maturín, Monagas', 'Residential'),
    ('Andrea', 'Sánchez', 'andresanchez18@outlook.com', 'Female', '+58-418-889-9001', 'Calle Comercio, Ciudad Guayana, Bolívar', 'Residential'),
    ('Ricardo', 'Ramírez', 'ricardoramirez19@gmail.com', 'Male', '+58-419-990-0112', 'Av. Paseo, San Cristóbal, Táchira', 'Residential'),
    ('Laura', 'Torres', 'lauratorres20@hotmail.com', 'Female', '+58-420-101-1223', 'Calle Jardín, Cumaná, Sucre', 'Residential'),
    ('Juan', 'Pérez', 'juanperez21@outlook.com', 'Male', '+58-421-212-2334', 'Av. Bolívar, Caracas, Distrito Capital', 'Residential'),
    ('María', 'González', 'mariagonzalez22@gmail.com', 'Female', '+58-422-323-3445', 'Calle El Recreo, Maracaibo, Zulia', 'Residential'),
    ('Carlos', 'Rodríguez', 'carlosrodriguez23@hotmail.com', 'Male', '+58-423-434-4556', 'Av. Universidad, Valencia, Carabobo', 'Residential'),
    ('Ana', 'López', 'analopez24@outlook.com', 'Female', '+58-424-545-5667', 'Calle 72, Barquisimeto, Lara', 'Residential'),
    ('José', 'Martínez', 'josemartinez25@gmail.com', 'Male', '+58-425-656-6778', 'Av. Circunvalación, Maracay, Aragua', 'Residential'),
    ('Carmen', 'García', 'carmengarcia26@hotmail.com', 'Female', '+58-426-767-7889', 'Calle Libertad, Barcelona, Anzoátegui', 'Residential'),
    ('Luis', 'Hernández', 'luishernandez27@outlook.com', 'Male', '+58-427-878-8990', 'Av. Principal, Maturín, Monagas', 'Residential'),
    ('Isabel', 'Sánchez', 'isabelsanchez28@gmail.com', 'Female', '+58-428-989-9001', 'Calle Comercio, Ciudad Guayana, Bolívar', 'Residential'),
    ('Miguel', 'Ramírez', 'miguelramirez29@hotmail.com', 'Male', '+58-429-090-0112', 'Av. Paseo, San Cristóbal, Táchira', 'Residential'),
    ('Patricia', 'Torres', 'patriciatorres30@outlook.com', 'Female', '+58-430-101-1223', 'Calle Jardín, Cumaná, Sucre', 'Residential'),
    ('Empresa', 'Venezolana S.A.', 'empresavenezolana31@gmail.com', 'Male', '+58-431-202-2334', 'Av. Industrial, Caracas, Distrito Capital', 'Commercial'),
    ('Comercial', 'Maracaibo C.A.', 'comercialmaracaibo32@hotmail.com', 'Female', '+58-432-303-3445', 'Calle Comercial, Maracaibo, Zulia', 'Commercial'),
    ('Industrias', 'Valencia Ltda.', 'industriasvalencia33@outlook.com', 'Male', '+58-433-404-4556', 'Av. Tecnológica, Valencia, Carabobo', 'Commercial'),
    ('Servicios', 'Lara S.R.L.', 'servicioslara34@gmail.com', 'Female', '+58-434-505-5667', 'Calle Servicio, Barquisimeto, Lara', 'Commercial'),
    ('Constructora', 'Aragua C.A.', 'constructoraaragua35@hotmail.com', 'Male', '+58-435-606-6778', 'Av. Construcción, Maracay, Aragua', 'Commercial'),
    ('Exportadora', 'Anzoátegui S.A.', 'exportadoraanzoategui36@outlook.com', 'Female', '+58-436-707-7889', 'Calle Exportación, Barcelona, Anzoátegui', 'Commercial'),
    ('Minería', 'Bolívar C.A.', 'mineriabolivar37@gmail.com', 'Male', '+58-437-808-8990', 'Av. Minera, Ciudad Guayana, Bolívar', 'Commercial'),
    ('Agroindustrial', 'Monagas S.R.L.', 'agroindustrialmonagas38@hotmail.com', 'Female', '+58-438-909-9001', 'Calle Agrícola, Maturín, Monagas', 'Commercial'),
    ('Tecnología', 'Táchira Ltda.', 'tecnologiatachira39@outlook.com', 'Male', '+58-439-010-0112', 'Av. Digital, San Cristóbal, Táchira', 'Commercial'),
    ('Pesquera', 'Sucre C.A.', 'pesquerasucre40@gmail.com', 'Female', '+58-440-111-1223', 'Calle Pesquera, Cumaná, Sucre', 'Commercial'),
    ('Transporte', 'Nacional S.A.', 'transportenacional41@hotmail.com', 'Male', '+58-441-212-2334', 'Av. Transporte, Caracas, Distrito Capital', 'Commercial'),
    ('Hotelería', 'Zulia C.A.', 'hoteleriazulia42@outlook.com', 'Female', '+58-442-323-3445', 'Calle Hotelera, Maracaibo, Zulia', 'Commercial'),
    ('Educación', 'Carabobo S.R.L.', 'educacioncarabobo43@gmail.com', 'Male', '+58-443-434-4556', 'Av. Educativa, Valencia, Carabobo', 'Commercial'),
    ('Salud', 'Lara Ltda.', 'saludlara44@hotmail.com', 'Female', '+58-444-545-5667', 'Calle Salud, Barquisimeto, Lara', 'Commercial'),
    ('Turismo', 'Aragua S.A.', 'turismoaragua45@outlook.com', 'Male', '+58-445-656-6778', 'Av. Turística, Maracay, Aragua', 'Commercial');

INSERT INTO client_equipment (client_id, equipment_name, brand_id, equipment_type_id, model, serial_number, location, installation_date, warranty_expiration, capacity_btu, status, equipment_condition)
VALUES
    ((SELECT id FROM clients WHERE email = 'juanperez21@outlook.com'), 'Split System', (SELECT id FROM equipment_brands WHERE name = 'LG'), (SELECT id FROM equipment_types WHERE name = 'Air Conditioner'), 'Model 123', 'SN-456789', 'Living Room', '2020-01-15', '2023-01-15', 12000, 'Operational', 'New'),




ALTER TABLE leads 
ADD COLUMN lead_type VARCHAR(20) DEFAULT 'Residential' CHECK (lead_type IN ('Residential', 'Commercial'));

ALTER TABLE Clients 
    -- 1. Quitamos la restricción vieja
    DROP CONSTRAINT IF EXISTS clients_client_type_check, 
    
    -- 2. Cambiamos el valor por defecto a Mayúsculas
    ALTER COLUMN client_type SET DEFAULT 'Residential',
    
    -- 3. Agregamos la nueva restricción con los valores actualizados
    ADD CONSTRAINT chk_client_type_values 
    CHECK (client_type IN ('Residential', 'Commercial'));