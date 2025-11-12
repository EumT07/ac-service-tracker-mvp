-- =============================================================================
-- TABLAS BASE
-- =============================================================================

-- 1. CLIENTS
CREATE TABLE clients (
  id VARCHAR(50) PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(255) UNIQUE,
  gender VARCHAR(50) CHECK (gender IN ('Male', 'Female')),
  phone VARCHAR(50) UNIQUE NOT NULL,
  address TEXT,
  client_type VARCHAR(50) DEFAULT 'Residential' CHECK (client_type IN ('Residential', 'Commercial')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. USERS/TECHNICIANS
CREATE TABLE users (
  id VARCHAR(50) PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(50) UNIQUE NOT NULL,
  gender VARCHAR(50) CHECK (gender IN ('Male', 'Female')),
  address TEXT,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'technician' CHECK (role IN ('admin', 'technician', 'operator')),
  hourly_rate DECIMAL(10,2) DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. MAINTENANCE TYPES
CREATE TABLE maintenance_types (
  id VARCHAR(50) PRIMARY KEY,
  code VARCHAR(10) UNIQUE NOT NULL CHECK (code IN ('PM', 'CM', 'PdM')),
  name VARCHAR(100) NOT NULL,
  frequency_days INTEGER,
  description TEXT
);

-- 4. FAILURE TYPES
CREATE TABLE failure_types (
  id VARCHAR(50) PRIMARY KEY,
  category VARCHAR(100) NOT NULL CHECK (category IN (
    'Electrical', 'Mechanical', 'Refrigeration', 'Airflow', 
    'Control System', 'Drainage', 'Noise/Vibration', 'Other'
  )),
  name VARCHAR(255) NOT NULL UNIQUE,
  severity VARCHAR(50) CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
  estimated_repair_hours INTEGER DEFAULT 1 CHECK (estimated_repair_hours > 0),
  common_causes TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================================================
-- TABLAS PRINCIPALES
-- =============================================================================

-- 5. CLIENT_EQUIPMENT
CREATE TABLE client_equipment (
  id VARCHAR(50) PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  equipment_name VARCHAR(100) NOT NULL,
  brand VARCHAR(100) NOT NULL,
  model VARCHAR(100) NOT NULL,
  serial_number VARCHAR(100),
  equipment_type VARCHAR(50) CHECK (equipment_type IN (
    'Split AC', 'Window AC', 'Central AC', 'Furnace', 'Heat Pump', 
    'Ventilation', 'Chiller', 'Other'
  )),
  capacity_btu INTEGER CHECK (capacity_btu > 0),
  location VARCHAR(100),
  installation_date DATE,
  warranty_expiration DATE,
  status VARCHAR(50) DEFAULT 'Operational' CHECK (status IN (
    'Operational', 'Requires Repair', 'Out of Service', 'Under Maintenance'
  )),
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
);

-- 6. MAINTENANCE ORDERS (Tabla principal)
CREATE TABLE maintenance_orders (
  id VARCHAR(50) PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  user_id VARCHAR(50) NOT NULL,
  equipment_id VARCHAR(50) NOT NULL,
  type_id VARCHAR(50) NOT NULL,
  status VARCHAR(50) NOT NULL CHECK (status IN (
    'scheduled', 'in_progress', 'completed', 'cancelled'
  )),
  scheduled_date DATE NOT NULL,
  completed_date DATE,
  technician_notes TEXT,
  customer_feedback TEXT,
  customer_rating INTEGER CHECK (customer_rating BETWEEN 1 AND 5),
  labor_hours DECIMAL(5,2) DEFAULT 0 CHECK (labor_hours >= 0),
  labor_cost DECIMAL(10,2) DEFAULT 0 CHECK (labor_cost >= 0),
  parts_cost DECIMAL(10,2) DEFAULT 0 CHECK (parts_cost >= 0),
  total_cost DECIMAL(10,2) DEFAULT 0 CHECK (total_cost >= 0),
  next_maintenance_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  FOREIGN KEY (equipment_id) REFERENCES client_equipment(id) ON DELETE CASCADE,
  FOREIGN KEY (type_id) REFERENCES maintenance_types(id) ON DELETE RESTRICT,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- 7. EQUIPMENT_FAILURES
CREATE TABLE equipment_failures (
  id VARCHAR(50) PRIMARY KEY,
  maintenance_order_id VARCHAR(50) NOT NULL,
  failure_type_id VARCHAR(50) NOT NULL,
  equipment_id VARCHAR(50) NOT NULL,
  detected_date DATE NOT NULL,
  resolved_date DATE,
  severity_actual VARCHAR(50) CHECK (severity_actual IN ('Low', 'Medium', 'High', 'Critical')),
  repair_notes TEXT,
  repair_hours_actual DECIMAL(5,2) CHECK (repair_hours_actual >= 0),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (maintenance_order_id) REFERENCES maintenance_orders(id) ON DELETE CASCADE,
  FOREIGN KEY (failure_type_id) REFERENCES failure_types(id) ON DELETE RESTRICT,
  FOREIGN KEY (equipment_id) REFERENCES client_equipment(id) ON DELETE CASCADE
);

-- 8. INSPECTIONS
CREATE TABLE inspections (
  id VARCHAR(50) PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  equipment_id VARCHAR(50) NOT NULL,
  user_id VARCHAR(50) NOT NULL,
  inspection_date DATE NOT NULL,
  pressure_suction DECIMAL(10,2),
  temp_supply DECIMAL(10,2),
  temp_return DECIMAL(10,2),
  amps_reading DECIMAL(10,2),
  general_notes TEXT,
  findings_summary TEXT,
  status VARCHAR(50) DEFAULT 'Pending' CHECK (status IN (
    'Pending', 'Converted to Maintenance', 'Rejected'
  )),
  converted_to_maintenance_order_id VARCHAR(50) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  FOREIGN KEY (equipment_id) REFERENCES client_equipment(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
  FOREIGN KEY (converted_to_maintenance_order_id) REFERENCES maintenance_orders(id) ON DELETE SET NULL
);