-- Project in PostgreSQL 
-- Create database
CREATE DATABASE parking_lot_management;
\c parking_lot_management;

CREATE TABLE parking_lots (
    lot_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(255),
    total_spots INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE parking_spots (
    spot_id SERIAL PRIMARY KEY,
    lot_id INT REFERENCES parking_lots(lot_id),
    spot_number VARCHAR(10),
    spot_type VARCHAR(50), -- e.g., Compact, Large, Handicapped
    is_occupied BOOLEAN DEFAULT FALSE
);

CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    license_plate VARCHAR(20) UNIQUE,
    owner_name VARCHAR(100),
    vehicle_type VARCHAR(50) -- e.g., Car, Motorcycle, Truck
);

CREATE TABLE parking_sessions (
    session_id SERIAL PRIMARY KEY,
    vehicle_id INT REFERENCES vehicles(vehicle_id),
    spot_id INT REFERENCES parking_spots(spot_id),
    check_in TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    check_out TIMESTAMP,
    fee DECIMAL(7,2)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    session_id INT REFERENCES parking_sessions(session_id),
    amount DECIMAL(7,2),
    payment_method VARCHAR(50), -- e.g., Cash, Card, Online
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO parking_lots (name, location, total_spots) VALUES
('Central Plaza', '123 Main St', 50),
('Downtown Garage', '456 Elm St', 100);

INSERT INTO parking_spots (lot_id, spot_number, spot_type) VALUES
(1, 'A1', 'Compact'),
(1, 'A2', 'Large'),
(1, 'A3', 'Handicapped'),
(2, 'B1', 'Compact'),
(2, 'B2', 'Large');

INSERT INTO vehicles (license_plate, owner_name, vehicle_type) VALUES
('ABC123', 'Alice Smith', 'Car'),
('XYZ789', 'Bob Lee', 'Motorcycle'),
('JKL456', 'Charlie Ray', 'Truck');

INSERT INTO parking_sessions (vehicle_id, spot_id, check_in, check_out, fee) VALUES
(1, 1, '2024-04-08 08:00:00', '2024-04-08 10:30:00', 5.00),
(2, 2, '2024-04-08 09:00:00', NULL, NULL), -- ongoing session
(3, 4, '2024-04-07 15:00:00', '2024-04-07 18:00:00', 8.00);

INSERT INTO payments (session_id, amount, payment_method) VALUES
(1, 5.00, 'Card'),
(3, 8.00, 'Cash');

-- Check availability in a specific lot
SELECT COUNT(*) AS available_spots
FROM parking_spots
WHERE lot_id = 1 AND is_occupied = FALSE;

-- Active parking sessions (ongoing)
SELECT v.license_plate, ps.spot_id, ps.check_in
FROM parking_sessions ps
JOIN vehicles v ON ps.vehicle_id = v.vehicle_id
WHERE ps.check_out IS NULL;

-- Revenue by parking lot
SELECT pl.name, SUM(ps.fee) AS total_revenue
FROM parking_sessions ps
JOIN parking_spots s ON ps.spot_id = s.spot_id
JOIN parking_lots pl ON s.lot_id = pl.lot_id
WHERE ps.fee IS NOT NULL
GROUP BY pl.name;

-- Parking duration per session
SELECT session_id, 
       check_out - check_in AS duration,
       fee
FROM parking_sessions
WHERE check_out IS NOT NULL;

-- List all currently available spots by type and lot
SELECT 
    pl.name AS lot_name,
    ps.spot_type,
    COUNT(*) AS available_spots
FROM parking_spots ps
JOIN parking_lots pl ON ps.lot_id = pl.lot_id
WHERE ps.is_occupied = FALSE
GROUP BY pl.name, ps.spot_type
ORDER BY pl.name, ps.spot_type;

-- Daily revenue report
SELECT 
    DATE(check_out) AS date,
    SUM(fee) AS total_daily_revenue
FROM parking_sessions
WHERE check_out IS NOT NULL
GROUP BY DATE(check_out)
ORDER BY date DESC;

-- Payment method summary
SELECT 
    payment_method,
    COUNT(*) AS total_payments,
    SUM(amount) AS total_amount
FROM payments
GROUP BY payment_method
ORDER BY total_amount DESC;

-- Average parking duration per vehicle type
SELECT 
    v.vehicle_type,
    ROUND(AVG(EXTRACT(EPOCH FROM (ps.check_out - ps.check_in)) / 3600), 2) AS avg_duration_hours
FROM parking_sessions ps
JOIN vehicles v ON ps.vehicle_id = v.vehicle_id
WHERE ps.check_out IS NOT NULL
GROUP BY v.vehicle_type;

-- Utilization rate of each parking lot
SELECT 
    pl.name,
    COUNT(CASE WHEN ps.is_occupied = TRUE THEN 1 END) * 100.0 / COUNT(*) AS utilization_percentage
FROM parking_spots ps
JOIN parking_lots pl ON ps.lot_id = pl.lot_id
GROUP BY pl.name;

-- Monthly revenue trend
SELECT 
    TO_CHAR(check_out, 'YYYY-MM') AS month,
    SUM(fee) AS monthly_revenue
FROM parking_sessions
WHERE check_out IS NOT NULL
GROUP BY TO_CHAR(check_out, 'YYYY-MM')
ORDER BY month DESC;
