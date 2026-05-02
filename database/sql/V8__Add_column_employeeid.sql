ALTER TABLE IF EXISTS people.employees
    ADD COLUMN IF NOT EXISTS employeeid VARCHAR(12) UNIQUE;


CREATE INDEX IF NOT EXISTS idx_employees_employeeid ON people.employees(employeeid);