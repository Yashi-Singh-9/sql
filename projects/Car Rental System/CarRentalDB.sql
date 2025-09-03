-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE CarRentalDB;
\c CarRentalDB;

-- Customers Table  
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  customer_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  phone BIGINT,
  address VARCHAR(100),
  license_number VARCHAR(100)
);

-- Cars Table 
CREATE TABLE cars (
  car_id SERIAL PRIMARY KEY,
  model VARCHAR(50),
  brand VARCHAR(50),
  year INT,
  registration_number VARCHAR(100),
  status VARCHAR(18) CHECK (status IN ('Available', 'Rented', 'Under Maintenance')),
  daily_rental_price DECIMAL(10,2)
);

-- Rentals Table  
CREATE TABLE rentals (
  rental_id SERIAL PRIMARY KEY,
  customer_id INT,
  car_id INT,
  rental_date DATE,
  return_date DATE,
  total_price DECIMAL(10,2),
  status VARCHAR(10) CHECK (status IN ('Ongoing', 'Completed', 'Canceled')),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (car_id) REFERENCES cars(car_id)
);

-- Payments Table  
CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  rental_id INT,
  payment_date DATE,
  amount DECIMAL(10,2),
  payment_method VARCHAR(6) CHECK (payment_method IN ('Card', 'Cash', 'Online')),
  status VARCHAR(10) CHECK (status IN ('Pending', 'Completed', 'Failed')),
  FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
);

-- Employees Table 
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,
  employees_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  phone BIGINT,
  positions VARCHAR(50),
  salary DECIMAL(10,2)
);

-- Maintenance Table 
CREATE TABLE maintenance (
  maintenance_id SERIAL PRIMARY KEY,
  car_id INT,
  date DATE,
  description TEXT,
  cost DECIMAL(10,2),
  status VARCHAR(10) CHECK (status IN ('Pending', 'Completed')),
  FOREIGN KEY (car_id) REFERENCES cars(car_id)
);

-- Insert sample data into customers table
INSERT INTO customers (customer_name, email, phone, address, license_number) VALUES
('Alice Johnson', 'alice.johnson@example.com', 9876543210, '123 Main St, NY', 'A1234567'),
('Bob Smith', 'bob.smith@example.com', 8765432109, '456 Elm St, CA', 'B2345678'),
('Charlie Brown', 'charlie.brown@example.com', 7654321098, '789 Pine St, TX', 'C3456789'),
('David Miller', 'david.miller@example.com', 6543210987, '321 Oak St, FL', 'D4567890'),
('Eva Davis', 'eva.davis@example.com', 5432109876, '567 Maple St, WA', 'E5678901');

-- Insert sample data into cars table
INSERT INTO cars (model, brand, year, registration_number, status, daily_rental_price) VALUES
('Civic', 'Honda', 2020, 'NY12345', 'Available', 50.00),
('Corolla', 'Toyota', 2019, 'CA67890', 'Rented', 45.00),
('Model S', 'Tesla', 2021, 'TX13579', 'Available', 100.00),
('Mustang', 'Ford', 2018, 'FL24680', 'Under Maintenance', 75.00),
('X5', 'BMW', 2022, 'WA98765', 'Rented', 120.00);

-- Insert sample data into rentals table (Foreign keys randomly repeated)
INSERT INTO rentals (customer_id, car_id, rental_date, return_date, total_price, status) VALUES
(1, 2, '2025-02-01', '2025-02-05', 225.00, 'Completed'),
(2, 3, '2025-02-10', '2025-02-15', 500.00, 'Ongoing'),
(3, 1, '2025-02-05', '2025-02-07', 100.00, 'Completed'),
(4, 5, '2025-02-12', '2025-02-20', 960.00, 'Ongoing'),
(5, 4, '2025-02-03', '2025-02-06', 225.00, 'Canceled');

-- Insert sample data into payments table (Foreign keys randomly repeated)
INSERT INTO payments (rental_id, payment_date, amount, payment_method, status) VALUES
(1, '2025-02-05', 225.00, 'Card', 'Completed'),
(2, '2025-02-10', 500.00, 'Cash', 'Pending'),
(3, '2025-02-07', 100.00, 'Online', 'Completed'),
(4, '2025-02-12', 960.00, 'Card', 'Pending'),
(5, '2025-02-06', 225.00, 'Cash', 'Failed');

-- Insert sample data into employees table
INSERT INTO employees (employees_name, email, phone, positions, salary) VALUES
('John Walker', 'john.walker@example.com', 4321098765, 'Manager', 5000.00),
('Sophia Lopez', 'sophia.lopez@example.com', 3210987654, 'Clerk', 3000.00),
('Michael Carter', 'michael.carter@example.com', 2109876543, 'Technician', 3500.00),
('Olivia White', 'olivia.white@example.com', 1098765432, 'Receptionist', 2800.00),
('Daniel Harris', 'daniel.harris@example.com', 9876543211, 'Mechanic', 4000.00);

