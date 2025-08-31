-- MS SQL Project
CREATE DATABASE HOA_Management;
USE HOA_Management;

-- Create Homeowners Table
CREATE TABLE Homeowners (
    homeowner_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(255),
    registration_date DATE
);

-- Create Properties Table
CREATE TABLE Properties (
    property_id INT PRIMARY KEY,
    homeowner_id INT,
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    property_type VARCHAR(50),
    FOREIGN KEY (homeowner_id) REFERENCES Homeowners(homeowner_id)
);

-- Create Fees Table
CREATE TABLE Fees (
    fee_id INT PRIMARY KEY,
    homeowner_id INT,
    amount DECIMAL(10,2),
    due_date DATE,
    status VARCHAR(10),
    FOREIGN KEY (homeowner_id) REFERENCES Homeowners(homeowner_id)
);

-- Create Violations Table
CREATE TABLE Violations (
    violation_id INT PRIMARY KEY,
    homeowner_id INT,
    violation_type VARCHAR(100),
    description TEXT,
    violation_date DATE,
    status VARCHAR(10),
    FOREIGN KEY (homeowner_id) REFERENCES Homeowners(homeowner_id)
);

-- Create Meetings Table
CREATE TABLE Meetings (
    meeting_id INT PRIMARY KEY,
    date DATE,
    time TIME,
    location VARCHAR(255),
    agenda TEXT
);

-- Create Attendees Table
CREATE TABLE Attendees (
    attendee_id INT PRIMARY KEY,
    meeting_id INT,
    homeowner_id INT,
    FOREIGN KEY (meeting_id) REFERENCES Meetings(meeting_id),
    FOREIGN KEY (homeowner_id) REFERENCES Homeowners(homeowner_id)
);

-- Create Vendors Table
CREATE TABLE Vendors (
    vendor_id INT PRIMARY KEY,
    company_name VARCHAR(100),
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    service_type VARCHAR(50)
);

