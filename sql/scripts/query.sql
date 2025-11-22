--Get all users
SELECT * FROM users;
-- Get all Clients
SELECT * FROM clients;
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

/*
----------------------
Data analitics queries
----------------------
*/

-- Question: List the first names, last names, and email addresses of all clients whose client_type is 'Commercial'.
SELECT
    first_name,
    last_name,
    email
FROM clients
WHERE client_type = 'Commercial';

-- Question: How many pieces of equipment exist for each equipment_type? Show the type and the count.
SELECT
    equipment_type,
    COUNT(*) AS equipment_count
FROM client_equipment
GROUP BY equipment_type;

-- Question: Retrieve a list of all active technicians (users where is_active = TRUE), showing their full name, email, and phone number.
SELECT
    first_name,
    last_name,
    phone
FROM users
WHERE is_active = TRUE AND role = 'technician';

-- Question: List all the distinct brands (brand) present in the client_equipment table.
SELECT
    DISTINCT brand,
FROM client_equipment;
-- How many brand are there?
SELECT
    DISTINCT brand,
    COUNT(*) as brand_count
FROM client_equipment
GROUP BY brand;

-- Question: What is the average total cost (total_cost) of completed maintenance orders?
SELECT 
    AVG(total_cost) AS avg_total_cost
FROM maintenance_orders;

-- Question: Show all failure types (failure_types) that have a 'Critical' severity and are active.
SELECT
    category
FROM failure_types
WHERE severity = 'Critical' AND is_active = TRUE;
SELECT * FROM failure_types;

-- Question: Find all equipment that has a status of 'Requires Repair'.
SELECT 
    *
FROM client_equipment
WHERE status = 'Requires Repair';

-- Question: How many maintenance orders has each client had? Show the client's name and the count.
SELECT 
    c.id,
    c.first_name,
    COUNT(mo.id) as orders_count
FROM maintenance_orders AS mo
LEFT JOIN clients AS c
ON mo.client_id = c.id
GROUP BY c.first_name, c.id
ORDER BY orders_count DESC;

-- Question: List the maintenance types (maintenance_types) and their descriptions, ordered by their frequency in days (frequency_days) in descending order.
SELECT 
    name,
    description,
    frequency_days
FROM maintenance_types
WHERE frequency_days IS NOT NULL
ORDER BY frequency_days DESC

-- Question: Find all inspections (inspections) that are still in 'Pending' status.
SELECT 
    *
FROM inspections
WHERE status = 'Pending';

-- Question: Which users have a role of 'admin'?
SELECT
    *
FROM users
WHERE role = 'admin';

-- Question: Show the equipment name and installation date for all equipment installed within the last year.
SELECT 
    equipment_name,
    installation_date
FROM client_equipment
WHERE installation_date >= CURRENT_DATE - INTERVAL '3 year';

-- Question: Retrieve a list of equipment failures (equipment_failures) that were detected but do not yet have a resolution date (resolved_date is NULL) also get names of client, and details of equipment.
WITH all_equipment AS (
    SELECT 
        id,
        client_id,
        equipment_name,
        capacity_btu,
        location,
        status
    FROM client_equipment
)

SELECT
    -- e.client_id,
    c.first_name,
    c.phone,
    c.address,
    e.equipment_name,
    e.capacity_btu,
    e.location,
    e.status,
    ef.detected_date,
    ef.severity_actual,
    ef.repair_notes
FROM equipment_failures AS ef
INNER JOIN all_equipment AS e
ON ef.equipment_id = e.id
INNER JOIN clients AS c
ON e.client_id = c.id
WHERE resolved_date IS NULL;

-- Question: How many clients of each gender (gender) are there in the database?
SELECT
    gender,
    COUNT(gender) AS total_clients
FROM clients
GROUP BY gender;