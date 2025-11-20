--Get all users
SELECT * FROM users;

--Get users: admin role
SELECT 
    * 
FROM users 
WHERE role = 'admin';

--Get usesrs: Technician role
SELECT 
    * 
FROM users 
WHERE role = 'technician';

--Get all Clients
SELECT 
    count(*) AS total_clients
FROM clients;

--Get all clients total by type
SELECT
    client_type,
    count(*) AS total_clients_type
FROM clients
GROUP BY client_type;

-- show maintenances types
SELECT * FROM maintenance_types;

-- show failure types
SELECT * FROM failure_types;
-- show client equipment
SELECT * FROM client_equipment;
-- show maintenance orders
SELECT * FROM maintenance_orders;
-- show equipment failures
SELECT * FROM equipment_failures;
-- show inspections
SELECT * FROM inspections;