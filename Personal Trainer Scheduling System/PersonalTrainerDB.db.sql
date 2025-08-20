sqlite3 PersonalTrainerDB.db

-- Users Table 
CREATE TABLE users (
  user_id INT PRIMARY KEY,
  first_name VARCHAR(20),
  last_name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  password TEXT,
  phone_number BIGINT,
  role VARCHAR(10) CHECK (role IN ('trainer', 'client'))
);

-- Trainers Table 
CREATE TABLE trainers (
  trainer_id INT PRIMARY KEY,
  user_id INT,
  specialization VARCHAR(50),
  experience_years YEAR,
  certifications TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Clients Table  
CREATE TABLE clients (
  client_id INT PRIMARY KEY,
  user_id INT,
  date_of_birth DATE,
  fitness_goal VARCHAR(155),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Sessions Table  
CREATE TABLE sessions (
  session_id INT PRIMARY KEY,
  trainer_id INT,
  client_id INT,
  session_date DATE,
  session_time TIME,
  status VARCHAR(20) CHECK (status IN ('Scheduled', 'Completed', 'Canceled')),
  FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id),
  FOREIGN KEY (client_id) REFERENCES clients(client_id)
);

-- Payments Table  
CREATE TABLE payments (
  payment_id INT PRIMARY KEY,
  client_id INT,
  amount DECIMAL(5,2),
  payment_date DATE,
  payment_status VARCHAR(12) CHECK (payment_status IN ('Paid', 'Pending', 'Failed')),
  FOREIGN KEY (client_id) REFERENCES clients(client_id),
);

-- Reviews Table 
CREATE TABLE reviews (
  review_id INT PRIMARY KEY,
  client_id INT,
  trainer_id INT,
  rating INT CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  review_date DATE,
  FOREIGN KEY (client_id) REFERENCES clients(client_id),
  FOREIGN KEY (trainer_id) REFERENCES trainers(trainer_id) 
);

-- Insert Users
INSERT INTO users (user_id, first_name, last_name, email, password, phone_number, role) VALUES
(1, 'John', 'Doe', 'john.doe@email.com', 'pass123', 1234567890, 'trainer'),
(2, 'Jane', 'Smith', 'jane.smith@email.com', 'pass456', 9876543210, 'trainer'),
(3, 'Mike', 'Johnson', 'mike.johnson@email.com', 'pass789', 1122334455, 'client'),
(4, 'Emily', 'Brown', 'emily.brown@email.com', 'pass321', 5544332211, 'client'),
(5, 'Chris', 'Evans', 'chris.evans@email.com', 'pass654', 6677889900, 'trainer'),
(6, 'Sophia', 'Wilson', 'sophia.wilson@email.com', 'pass987', 4433221100, 'client'),
(7, 'David', 'Lee', 'david.lee@email.com', 'pass147', 9988776655, 'client'),
(8, 'Olivia', 'Taylor', 'olivia.taylor@email.com', 'pass258', 7766554433, 'trainer');

-- Insert Trainers
INSERT INTO trainers (trainer_id, user_id, specialization, experience_years, certifications) VALUES
(1, 1, 'Strength Training', 5, 'CPT, CSCS'),
(2, 2, 'Yoga', 3, 'RYT-200'),
(3, 5, 'Cardio & Endurance', 7, 'ACE Certified'),
(4, 8, 'Weight Loss', 4, 'NASM Certified');

-- Insert Clients
INSERT INTO clients (client_id, user_id, date_of_birth, fitness_goal) VALUES
(1, 3, '1995-06-15', 'Lose 10 pounds'),
(2, 4, '1988-09-20', 'Build muscle'),
(3, 6, '1992-11-05', 'Increase endurance'),
(4, 7, '2000-01-10', 'General fitness');

-- Insert Sessions
INSERT INTO sessions (session_id, trainer_id, client_id, session_date, session_time, status) VALUES
(1, 1, 1, '2025-02-20', '10:00:00', 'Scheduled'),
(2, 2, 2, '2025-02-21', '14:00:00', 'Completed'),
(3, 3, 3, '2025-02-22', '08:30:00', 'Scheduled'),
(4, 4, 4, '2025-02-23', '12:00:00', 'Canceled'),
(5, 1, 2, '2025-02-24', '16:00:00', 'Scheduled'),
(6, 2, 3, '2025-02-25', '09:00:00', 'Completed'),
(7, 3, 4, '2025-02-26', '07:30:00', 'Scheduled'),
(8, 4, 1, '2025-02-27', '18:00:00', 'Completed');

-- Insert Payments
INSERT INTO payments (payment_id, client_id, amount, payment_date, payment_status) VALUES
(1, 1, 50.00, '2025-02-20', 'Paid'),
(2, 2, 75.00, '2025-02-21', 'Pending'),
(3, 3, 60.00, '2025-02-22', 'Paid'),
(4, 4, 80.00, '2025-02-23', 'Failed'),
(5, 1, 50.00, '2025-02-24', 'Paid'),
(6, 2, 75.00, '2025-02-25', 'Paid'),
(7, 3, 60.00, '2025-02-26', 'Pending'),
(8, 4, 80.00, '2025-02-27', 'Paid');

-- Insert Reviews
INSERT INTO reviews (review_id, client_id, trainer_id, rating, comment, review_date) VALUES
(1, 1, 1, 5, 'Great trainer, very motivating!', '2025-02-20'),
(2, 2, 2, 4, 'Good session, but could be more intense.', '2025-02-21'),
(3, 3, 3, 5, 'Loved the endurance training!', '2025-02-22'),
(4, 4, 4, 3, 'Session was okay, expected more.', '2025-02-23'),
(5, 1, 2, 4, 'Yoga session was relaxing.', '2025-02-24'),
(6, 2, 3, 5, 'Cardio training was excellent.', '2025-02-25'),
(7, 3, 4, 4, 'Trainer was knowledgeable.', '2025-02-26'),
(8, 4, 1, 5, 'Best trainer I have worked with!', '2025-02-27');

-- Retrieve all upcoming sessions for a specific trainer.
SELECT session_id, client_id, session_date, session_time, status 
FROM sessions 
WHERE trainer_id = 3 AND session_date >= DATE('now') AND status = 'Scheduled';

-- Find all trainers specialized in "Weight Loss".
SELECT u.user_id, u.first_name, u.last_name, t.specialization 
FROM trainers t
JOIN users u ON t.user_id = u.user_id
WHERE t.specialization = 'Weight Loss';

-- Get the total number of sessions each trainer has completed.
SELECT trainer_id, COUNT(*) AS total_sessions_completed
FROM sessions
WHERE status = 'Completed'
GROUP BY trainer_id;

-- Find the highest-rated trainer based on client reviews.
SELECT t.trainer_id, u.first_name, u.last_name, AVG(r.rating) AS avg_rating
FROM reviews r
JOIN trainers t ON r.trainer_id = t.trainer_id
JOIN users u ON t.user_id = u.user_id
GROUP BY t.trainer_id
ORDER BY avg_rating DESC
LIMIT 1;

-- Calculate the total earnings of a trainer in a given month.
SELECT s.trainer_id, SUM(p.amount) AS total_earnings
FROM payments p
JOIN sessions s ON p.client_id = s.client_id
WHERE strftime('%Y-%m', p.payment_date) = '2025-02'
GROUP BY s.trainer_id;

-- List all clients who have never booked a session.
SELECT c.client_id, u.first_name, u.last_name
FROM clients c
JOIN users u ON c.user_id = u.user_id
LEFT JOIN sessions s ON c.client_id = s.client_id
WHERE s.client_id IS NULL;

-- Show all pending payments for a specific client.
SELECT payment_id, amount, payment_date, payment_status 
FROM payments 
WHERE client_id = 3 AND payment_status = 'Pending';

-- Retrieve session details along with client and trainer names.
SELECT s.session_id, s.session_date, s.session_time, s.status, 
       u1.first_name || ' ' || u1.last_name AS trainer_name, 
       u2.first_name || ' ' || u2.last_name AS client_name
FROM sessions s
JOIN trainers t ON s.trainer_id = t.trainer_id
JOIN clients c ON s.client_id = c.client_id
JOIN users u1 ON t.user_id = u1.user_id
JOIN users u2 ON c.user_id = u2.user_id;

-- Count the number of sessions canceled by each client.
SELECT client_id, COUNT(*) AS total_canceled_sessions
FROM sessions
WHERE status = 'Canceled'
GROUP BY client_id;

-- Find clients who have booked more than 1 sessions in the last month.
SELECT client_id, COUNT(*) AS total_sessions
FROM sessions
WHERE session_date >= DATE('now', '-1 month')
GROUP BY client_id
HAVING total_sessions > 1;