-- Project in PostgreSQL 
-- Create Database
CREATE DATABASE FestivalEventPlanning;
\c FestivalEventPlanning;

-- Festivals Table
CREATE TABLE Festivals (
    festival_id SERIAL PRIMARY KEY,
    festival_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- Vendors Table
CREATE TABLE Vendors (
    vendor_id SERIAL PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL,
    contact_info VARCHAR(100) NOT NULL
);

-- Attendees Table
CREATE TABLE Attendees (
    attendee_id SERIAL PRIMARY KEY,
    attendee_name VARCHAR(100) NOT NULL,
    age INT NOT NULL
);

-- Event Schedule Table
CREATE TABLE EventSchedule (
    event_id SERIAL PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    festival_id INT REFERENCES Festivals(festival_id) ON DELETE CASCADE,
    event_date DATE NOT NULL
);

-- Vendor Assignments Table
CREATE TABLE VendorAssignments (
    assignment_id SERIAL PRIMARY KEY,
    vendor_id INT REFERENCES Vendors(vendor_id) ON DELETE CASCADE,
    festival_id INT REFERENCES Festivals(festival_id) ON DELETE CASCADE
);

INSERT INTO Festivals (festival_name, location, start_date, end_date)
VALUES 
('Music Mania', 'New York', '2025-06-10', '2025-06-15'),
('Food Fiesta', 'Los Angeles', '2025-07-05', '2025-07-10'),
('Cultural Fest', 'Chicago', '2025-08-12', '2025-08-18'),
('Tech Expo', 'San Francisco', '2025-09-20', '2025-09-25'),
('Art Carnival', 'Miami', '2025-10-15', '2025-10-20');

INSERT INTO Vendors (vendor_name, contact_info)
VALUES 
('Food Delights', 'food@vendor.com'),
('Music Beats', 'music@vendor.com'),
('Tech Gadgets', 'tech@vendor.com'),
('Art Hub', 'art@vendor.com'),
('Handmade Crafts', 'crafts@vendor.com');

INSERT INTO Attendees (attendee_name, age)
VALUES 
('John Doe', 25),
('Alice Smith', 30),
('Robert Brown', 28),
('Emily Johnson', 22),
('Michael Lee', 35);

INSERT INTO EventSchedule (event_name, festival_id, event_date)
VALUES 
('Rock Concert', 1, '2025-06-12'),
('Food Tasting', 2, '2025-07-07'),
('Dance Show', 3, '2025-08-14'),
('Tech Seminar', 4, '2025-09-22'),
('Painting Exhibition', 5, '2025-10-18');

INSERT INTO VendorAssignments (vendor_id, festival_id)
VALUES 
(1, 1),  
(2, 1),  
(1, 2),  
(3, 4),  
(5, 3);  

-- Retrieve All Festivals
SELECT * 
FROM Festivals;

-- Retrieve All Vendors
SELECT * 
FROM Vendors;

-- Retrieve All Attendees
SELECT * 
FROM Attendees;

-- Retrieve All Events Scheduled for a Specific Festival
SELECT e.event_name, e.event_date, f.festival_name 
FROM EventSchedule e
JOIN Festivals f ON e.festival_id = f.festival_id
WHERE f.festival_name = 'Music Mania';

-- Retrieve Vendors Assigned to Each Festival
SELECT v.vendor_name, f.festival_name 
FROM VendorAssignments va
JOIN Vendors v ON va.vendor_id = v.vendor_id
JOIN Festivals f ON va.festival_id = f.festival_id;

-- Retrieve Attendees Older Than 25
SELECT * 
FROM Attendees
WHERE age > 25;

-- Count the Number of Events in Each Festival
SELECT f.festival_name, COUNT(e.event_id) AS event_count
FROM Festivals f
LEFT JOIN EventSchedule e ON f.festival_id = e.festival_id
GROUP BY f.festival_name;

-- List All Festivals with Start and End Dates
SELECT festival_name, start_date, end_date 
FROM Festivals;

-- Find All Vendors Participating in a Specific Festival 
SELECT v.vendor_name 
FROM VendorAssignments va
JOIN Vendors v ON va.vendor_id = v.vendor_id
JOIN Festivals f ON va.festival_id = f.festival_id
WHERE f.festival_name = 'Tech Expo';

-- Retrieve Festival Details Along with the Events Scheduled
SELECT f.festival_name, f.location, e.event_name, e.event_date
FROM Festivals f
LEFT JOIN EventSchedule e ON f.festival_id = e.festival_id
ORDER BY f.festival_name, e.event_date;

-- Find Festivals with More Than One Vendor Assigned
SELECT f.festival_name, COUNT(va.vendor_id) AS vendor_count
FROM Festivals f
JOIN VendorAssignments va ON f.festival_id = va.festival_id
GROUP BY f.festival_name
HAVING COUNT(va.vendor_id) > 1;

-- Retrieve All Events Happening After a Specific Date
SELECT event_name, event_date, festival_id 
FROM EventSchedule 
WHERE event_date > '2025-07-01'
ORDER BY event_date;

-- Get Festivals Along with the Total Number of Vendors Assigned
SELECT f.festival_name, COUNT(va.vendor_id) AS total_vendors
FROM Festivals f
LEFT JOIN VendorAssignments va ON f.festival_id = va.festival_id
GROUP BY f.festival_name;

-- Retrieve Festival Names Along with the Total Number of Events
SELECT f.festival_name, COUNT(e.event_id) AS total_events
FROM Festivals f
LEFT JOIN EventSchedule e ON f.festival_id = e.festival_id
GROUP BY f.festival_name;

-- Find Vendors Who Are Assigned to More Than One Festival
SELECT v.vendor_name, COUNT(va.festival_id) AS festival_count
FROM Vendors v
JOIN VendorAssignments va ON v.vendor_id = va.vendor_id
GROUP BY v.vendor_name
HAVING COUNT(va.festival_id) > 1;
