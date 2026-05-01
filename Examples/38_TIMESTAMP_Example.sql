-- Use TIMESTAMP in employees table
-- TIMESTAMP is used to store both date and time together

-- Table used:
-- employees → stores employee details including created_at

-- Create table with TIMESTAMP
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    created_at TIMESTAMP
);

-- Insert current timestamp
INSERT INTO employees (id, name, created_at)
VALUES (1, 'Rahul', NOW());

-- Auto insert current timestamp
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Auto update timestamp on row update
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
);

-- Explanation
-- TIMESTAMP → stores date and time together
-- Format → YYYY-MM-DD HH:MM:SS
-- NOW() → inserts current date and time
-- DEFAULT CURRENT_TIMESTAMP → auto inserts current time
-- ON UPDATE CURRENT_TIMESTAMP → updates time automatically when row changes

-- Important Note:
-- Useful for tracking record creation and updates
-- Automatically handled by database
-- Time zone may affect stored values (depends on database)

-- Example Table Data

-- | id | name  | created_at          |
-- | -- | ----- | ------------------- |
-- | 1  | Rahul | 2024-01-10 10:30:00 |
-- | 2  | Anita | 2024-01-11 11:45:00 |

-- Example Output

-- | id | name  | created_at          |
-- | -- | ----- | ------------------- |
-- | 1  | Rahul | 2024-01-10 10:30:00 |
-- | 2  | Anita | 2024-01-11 11:45:00 |