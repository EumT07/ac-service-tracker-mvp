-- Using UUID 
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE employees (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  phone VARCHAR(50) UNIQUE NOT NULL,
  gender VARCHAR(10) CHECK (gender IN ('Male', 'Female')),
  address TEXT,
  password VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'Technician' CHECK (role IN ('Admin', 'Technician', 'Operator', 'Trainer')),
  employee_hourly_rate DECIMAL(10,2) DEFAULT 0.00 CHECK (employee_hourly_rate >= 0),
  cost_hourly_rate DECIMAL(10,2) GENERATED ALWAYS AS ( (employee_hourly_rate * 0.5) + employee_hourly_rate) STORED,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE clients (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(255) UNIQUE NOT NULL,
  gender VARCHAR(50) CHECK (gender IN ('Male', 'Female')),
  phone VARCHAR(50) UNIQUE NOT NULL,
  address TEXT,
  client_type VARCHAR(50) DEFAULT 'Residential' CHECK (client_type IN ('Residential', 'Commercial')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employee_invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(id) ON DELETE RESTRICT,
    period_start DATE NOT NULL,
    period_end DATE NOT NULL,
    total_hours_worked DECIMAL(10,2) DEFAULT 0.00,
    employee_hourly_rate DECIMAL(10,2) NOT NULL,
    bonuses DECIMAL(10,2) DEFAULT 0.00,
    reimbursements DECIMAL(10,2) DEFAULT 0.00,
    deductions DECIMAL(10,2) DEFAULT 0.00,
    total_payment DECIMAL(10,2) GENERATED ALWAYS AS (
        (total_hours_worked * employee_hourly_rate) + bonuses + reimbursements - deductions
    ) STORED,
    payment_date DATE,
    payment_reference VARCHAR(100),
    status VARCHAR(20) DEFAULT 'Draft' CHECK (status IN ('Draft', 'Approved', 'Paid', 'Disputed', 'Cancelled')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE client_equipment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    client_id UUID NOT NULL REFERENCES clients(id) ON DELETE CASCADE,
    brand VARCHAR(100),
    equipment_type VARCHAR(100),
    model VARCHAR(100),
    serial_number VARCHAR(100),
    location varchar(255),
    installation_date DATE,
    warranty_expiration DATE,
    capacity_btu INTEGER CHECK (capacity_btu > 0),
    status VARCHAR(50) DEFAULT 'Operational' CHECK (status IN (
    'Operational', 'Requires Repair', 'Out of Service', 'Under Maintenance'
  )),
    equipment_condition VARCHAR(50) DEFAULT 'New' CHECK (equipment_condition IN ('New', 'Refurbished', 'Used','For Parts')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  client_id UUID  REFERENCES clients(id) ON DELETE SET NULL,
  client_equipment_id UUID REFERENCES client_equipment(id) ON DELETE SET NULL,
  lead_technician_id UUID REFERENCES employees(id) ON DELETE SET NULL,
  service_type VARCHAR(50) DEFAULT 'Inspection' CHECK (service_type IN ('Inspection','Installation' ,'Maintenance')),
  service_date DATE NOT NULL DEFAULT CURRENT_DATE,
  status VARCHAR(50) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved','Rejected')),
  notes TEXT,
  cost DECIMAL(10,2) DEFAULT 30.00 CHECK (cost >= 30.00),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE work_orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    services_id UUID UNIQUE REFERENCES services(id) ON DELETE RESTRICT,
    client_id UUID REFERENCES clients(id) ON DELETE SET NULL,
    lead_technician_id UUID REFERENCES employees(id) ON DELETE SET NULL,
    client_equipment_id UUID REFERENCES client_equipment(id) ON DELETE SET NULL,
    code VARCHAR(10) NOT NULL DEFAULT 'PM' CHECK (code IN ('PM', 'CM', 'PdM','INSP','INST')),
    pressure_suction DECIMAL(10,2),
    temperature_in DECIMAL(10,2),
    temperature_out DECIMAL(10,2),
    amps_reading DECIMAL(10,2),
    voltage_reading DECIMAL(10,2),
    scheduled_date DATE NOT NULL,
    completed_date DATE,
    next_work_date DATE,
    total_parts_cost DECIMAL(10,2) DEFAULT 0.00,
    total_labor_cost DECIMAL(10,2) DEFAULT 0.00,
    total_order_cost DECIMAL(10,2) GENERATED ALWAYS AS (total_parts_cost + total_labor_cost) STORED,
    status VARCHAR(20) NOT NULL DEFAULT 'Scheduled' CHECK (status IN ('Scheduled', 'In Progress', 'Completed', 'Cancelled')),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE order_parts_used (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_order_id UUID NOT NULL REFERENCES work_orders(id) ON DELETE CASCADE,
    part_name VARCHAR(150),
    quantity DECIMAL(10,2) DEFAULT 1.00,
    unit_price DECIMAL(10,2) DEFAULT 0.00,
    line_total DECIMAL(10,2) GENERATED ALWAYS AS (quantity * unit_price) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE order_labor_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_order_id UUID NOT NULL REFERENCES work_orders(id) ON DELETE CASCADE,
    technician_id UUID REFERENCES employees(id) ON DELETE SET NULL,
    employee_invoice_id UUID REFERENCES employee_invoices(id) ON DELETE SET NULL,
    hours_worked DECIMAL(10,2), 
    hourly_rate_at_time DECIMAL(10,2) DEFAULT 0.00 CHECK (hourly_rate_at_time >= 0),
    labor_description TEXT,
    line_total DECIMAL(10,2) GENERATED ALWAYS AS (hours_worked * hourly_rate_at_time) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE equipment_failures (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  work_order_id UUID REFERENCES work_orders(id) ON DELETE SET NULL,
  client_equipment_id UUID NOT NULL REFERENCES client_equipment(id) ON DELETE CASCADE,
  failure_category VARCHAR(100),
  failure_description TEXT,
  detected_date DATE NOT NULL DEFAULT CURRENT_DATE,
  resolved_date DATE,
  severity VARCHAR(50) CHECK (severity IN ('Low', 'Medium', 'High', 'Critical')),
  is_active BOOLEAN DEFAULT TRUE,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE leads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID REFERENCES employees(id) ON DELETE SET NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender VARCHAR(50) CHECK (gender IN ('Male', 'Female')),
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(50) UNIQUE,
    lead_type VARCHAR(20) DEFAULT 'Residential' CHECK (lead_type IN ('Residential', 'Commercial')),
    service_type VARCHAR(50) CHECK (service_type IN ('Inspection','Installation' ,'Maintenance')),
    notes TEXT,
    status VARCHAR(50) DEFAULT 'New' CHECK (status IN ('New','Contacted', 'Follow-up', 'Scheduled', 'Lost')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bills (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    work_order_id UUID UNIQUE REFERENCES work_orders(id) ON DELETE SET NULL,
    service_id UUID UNIQUE REFERENCES services(id) ON DELETE SET NULL,
    client_id UUID REFERENCES clients(id) ON DELETE SET NULL,
    bill_date DATE NOT NULL DEFAULT CURRENT_DATE,
    total_labor_cost DECIMAL(10,2) DEFAULT 0.00,
    total_parts_cost DECIMAL(10,2) DEFAULT 0.00,
    service_fee DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(10,2) GENERATED ALWAYS AS (total_labor_cost + total_parts_cost + service_fee) STORED,
    status VARCHAR(50) DEFAULT 'Unpaid' CHECK (status IN ('Unpaid', 'Paid', 'Overdue')),
    payment_method VARCHAR(50) CHECK (payment_method IN ('Cash', 'Transfer', 'Credit Card','Bank Transfer','Other')),
    payment_reference VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
