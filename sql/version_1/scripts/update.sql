-- Updating a mistake that I did when I was creatinmg a table. 

/*
- CREATE TABLE maintenance_types (
  id VARCHAR(50) PRIMARY KEY,
  code VARCHAR(10) UNIQUE NOT NULL CHECK (code IN ('PM', 'CM', 'PdM')),
  name VARCHAR(100) NOT NULL,
  frequency_days INTEGER,
  description TEXT
);
*/

--Error:
/*
Started executing query at Line 36
llave duplicada viola restricción de unicidad «maintenance_types_code_key»
DETAIL: Ya existe la llave (code)=(CM).
Total execution time: 00:00:00.004
*/

SELECT constraint_name 
FROM information_schema.table_constraints 
WHERE table_name = 'maintenance_types' 
AND constraint_type = 'UNIQUE';

ALTER TABLE maintenance_types 
DROP CONSTRAINT maintenance_types_code_key;