-- MS SQL Project
CREATE DATABASE AttendanceDB;
USE AttendanceDB;

-- Users Table  
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  phone BIGINT,
  role VARCHAR(15) CHECK (role IN ('Student', 'Teacher', 'Employee', 'Admin', 'Manager', 'Supervisor', 'Staff', 'Guest', 'Intern'))
);

-- Departments Table  
CREATE TABLE departments (
  department_id INT IDENTITY(1,1) PRIMARY KEY,
  department_name VARCHAR(20)
);

-- Courses Table  
CREATE TABLE courses (
  course_id INT IDENTITY(1,1) PRIMARY KEY,
  course_name VARCHAR(20),
  instructor_id INT,
  FOREIGN KEY (instructor_id) REFERENCES users(user_id)
);

-- Attendance Table  
CREATE TABLE attendance (
  attendance_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  date DATE,
  status VARCHAR(10) CHECK (status IN ('Present', 'Absent', 'Late')),
  remarks TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Shifts Table 
CREATE TABLE shifts (
  shift_id INT IDENTITY(1,1) PRIMARY KEY,
  shift_name VARCHAR(20),
  start_time TIME,
  end_time TIME
);

-- User Shifts Table 
CREATE TABLE user_shifts (
  user_id INT,
  shift_id INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (shift_id) REFERENCES shifts(shift_id)
);

-- Holidays Table
CREATE Table holidays (
  holiday_id INT PRIMARY KEY,
  date DATE,
  description TEXT
);  

-- Insert Users  
INSERT INTO users (name, email, phone, role) VALUES
('Alice Johnson', 'alice@example.com', 1234567890, 'Student'),
('Bob Smith', 'bob@example.com', 1234567891, 'Teacher'),
('Charlie Brown', 'charlie@example.com', 1234567892, 'Employee'),
('David Lee', 'david@example.com', 1234567893, 'Admin'),
('Eve Adams', 'eve@example.com', 1234567894, 'Manager'),
('Frank White', 'frank@example.com', 1234567895, 'Supervisor'),
('Grace Hall', 'grace@example.com', 1234567896, 'Staff'),
('Hannah Scott', 'hannah@example.com', 1234567897, 'Guest'),
('Ian Turner', 'ian@example.com', 1234567898, 'Intern'),
('Jack Miller', 'jack@example.com', 1234567899, 'Student'),
('Kelly Green', 'kelly@example.com', 1234567800, 'Teacher'),
('Liam Carter', 'liam@example.com', 1234567801, 'Employee');

-- Insert Departments  
INSERT INTO departments (department_name) VALUES
('Computer Science'),
('Mathematics'),
('Physics'),
('Human Resources');

-- Insert Courses  
INSERT INTO courses (course_name, instructor_id) VALUES
('Data Structures', 2),
('Calculus', 11),
('Physics 101', 2);

-- Insert Attendance  
INSERT INTO attendance (user_id, date, status, remarks) VALUES
(1, '2024-02-01', 'Present', 'On time'),
(2, '2024-02-01', 'Late', '5 minutes late'),
(3, '2024-02-01', 'Absent', 'Sick leave'),
(4, '2024-02-02', 'Present', 'On time'),
(5, '2024-02-02', 'Present', 'On time'),
(6, '2024-02-02', 'Absent', 'Personal leave'),
(7, '2024-02-03', 'Present', 'On time'),
(8, '2024-02-03', 'Late', '10 minutes late'),
(9, '2024-02-03', 'Absent', 'No reason given'),
(10, '2024-02-04', 'Present', 'On time'),
(11, '2024-02-04', 'Present', 'On time'),
(12, '2024-02-04', 'Late', '15 minutes late');

-- Insert Shifts  
INSERT INTO shifts (shift_name, start_time, end_time) VALUES
('Morning Shift', '08:00:00', '16:00:00'),
('Evening Shift', '16:00:00', '00:00:00'),
('Night Shift', '00:00:00', '08:00:00');

-- Assign Users to Shifts  
INSERT INTO user_shifts (user_id, shift_id) VALUES
(3, 1),
(5, 2),
(7, 3),
(9, 1),
(11, 2),
(12, 3);

-- Insert Holidays  
INSERT INTO holidays (holiday_id, date, description) VALUES
(1, '2024-12-25', 'Christmas Day'),
(2, '2024-01-01', 'New Year’s Day'),
(3, '2024-07-04', 'Independence Day');

-- Write a query to fetch the attendance details of a specific user for a given date range.
SELECT user_id, date, status, remarks
FROM attendance
WHERE user_id = 4
AND date BETWEEN '2024-02-01' AND '2024-02-10';

-- Retrieve the total number of days a user was present in a given month.
SELECT user_id, COUNT(*) AS total_present_days
FROM attendance
WHERE user_id = 1
AND status = 'Present'
AND MONTH(date) = 2
AND YEAR(date) = 2024
GROUP BY user_id;

-- Find users who have more than 5 absences in a specific month.
SELECT user_id, COUNT(*) AS total_absences
FROM attendance
WHERE status = 'Absent'
AND MONTH(date) = 2
AND YEAR(date) = 2024
GROUP BY user_id
HAVING COUNT(*) > 5;

-- Fetch all users who were marked "Late" more than three times in a given week.
SELECT user_id, COUNT(*) AS late_count, MIN(date) AS start_date, MAX(date) AS end_date
FROM attendance
WHERE status = 'Late'
AND date BETWEEN '2024-02-01' AND '2024-02-07'
GROUP BY user_id
HAVING COUNT(*) > 3;

-- List all users who have no attendance records for a given month.
SELECT u.user_id, u.name
FROM users u
LEFT JOIN attendance a ON u.user_id = a.user_id
AND MONTH(a.date) = 2
AND YEAR(a.date) = 2024
WHERE a.user_id IS NULL;

-- Retrieve the attendance percentage of all users for the last month.\SELECT a.user_id, u.name, 
SELECT a.user_id, u.name, 
       COUNT(a.attendance_id) AS total_days, 
       SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_days,
       (SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS attendance_percentage
FROM attendance a
JOIN users u ON a.user_id = u.user_id
WHERE MONTH(a.date) = MONTH(DATEADD(MONTH, -1, GETDATE()))
AND YEAR(a.date) = YEAR(DATEADD(MONTH, -1, GETDATE()))
GROUP BY a.user_id, u.name;

-- Find employees who have no assigned shifts but have attendance records.
SELECT DISTINCT a.user_id, u.name
FROM attendance a
LEFT JOIN user_shifts us ON a.user_id = us.user_id
JOIN users u ON a.user_id = u.user_id
WHERE us.user_id IS NULL;

-- Fetch all users along with their assigned shifts.
SELECT u.user_id, u.name, s.shift_name, s.start_time, s.end_time
FROM users u
LEFT JOIN user_shifts us ON u.user_id = us.user_id
LEFT JOIN shifts s ON us.shift_id = s.shift_id;

-- Find all employees who have worked in multiple shifts in a single day.
SELECT a.user_id, a.date, COUNT(DISTINCT us.shift_id) AS shift_count
FROM attendance a
JOIN user_shifts us ON a.user_id = us.user_id
GROUP BY a.user_id, a.date
HAVING COUNT(DISTINCT us.shift_id) > 1;

-- Display all holidays in the upcoming month.
SELECT holiday_id, date, description
FROM holidays
WHERE MONTH(date) = MONTH(DATEADD(MONTH, 1, GETDATE()))
AND YEAR(date) = YEAR(DATEADD(MONTH, 1, GETDATE()));

-- Identify users who have attended less than 75% of the working days in the last three months.
SELECT user_id, COUNT(*) AS total_days, 
       SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) AS present_days,
       (SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS attendance_percentage
FROM attendance
WHERE date >= DATEADD(MONTH, -3, GETDATE())
GROUP BY user_id
HAVING (SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) < 75;

-- Identify employees with continuous absences for more than 5 days.
WITH AbsenceStreak AS (
    SELECT user_id, date,
           LAG(date, 1) OVER (PARTITION BY user_id ORDER BY date) AS prev_date
    FROM attendance
    WHERE status = 'Absent'
)
SELECT user_id
FROM AbsenceStreak
WHERE DATEDIFF(DAY, prev_date, date) = 1
GROUP BY user_id
HAVING COUNT(*) > 5;
