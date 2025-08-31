-- SQL Lite Project
-- Create Database
sqlite3 FreelanceHub.db

-- Users Table 
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  password TEXT,
  user_type VARCHAR(10) CHECK (user_type IN ('Freelancer', 'Client')),
  created_at DATETIME
);

-- Profiles Table 
CREATE TABLE profiles (
  profile_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  bio TEXT,
  skills VARCHAR(20),
  rating INTEGER,
  portfolio_link VARCHAR(20), 
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Jobs Table 
CREATE table jobs (
  job_id INTEGER PRIMARY KEY,
  client_id INTEGER,
  title VARCHAR(20),
  description TEXT,
  budget DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) CHECK (status IN ('Open', 'Assigned', 'Completed')),
  created_at DATETIME,
  FOREIGN KEY (client_id) REFERENCES users(user_id)
);

-- Proposals Table  
CREATE TABLE proposals (
  proposal_id INTEGER PRIMARY KEY,
  job_id INTEGER,
  freelancer_id INTEGER,
  cover_letter TEXT,
  bid_amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(15) CHECK (status IN ('Pending', 'Accepted', 'Rejected')),
  FOREIGN KEY (job_id) REFERENCES jobs(job_id),
  FOREIGN KEY (freelancer_id) REFERENCES users(user_id)
);

-- Contracts Table  
CREATE TABLE contracts (
  contract_id INTEGER PRIMARY KEY,
  job_id INTEGER,
  freelancer_id INTEGER,
  client_id INTEGER,
  agreed_price DECIMAL(10,2) NOT NULL,
  start_date DATE,
  end_date DATE,
  status VARCHAR(15) CHECK (status IN ('Ongoing', 'Completed', 'Disputed')),
  FOREIGN KEY (job_id) REFERENCES jobs(job_id),
  FOREIGN KEY (freelancer_id) REFERENCES users(user_id),
  FOREIGN KEY (client_id) REFERENCES users(client_id)
);

-- Payments Table  
CREATE Table payments (
  payment_id INTEGER PRIMARY KEY,
  contract_id INTEGER,
  amount DECIMAL(10,2) NOT NULL,
  status VARCHAR(15) CHECK (status IN ('Pending', 'Completed', 'Failed')),
  payment_date DATE,
  FOREIGN KEY (contract_id) REFERENCES contracts(contract_id)
);

-- Reviews Table 
CREATE TABLE reviews (
  review_id INTEGER PRIMARY KEY,
  contract_id INTEGER,
  reviewer_id INTEGER,
  reviewee_id INTEGER,
  rating INTEGER,
  comment TEXT,
  FOREIGN KEY (contract_id) REFERENCES contracts(contract_id),
  FOREIGN KEY (reviewer_id) REFERENCES users(user_id),
  FOREIGN KEY (reviewee_id) REFERENCES users(user_id)
);

-- Messages Table 
CREATE TABLE messages (
  message_id INTEGER,
  sender_id INTEGER,
  receiver_id INTEGER,
  message_text TEXT,
  timestamp DATETIME,
  FOREIGN KEY (sender_id) REFERENCES users(user_id),
  FOREIGN KEY (receiver_id) REFERENCES users(user_id)
);  

-- Insert data into Users Table
INSERT INTO users (user_id, name, email, password, user_type, created_at) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'password123', 'Freelancer', '2024-01-01 10:00:00'),
(2, 'Bob Smith', 'bob@example.com', 'securepass', 'Client', '2024-01-02 11:00:00'),
(3, 'Charlie Brown', 'charlie@example.com', 'pass1234', 'Freelancer', '2024-01-03 12:00:00'),
(4, 'David White', 'david@example.com', 'whitedavid', 'Client', '2024-01-04 13:00:00'),
(5, 'Emma Davis', 'emma@example.com', 'emma456', 'Freelancer', '2024-01-05 14:00:00'),
(6, 'Frank Miller', 'frank@example.com', 'miller789', 'Client', '2024-01-06 15:00:00');

-- Insert data into Profiles Table
INSERT INTO profiles (profile_id, user_id, bio, skills, rating, portfolio_link) VALUES
(1, 1, 'Web Developer with 5 years of experience', 'HTML, CSS', 5, 'alice.dev'),
(2, 3, 'Graphic Designer skilled in Adobe Suite', 'Photoshop', 4, 'charlie.design'),
(3, 5, 'Expert in mobile app development', 'Flutter', 5, 'emma.app'),
(4, 1, 'Backend Developer', 'Python, Django', 5, 'alicebackend.dev'),
(5, 3, 'UI/UX Designer', 'Figma', 4, 'charlieux.design'),
(6, 5, 'Game Developer', 'Unity, C#', 5, 'emma.games');

-- Insert data into Jobs Table
INSERT INTO jobs (job_id, client_id, title, description, budget, status, created_at) VALUES
(1, 2, 'Website Design', 'Need a responsive website', 500.00, 'Open', '2024-02-01 09:00:00'),
(2, 4, 'Mobile App Development', 'Develop an Android app', 1000.00, 'Open', '2024-02-02 10:00:00'),
(3, 6, 'Logo Design', 'Create a modern logo', 150.00, 'Assigned', '2024-02-03 11:00:00'),
(4, 2, 'E-commerce Website', 'Develop an online store', 1200.00, 'Open', '2024-02-04 12:00:00'),
(5, 4, 'Game Development', 'Build a 2D game', 2000.00, 'Completed', '2024-02-05 13:00:00'),
(6, 6, 'Marketing Banner', 'Create a promotional banner', 100.00, 'Open', '2024-02-06 14:00:00');

