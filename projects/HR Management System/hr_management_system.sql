-- Project In MariaDB 
-- Create database
CREATE DATABASE hr_management_system;
USE hr_management_system;

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    hire_date DATE,
    department_id INT,
    job_id INT,
    salary DECIMAL(10,2),
    status ENUM('Active', 'Inactive') DEFAULT 'Active'
);

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100)
);

CREATE TABLE jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(100),
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2)
);

CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    check_in DATETIME,
    check_out DATETIME,
    date DATE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE leave_requests (
    leave_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    leave_type VARCHAR(50), -- e.g., Sick, Vacation, Emergency
    start_date DATE,
    end_date DATE,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE payroll (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    pay_date DATE,
    basic_salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    deductions DECIMAL(10,2),
    net_salary DECIMAL(10,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

INSERT INTO departments (department_name, location) VALUES
('Human Resources', 'New York'),
('Engineering', 'San Francisco'),
('Marketing', 'Los Angeles');

INSERT INTO jobs (job_title, min_salary, max_salary) VALUES
('HR Manager', 50000, 80000),
('Software Engineer', 60000, 120000),
('Marketing Executive', 40000, 70000);

INSERT INTO employees (full_name, email, phone, date_of_birth, hire_date, department_id, job_id, salary) VALUES
('Alice Smith', 'alice@company.com', '555-1001', '1990-05-15', '2020-01-10', 1, 1, 75000),
('Bob Johnson', 'bob@company.com', '555-1002', '1988-09-23', '2019-03-12', 2, 2, 110000),
('Clara Lee', 'clara@company.com', '555-1003', '1992-12-30', '2021-06-01', 3, 3, 65000);

INSERT INTO attendance (employee_id, check_in, check_out, date) VALUES
(1, '2025-04-08 09:00:00', '2025-04-08 17:00:00', '2025-04-08'),
(2, '2025-04-08 09:30:00', '2025-04-08 18:00:00', '2025-04-08');

INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, status) VALUES
(3, 'Vacation', '2025-04-15', '2025-04-20', 'Approved'),
(1, 'Sick', '2025-04-01', '2025-04-03', 'Approved');

INSERT INTO payroll (employee_id, pay_date, basic_salary, bonus, deductions, net_salary) VALUES
(1, '2025-03-31', 75000, 2000, 500, 76500),
(2, '2025-03-31', 110000, 3000, 800, 112200);

-- Current active employees by department
SELECT d.department_name, COUNT(e.employee_id) AS total_employees
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.status = 'Active'
GROUP BY d.department_name;

-- Monthly attendance report 
SELECT employee_id, date, check_in, check_out,
       TIMESTAMPDIFF(HOUR, check_in, check_out) AS hours_worked
FROM attendance
WHERE MONTH(date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE());

-- Upcoming leaves 
SELECT e.full_name, l.leave_type, l.start_date, l.end_date
FROM leave_requests l
JOIN employees e ON l.employee_id = e.employee_id
WHERE l.start_date > CURDATE();

-- Payroll summary
SELECT e.full_name, p.pay_date, p.basic_salary, p.bonus, p.deductions, p.net_salary
FROM payroll p
JOIN employees e ON p.employee_id = e.employee_id
ORDER BY p.pay_date DESC;

-- Employees Who Didn’t Attend Today
SELECT e.full_name
FROM employees e
WHERE e.employee_id NOT IN (
    SELECT a.employee_id
    FROM attendance a
    WHERE a.date = CURDATE()
);

-- Salary Range by Job Title
SELECT job_title, MIN(salary) AS min_current_salary, MAX(salary) AS max_current_salary
FROM employees e
JOIN jobs j ON e.job_id = j.job_id
GROUP BY job_title;

-- Longest-Serving Employees 
SELECT full_name, hire_date, DATEDIFF(CURDATE(), hire_date) AS days_with_company
FROM employees
ORDER BY hire_date ASC
LIMIT 5;

-- Total Monthly Payroll Cost
SELECT 
    DATE_FORMAT(pay_date, '%Y-%m') AS month,
    SUM(net_salary) AS total_payroll
FROM payroll
GROUP BY month
ORDER BY month DESC;

-- Department-wise Salary Expenditure
SELECT d.department_name, SUM(e.salary) AS total_salaries
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- Employee Attendance Summary (Total Hours Worked in Current Month)
SELECT 
    e.full_name,
    SUM(TIMESTAMPDIFF(HOUR, a.check_in, a.check_out)) AS total_hours
FROM attendance a
JOIN employees e ON a.employee_id = e.employee_id
WHERE MONTH(a.date) = MONTH(CURDATE()) AND YEAR(a.date) = YEAR(CURDATE())
GROUP BY e.full_name;

-- Search Employee by Name or Email (Flexible Search)
SELECT * 
FROM employees
WHERE full_name LIKE '%alice%' OR email LIKE '%alice%';

-- Employee Leave Balance (Assuming 20 total days/year)
SELECT 
    e.full_name,
    SUM(DATEDIFF(l.end_date, l.start_date) + 1) AS total_leave_taken,
    (20 - SUM(DATEDIFF(l.end_date, l.start_date) + 1)) AS leave_balance
FROM employees e
JOIN leave_requests l ON e.employee_id = l.employee_id
WHERE YEAR(l.start_date) = YEAR(CURDATE()) AND l.status = 'Approved'
GROUP BY e.employee_id;