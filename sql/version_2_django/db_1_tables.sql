-- Using UUID 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ======
-- Tables
-- ======

-- 1. Clients
CREATE TABLE clients (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
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

-- 2. User/Technicians
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(50) UNIQUE NOT NULL,
  gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
  address TEXT,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'technician' CHECK (role IN ('admin', 'technician', 'operator')),
  hourly_rate DECIMAL(10,2) DEFAULT 0.00 CHECK (hourly_rate >= 0),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Maintenance Types
CREATE TABLE maintenance_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code VARCHAR(10) NOT NULL CHECK (code IN ('PM', 'CM', 'PdM')),
  name VARCHAR(100) NOT NULL,
  frequency_days INTEGER CHECK (frequency_days > 0),
  description TEXT
);

-- 4.1 Failure Categories
CREATE TABLE failure_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE
);
/*
    ('Electrical', 'Mechanical', 'Refrigeration', 'Airflow', 'Control System', 'Drainage', 'Noise/Vibration', 'Other')
*/
-- 4.2 Failure Types
CREATE TABLE failure_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id UUID NOT NULL,
  name VARCHAR(255) NOT NULL UNIQUE,
  severity VARCHAR(50) CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
  estimated_repair_hours DECIMAL(5,2) DEFAULT 1.0 CHECK (estimated_repair_hours > 0),
  common_causes TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  -- Relationships
  FOREIGN KEY (category_id) REFERENCES failure_categories(id) ON DELETE RESTRICT
);

-- 5.1 Client Equipment Types:
CREATE TABLE equipment_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE
);
/*
    ('Split AC', 'Window AC', 'Central AC', 'Furnace', 'Heat Pump', 
    'Ventilation', 'Chiller', 'Other')
*/

-- 5.2 Client Equipment Brands:
CREATE TABLE equipment_brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 5.3 Client Equipment
CREATE TABLE maintenance_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL,
    user_id UUID NOT NULL,-- Technician
    equipment_id UUID NOT NULL,
    type_id UUID NOT NULL,-- Type (PM, CM, PdM)
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled' 
        CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    scheduled_date DATE NOT NULL,
    completed_date DATE,
    next_maintenance_date DATE,
    technician_notes TEXT,
    customer_feedback TEXT,
    customer_rating INTEGER CHECK (customer_rating BETWEEN 1 AND 5),
    labor_hours DECIMAL(5,2) DEFAULT 0 CHECK (labor_hours >= 0),
    labor_cost DECIMAL(10,2) DEFAULT 0 CHECK (labor_cost >= 0),
    parts_cost DECIMAL(10,2) DEFAULT 0 CHECK (parts_cost >= 0),
    total_cost DECIMAL(10,2) GENERATED ALWAYS AS (labor_cost + parts_cost) STORED,,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Relationships
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
    FOREIGN KEY (equipment_id) REFERENCES client_equipment(id) ON DELETE CASCADE,
    FOREIGN KEY (type_id) REFERENCES maintenance_types(id) ON DELETE RESTRICT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
);

-- 7. Equipment Failures
CREATE TABLE equipment_failures (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  maintenance_order_id UUID,
  failure_type_id UUID NOT NULL,
  equipment_id UUID NOT NULL,
  detected_date DATE NOT NULL DEFAULT CURRENT_DATE,
  resolved_date DATE,
  severity_actual VARCHAR(50) CHECK (severity_actual IN ('Low', 'Medium', 'High', 'Critical')),
  repair_notes TEXT,
  repair_hours_actual DECIMAL(5,2) CHECK (repair_hours_actual >= 0),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (maintenance_order_id) REFERENCES maintenance_orders(id) ON DELETE SET NULL,
  FOREIGN KEY (failure_type_id) REFERENCES failure_types(id) ON DELETE RESTRICT,
  FOREIGN KEY (equipment_id) REFERENCES client_equipment(id) ON DELETE CASCADE
);

-- 8. Inspections
CREATE TABLE inspections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID NOT NULL,
  equipment_id UUID NOT NULL,
  user_id UUID NOT NULL,
  inspection_date DATE NOT NULL DEFAULT CURRENT_DATE,
  pressure_suction DECIMAL(10,2),
  temp_supply DECIMAL(10,2),
  temp_return DECIMAL(10,2),
  amps_reading DECIMAL(10,2),
  general_notes TEXT,
  findings_summary TEXT,
  status VARCHAR(50) DEFAULT 'Pending' CHECK (status IN (
    'Pending', 'Converted to Maintenance', 'Rejected'
  )),
  converted_to_maintenance_order_id UUID UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  --Relationships
  FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE,
  FOREIGN KEY (equipment_id) REFERENCES client_equipment(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
  FOREIGN KEY (converted_to_maintenance_order_id) REFERENCES maintenance_orders(id) ON DELETE SET NULL
);