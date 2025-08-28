sqlite3 CybercrimeReportingDB.db

-- Users Table  
CREATE Table users (
  user_id INT PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  phone BIGINT,
  role VARCHAR(10) CHECK (role IN ('Victim', 'Officer', 'Admin'))
);

-- Incidents Table  
CREATE TABLE incidents (
  incident_id INT PRIMARY KEY,
  user_id INT,
  incident_type VARCHAR(20),
  description TEXT,
  reported_date DATE,
  status VARCHAR(22) CHECK (status IN ('Pending', 'Under Investigation', 'Resolved')),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Evidence 
CREATE TABLE evidence (
  evidence_id INT PRIMARY KEY,
  incident_id INT,
  file_path VARCHAR(500),
  description TEXT,
  uploaded_date DATE,
  FOREIGN KEY (incident_id) REFERENCES incidents(incident_id)
);

-- Officers Table 
CREATE TABLE officers (
  officer_id INT PRIMARY KEY,
  name VARCHAR(20),
  badge_number INT UNIQUE,
  department VARCHAR(20)
);

-- Incident Assignment Table 
CREATE TABLE incident_assignment (
  assignment_id INT PRIMARY KEY,
  incident_id INT,
  officer_id INT,
  assigned_date DATE,
  status VARCHAR(20),
  FOREIGN KEY (incident_id) REFERENCES incidents(incident_id),
  FOREIGN KEY (officer_id) REFERENCES officers(officer_id)
);

-- Activity Log Table 
CREATE TABLE activity_log (
  log_id INT PRIMARY KEY,
  incident_id INT,
  user_id INT,
  actions VARCHAR(20) CHECK (actions IN ('Updated Status', 'Added Evidence')),
  timestamp TIMESTAMP,
  FOREIGN KEY (incident_id) REFERENCES incidents(incident_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);  

-- Insert Users
INSERT INTO users (user_id, name, email, phone, role) VALUES
(1, 'Alice Johnson', 'alice@example.com', 9876543210, 'Victim'),
(2, 'Bob Smith', 'bob@example.com', 8765432109, 'Victim'),
(3, 'Charlie Brown', 'charlie@example.com', NULL, 'Officer'),
(4, 'David Lee', 'david@example.com', 7654321098, 'Admin'),
(5, 'Emily White', 'emily@example.com', 6543210987, 'Victim'),
(6, 'Frank Harris', 'frank@example.com', 5432109876, 'Officer'),
(7, 'Grace Adams', 'grace@example.com', NULL, 'Victim'),
(8, 'Hank Miller', 'hank@example.com', 4321098765, 'Admin');

-- Insert Incidents
INSERT INTO incidents (incident_id, user_id, incident_type, description, reported_date, status) VALUES
(101, 1, 'Phishing', 'Received a suspicious email.', '2024-02-01', 'Pending'),
(102, 2, 'Hacking', 'Unauthorized access to my account.', '2024-02-05', 'Under Investigation'),
(103, 5, 'Fraud', 'Fake website scammed me.', '2024-02-10', 'Resolved'),
(104, 7, 'Phishing', 'Suspicious email asking for credentials.', '2024-02-12', 'Pending'),
(105, 1, 'Identity Theft', 'Someone is using my identity.', '2024-02-15', 'Under Investigation'),
(106, 3, 'Hacking', 'My company website was attacked.', '2024-02-20', 'Pending'),
(107, 2, 'Fraud', 'Scammed on an e-commerce site.', '2024-02-22', 'Resolved'),
(108, 6, 'Malware', 'Device infected with malware.', '2024-02-25', 'Under Investigation');

-- Insert Evidence
INSERT INTO evidence (evidence_id, incident_id, file_path, description, uploaded_date) VALUES
(201, 101, '/uploads/email_screenshot.png', 'Screenshot of the phishing email.', '2024-02-02'),
(202, 102, '/uploads/hacked_account_log.txt', 'Log of unauthorized access.', '2024-02-06'),
(203, 103, '/uploads/scam_website.png', 'Screenshot of the fake website.', '2024-02-11'),
(204, 104, '/uploads/phishing_attempt.png', NULL, '2024-02-13'),
(205, 105, '/uploads/id_theft_report.pdf', 'Police report for identity theft.', '2024-02-16'),
(206, 106, '/uploads/attack_logs.txt', NULL, '2024-02-21'),
(207, 107, NULL, 'Transaction record of fraud.', '2024-02-23'),
(208, 108, '/uploads/malware_scan.png', 'Antivirus scan result.', '2024-02-26');

-- Insert Officers
INSERT INTO officers (officer_id, name, badge_number, department) VALUES
(301, 'Tom Wilson', 45678, 'Cybercrime'),
(302, 'Sarah Lee', 12345, 'Fraud Investigation'),
(303, 'Mike Brown', 98765, 'Hacking Unit'),
(304, 'Jessica Green', 23456, 'Phishing Control'),
(305, 'Robert Black', 67890, 'Cybercrime'),
(306, 'Sophia Davis', 34567, 'Fraud Investigation'),
(307, 'Daniel White', 78901, 'Hacking Unit'),
(308, 'Laura Martinez', 56789, 'Malware Analysis');

-- Insert Incident Assignments
INSERT INTO incident_assignment (assignment_id, incident_id, officer_id, assigned_date, status) VALUES
(401, 101, 301, '2024-02-03', 'In Progress'),
(402, 102, 302, '2024-02-06', 'Completed'),
(403, 103, 303, '2024-02-12', 'Completed'),
(404, 104, 304, '2024-02-14', 'In Progress'),
(405, 105, 305, '2024-02-17', 'In Progress'),
(406, 106, 306, '2024-02-22', 'Pending'),
(407, 107, 307, '2024-02-23', 'Completed'),
(408, 108, 308, '2024-02-27', 'In Progress');

-- Insert Activity Logs
INSERT INTO activity_log (log_id, incident_id, user_id, actions, timestamp) VALUES
(501, 101, 1, 'Updated Status', '2024-02-03 10:00:00'),
(502, 102, 2, 'Added Evidence', '2024-02-06 11:15:00'),
(503, 103, 5, 'Updated Status', '2024-02-12 12:30:00'),
(504, 104, 7, 'Added Evidence', '2024-02-14 13:45:00'),
(505, 105, 1, 'Updated Status', '2024-02-17 15:00:00'),
(506, 106, 3, 'Added Evidence', '2024-02-22 16:15:00'),
(507, 107, 2, 'Updated Status', '2024-02-23 17:30:00'),
(508, 108, 6, 'Added Evidence', '2024-02-27 18:45:00');

-- Retrieve all incidents reported by a specific user.
SELECT * FROM incidents  
WHERE user_id = 5; 

-- Find all pending incidents that have no officer assigned yet.
SELECT * FROM incidents  
WHERE status = 'Pending'  
AND incident_id NOT IN (SELECT incident_id FROM incident_assignment);

-- Get the number of incidents handled by each officer.
SELECT officers.officer_id, officers.name, COUNT(incident_assignment.incident_id) AS total_cases  
FROM officers  
LEFT JOIN incident_assignment ON officers.officer_id = incident_assignment.officer_id  
GROUP BY officers.officer_id, officers.name;

-- Fetch the latest activity log for a specific incident.
SELECT * FROM activity_log  
WHERE incident_id = 103
ORDER BY timestamp DESC  
LIMIT 1;

-- List all evidence related to a specific incident.
SELECT * 
FROM evidence  
WHERE incident_id = 102;  

-- Identify users who have reported the most cybercrime incidents.
SELECT users.user_id, users.name, COUNT(incidents.incident_id) AS total_incidents  
FROM users  
JOIN incidents ON users.user_id = incidents.user_id  
GROUP BY users.user_id, users.name  
ORDER BY total_incidents DESC  
LIMIT 5;

-- Retrieve incidents reported in the last 30 days.
SELECT * 
FROM incidents  
WHERE reported_date >= date('now', '-30 days');

-- Find unresolved incidents older than 6 months.
SELECT * FROM incidents  
WHERE status != 'Resolved'  
AND reported_date < date('now', '-6 months');
