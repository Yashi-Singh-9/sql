-- SQL Lite Project
sqlite3 PropertyRentalDB.db

-- Users Table 
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  phone TEXT, 
  user_type VARCHAR(10) CHECK (user_type IN ('Tenant', 'Landlord')),
  password TEXT  
);

-- Properties Table  
CREATE TABLE properties (
  property_id INTEGER PRIMARY KEY,
  landlord_id INTEGER,
  property_name VARCHAR(50),
  address TEXT,
  city VARCHAR(50),
  state VARCHAR(50),
  zip_code TEXT,  -- Changed from BIGINT to TEXT
  property_type VARCHAR(20) CHECK (property_type IN ('Apartment', 'House', 'Villa', 'Condo', 'Townhouse', 'Studio')),
  rent_price DECIMAL(10,2),
  availability_status VARCHAR(15) CHECK (availability_status IN ('Available', 'Not Available')),
  FOREIGN KEY (landlord_id) REFERENCES users(user_id)
);

-- Bookings Table  
CREATE TABLE bookings (
  booking_id INTEGER PRIMARY KEY,
  tenant_id INTEGER,
  property_id INTEGER,
  start_date DATE,
  end_date DATE,
  booking_status VARCHAR(15) CHECK (booking_status IN ('Pending', 'Approved', 'Rejected')),
  payment_status VARCHAR(10) CHECK (payment_status IN ('Completed', 'Pending')), -- Standardized
  FOREIGN KEY (tenant_id) REFERENCES users(user_id),
  FOREIGN KEY (property_id) REFERENCES properties(property_id),
  CHECK (start_date < end_date)  
);

-- Payments Table 
CREATE TABLE payments (
  payment_id INTEGER PRIMARY KEY,
  booking_id INTEGER,
  payment_date DATETIME,
  amount_paid DECIMAL(10,2),  
  payment_method VARCHAR(20) CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'Cash')),
  payment_status VARCHAR(15) CHECK (payment_status IN ('Completed', 'Pending')),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Reviews Table 
