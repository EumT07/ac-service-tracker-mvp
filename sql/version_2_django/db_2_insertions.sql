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