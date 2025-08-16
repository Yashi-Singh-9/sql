sqlite3 gym_management.db

-- Memberships Table
CREATE TABLE memberships (
  membership_type_id INT PRIMARY KEY,
  membership_name VARCHAR(15) CHECK (membership_name IN ('Basic', 'Premium', 'Pro', 'VIP')),
  price DECIMAL(5,2),
  duration_months INT 
);

-- Members Table
CREATE TABLE members (
  member_id INT PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  date_of_birth DATE,
  phone BIGINT,
  email VARCHAR(50) UNIQUE,
  address VARCHAR(50),
  join_date DATE,
  membership_type_id INT,
  FOREIGN KEY (membership_type_id) REFERENCES memberships(membership_type_id)
);

-- Payments Table
CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  member_id INT,
  amount DECIMAL(5,2),
  payment_date DATE,
  payment_method VARCHAR(10) CHECK (payment_method IN ('Card', 'Cash', 'Online')),
  FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Trainers Table
CREATE TABLE trainers (
  trainer_id INT PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  specialization VARCHAR(50),
  phone BIGINT,
  email VARCHAR(50) UNIQUE
);

-- Training Sessions Table
CREATE TABLE training_sessions (
  session_id INT PRIMARY KEY,
  trainer_id INT,
  session_date DATE,
  session_time TIME,
  session_type VARCHAR(30) CHECK (session_type IN (
        'Cardio', 
        'Strength Training', 
        'Yoga', 
        'HIIT', 
        'Pilates', 
        'CrossFit', 
        'Zumba', 
        'Spin Class', 
        'Bootcamp', 
        'Functional Training', 
        'Bodyweight Training', 
        'Flexibility & Mobility'
    )),
  FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id)
);

-- Member Sessions Table
CREATE TABLE member_sessions (
  member_id INT,
  session_id INT,
  FOREIGN KEY (member_id) REFERENCES members(member_id),
  FOREIGN KEY (session_id) REFERENCES training_sessions(session_id)
);

-- Inserting data into memberships table
INSERT INTO memberships (membership_type_id, membership_name, price, duration_months) VALUES
(1, 'Basic', 29.99, 1),
(2, 'Premium', 49.99, 3),
(3, 'Pro', 69.99, 6),
(4, 'VIP', 99.99, 12);

-- Inserting data into members table
INSERT INTO members (member_id, first_name, last_name, date_of_birth, phone, email, address, join_date, membership_type_id) VALUES
(1, 'John', 'Doe', '1985-06-15', 1234567890, 'john.doe@example.com', '123 Elm St', '2025-01-10', 1),
(2, 'Jane', 'Smith', '1990-09-25', 2345678901, 'jane.smith@example.com', '456 Oak St', '2025-02-01', 2),
(3, 'Mark', 'Johnson', '1982-11-05', 3456789012, 'mark.johnson@example.com', '789 Pine St', '2025-01-20', 1),
(4, 'Emily', 'Davis', '1995-07-13', 4567890123, 'emily.davis@example.com', '321 Maple St', '2025-02-10', 3),
(5, 'Michael', 'Miller', '1988-02-19', 5678901234, 'michael.miller@example.com', '654 Birch St', '2025-01-25', 4),
(6, 'Sarah', 'Wilson', '1992-03-09', 6789012345, 'sarah.wilson@example.com', '987 Cedar St', '2025-02-12', 2),
(7, 'David', 'Moore', '1986-12-01', 7890123456, 'david.moore@example.com', '741 Redwood St', '2025-01-30', 1),
(8, 'Sophia', 'Taylor', '1994-10-11', 8901234567, 'sophia.taylor@example.com', '852 Willow St', '2025-02-15', 3),
(9, 'Chris', 'Brown', '1998-01-22', 9012345678, 'chris.brown@example.com', '963 Fir St', '2025-01-05', 4),
(10, 'Linda', 'Garcia', '1989-04-14', 1239876543, 'linda.garcia@example.com', '159 Chestnut St', '2025-01-19', 2),
(11, 'James', 'Martinez', '1984-06-30', 2348765432, 'james.martinez@example.com', '258 Cypress St', '2025-02-01', 1),
(12, 'Olivia', 'Hernandez', '1993-12-03', 3457654321, 'olivia.hernandez@example.com', '369 Poplar St', '2025-02-10', 2),
(13, 'Liam', 'King', '1996-08-25', 4566543210, 'liam.king@example.com', '741 Spruce St', '2025-01-15', 4),
(14, 'Mia', 'Lee', '1990-01-10', 5675432109, 'mia.lee@example.com', '852 Aspen St', '2025-01-28', 3),
(15, 'Ethan', 'Walker', '1987-05-21', 6784321098, 'ethan.walker@example.com', '963 Fir St', '2025-02-05', 1);

-- Inserting data into trainers table
INSERT INTO trainers (trainer_id, first_name, last_name, specialization, phone, email) VALUES
(1, 'Alice', 'Walker', 'Yoga', 1234567890, 'alice.walker@example.com'),
(2, 'Bob', 'Johnson', 'HIIT', 2345678901, 'bob.johnson@example.com'),
(3, 'Charlie', 'Davis', 'Strength Training', 3456789012, 'charlie.davis@example.com'),
(4, 'Diana', 'Taylor', 'CrossFit', 4567890123, 'diana.taylor@example.com'),
(5, 'Ethan', 'Miller', 'Zumba', 5678901234, 'ethan.miller@example.com'),
(6, 'Fiona', 'Martinez', 'Pilates', 6789012345, 'fiona.martinez@example.com'),
(7, 'George', 'Anderson', 'Cardio', 7890123456, 'george.anderson@example.com');