-- Create Service Requests Table
CREATE TABLE Service_Requests (
    request_id INT PRIMARY KEY,
    homeowner_id INT,
    vendor_id INT,
    request_date DATE,
    status VARCHAR(10),
    FOREIGN KEY (homeowner_id) REFERENCES Homeowners(homeowner_id),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Insert Sample Data (8 Entries)
INSERT INTO Homeowners VALUES
(1, 'John', 'Doe', 'john@example.com', '1234567890', '123 Maple St', '2023-01-10'),
(2, 'Jane', 'Smith', 'jane@example.com', '2345678901', '456 Oak St', '2023-02-15'),
(3, 'Michael', 'Johnson', 'michael@example.com', '3456789012', '789 Pine St', '2023-03-20'),
(4, 'Emily', 'Davis', 'emily@example.com', '4567890123', '321 Cedar St', '2023-04-25'),
(5, 'Robert', 'Brown', 'robert@example.com', '5678901234', '654 Elm St', '2023-05-30'),
(6, 'Linda', 'Wilson', 'linda@example.com', '6789012345', '987 Birch St', '2023-06-05'),
(7, 'James', 'Taylor', 'james@example.com', '7890123456', '147 Spruce St', '2023-07-10'),
(8, 'Patricia', 'Anderson', 'patricia@example.com', '8901234567', '258 Fir St', '2023-08-15');

INSERT INTO Properties VALUES
(1, 1, '123 Maple St', 'Springfield', 'IL', '62701', 'Single Family'),
(2, 2, '456 Oak St', 'Austin', 'TX', '73301', 'Townhouse'),
(3, 3, '789 Pine St', 'Seattle', 'WA', '98101', 'Condo'),
(4, 4, '321 Cedar St', 'Miami', 'FL', '33101', 'Apartment'),
(5, 5, '654 Elm St', 'Denver', 'CO', '80201', 'Single Family'),
(6, 6, '987 Birch St', 'Boston', 'MA', '02101', 'Townhouse'),
(7, 7, '147 Spruce St', 'Portland', 'OR', '97201', 'Condo'),
(8, 8, '258 Fir St', 'New York', 'NY', '10001', 'Apartment');

INSERT INTO Fees VALUES
(1, 1, 200.00, '2024-02-01', 'Paid'),
(2, 2, 250.00, '2024-02-10', 'Unpaid'),
(3, 3, 180.00, '2024-02-15', 'Paid'),
(4, 4, 220.00, '2024-02-20', 'Unpaid'),
(5, 5, 300.00, '2024-02-25', 'Paid'),
(6, 6, 260.00, '2024-03-01', 'Unpaid'),
(7, 7, 280.00, '2024-03-05', 'Paid'),
(8, 8, 230.00, '2024-03-10', 'Unpaid');

INSERT INTO Violations VALUES
(1, 1, 'Noise Complaint', 'Loud music after 10 PM', '2024-01-15', 'Resolved'),
(2, 2, 'Parking Violation', 'Unauthorized vehicle in reserved spot', '2024-01-20', 'Pending'),
(3, 3, 'Lawn Maintenance', 'Overgrown grass and weeds', '2024-01-25', 'Resolved'),
(4, 4, 'Trash Disposal', 'Garbage left outside bin', '2024-02-01', 'Pending'),
(5, 5, 'Fence Issue', 'Broken fence panel', '2024-02-05', 'Resolved'),
(6, 6, 'Exterior Damage', 'Peeling paint on home exterior', '2024-02-10', 'Pending'),
(7, 7, 'Pet Violation', 'Unleashed dog in common area', '2024-02-15', 'Resolved'),
(8, 8, 'Signage Violation', 'Unauthorized advertisement sign', '2024-02-20', 'Pending');

INSERT INTO Meetings VALUES
(1, '2024-03-01', '18:00:00', 'Community Hall', 'Annual Budget Discussion'),
(2, '2024-03-10', '17:00:00', 'Clubhouse', 'Security and Safety Updates'),
(3, '2024-03-20', '19:00:00', 'Online Zoom', 'HOA Rules Review'),
(4, '2024-03-25', '18:30:00', 'Park Pavilion', 'Community Event Planning');

INSERT INTO Attendees VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(5, 3, 5),
(6, 3, 6),
(7, 4, 7),
(8, 4, 8);

INSERT INTO Vendors VALUES
(1, 'Green Landscaping', 'Mike Green', '3219876543', 'Landscaping'),
(2, 'Quick Plumbing', 'Sarah White', '4321987654', 'Plumbing'),
(3, 'Bright Electric', 'James Blue', '5432198765', 'Electrical'),
(4, 'Secure Guard', 'Anna Black', '6543219876', 'Security');

INSERT INTO Service_Requests VALUES
(1, 1, 1, '2024-02-05', 'Pending'),
(2, 2, 2, '2024-02-10', 'Completed'),
(3, 3, 3, '2024-02-15', 'Pending'),
(4, 4, 4, '2024-02-20', 'Completed'),
(5, 5, 1, '2024-02-25', 'Pending'),
(6, 6, 2, '2024-03-01', 'Completed'),
(7, 7, 3, '2024-03-05', 'Pending'),
(8, 8, 4, '2024-03-10', 'Completed');

-- Find all homeowners who have unpaid fees.
SELECT H.homeowner_id, H.first_name, H.last_name, H.email, H.phone, H.address
FROM Homeowners H
JOIN Fees F ON H.homeowner_id = F.homeowner_id
WHERE F.status = 'Unpaid';

-- List all properties and their corresponding homeowners.
SELECT P.property_id, P.address, P.city, P.state, P.zip_code, P.property_type,
       H.homeowner_id, H.first_name, H.last_name, H.email, H.phone
FROM Properties P
JOIN Homeowners H ON P.homeowner_id = H.homeowner_id;

-- Retrieve all violations that are still unresolved.
SELECT violation_id, homeowner_id, violation_type, description, violation_date, status
FROM Violations
WHERE status = 'Pending';

-- Get the total amount of fees collected for a specific month.
SELECT SUM(amount) AS total_fees_collected
FROM Fees
WHERE status = 'Paid' AND FORMAT(due_date, 'yyyy-MM') = '2024-02';

-- Find homeowners who have attended more than three meetings.
SELECT A.homeowner_id, H.first_name, H.last_name, COUNT(A.meeting_id) AS meetings_attended
FROM Attendees A
JOIN Homeowners H ON A.homeowner_id = H.homeowner_id
GROUP BY A.homeowner_id, H.first_name, H.last_name
HAVING COUNT(A.meeting_id) > 3;

-- List all vendors who provide landscaping services.
SELECT vendor_id, company_name, contact_person, phone, service_type
FROM Vendors
WHERE service_type = 'Landscaping';

-- Retrieve homeowners who have service requests pending.
SELECT DISTINCT H.homeowner_id, H.first_name, H.last_name, H.email, H.phone, H.address
FROM Homeowners H
JOIN Service_Requests SR ON H.homeowner_id = SR.homeowner_id
WHERE SR.status = 'Pending';

-- Find properties located in a specific ZIP code.
SELECT property_id, homeowner_id, address, city, state, zip_code, property_type
FROM Properties
WHERE zip_code = '10001';

-- List homeowners who have received more than two violations.
SELECT V.homeowner_id, H.first_name, H.last_name, COUNT(V.violation_id) AS violation_count
FROM Violations V
JOIN Homeowners H ON V.homeowner_id = H.homeowner_id
GROUP BY V.homeowner_id, H.first_name, H.last_name
HAVING COUNT(V.violation_id) > 2;

-- Get the details of the latest HOA meeting.
SELECT TOP 1 *
FROM Meetings
ORDER BY date DESC, time DESC;
