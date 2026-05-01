-- Use GRANT and REVOKE in SQL
-- These commands are used to manage user permissions in a database

-- GRANT → gives permissions to a user
-- REVOKE → removes permissions from a user

-- Grant SELECT permission
GRANT SELECT ON employees TO user1;

-- Grant multiple permissions
GRANT SELECT, INSERT, UPDATE
ON employees
TO user1;

-- Grant all permissions
GRANT ALL PRIVILEGES
ON employees
TO user1;

-- Revoke specific permission
REVOKE INSERT
ON employees
FROM user1;

-- Revoke all permissions
REVOKE ALL PRIVILEGES
ON employees
FROM user1;

-- Explanation
-- GRANT → provides access/permission to user
-- REVOKE → removes access/permission
-- SELECT → read data
-- INSERT → add new data
-- UPDATE → modify data
-- DELETE → remove data
-- ALL PRIVILEGES → full access
-- employees → table name
-- user1 → database user

-- Important Note:
-- Used for database security
-- Controls who can access or modify data
-- Permissions can be given at table, database, or column level

-- Example Scenario

-- Before GRANT
-- user1 cannot access employees table

-- After GRANT SELECT
-- user1 can only read data

-- After REVOKE SELECT
-- user1 loses access again