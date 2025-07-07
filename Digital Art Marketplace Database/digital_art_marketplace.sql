-- Project In MariaDB 
-- Create the database
CREATE DATABASE digital_art_marketplace;
USE digital_art_marketplace;

-- Artists table
CREATE TABLE artists (
    artist_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    bio TEXT,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Buyers table
CREATE TABLE buyers (
    buyer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    registered_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Artworks table
CREATE TABLE artworks (
    artwork_id INT AUTO_INCREMENT PRIMARY KEY,
    artist_id INT,
    title VARCHAR(255),
    description TEXT,
    file_path VARCHAR(255),
    price DECIMAL(10,2),
    is_sold BOOLEAN DEFAULT FALSE,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
);

-- Transactions table
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    buyer_id INT,
    artwork_id INT,
    transaction_amount DECIMAL(10,2),
    transaction_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (buyer_id) REFERENCES buyers(buyer_id),
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id)
);

-- Licenses table
CREATE TABLE licenses (
    license_id INT AUTO_INCREMENT PRIMARY KEY,
    artwork_id INT,
    buyer_id INT,
    license_type ENUM('personal', 'commercial', 'exclusive'),
    licensed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id),
    FOREIGN KEY (buyer_id) REFERENCES buyers(buyer_id)
);

-- Artists
INSERT INTO artists (name, email, bio) VALUES
('Lena Rowe', 'lena@art.com', 'Digital surrealist artist.'),
('Marco Diaz', 'marco@art.com', 'Futuristic illustrations and sci-fi art.');

-- Buyers
INSERT INTO buyers (name, email) VALUES
('Alice Monroe', 'alice@buyer.com'),
('Tom Jacobs', 'tom@buyer.com');

-- Artworks
INSERT INTO artworks (artist_id, title, description, file_path, price) VALUES
(1, 'Dream Forest', 'A surreal digital landscape.', '/artworks/dream_forest.png', 250.00),
(2, 'Cyber Horizon', 'Sci-fi scene of a distant world.', '/artworks/cyber_horizon.jpg', 300.00);

-- Transactions
INSERT INTO transactions (buyer_id, artwork_id, transaction_amount) VALUES
(1, 1, 250.00),
(2, 2, 300.00);

-- Licenses
INSERT INTO licenses (artwork_id, buyer_id, license_type) VALUES
(1, 1, 'personal'),
(2, 2, 'commercial');

-- List all available (unsold) artworks
SELECT title, price 
FROM artworks 
WHERE is_sold = FALSE;

-- View all sales made by an artist
SELECT a.title, t.transaction_amount, t.transaction_time
FROM artworks a
JOIN transactions t ON a.artwork_id = t.artwork_id
WHERE a.artist_id = 1;

-- Find all artworks a buyer has purchased
SELECT a.title, l.license_type
FROM licenses l
JOIN artworks a ON l.artwork_id = a.artwork_id
WHERE l.buyer_id = 1;

-- Top-Selling Artists by Revenue
SELECT ar.name AS artist_name, SUM(t.transaction_amount) AS total_revenue
FROM transactions t
JOIN artworks a ON t.artwork_id = a.artwork_id
JOIN artists ar ON a.artist_id = ar.artist_id
GROUP BY ar.artist_id
ORDER BY total_revenue DESC;

-- Most Recent Sales Transactions
SELECT t.transaction_id, b.name AS buyer, a.title AS artwork_title, t.transaction_amount, t.transaction_time
FROM transactions t
JOIN buyers b ON t.buyer_id = b.buyer_id
JOIN artworks a ON t.artwork_id = a.artwork_id
ORDER BY t.transaction_time DESC
LIMIT 1;

-- Count of Artworks Per Artist
SELECT ar.name AS artist_name, COUNT(a.artwork_id) AS total_artworks
FROM artists ar
LEFT JOIN artworks a ON ar.artist_id = a.artist_id
GROUP BY ar.artist_id;

-- Monthly Sales Report (Revenue by Month)
SELECT 
    DATE_FORMAT(transaction_time, '%Y-%m') AS sale_month,
    SUM(transaction_amount) AS total_revenue,
    COUNT(*) AS total_sales
FROM transactions
GROUP BY sale_month
ORDER BY sale_month DESC;

-- List All Artworks by a Specific Artist
SELECT title, price, is_sold, uploaded_at
FROM artworks
WHERE artist_id = 1; 

-- Total Number of Artworks Licensed by License Type
SELECT license_type, COUNT(*) AS total_licenses
FROM licenses
GROUP BY license_type;

-- Detailed License History for a Specific Buyer
SELECT 
    a.title AS artwork_title,
    l.license_type,
    l.licensed_at
FROM licenses l
JOIN artworks a ON l.artwork_id = a.artwork_id
WHERE l.buyer_id = 2; 