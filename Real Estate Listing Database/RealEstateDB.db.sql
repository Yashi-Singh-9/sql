sqlite3 RealEstateDB.db

-- Users Table  
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50),
  phone BIGINT,
  user_type VARCHAR(10) CHECK (user_type IN ('buyer', 'seller', 'agent')),
  password TEXT
);

-- Properties Table 
CREATE TABLE properties (
  property_id INTEGER PRIMARY KEY,
  title VARCHAR(20),
  description TEXT,
  price DECIMAL(12,2),
  location VARCHAR(20),
  property_type VARCHAR(30) CHECK (property_type IN ('apartment', 'house', 'commercial', 'land', 'other')),
  size_sqft INTEGER,
  bedrooms INTEGER,
  bathrooms INTEGER,
  seller_id INTEGER,
  FOREIGN KEY (seller_id) REFERENCES users(user_id)
);

-- Listings Table 
CREATE TABLE listings (
  listing_id INTEGER PRIMARY KEY,
  property_id INTEGER,
  agent_id INTEGER,
  status VARCHAR(15) CHECK (status IN ('available', 'sold', 'pending')),
  date_listed DATETIME,
  date_sold DATETIME,
  FOREIGN KEY (property_id) REFERENCES properties(property_id),
  FOREIGN KEY (agent_id) REFERENCES users(user_id)
);

