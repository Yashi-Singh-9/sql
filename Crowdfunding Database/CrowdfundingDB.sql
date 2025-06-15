-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE CrowdfundingDB;
\c CrowdfundingDB;

-- Users Table (Backers & Creators)
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Projects Table (Crowdfunding Campaigns)
CREATE TABLE Projects (
    project_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    goal_amount DECIMAL(10,2) NOT NULL,
    raised_amount DECIMAL(10,2) DEFAULT 0,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    creator_id INT NOT NULL,
    FOREIGN KEY (creator_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Pledges Table (Backers pledging money to projects)
CREATE TABLE Pledges (
    pledge_id SERIAL PRIMARY KEY,
    project_id INT NOT NULL,
    backer_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    pledge_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE,
    FOREIGN KEY (backer_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Rewards Table (Perks for backers based on pledge amount)
CREATE TABLE Rewards (
    reward_id SERIAL PRIMARY KEY,
    project_id INT NOT NULL,
    description TEXT NOT NULL,
    min_pledge_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id) ON DELETE CASCADE
);

-- Transactions Table (For tracking payments)
CREATE TABLE Transactions (
    transaction_id SERIAL PRIMARY KEY,
    pledge_id INT NOT NULL,
    payment_status VARCHAR(50) CHECK (payment_status IN ('Pending', 'Completed', 'Failed')),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pledge_id) REFERENCES Pledges(pledge_id) ON DELETE CASCADE
);

-- Insert Users
INSERT INTO Users (name, email, password) VALUES 
('Alice Johnson', 'alice@example.com', 'password123'),
('Bob Smith', 'bob@example.com', 'securepass'),
('Charlie Brown', 'charlie@example.com', 'charliepass');

-- Insert Projects
INSERT INTO Projects (title, description, goal_amount, start_date, end_date, creator_id) VALUES 
('Eco-Friendly Water Bottle', 'A sustainable bottle to reduce plastic waste.', 5000.00, '2025-01-01', '2025-03-01', 1),
('Smart LED Lamp', 'A lamp that adjusts brightness based on room light.', 3000.00, '2025-02-01', '2025-04-01', 2);

-- Insert Pledges
INSERT INTO Pledges (project_id, backer_id, amount) VALUES 
(1, 2, 100.00),
(1, 3, 50.00),
(2, 1, 75.00);

-- Insert Rewards
INSERT INTO Rewards (project_id, description, min_pledge_amount) VALUES 
(1, 'Reusable Straw Set', 25.00),
(1, 'Eco-Friendly Water Bottle', 50.00),
(2, 'Smart LED Lamp Discount Code', 30.00);

-- Insert Transactions
INSERT INTO Transactions (pledge_id, payment_status) VALUES 
(1, 'Completed'),
(2, 'Pending'),
(3, 'Completed');

-- Find the total number of backers for each project.
SELECT p.project_id, p.title, COUNT(pl.pledge_id) AS total_backers 
FROM Projects p
LEFT JOIN Pledges pl ON p.project_id = pl.project_id
GROUP BY p.project_id, p.title;

-- Show projects with the highest pledges.
SELECT p.project_id, p.title, SUM(pl.amount) AS total_pledged
FROM Projects p
JOIN Pledges pl ON p.project_id = pl.project_id
GROUP BY p.project_id, p.title
ORDER BY total_pledged DESC
LIMIT 1;

-- Retrieve all pending transactions.
SELECT transaction_id, pledge_id, payment_status, payment_date
FROM Transactions
WHERE payment_status = 'Pending';

-- Find all projects that failed to reach their funding goal
SELECT project_id, title, goal_amount, raised_amount
FROM Projects
WHERE raised_amount < goal_amount;

-- List all backers who pledged more than $50
SELECT DISTINCT u.user_id, u.name, SUM(p.amount) AS total_pledged
FROM Users u
JOIN Pledges p ON u.user_id = p.backer_id
GROUP BY u.user_id, u.name
HAVING SUM(p.amount) > 50;

-- Show the total amount pledged per project
SELECT p.project_id, p.title, COALESCE(SUM(pl.amount), 0) AS total_pledged
FROM Projects p
LEFT JOIN Pledges pl ON p.project_id = pl.project_id
GROUP BY p.project_id, p.title;

-- Find the top 3 projects with the most backers
SELECT p.project_id, p.title, COUNT(pl.pledge_id) AS backer_count
FROM Projects p
JOIN Pledges pl ON p.project_id = pl.project_id
GROUP BY p.project_id, p.title
ORDER BY backer_count DESC
LIMIT 3;

-- List all backers along with the projects they supported
SELECT u.name AS backer_name, p.title AS project_title, pl.amount
FROM Pledges pl
JOIN Users u ON pl.backer_id = u.user_id
JOIN Projects p ON pl.project_id = p.project_id
ORDER BY u.name;

-- Get the average pledge amount per project
SELECT p.project_id, p.title, AVG(pl.amount) AS avg_pledge_amount
FROM Projects p
JOIN Pledges pl ON p.project_id = pl.project_id
GROUP BY p.project_id, p.title;

-- Show the highest pledge made for each project
SELECT p.project_id, p.title, MAX(pl.amount) AS highest_pledge
FROM Projects p
JOIN Pledges pl ON p.project_id = pl.project_id
GROUP BY p.project_id, p.title;

-- Find users who are both backers and creators
SELECT DISTINCT u.user_id, u.name
FROM Users u
JOIN Projects pr ON u.user_id = pr.creator_id
JOIN Pledges pl ON u.user_id = pl.backer_id;

-- Show all rewards for a specific project
SELECT r.reward_id, r.description, r.min_pledge_amount
FROM Rewards r
WHERE r.project_id = 1;