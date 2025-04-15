sqlite3 FoodDeliveryDB.db

-- Political Parties Table
CREATE TABLE political_party (
  party_id INTEGER PRIMARY KEY,
  party_name VARCHAR(20),
  leader_name VARCHAR(20)
);

-- Elections Table
CREATE TABLE elections (
  election_id INTEGER PRIMARY KEY,
  election_year YEAR,
  election_type VARCHAR(20)
);  

-- Candidates Table
CREATE TABLE candidates (
  candidate_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  age INT,
  gender VARCHAR(10) CHECK (gender IN ('Female', 'Male', 'Others')),
  party_id INTEGER,
  election_id INTEGER,
  FOREIGN KEY (party_id) REFERENCES political_party(party_id),
  FOREIGN KEY (election_id) REFERENCES elections(election_id)
);

-- Voting Records Table
CREATE TABLE voting_records (
  vote_id INTEGER PRIMARY KEY,
  voter_id INTEGER,
  candidate_id INTEGER,
  election_id INTEGER,
  FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id),
  FOREIGN KEY (election_id) REFERENCES elections(candidate_id)
);  

-- Locations Table
CREATE TABLE locations (
  location_id INTEGER PRIMARY KEY,
  state VARCHAR(50),
  city VARCHAR(50)
);

-- Voters Table
CREATE TABLE voters_table (
  voter_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  age INTEGER,
  gender VARCHAR(10) CHECK (gender IN ('Female', 'Male', 'Others')),
  location_id INTEGER,
  FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

-- Insert into political_party
INSERT INTO political_party (party_id, party_name, leader_name) VALUES
(1, 'Democratic Front', 'Alice Brown'),
(2, 'United Party', 'John Smith'),
(3, 'People Alliance', 'Maria Garcia'),
(4, 'Progressive Union', 'James White');

-- Insert into elections
INSERT INTO elections (election_id, election_year, election_type) VALUES
(1, 2020, 'Presidential'),
(2, 2022, 'Congressional'),
(3, 2024, 'State');

-- Insert into candidates
INSERT INTO candidates (candidate_id, name, age, gender, party_id, election_id) VALUES
(1, 'Michael Green', 45, 'Male', 1, 1),
(2, 'Susan Clark', 52, 'Female', 2, 2),
(3, 'Robert Hall', 60, 'Male', NULL, 3),
(4, 'Emily Adams', 39, 'Female', 3, NULL),
(5, 'William Scott', 50, 'Male', 4, 2),
(6, 'Jessica Moore', 48, 'Female', 1, 3),
(7, 'David Lee', 55, 'Male', 2, 1),
(8, 'Sarah Wilson', 42, 'Female', NULL, NULL);

-- Insert into locations
INSERT INTO locations (location_id, state, city) VALUES
(1, 'California', 'Los Angeles'),
(2, 'New York', 'New York City'),
(3, 'Texas', 'Houston'),
(4, 'Illinois', 'Chicago'),
(5, 'Florida', 'Miami'),
(6, 'Ohio', 'Columbus'),
(7, 'Georgia', 'Atlanta'),
(8, 'Nevada', 'Las Vegas');

-- Insert into voters_table
INSERT INTO voters_table (voter_id, name, age, gender, location_id) VALUES
(1, 'Daniel Harris', 30, 'Male', 1),
(2, 'Sophia Martin', 28, 'Female', 2),
(3, 'Christopher Taylor', 35, 'Male', NULL),
(4, 'Olivia Anderson', 40, 'Female', 3),
(5, 'Matthew Thomas', 33, 'Male', 4),
(6, 'Emma Walker', 29, 'Female', NULL),
(7, 'Andrew Robinson', 45, 'Male', 5),
(8, 'Isabella Wright', 50, 'Female', 6);

-- Insert into voting_records
INSERT INTO voting_records (vote_id, voter_id, candidate_id, election_id) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, NULL, 3),
(4, NULL, 4, 1),
(5, 5, 5, 2),
(6, 6, 6, NULL),
(7, 7, 7, 1),
(8, 8, NULL, NULL);

-- Find the number of votes each candidate received in an election
SELECT candidate_id, election_id, COUNT(*) AS total_votes
FROM voting_records
WHERE candidate_id IS NOT NULL
GROUP BY candidate_id, election_id
ORDER BY election_id, total_votes DESC;

-- Determine which candidate received the most votes in a particular election.
SELECT candidate_id, COUNT(*) AS total_votes
FROM voting_records
WHERE election_id = 2
AND candidate_id IS NOT NULL
GROUP BY candidate_id
ORDER BY total_votes DESC
LIMIT 1;

-- Count how many people voted from each location.
SELECT l.state, l.city, COUNT(vr.voter_id) AS total_voters
FROM voting_records vr
JOIN voters_table v ON vr.voter_id = v.voter_id
JOIN locations l ON v.location_id = l.location_id
GROUP BY l.state, l.city
ORDER BY total_voters DESC;

-- Calculate the percentage of votes each political party received in an election.
SELECT p.party_name, 
       COUNT(vr.vote_id) AS votes_received, 
       (COUNT(vr.vote_id) * 100.0 / (SELECT COUNT(*) FROM voting_records WHERE election_id = ?)) AS vote_percentage
FROM voting_records vr
JOIN candidates c ON vr.candidate_id = c.candidate_id
JOIN political_party p ON c.party_id = p.party_id
WHERE vr.election_id = 2
GROUP BY p.party_name
ORDER BY vote_percentage DESC;

-- Find out how many voters belong to different age groups (e.g., 18-25, 26-40, etc.).
SELECT 
    CASE 
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'
        WHEN age BETWEEN 41 AND 60 THEN '41-60'
        ELSE '60+'
    END AS age_group, 
    COUNT(*) AS total_voters
FROM voters_table
GROUP BY age_group
ORDER BY age_group;

-- List the top parties with the most candidates in a given election.
SELECT p.party_name, COUNT(c.candidate_id) AS total_candidates
FROM candidates c
JOIN political_party p ON c.party_id = p.party_id
WHERE c.election_id = 3
GROUP BY p.party_name
ORDER BY total_candidates DESC
LIMIT 5;

-- Find the number of male vs. female voters who participated in an election.
SELECT v.gender, COUNT(vr.voter_id) AS total_voters
FROM voting_records vr
JOIN voters_table v ON vr.voter_id = v.voter_id
WHERE vr.election_id = 2
GROUP BY v.gender;

-- List all elections in which a candidate has participated.
SELECT e.election_id, e.election_year, e.election_type
FROM elections e
JOIN candidates c ON e.election_id = c.election_id
WHERE c.candidate_id = 1;

-- Find out how many votes were cast in each state.
SELECT l.state, COUNT(vr.vote_id) AS total_votes
FROM voting_records vr
JOIN voters_table v ON vr.voter_id = v.voter_id
JOIN locations l ON v.location_id = l.location_id
GROUP BY l.state
ORDER BY total_votes DESC;

-- Identify any cases where a voter has cast more than one vote (if applicable).
SELECT voter_id, COUNT(*) AS vote_count
FROM voting_records
GROUP BY voter_id
HAVING COUNT(*) > 1;