-- Project In MariaDB 
-- Creating the database
CREATE DATABASE multi_tenant_saas;
USE multi_tenant_saas;

-- Tenants Table
CREATE TABLE tenants (
    tenant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    subscription_plan ENUM('Free', 'Basic', 'Pro', 'Enterprise') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tenants (name, subscription_plan) VALUES
('Alpha Corp', 'Pro'),
('Beta Ltd', 'Enterprise'),
('Gamma Solutions', 'Basic'),
('Delta Inc', 'Free'),
('Epsilon LLC', 'Pro');

-- Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user', 'viewer') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id)
);

INSERT INTO users (tenant_id, email, password_hash, role) VALUES
(1, 'user1@alpha.com', 'pass1hash', 'admin'),
(2, 'user2@beta.com', 'pass2hash', 'user'),
(3, 'user3@gamma.com', 'pass3hash', 'viewer'),
(1, 'user4@alpha.com', 'pass4hash', 'user'),
(5, 'user5@epsilon.com', 'pass5hash', 'admin');

-- Organizations Table
CREATE TABLE organizations (
    org_id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id)
);

INSERT INTO organizations (tenant_id, name, address) VALUES
(1, 'Alpha Tech', '123 Alpha St'),
(2, 'Beta Systems', '456 Beta Ave'),
(3, 'Gamma Labs', '789 Gamma Rd'),
(1, 'Alpha Devs', '321 Alpha Blvd'),
(5, 'Epsilon Innovate', '654 Epsilon Pkwy');

-- Projects Table
CREATE TABLE projects (
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id)
);

INSERT INTO projects (tenant_id, name, description) VALUES
(1, 'Project A', 'Alpha’s first project'),
(2, 'Project B', 'Beta’s enterprise project'),
(3, 'Project C', 'Gamma’s research project'),
(1, 'Project D', 'Another Alpha project'),
(5, 'Project E', 'Epsilon’s startup project');

-- Billing Table
CREATE TABLE billing (
    billing_id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'USD',
    status ENUM('Paid', 'Pending', 'Failed') NOT NULL,
    billing_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id)
);

INSERT INTO billing (tenant_id, amount, currency, status) VALUES
(1, 100.00, 'USD', 'Paid'),
(2, 500.00, 'USD', 'Pending'),
(3, 200.00, 'USD', 'Failed'),
(4, 50.00, 'USD', 'Paid'),
(5, 300.00, 'USD', 'Pending');

-- Audit Logs Table
CREATE TABLE audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id INT,
    user_id INT,
    action TEXT NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO audit_logs (tenant_id, user_id, action) VALUES
(1, 1, 'User created project A'),
(2, 2, 'User updated project B'),
(3, 3, 'User deleted project C'),
(1, 4, 'User logged in'),
(5, 5, 'User made a payment');

-- Retrieve all users belonging to a specific tenant 
SELECT user_id, email, role, created_at 
FROM users 
WHERE tenant_id = 1;

-- Find tenants with overdue payments
SELECT t.tenant_id, t.name, b.amount, b.status 
FROM tenants t
JOIN billing b ON t.tenant_id = b.tenant_id
WHERE b.status IN ('Pending', 'Failed');

-- List all projects managed by a tenant
SELECT project_id, name, description, created_at 
FROM projects 
WHERE tenant_id = 1;

-- Get all organizations under a particular tenant
SELECT org_id, name, address, created_at 
FROM organizations 
WHERE tenant_id = 2;

-- Find the total revenue from all tenants
SELECT SUM(amount) AS total_revenue 
FROM billing 
WHERE status = 'Paid';

-- Find the most active tenant based on user actions
SELECT tenant_id, COUNT(log_id) AS action_count 
FROM audit_logs 
GROUP BY tenant_id 
ORDER BY action_count DESC 
LIMIT 1;

-- Show the total number of projects for each tenant
SELECT tenant_id, COUNT(project_id) AS total_projects 
FROM projects 
GROUP BY tenant_id;

-- Fetch the latest payment made by each tenant
SELECT tenant_id, MAX(billing_date) AS latest_payment 
FROM billing 
WHERE status = 'Paid'
GROUP BY tenant_id;

-- List all users who are admins for their tenants
SELECT user_id, email, tenant_id 
FROM users 
WHERE role = 'admin';

-- Get the total number of users per tenant
SELECT tenant_id, COUNT(user_id) AS total_users 
FROM users 
GROUP BY tenant_id;

-- Find the tenant that has spent the most on billing
SELECT t.tenant_id, t.name, SUM(b.amount) AS total_spent 
FROM tenants t
JOIN billing b ON t.tenant_id = b.tenant_id
WHERE b.status = 'Paid'
GROUP BY t.tenant_id
ORDER BY total_spent DESC 
LIMIT 1;

-- List projects along with their tenant names
SELECT p.project_id, p.name AS project_name, t.name AS tenant_name 
FROM projects p
JOIN tenants t ON p.tenant_id = t.tenant_id;

-- Retrieve audit logs for a specific user
SELECT log_id, action, timestamp 
FROM audit_logs 
WHERE user_id = 3 
ORDER BY timestamp DESC;