CREATE TABLE reviews (
  review_id INTEGER PRIMARY KEY,
  tenant_id INTEGER,
  property_id INTEGER,
  rating INTEGER CHECK (rating BETWEEN 1 AND 5),
  review_text TEXT,
  review_date DATE,
  FOREIGN KEY (tenant_id) REFERENCES users(user_id),
  FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

INSERT INTO users (user_id, first_name, last_name, email, phone, user_type, password) VALUES
(1, 'Alice', 'Johnson', 'alice.j@example.com', '1234567890', 'Tenant', 'hashed_pw1'),
(2, 'Bob', 'Smith', 'bob.smith@example.com', '9876543210', 'Tenant', 'hashed_pw2'),
(3, 'Charlie', 'Brown', 'charlie.b@example.com', '5556667777', 'Tenant', 'hashed_pw3'),
(4, 'David', 'Miller', 'david.m@example.com', '1112223333', 'Tenant', 'hashed_pw4'),
(5, 'Eve', 'Davis', 'eve.davis@example.com', '4445556666', 'Landlord', 'hashed_pw5'),
(6, 'Frank', 'Wilson', 'frank.w@example.com', '7778889999', 'Landlord', 'hashed_pw6'),
(7, 'Grace', 'Lee', 'grace.lee@example.com', '2223334444', 'Landlord', 'hashed_pw7'),
(8, 'Hank', 'Moore', 'hank.m@example.com', '9998887777', 'Landlord', 'hashed_pw8');

INSERT INTO properties (property_id, landlord_id, property_name, address, city, state, zip_code, property_type, rent_price, availability_status) VALUES
(1, 5, 'Sunset Villa', '123 Palm St', 'Los Angeles', 'CA', '90001', 'Villa', 2500.00, 'Available'),
(2, 5, 'Cozy Condo', '456 Beach Rd', 'Miami', 'FL', '33101', 'Condo', 1800.00, 'Available'),
(3, 6, 'Downtown Loft', '789 Main St', 'New York', 'NY', '10001', 'Apartment', 2200.00, 'Not Available'),
(4, 6, 'Greenwood House', '321 Oak Ave', 'Chicago', 'IL', '60601', 'House', 2700.00, 'Available'),
(5, 7, 'Studio Central', '654 Pine St', 'San Francisco', 'CA', '94101', 'Studio', 1500.00, 'Available'),
(6, 7, 'Modern Townhouse', '987 Cedar Ln', 'Seattle', 'WA', '98101', 'Townhouse', 2000.00, 'Not Available'),
(7, 8, 'Luxury Apartment', '741 Elm St', 'Houston', 'TX', '77001', 'Apartment', 2300.00, 'Available'),
(8, 8, 'Seaside Retreat', '852 Ocean Blvd', 'San Diego', 'CA', '92001', 'Villa', 2600.00, 'Available');

INSERT INTO bookings (booking_id, tenant_id, property_id, start_date, end_date, booking_status, payment_status) VALUES
(1, 1, 1, '2024-03-01', '2024-09-01', 'Approved', 'Completed'),
(2, 2, 2, '2024-04-15', '2024-10-15', 'Pending', 'Pending'),
(3, 3, 3, '2024-05-01', '2024-11-01', 'Rejected', 'Pending'),
(4, 4, 4, '2024-06-10', '2024-12-10', 'Approved', 'Completed'),
(5, 1, 5, '2024-07-05', '2025-01-05', 'Pending', 'Pending'),
(6, 2, 6, '2024-08-01', '2025-02-01', 'Approved', 'Completed'),
(7, 3, 7, '2024-09-01', '2025-03-01', 'Approved', 'Completed'),
(8, 4, 8, '2024-10-01', '2025-04-01', 'Pending', 'Pending');

INSERT INTO payments (payment_id, booking_id, payment_date, amount_paid, payment_method, payment_status) VALUES
(1, 1, '2024-03-02 14:00:00', 2500.00, 'Credit Card', 'Completed'),
(2, 4, '2024-06-11 10:30:00', 2700.00, 'Bank Transfer', 'Completed'),
(3, 6, '2024-08-02 12:45:00', 2000.00, 'Cash', 'Completed'),
(4, 7, '2024-09-02 16:00:00', 2300.00, 'Credit Card', 'Completed'),
(5, 2, NULL, 0.00, 'Bank Transfer', 'Pending'),
(6, 5, NULL, 0.00, 'Cash', 'Pending'),
(7, 8, NULL, 0.00, 'Credit Card', 'Pending'),
(8, 3, NULL, 0.00, 'Bank Transfer', 'Pending');

INSERT INTO reviews (review_id, tenant_id, property_id, rating, review_text, review_date) VALUES
(1, 1, 1, 5, 'Amazing villa, very comfortable!', '2024-09-02'),
(2, 2, 2, 4, 'Nice condo, but a bit noisy.', '2024-10-20'),
(3, 3, 3, 3, 'Decent place, but overpriced.', '2024-11-15'),
(4, 4, 4, 5, 'Loved the backyard and space.', '2024-12-12'),
(5, 1, 5, 4, 'Great studio, perfect for one person.', '2025-01-06'),
(6, 2, 6, 5, 'Townhouse was spacious and modern.', '2025-02-02'),
(7, 3, 7, 4, 'Apartment had amazing city views.', '2025-03-05'),
(8, 4, 8, 5, 'Best vacation home ever!', '2025-04-10');

-- Retrieve all properties that are currently available for rent.
SELECT * 
FROM properties 
WHERE availability_status = 'Available';

-- Find all bookings for a specific tenant.
SELECT * 
FROM bookings 
WHERE tenant_id = 1;

-- List all landlords along with the properties they own.
SELECT u.user_id, u.first_name, u.last_name, p.property_id, p.property_name, p.address, p.city, p.state
FROM users u
JOIN properties p ON u.user_id = p.landlord_id
WHERE u.user_type = 'Landlord';

-- Find all unpaid bookings and their respective tenants.
SELECT b.booking_id, b.start_date, b.end_date, u.first_name, u.last_name, u.email
FROM bookings b
JOIN users u ON b.tenant_id = u.user_id
WHERE b.payment_status = 'Unpaid';

-- Get the total amount paid by a specific tenant.
SELECT u.user_id, u.first_name, u.last_name, COALESCE(SUM(p.amount_paid), 0) AS total_paid
FROM users u
LEFT JOIN bookings b ON u.user_id = b.tenant_id
LEFT JOIN payments p ON b.booking_id = p.booking_id
WHERE u.user_id = 5;

-- Retrieve all reviews for a particular property.
SELECT r.review_id, r.rating, r.review_text, r.review_date, u.first_name, u.last_name
FROM reviews r
JOIN users u ON r.tenant_id = u.user_id
WHERE r.property_id = 3;

-- Find the most rented property based on the number of bookings.
SELECT p.property_id, p.property_name, COUNT(b.booking_id) AS total_bookings
FROM properties p
JOIN bookings b ON p.property_id = b.property_id
GROUP BY p.property_id
ORDER BY total_bookings DESC
LIMIT 1;

-- Retrieve tenants who have booked more than one properties.
SELECT u.user_id, u.first_name, u.last_name, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b ON u.user_id = b.tenant_id
GROUP BY u.user_id
HAVING COUNT(b.booking_id) > 1;

-- List all properties along with the average rating from reviews.
SELECT p.property_id, p.property_name, COALESCE(AVG(r.rating), 0) AS avg_rating
FROM properties p
LEFT JOIN reviews r ON p.property_id = r.property_id
GROUP BY p.property_id;

-- Find all landlords who have properties without any bookings.
SELECT u.user_id, u.first_name, u.last_name
FROM users u
WHERE u.user_type = 'Landlord'
AND u.user_id IN (
    SELECT p.landlord_id 
    FROM properties p
    LEFT JOIN bookings b ON p.property_id = b.property_id
    WHERE b.booking_id IS NULL
);
