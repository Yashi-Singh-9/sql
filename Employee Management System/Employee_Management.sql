-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE Employee_Management;
\c Employee_Management;

-- Departments Table 
CREATE TABLE Departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL,
    manager_id INT
);

-- Jobs Table 
CREATE TABLE Jobs (
    job_id SERIAL PRIMARY KEY,
    job_title VARCHAR(50) NOT NULL,
    min_salary DECIMAL(10,2) NOT NULL,
    max_salary DECIMAL(10,2) NOT NULL
);

-- Employees Table
CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    hire_date DATE NOT NULL,
    job_id INT REFERENCES Jobs(job_id),
    salary DECIMAL(10,2) NOT NULL,
    department_id INT REFERENCES Departments(department_id),
    manager_id INT REFERENCES Employees(employee_id)
);

-- Attendance Table  
CREATE TABLE Attendance (
    attendance_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES Employees(employee_id),
    date DATE NOT NULL,
    status VARCHAR(10) CHECK (status IN ('Present', 'Absent', 'Late', 'Leave')) NOT NULL
);

-- Salaries Table  
CREATE TABLE Salaries (
    salary_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES Employees(employee_id),
    basic_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2),
    deductions DECIMAL(10,2),
    net_salary DECIMAL(10,2) NOT NULL
);

-- Leaves Table 
CREATE TABLE Leaves (
    leave_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES Employees(employee_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    leave_type VARCHAR(20) CHECK (leave_type IN ('Sick Leave', 'Casual Leave', 'Annual Leave', 'Maternity Leave')) NOT NULL,
    status VARCHAR(10) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected'))
);

INSERT INTO Departments (department_name, manager_id) VALUES
('HR', 1),
('Finance', 2),
('IT', 3),
('Sales', 4),
('HR', 1);

INSERT INTO Jobs (job_title, min_salary, max_salary) VALUES
('Software Engineer', 50000, 120000),
('HR Manager', 45000, 100000),
('Accountant', 40000, 90000),
('Sales Executive', 35000, 85000),
('Software Engineer', 50000, 120000);

INSERT INTO Employees (first_name, last_name, email, phone, hire_date, job_id, salary, department_id, manager_id) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', '2021-01-15', 1, 75000, 3, NULL),
('Alice', 'Smith', 'alice.smith@example.com', '1234567891', '2020-06-10', 2, 60000, 1, 1),
('Bob', 'Johnson', 'bob.johnson@example.com', '1234567892', '2019-03-25', 3, 55000, 2, 2),
('John', 'Doe', 'john.duplicate@example.com', '1234567893', '2022-07-20', 1, 75000, 3, NULL),
('Alice', 'Smith', 'alice.duplicate@example.com', '1234567894', '2023-09-10', 2, 60000, 1, 1);

INSERT INTO Attendance (employee_id, date, status) VALUES
(1, '2024-02-20', 'Present'),
(2, '2024-02-20', 'Absent'),
(3, '2024-02-20', 'Late'),
(4, '2024-02-20', 'Present'),
(5, '2024-02-20', 'Absent');

INSERT INTO Salaries (employee_id, basic_salary, bonus, deductions, net_salary) VALUES
(1, 75000, 5000, 2000, 78000),
(2, 60000, 3000, 1500, 61500),
(3, 55000, 2000, 1000, 56000),
(4, 75000, 5000, 2000, 78000),
(5, 60000, 3000, 1500, 61500);

INSERT INTO Leaves (employee_id, start_date, end_date, leave_type, status) VALUES
(1, '2024-02-01', '2024-02-05', 'Sick Leave', 'Approved'),
(2, '2024-03-10', '2024-03-12', 'Casual Leave', 'Pending'),
(3, '2024-01-20', '2024-01-25', 'Annual Leave', 'Rejected'),
(4, '2024-02-01', '2024-02-05', 'Sick Leave', 'Approved'),
(5, '2024-03-10', '2024-03-12', 'Casual Leave', 'Pending');

-- Retrieve all employees along with their department names and job titles.
SELECT e.employee_id, e.first_name, e.last_name, e.email, 
       d.department_name, j.job_title, e.salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
JOIN Jobs j ON e.job_id = j.job_id;

-- Get a list of employees who report to a specific manager
SELECT employee_id, first_name, last_name, manager_id
FROM Employees
WHERE manager_id = 1;

-- Find the total salary paid to each department.
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name;

-- Calculate net salary of employees after deductions and bonuses.
SELECT e.employee_id, e.first_name, e.last_name, s.basic_salary, 
       s.bonus, s.deductions, (s.basic_salary + COALESCE(s.bonus, 0) - COALESCE(s.deductions, 0)) AS net_salary
FROM Employees e
JOIN Salaries s ON e.employee_id = s.employee_id;

-- Find the department with the highest number of employees.
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM Employees e
JOIN Departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY employee_count DESC
LIMIT 1;

-- List employees who joined before a certain date but haven't received a promotion (assuming promotions affect job_id).
SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, j.job_title
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
WHERE e.hire_date < '2022-01-01' 
AND e.job_id NOT IN (
    SELECT DISTINCT job_id FROM Employees WHERE hire_date > '2022-01-01'
);

-- This query retrieves the employee(s) who have taken the highest number of leaves.
SELECT e.employee_id, e.first_name, e.last_name, COUNT(l.leave_id) AS leave_count
FROM Employees e
JOIN Leaves l ON e.employee_id = l.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY leave_count DESC
LIMIT 1;  -- Get the top employee with the most leaves.

-- This query retrieves the employee who has the second highest salary.
SELECT employee_id, first_name, last_name, salary
FROM Employees
ORDER BY salary DESC
OFFSET 1 LIMIT 1;

-- This query finds employees who share the same salary as someone else.
SELECT e1.employee_id, e1.first_name, e1.last_name, e1.salary
FROM Employees e1
JOIN Employees e2 ON e1.salary = e2.salary AND e1.employee_id <> e2.employee_id
ORDER BY e1.salary;