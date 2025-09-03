-- Project In MariaDB 
-- Creating the database
CREATE DATABASE Event_Management_DB;
USE Event_Management_DB;

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    role ENUM('Attendee', 'Organizer', 'Admin') NOT NULL
);

CREATE TABLE Locations (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    venue_name VARCHAR(100),
    address TEXT,
    capacity INT
);

CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    event_name VARCHAR(100),
    event_date DATE,
    location_id INT,
    organizer_id INT,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    FOREIGN KEY (organizer_id) REFERENCES Users(user_id)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    user_id INT,
    price DECIMAL(10,2),
    seat_no VARCHAR(10),
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    ticket_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash'),
    FOREIGN KEY (ticket_id) REFERENCES Tickets(ticket_id)
);

CREATE TABLE Sponsors (
    sponsor_id INT PRIMARY KEY AUTO_INCREMENT,
    sponsor_name VARCHAR(100),
    event_id INT,
    contribution_amount DECIMAL(10,2),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Feedback (
    feedback_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    user_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    FOREIGN KEY (event_id) REFERENCES Events(event_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Insert into Users
INSERT INTO Users (name, email, phone, role) VALUES
('Alice Johnson', 'alice@example.com', '1234567890', 'Organizer'),
('Bob Smith', 'bob@example.com', '2345678901', 'Attendee'),
('Charlie Brown', 'charlie@example.com', '3456789012', 'Admin'),
('David Miller', 'david@example.com', '4567890123', 'Attendee'),
('Eva Green', 'eva@example.com', '5678901234', 'Organizer');

-- Insert into Locations
INSERT INTO Locations (venue_name, address, capacity) VALUES
('Grand Hall', '123 Main St, City A', 500),
('Conference Center', '456 Elm St, City B', 300),
('Open Air Park', '789 Oak St, City C', 1000),
('Luxury Ballroom', '321 Pine St, City D', 200),
('Tech Auditorium', '654 Maple St, City E', 400);

-- Insert into Events
INSERT INTO Events (event_name, event_date, location_id, organizer_id) VALUES
('Tech Summit 2025', '2025-05-10', 1, 1),
('Music Concert', '2025-06-15', 3, 5),
('Startup Expo', '2025-07-20', 2, 1),
('Art Exhibition', '2025-08-25', 4, 5),
('Business Conference', '2025-09-30', 5, 1);

-- Insert into Tickets
INSERT INTO Tickets (event_id, user_id, price, seat_no) VALUES
(1, 2, 50.00, 'A1'),
(1, 4, 50.00, 'A2'),
(2, 3, 75.00, 'B1'),
(3, 2, 100.00, 'C1'),
(4, 4, 120.00, 'D1');

-- Insert into Payments
INSERT INTO Payments (ticket_id, payment_date, amount, payment_method) VALUES
(1, '2025-04-15', 50.00, 'Credit Card'),
(2, '2025-04-16', 50.00, 'PayPal'),
(3, '2025-06-01', 75.00, 'Debit Card'),
(4, '2025-07-10', 100.00, 'Cash'),
(5, '2025-08-15', 120.00, 'Credit Card');

-- Insert into Sponsors
INSERT INTO Sponsors (sponsor_name, event_id, contribution_amount) VALUES
('TechCorp', 1, 5000.00),
('MusicWorld', 2, 3000.00),
('StartupFund', 3, 7000.00),
('ArtLovers', 4, 4000.00),
('BizPartners', 5, 6000.00);

-- Insert into Feedback
INSERT INTO Feedback (event_id, user_id, rating, comments) VALUES
(1, 2, 5, 'Amazing event, well organized!'),
(1, 4, 4, 'Good experience, but could be improved.'),
(2, 3, 3, 'Decent show, but sound system was bad.'),
(3, 2, 5, 'Startup Expo was fantastic!'),
(4, 4, 2, 'Art Exhibition was underwhelming.');

-- Retrieve all events along with their location details.
SELECT e.event_name, e.event_date, l.venue_name, l.address 
FROM Events e 
JOIN Locations l ON e.location_id = l.location_id;

-- Find total revenue generated from ticket sales for a particular event.
SELECT e.event_name, SUM(t.price) AS total_revenue
FROM Tickets t 
JOIN Events e ON t.event_id = e.event_id 
WHERE e.event_id = 1;

-- Get the list of users who have attended more than 1 event.
SELECT u.name, COUNT(t.ticket_id) AS events_attended
FROM Users u
JOIN Tickets t ON u.user_id = t.user_id
GROUP BY u.user_id
HAVING COUNT(t.ticket_id) > 1;

-- Find the most booked event by attendees.
SELECT e.event_name, COUNT(t.ticket_id) AS total_tickets
FROM Tickets t
JOIN Events e ON t.event_id = e.event_id
GROUP BY e.event_id
ORDER BY total_tickets DESC
LIMIT 1;

-- List all sponsors who have contributed more than $4000.
SELECT sponsor_name, contribution_amount 
FROM Sponsors 
WHERE contribution_amount > 4000;

-- Fetch all feedback with ratings below 3 for a particular event.
SELECT * 
FROM Feedback 
WHERE rating < 3;

-- Show the percentage of events that are fully booked.
SELECT (COUNT(DISTINCT event_id) * 100.0 / (SELECT COUNT(*) FROM Events)) AS fully_booked_percentage
FROM Tickets;

-- Retrieve the top 3 locations with the most events held
SELECT l.venue_name, COUNT(e.event_id) AS total_events
FROM Events e
JOIN Locations l ON e.location_id = l.location_id
GROUP BY l.location_id
ORDER BY total_events DESC
LIMIT 3;

-- Get the highest amount paid for a single ticket.
SELECT MAX(amount) AS highest_ticket_price 
FROM Payments;

-- Find the organizer who has hosted the most events
SELECT u.name AS organizer_name, COUNT(e.event_id) AS total_events
FROM Events e
JOIN Users u ON e.organizer_id = u.user_id
GROUP BY u.user_id
ORDER BY total_events DESC
LIMIT 1;

-- Find users who have attended the "Tech Summit 2025".
SELECT u.name, u.email 
FROM Users u
JOIN Tickets t ON u.user_id = t.user_id
JOIN Events e ON t.event_id = e.event_id
WHERE e.event_name = 'Tech Summit 2025';

-- Retrieve a list of events along with their sponsors.
SELECT e.event_name, s.sponsor_name, s.contribution_amount
FROM Sponsors s
JOIN Events e ON s.event_id = e.event_id;

-- Count the total number of tickets sold per event.
SELECT e.event_name, COUNT(t.ticket_id) AS total_tickets_sold
FROM Tickets t
JOIN Events e ON t.event_id = e.event_id
GROUP BY e.event_id;

-- Find the average rating of each event based on feedback.
SELECT e.event_name, AVG(f.rating) AS average_rating
FROM Feedback f
JOIN Events e ON f.event_id = e.event_id
GROUP BY e.event_id;
