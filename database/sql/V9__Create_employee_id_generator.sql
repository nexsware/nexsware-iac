-- Generate a new random employee ID 

CREATE OR REPLACE FUNCTION people.generate_unique_employee_id()
RETURNS VARCHAR(12) AS $$
DECLARE
    new_id VARCHAR(12);
    done BOOL;
BEGIN
    done := FALSE;
    WHILE NOT done LOOP
        -- Generate a random 12-digit number as a string
        new_id := LPAD(FLOOR(RANDOM() * 900000000000 + 100000000000)::TEXT, 12, '0');

        -- Check if the generated ID already exists in the Employees table
        EXIT WHEN NOT EXISTS (SELECT 1 FROM people.employees WHERE employeeid = new_id);
    END LOOP;
    RETURN new_id;
END;
$$ LANGUAGE plpgsql;