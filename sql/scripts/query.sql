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

-- Question: Show a list of completed maintenance orders, including the client's name, the name of the equipment serviced, and the full name of the assigned technician.
SELECT 
    mo.id,
    CONCAT(c.first_name, ' ', c.last_name) AS Client,
    CONCAT(u.first_name, ' ', u.last_name) AS Technician,
    ce.equipment_name,
    mo.status,
    mo.total_cost,
    mo.completed_date,
    mo.next_maintenance_date,
    mo.technician_notes
FROM maintenance_orders AS mo
INNER JOIN clients AS c
ON mo.client_id = c.id
INNER JOIN users AS u
ON mo.user_id = u.id
INNER JOIN client_equipment AS ce
ON mo.equipment_id = ce.id
WHERE mo.status = 'completed';

-- Question: Find the top 5 pieces of equipment that have required the most maintenance orders (the most problematic). Show the equipment name and the order count.
SELECT 
    ce.equipment_name,
    COUNT(mo.id) As order_count
FROM maintenance_orders AS mo
INNER JOIN client_equipment AS ce
ON mo.equipment_id = ce.id
GROUP BY ce.equipment_name
ORDER BY order_count DESC
LIMIT 5;

-- Question: For each failure category (failure_types.category), calculate the average estimated repair hours (estimated_repair_hours) and the average actual repair hours (repair_hours_actual). In which categories did repairs take longer than estimated on average?
SELECT
    ft.category,
    AVG(ft.estimated_repair_hours) AS avg_estimated_repairs_hours,
    AVG(ef.repair_hours_actual) AS avg_actual_repairs_hours
FROM equipment_failures AS ef
INNER JOIN failure_types AS ft
ON ef.failure_type_id = ft.id
GROUP BY ft.category
HAVING AVG(ft.estimated_repair_hours) < AVG(ef.repair_hours_actual)

-- Question: List all technicians and the total number of labor hours (labor_hours) they have recorded on completed orders. Include only technicians with more than 50 total hours.
SELECT 
    u.id,
    CONCAT(u.first_name, ' ', u.last_name) AS Technician,
    SUM(mo.labor_hours) AS total_labor_hours
FROM maintenance_orders AS mo
INNER JOIN users AS u
ON mo.user_id = u.id
WHERE mo.status = 'completed'
GROUP BY u.id
HAVING SUM(mo.labor_hours) > 3;

--Question: Find the maintenance orders that were created from an inspection (i.e., where the inspection was "Converted to Maintenance").

--Question: Which clients (full name) have not had any maintenance orders? (Use a subquery or a LEFT JOIN with a WHERE IS NULL filter).

--Question: Calculate the total labor cost (labor_cost) and total parts cost (parts_cost) per month and year, based on the completion date of the orders.
--Question: Show the equipment that has the nearest upcoming warranty expiration date (warranty_expiration) that has not yet expired.
--Question: Find the maintenance order with the highest total_cost. Include the client's name and the associated technician's name in the result.
--Question: For each 'Commercial' client, calculate how many pieces of equipment they have in each status (status in client_equipment).
--Question: Create a "Maintenance History" for a specific piece of equipment (choose an equipment_id). The query should combine information from the maintenance order, maintenance type, technician, costs, and any found failures into a single, clear view.
--Question: Identify the most efficient technicians. Calculate the average difference between the estimated repair hours for a failure (failure_types.estimated_repair_hours) and the actual hours the technician took (equipment_failures.repair_hours_actual) for the orders they completed. A positive value means they were faster than estimated.
--Question: Find "recurring" clients. List the clients who have had more than 3 corrective maintenance orders (maintenance_types.code = 'CM') in the last 6 months.
--Question: Write a query that shows, for each month of the current year, the number of new inspections and the number of new maintenance orders. This will help you see the relationship between the two processes over time.
--Question: Business Question: The sales department wants a list of "Preventive Maintenance Opportunities." Find all equipment that: Does not have a preventive maintenance order (maintenance_types.code = 'PM') scheduled (scheduled_date) for the next month. And their last completed preventive maintenance (status = 'completed') was over 6 months ago (or they have never had one).