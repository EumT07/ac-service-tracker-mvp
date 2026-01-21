SELECT * FROM users;

INSERT INTO users (first_name, last_name, email, phone, gender, address, password, role, hourly_rate, is_active)
VALUES 
        (
            'John',
            'Doe', 
            'john.doe@hotmail.com', 
            '+58-1234-567-890', 
            'Male', 
            '123 Main St', 
            'hashed_password_here', 
            'admin', 
            20.00, 
            FALSE
        ),(
            'Jane',
            'Smith', 
            'jane.smith@gmail.com', 
            '+58-0987-654-321', 
            'Female', 
            '456 Oak Ave', 
            'hashed_password_here', 
            'operator', 
            25.00, 
            TRUE
        )