-- Insert sample data into maintenance table (Foreign keys randomly repeated)
INSERT INTO maintenance (car_id, date, description, cost, status) VALUES
(4, '2025-02-01', 'Engine repair', 500.00, 'Completed'),
(5, '2025-02-15', 'Oil change', 100.00, 'Pending'),
(1, '2025-02-05', 'Tire replacement', 200.00, 'Completed'),
(2, '2025-02-07', 'Battery replacement', 150.00, 'Completed'),
(3, '2025-02-10', 'Brake pads change', 250.00, 'Pending');

-- 1. Find the total revenue generated from rentals.
SELECT SUM(total_price) AS total_revenue FROM rentals WHERE status = 'Completed';

-- 2. List all currently rented cars along with customer details.
SELECT c.car_id, c.model, c.brand, c.registration_number, r.rental_date, r.return_date,
       cust.customer_id, cust.customer_name, cust.email, cust.phone 
FROM rentals r
JOIN cars c ON r.car_id = c.car_id
JOIN customers cust ON r.customer_id = cust.customer_id
WHERE r.status = 'Ongoing';

-- 3. Find the most rented car model and brand.
SELECT c.model, c.brand, COUNT(r.car_id) AS rental_count
FROM rentals r
JOIN cars c ON r.car_id = c.car_id
GROUP BY c.model, c.brand
ORDER BY rental_count DESC
LIMIT 1;

-- 4. List pending payments along with customer details.
SELECT p.payment_id, p.amount, p.payment_method, p.status,
       r.rental_id, c.customer_id, c.customer_name, c.email, c.phone
FROM payments p
JOIN rentals r ON p.rental_id = r.rental_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE p.status = 'Pending';

-- 5. Find employees who earn more than the average salary.
SELECT * FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- 6. List customers who have overdue rentals (return date has passed but status is not ‘Completed’).
SELECT c.customer_id, c.customer_name, c.email, c.phone, r.rental_id, r.return_date, r.status
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.return_date < CURRENT_DATE AND r.status != 'Completed';

-- 7. Find the top 3 highest spending customers based on rental payments.
SELECT c.customer_id, c.customer_name, c.email, SUM(p.amount) AS total_spent
FROM payments p
JOIN rentals r ON p.rental_id = r.rental_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE p.status = 'Completed'
GROUP BY c.customer_id, c.customer_name, c.email
ORDER BY total_spent DESC
LIMIT 3;

-- 8. Find the average rental duration (in days).
SELECT AVG(return_date - rental_date) AS avg_rental_duration FROM rentals WHERE status = 'Completed';

-- 9. Find the most common payment method.
SELECT payment_method, COUNT(*) AS count 
FROM payments 
GROUP BY payment_method 
ORDER BY count DESC 
LIMIT 1;

-- 10. Get a list of cars that are currently under maintenance.
SELECT c.car_id, c.model, c.brand, c.registration_number, m.date, m.description, m.status
FROM maintenance m
JOIN cars c ON m.car_id = c.car_id
WHERE m.status = 'Pending';

-- 11. Find the total number of rentals made for each car.
SELECT c.car_id, c.model, c.brand, COUNT(r.rental_id) AS total_rentals
FROM rentals r
JOIN cars c ON r.car_id = c.car_id
GROUP BY c.car_id, c.model, c.brand
ORDER BY total_rentals DESC;

-- 12. List employees and their salaries, showing the highest-paid employee first.
SELECT employee_id, employees_name, positions, salary
FROM employees
ORDER BY salary DESC;

-- 13. Count the number of rentals made per month.
SELECT DATE_TRUNC('month', rental_date) AS month, COUNT(*) AS total_rentals
FROM rentals
GROUP BY month
ORDER BY month;

-- 14. Get a list of customers who have made payments of more than $500 in a single transaction.
SELECT c.customer_id, c.customer_name, p.amount, p.payment_date
FROM payments p
JOIN rentals r ON p.rental_id = r.rental_id
JOIN customers c ON r.customer_id = c.customer_id
WHERE p.amount > 500
ORDER BY p.amount DESC;

-- 15. Find cars that are currently available for rent.
SELECT * FROM cars WHERE status = 'Available';

-- 16. Identify the employee with the highest salary.
SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;

-- 17. Find the most expensive car in terms of daily rental price.
SELECT * FROM cars 
ORDER BY daily_rental_price DESC 
LIMIT 1;

-- 18. Calculate the total amount spent on car maintenance.
SELECT SUM(cost) AS total_maintenance_cost FROM maintenance;

-- 19. List customers along with the total number of cars they have rented.
SELECT c.customer_id, c.customer_name, COUNT(r.rental_id) AS total_rentals
FROM customers c
LEFT JOIN rentals r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_rentals DESC;