-- Inserting data into training_sessions table
INSERT INTO training_sessions (session_id, trainer_id, session_date, session_time, session_type) VALUES
(1, 1, '2025-02-18', '08:00:00', 'Yoga'),
(2, 2, '2025-02-19', '09:00:00', 'HIIT'),
(3, 3, '2025-02-20', '10:00:00', 'Strength Training'),
(4, 4, '2025-02-21', '11:00:00', 'CrossFit'),
(5, 5, '2025-02-22', '12:00:00', 'Zumba'),
(6, 6, '2025-02-23', '13:00:00', 'Pilates'),
(7, 7, '2025-02-24', '14:00:00', 'Cardio'),
(8, 1, '2025-02-25', '15:00:00', 'Yoga'),
(9, 2, '2025-02-26', '16:00:00', 'HIIT'),
(10, 3, '2025-02-27', '17:00:00', 'Strength Training'),
(11, 4, '2025-02-28', '18:00:00', 'CrossFit'),
(12, 5, '2025-03-01', '19:00:00', 'Zumba'),
(13, 6, '2025-03-02', '20:00:00', 'Pilates'),
(14, 7, '2025-03-03', '21:00:00', 'Cardio'),
(15, 1, '2025-03-04', '08:30:00', 'Yoga');

-- Inserting data into payments table
INSERT INTO payments (payment_id, member_id, amount, payment_date, payment_method) VALUES
(1, 1, 29.99, '2025-01-15', 'Card'),
(2, 2, 49.99, '2025-02-01', 'Cash'),
(3, 3, 29.99, '2025-01-22', 'Online'),
(4, 4, 69.99, '2025-02-10', 'Card'),
(5, 5, 99.99, '2025-01-25', 'Online'),
(6, 6, 49.99, '2025-02-12', 'Cash'),
(7, 7, 29.99, '2025-01-30', 'Card'),
(8, 8, 69.99, '2025-02-15', 'Online'),
(9, 9, 99.99, '2025-01-05', 'Cash'),
(10, 10, 49.99, '2025-01-19', 'Card'),
(11, 11, 29.99, '2025-02-01', 'Online'),
(12, 12, 49.99, '2025-02-10', 'Card'),
(13, 13, 99.99, '2025-01-15', 'Cash'),
(14, 14, 69.99, '2025-02-03', 'Online'),
(15, 15, 29.99, '2025-02-05', 'Card');

-- Inserting data into member_sessions table
INSERT INTO member_sessions (member_id, session_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15);

-- Retrieve the names and contact details of all members who have an active membership.
SELECT first_name, last_name, phone, email
FROM members
WHERE join_date >= DATE('now', '-1 year');

-- Find the total number of members for each membership type.
SELECT m.membership_name, COUNT(mem.member_id) AS total_members
FROM memberships m
JOIN members mem ON m.membership_type_id = mem.membership_type_id
GROUP BY m.membership_name;

-- List all payments made by a specific member.
SELECT p.payment_id, p.amount, p.payment_date, p.payment_method
FROM payments p
WHERE p.member_id = 1;

-- Get the total revenue generated from memberships.
SELECT SUM(m.price) AS total_revenue
FROM memberships m
JOIN members mem ON m.membership_type_id = mem.membership_type_id;

-- Retrieve the trainers along with the number of sessions they have conducted.
SELECT t.first_name, t.last_name, COUNT(ts.session_id) AS session_count
FROM trainers t
LEFT JOIN training_sessions ts ON t.trainer_id = ts.trainer_id
GROUP BY t.trainer_id;

-- Find members who have never attended a training session.
SELECT mem.first_name, mem.last_name
FROM members mem
LEFT JOIN member_sessions ms ON mem.member_id = ms.member_id
WHERE ms.session_id IS NULL;

-- Identify members who have not made a payment in the last 1 months.
SELECT mem.first_name, mem.last_name
FROM members mem
WHERE NOT EXISTS (
  SELECT 1
  FROM payments p
  WHERE p.member_id = mem.member_id
  AND p.payment_date >= DATE('now', '-1 months')
);

-- List the top 5 members who attended the most sessions.
SELECT mem.first_name, mem.last_name, COUNT(ms.session_id) AS session_count
FROM members mem
JOIN member_sessions ms ON mem.member_id = ms.member_id
GROUP BY mem.member_id
ORDER BY session_count DESC
LIMIT 5;

-- Get the most popular session type based on attendance.
SELECT ts.session_type, COUNT(ms.member_id) AS attendee_count
FROM training_sessions ts
JOIN member_sessions ms ON ts.session_id = ms.session_id
GROUP BY ts.session_type
ORDER BY attendee_count DESC
LIMIT 1;

-- Identify trainers who specialize in "Weight Training" but have not conducted any sessions in the past month.
SELECT t.first_name, t.last_name
FROM trainers t
LEFT JOIN training_sessions ts ON t.trainer_id = ts.trainer_id
WHERE t.specialization = 'Strength Training'
AND (ts.session_date IS NULL OR ts.session_date < DATE('now', '-1 month'));