-- Insert data into Proposals Table
INSERT INTO proposals (proposal_id, job_id, freelancer_id, cover_letter, bid_amount, status) VALUES
(1, 1, 1, 'Experienced web designer ready to work', 450.00, 'Pending'),
(2, 2, 3, 'Expert in Android development', 950.00, 'Accepted'),
(3, 3, 5, 'Skilled in graphic design', 140.00, 'Rejected'),
(4, 4, 1, 'Can develop your e-commerce website', 1150.00, 'Pending'),
(5, 5, 3, 'Game developer with Unity expertise', 1950.00, 'Accepted'),
(6, 6, 5, 'Creative banner designer', 90.00, 'Pending');

-- Insert data into Contracts Table
INSERT INTO contracts (contract_id, job_id, freelancer_id, client_id, agreed_price, start_date, end_date, status) VALUES
(1, 2, 3, 4, 950.00, '2024-02-07', '2024-02-21', 'Ongoing'),
(2, 5, 3, 4, 1950.00, '2024-02-08', '2024-02-22', 'Completed'),
(3, 3, 5, 6, 140.00, '2024-02-09', '2024-02-23', 'Disputed'),
(4, 1, 1, 2, 450.00, '2024-02-10', '2024-02-24', 'Ongoing'),
(5, 4, 1, 2, 1150.00, '2024-02-11', '2024-02-25', 'Ongoing'),
(6, 6, 5, 6, 90.00, '2024-02-12', '2024-02-26', 'Ongoing');

-- Insert data into Payments Table
INSERT INTO payments (payment_id, contract_id, amount, status, payment_date) VALUES
(1, 1, 950.00, 'Pending', '2024-02-15'),
(2, 2, 1950.00, 'Completed', '2024-02-16'),
(3, 3, 140.00, 'Failed', '2024-02-17'),
(4, 4, 450.00, 'Pending', '2024-02-18'),
(5, 5, 1150.00, 'Completed', '2024-02-19'),
(6, 6, 90.00, 'Pending', '2024-02-20');

-- Insert data into Reviews Table
INSERT INTO reviews (review_id, contract_id, reviewer_id, reviewee_id, rating, comment) VALUES
(1, 1, 4, 3, 5, 'Great work on the app!'),
(2, 2, 4, 3, 4, 'Good game development but needs minor tweaks.'),
(3, 3, 6, 5, 3, 'Design was okay, but needs improvement.'),
(4, 4, 2, 1, 5, 'Amazing website development!'),
(5, 5, 2, 1, 5, 'E-commerce site turned out great!'),
(6, 6, 6, 5, 4, 'Nice banner design!');

-- Insert data into Messages Table
INSERT INTO messages (message_id, sender_id, receiver_id, message_text, timestamp) VALUES
(1, 1, 2, 'Hi, I am interested in the project!', '2024-02-01 09:30:00'),
(2, 2, 1, 'Sure! Let’s discuss further.', '2024-02-01 09:45:00'),
(3, 3, 4, 'I can develop the app for you.', '2024-02-02 10:30:00'),
(4, 4, 3, 'Great! When can you start?', '2024-02-02 10:45:00'),
(5, 5, 6, 'I can design the logo for you.', '2024-02-03 11:15:00'),
(6, 6, 5, 'Let’s discuss colors and style.', '2024-02-03 11:30:00');

-- Find all freelancers who have submitted proposals for a specific job.
SELECT u.user_id, u.name, u.email
FROM users u
JOIN proposals p ON u.user_id = p.freelancer_id
WHERE p.job_id = 3;

-- List all jobs posted by a specific client along with their statuses.
SELECT j.job_id, j.title, j.status
FROM jobs j
WHERE j.client_id = 2;

-- Find the total amount paid by a client for completed contracts.
SELECT c.client_id, SUM(p.amount) AS total_paid
FROM payments p
JOIN contracts c ON p.contract_id = c.contract_id
WHERE c.client_id = 4 AND c.status = 'Completed' AND p.status = 'Completed'
GROUP BY c.client_id;

-- Retrieve the highest-rated freelancers.
SELECT u.user_id, u.name, pr.rating
FROM users u
JOIN profiles pr ON u.user_id = pr.user_id
WHERE u.user_type = 'Freelancer'
ORDER BY pr.rating DESC
LIMIT 5;

-- List all contracts for a specific freelancer and their current status.
SELECT c.contract_id, c.job_id, c.status
FROM contracts c
WHERE c.freelancer_id = 1;

-- Find all pending proposals for a given job.
SELECT p.proposal_id, p.freelancer_id, p.bid_amount
FROM proposals p
WHERE p.job_id = 4 AND p.status = 'Pending';

-- Get the total number of jobs posted and completed by a client.
SELECT client_id, 
       COUNT(*) AS total_jobs, 
       SUM(CASE WHEN status = 'Completed' THEN 1 ELSE 0 END) AS completed_jobs
FROM jobs
WHERE client_id = 6
GROUP BY client_id;

-- Retrieve the conversation history between two users.
SELECT sender_id, receiver_id, message_text, timestamp
FROM messages
WHERE (sender_id = 1 AND receiver_id = 2) 
   OR (sender_id = 2 AND receiver_id = 1)
ORDER BY timestamp;

-- Get the average rating of a freelancer based on reviews.
SELECT reviewee_id AS freelancer_id, AVG(rating) AS average_rating
FROM reviews
WHERE reviewee_id = 3
GROUP BY reviewee_id;

-- Find the most active clients (those who posted the most jobs).
SELECT client_id, COUNT(*) AS total_jobs_posted
FROM jobs
GROUP BY client_id
ORDER BY total_jobs_posted DESC
LIMIT 5;
