-- Using UUID 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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

-- 2. Users
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
  code VARCHAR(10) NOT NULL,
  name VARCHAR(100) NOT NULL,
  frequency_days INTEGER CHECK (frequency_days > 0),
  description TEXT
);

-- 4. Equipment Master Tables
CREATE TABLE equipment_types (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE equipment_brands (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE
);

-- 5. Client Equipment (ESTA TABLA FALTABA Y ES NECESARIA PARA LAS ÓRDENES)
CREATE TABLE client_equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    equipment_name VARCHAR(100) NOT NULL,
    brand_id UUID NOT NULL REFERENCES equipment_brands(id) ON DELETE RESTRICT,
    equipment_type_id UUID NOT NULL REFERENCES equipment_types(id) ON DELETE RESTRICT,
    model VARCHAR(100),
    serial_number VARCHAR(100),
    status VARCHAR(50) DEFAULT 'Operational',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6. Failure Categories and Types
CREATE TABLE failure_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE failure_types (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id UUID NOT NULL REFERENCES failure_categories(id) ON DELETE RESTRICT,
  name VARCHAR(255) NOT NULL UNIQUE,
  severity VARCHAR(50) CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
  estimated_repair_hours DECIMAL(5,2) DEFAULT 1.0 CHECK (estimated_repair_hours > 0),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Maintenance Orders
CREATE TABLE maintenance_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    equipment_id UUID NOT NULL REFERENCES client_equipment(id) ON DELETE CASCADE,
    type_id UUID NOT NULL REFERENCES maintenance_types(id) ON DELETE RESTRICT,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled' 
        CHECK (status IN ('scheduled', 'in_progress', 'completed', 'cancelled')),
    scheduled_date DATE NOT NULL,
    labor_cost DECIMAL(10,2) DEFAULT 0 CHECK (labor_cost >= 0),
    parts_cost DECIMAL(10,2) DEFAULT 0 CHECK (parts_cost >= 0),
    total_cost DECIMAL(10,2) GENERATED ALWAYS AS (labor_cost + parts_cost) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Equipment Failures
CREATE TABLE equipment_failures (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  maintenance_order_id UUID REFERENCES maintenance_orders(id) ON DELETE SET NULL,
  failure_type_id UUID NOT NULL REFERENCES failure_types(id) ON DELETE RESTRICT,
  equipment_id UUID NOT NULL REFERENCES client_equipment(id) ON DELETE CASCADE,
  detected_date DATE NOT NULL DEFAULT CURRENT_DATE,
  resolved_date DATE,
  severity_actual VARCHAR(50) CHECK (severity_actual IN ('Low', 'Medium', 'High', 'Critical')),
  repair_notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9. Inspections
CREATE TABLE inspections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
  equipment_id UUID NOT NULL REFERENCES client_equipment(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  inspection_date DATE NOT NULL DEFAULT CURRENT_DATE,
  status VARCHAR(50) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Converted to Maintenance', 'Rejected')),
  converted_to_maintenance_order_id UUID UNIQUE REFERENCES maintenance_orders(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);