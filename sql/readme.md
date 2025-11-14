# HVAC Maintenance Management System
A comprehensive database system for managing HVAC maintenance operations, client equipment, and service history.

### 📋 Database Schema Overview

**Core Entities**
1. 👥 Clients
- Stores client information and contact details.
- Personal information (name, email, phone, address)
- Client type classification (Residential/Commercial)
- Timestamp tracking for record management

2. 🔧 Users/Technicians
- Manages system users including administrators and service technicians.
- Role-based access control (admin, technician, operator)
- Professional details and hourly rates
- Activity status tracking

3. 🏗️ Client Equipment
- Tracks HVAC equipment installed at client locations.
- Equipment specifications (brand, model, capacity)
- Installation details and warranty information
- Current operational status
- Location-specific information

**Maintenance Management**
1. 🔄 Maintenance Types
- Defines different types of maintenance services.
- Preventive (PM), Corrective (CM), Predictive (PdM) maintenance
- Standardized frequency intervals
- Service descriptions

2. 📝 Maintenance Orders
- Core table for managing service requests and work orders.
- Service scheduling and status tracking
- Cost breakdown (labor, parts, total)
- Technician assignments and notes
- Customer feedback and ratings
- Next maintenance date calculation

**Technical Components**
1. ⚠️ Failure Types
- Standardized catalog of common HVAC equipment failures.
- Categorized failure types (Electrical, Mechanical, Refrigeration, etc.)
- Severity levels and estimated repair times
- Common causes and troubleshooting guidance

2. 🔍 Equipment Failures
- Links specific failures to maintenance orders and equipment.
- Failure detection and resolution tracking
- Actual repair time and severity assessment
- Detailed repair notes

3. 📊 Inspections
- Records equipment inspection and diagnostic data.
- Technical readings (pressure, temperature, amps)
- Findings and recommendations
- Conversion to maintenance orders when needed

4. 🔗 Key Relationships
- Clients can have multiple equipment units
- Each equipment unit can have multiple maintenance orders
- Technicians are assigned to maintenance orders
- Failures are linked to specific maintenance events
- Inspections can be converted into maintenance orders

5. 🎯 System Capabilities
- Complete client and equipment management
- Maintenance scheduling and tracking
- Failure analysis and repair history
- Technician performance monitoring
- Cost tracking and service pricing
- Warranty and installation date management

6. 💾 Technical Features
- Referential integrity with foreign key constraints
- Data validation through check constraints
- Automated timestamp tracking
- Comprehensive indexing for performance
- Standardized failure categorization