-- Transactions Table  
CREATE TABLE transactions (
  transaction_id INTEGER PRIMARY KEY,
  buyer_id INTEGER,
  property_id INTEGER,
  amount DECIMAL(10,3),
  transaction_date DATETIME,
  FOREIGN KEY (buyer_id) REFERENCES users(user_id),
  FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Images Table 
CREATE TABLE images (
  image_id INTEGER PRIMARY KEY,
  property_id INTEGER,
  image_url VARCHAR(2083),
  FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Insert Users
INSERT INTO users (user_id, name, email, phone, user_type, password) VALUES
(1, 'Alice Johnson', 'alice@example.com', 1234567890, 'buyer', 'password1'),
(2, 'Bob Smith', 'bob@example.com', 9876543210, 'seller', 'password2'),
(3, 'Charlie Brown', 'charlie@example.com', 1928374650, 'agent', 'password3'),
(4, 'David White', 'david@example.com', 5647382910, 'buyer', 'password4'),
(5, 'Emma Green', 'emma@example.com', 6758493021, 'seller', 'password5'),
(6, 'Frank Black', 'frank@example.com', 9081726354, 'agent', 'password6'),
(7, 'Grace Adams', 'grace@example.com', 8172635490, 'buyer', 'password7'),
(8, 'Henry Ford', 'henry@example.com', 7348291056, 'seller', 'password8');

-- Insert Properties
INSERT INTO properties (property_id, title, description, price, location, property_type, size_sqft, bedrooms, bathrooms, seller_id) VALUES
(1, 'Modern Apartment', 'Spacious apartment in city center', 250000.00, 'New York', 'apartment', 1200, 2, 2, 2),
(2, 'Cozy House', 'Beautiful house with a garden', 450000.00, 'Los Angeles', 'house', 2200, 4, 3, 5),
(3, 'Office Space', 'Commercial office in business district', 600000.00, 'Chicago', 'commercial', 5000, 0, 2, 8),
(4, 'Luxury Villa', 'Stunning villa with pool', 1250000.00, 'Miami', 'house', 3500, 5, 4, 2),
(5, 'Downtown Studio', 'Compact studio perfect for singles', 180000.00, 'San Francisco', 'apartment', 600, 1, 1, 5),
(6, 'Retail Shop', 'Prime location retail shop', 750000.00, 'Boston', 'commercial', 2500, 0, 1, 8),
(7, 'Mountain Cabin', 'Cozy retreat in the mountains', 320000.00, 'Denver', 'house', 1800, 3, 2, 2),
(8, 'Vacant Land', 'Perfect for future development', 500000.00, 'Seattle', 'land', 10000, 0, 0, 5);

-- Insert Listings
INSERT INTO listings (listing_id, property_id, agent_id, status, date_listed, date_sold) VALUES
(1, 1, 3, 'available', '2024-01-15', NULL),
(2, 2, 6, 'pending', '2024-01-10', NULL),
(3, 3, 3, 'available', '2024-02-01', NULL),
(4, 4, 6, 'sold', '2024-01-20', '2024-02-05'),
(5, 5, 3, 'available', '2024-02-10', NULL),
(6, 6, 6, 'pending', '2024-01-25', NULL),
(7, 7, 3, 'available', '2024-02-05', NULL),
(8, 8, 6, 'sold', '2024-01-30', '2024-02-12');

-- Insert Transactions
INSERT INTO transactions (transaction_id, buyer_id, property_id, amount, transaction_date) VALUES
(1, 1, 4, 1250000.000, '2024-02-05'),
(2, 7, 8, 500000.000, '2024-02-12'),
(3, 4, 2, 450000.000, '2024-02-08'),
(4, 1, 6, 750000.000, '2024-02-15'),
(5, 7, 5, 180000.000, '2024-02-14'),
(6, 4, 3, 600000.000, '2024-02-18'),
(7, 1, 7, 320000.000, '2024-02-20'),
(8, 7, 1, 250000.000, '2024-02-25');

-- Insert Images
INSERT INTO images (image_id, property_id, image_url) VALUES
(1, 1, 'https://example.com/images/apt1.jpg'),
(2, 2, 'https://example.com/images/house1.jpg'),
(3, 3, 'https://example.com/images/office1.jpg'),
(4, 4, 'https://example.com/images/villa1.jpg'),
(5, 5, 'https://example.com/images/studio1.jpg'),
(6, 6, 'https://example.com/images/shop1.jpg'),
(7, 7, 'https://example.com/images/cabin1.jpg'),
(8, 8, 'https://example.com/images/land1.jpg');

-- Insert Reviews
INSERT INTO reviews (review_id, user_id, property_id, rating, comment, date_posted) VALUES
(1, 1, 1, 5, 'Great location and amenities!', '2024-02-01'),
(2, 4, 2, 4, 'Lovely house but needs some renovation.', '2024-02-02'),
(3, 7, 3, 3, 'Good office space but a bit pricey.', '2024-02-03'),
(4, 1, 4, 5, 'Absolutely stunning villa!', '2024-02-04'),
(5, 7, 5, 4, 'Nice studio but small.', '2024-02-05'),
(6, 4, 6, 3, 'Decent shop but parking is an issue.', '2024-02-06'),
(7, 1, 7, 5, 'Peaceful and beautiful cabin.', '2024-02-07'),
(8, 7, 8, 4, 'Good investment for future.', '2024-02-08');

-- Reviews Table  
CREATE TABLE reviews (
  review_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  property_id INTEGER,
  rating INTEGER CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  date_posted DATETIME,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Retrieve all properties listed by a specific seller.
SELECT * FROM properties WHERE seller_id = 2;

-- Find the most expensive property in a given location.
SELECT * FROM properties 
WHERE location = 'New York' 
ORDER BY price DESC 
LIMIT 1;

-- Get a list of properties that are still available for sale.
SELECT p.* FROM properties p
JOIN listings l ON p.property_id = l.property_id
WHERE l.status = 'available';

-- Show all transactions made by a specific buyer.
SELECT * FROM transactions WHERE buyer_id = 1;

-- Find the agent who has listed the most properties.
SELECT agent_id, COUNT(*) AS total_listings
FROM listings
GROUP BY agent_id
ORDER BY total_listings DESC
LIMIT 1;

-- Count the number of properties available in each city.
SELECT location, COUNT(*) AS total_properties
FROM properties
GROUP BY location;

-- Get the top 5 highest-rated properties based on reviews.
SELECT property_id, AVG(rating) AS average_rating
FROM reviews
GROUP BY property_id
ORDER BY average_rating DESC
LIMIT 5;

-- Find properties that have at least 3 bedrooms and are priced under $500,000.
SELECT * FROM properties 
WHERE bedrooms >= 3 AND price < 500000.00;

-- List all images associated with a particular property.
SELECT * FROM images WHERE property_id = 1;

-- Show all sellers who have not listed any properties.
SELECT u.* FROM users u
LEFT JOIN properties p ON u.user_id = p.seller_id
WHERE u.user_type = 'seller' AND p.property_id IS NULL;