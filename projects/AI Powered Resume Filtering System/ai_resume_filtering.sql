-- Project In MariaDB 
-- Create Database
CREATE DATABASE ai_resume_filtering;
USE ai_resume_filtering;

CREATE TABLE candidates (
    candidate_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE resumes (
    resume_id INT AUTO_INCREMENT PRIMARY KEY,
    candidate_id INT,
    file_path VARCHAR(255),
    extracted_text TEXT,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id)
);

CREATE TABLE jobs (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    requirements TEXT,
    posted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ai_analysis (
    analysis_id INT AUTO_INCREMENT PRIMARY KEY,
    resume_id INT,
    job_id INT,
    match_score DECIMAL(5,2), -- score out of 100
    ai_summary TEXT,
    analyzed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resume_id) REFERENCES resumes(resume_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
);

CREATE TABLE filters (
    filter_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT,
    filter_name VARCHAR(100),
    criteria TEXT,
    created_by VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES jobs(job_id)
);

INSERT INTO candidates (full_name, email, phone) VALUES
('Alice Smith', 'alice@example.com', '555-0101'),
('Bob Johnson', 'bob@example.com', '555-0102'),
('Charlie Lee', 'charlie@example.com', '555-0103'),
('Diana Ross', 'diana@example.com', '555-0104'),
('Ethan Hunt', 'ethan@example.com', '555-0105'),
('Fiona Gallagher', 'fiona@example.com', '555-0106');

INSERT INTO resumes (candidate_id, file_path, extracted_text) VALUES
(1, '/resumes/alice.pdf', 'Python, SQL, Machine Learning, NLP'),
(2, '/resumes/bob.pdf', 'Java, Spring Boot, SQL'),
(3, '/resumes/charlie.pdf', 'Python, Data Analysis, Excel'),
(4, '/resumes/diana.pdf', 'React, Node.js, HTML, CSS'),
(5, '/resumes/ethan.pdf', 'DevOps, Docker, Kubernetes, Python'),
(6, '/resumes/fiona.pdf', 'Project Management, Agile, Scrum');

INSERT INTO jobs (title, description, requirements) VALUES
('Data Scientist', 'Looking for a Data Scientist to work on AI models.', 'Python, SQL, ML'),
('Backend Developer', 'Backend systems for fintech app.', 'Java, Spring Boot, SQL'),
('Data Analyst', 'Work with big data and create reports.', 'Excel, Python, Visualization'),
('Frontend Developer', 'UI/UX for SaaS product.', 'React, CSS, HTML'),
('DevOps Engineer', 'CI/CD pipeline and infrastructure.', 'Docker, Kubernetes, Linux'),
('Product Manager', 'Lead agile teams and define roadmap.', 'Agile, Communication, Planning');

INSERT INTO ai_analysis (resume_id, job_id, match_score, ai_summary) VALUES
(1, 1, 88.50, 'Strong in Python and ML, meets job criteria.'),
(2, 2, 91.00, 'Excellent Java backend skills, fits perfectly.'),
(3, 3, 75.00, 'Good with Excel and Python, lacks visualization tools.'),
(4, 4, 82.30, 'Strong front-end experience, matches UI role.'),
(5, 5, 89.10, 'DevOps tools match well, solid experience.'),
(6, 6, 93.00, 'Excellent planning and agile background.');

INSERT INTO filters (job_id, filter_name, criteria, created_by) VALUES
(1, 'ML Expert Filter', 'Must include: Python, SQL, ML', 'recruiter1@example.com'),
(2, 'Java Backend Filter', 'Must include: Java, Spring Boot', 'recruiter2@example.com'),
(3, 'Data Analyst Basic', 'Must include: Excel, Python', 'recruiter3@example.com'),
(4, 'Frontend Essentials', 'Must include: React, HTML, CSS', 'recruiter4@example.com'),
(5, 'DevOps Filter', 'Must include: Docker, Kubernetes', 'recruiter5@example.com'),
(6, 'PM Profile Filter', 'Must include: Agile, Planning', 'recruiter6@example.com');

-- Show all candidates and their resumes
SELECT c.full_name, r.file_path
FROM candidates c
JOIN resumes r ON c.candidate_id = r.candidate_id;

--  Get top 3 candidates for the “Data Scientist” job
SELECT c.full_name, a.match_score, a.ai_summary
FROM ai_analysis a
JOIN resumes r ON a.resume_id = r.resume_id
JOIN candidates c ON r.candidate_id = c.candidate_id
WHERE a.job_id = 1
ORDER BY a.match_score DESC
LIMIT 3;

-- Get all jobs with number of matched resumes
SELECT j.title, COUNT(a.analysis_id) AS total_matches
FROM jobs j
LEFT JOIN ai_analysis a ON j.job_id = a.job_id
GROUP BY j.job_id;

-- Find resumes with a match score above 89
SELECT c.full_name, j.title, a.match_score
FROM ai_analysis a
JOIN resumes r ON a.resume_id = r.resume_id
JOIN candidates c ON r.candidate_id = c.candidate_id
JOIN jobs j ON a.job_id = j.job_id
WHERE a.match_score > 89
ORDER BY a.match_score DESC;

-- View resumes that have not been analyzed yet
SELECT r.resume_id, c.full_name, r.file_path
FROM resumes r
JOIN candidates c ON r.candidate_id = c.candidate_id
LEFT JOIN ai_analysis a ON r.resume_id = a.resume_id
WHERE a.resume_id IS NULL;

-- Filter candidates by a skill (e.g., Python)
SELECT c.full_name, r.extracted_text
FROM resumes r
JOIN candidates c ON r.candidate_id = c.candidate_id
WHERE r.extracted_text LIKE '%Python%';

-- Average match score per job
SELECT j.title, ROUND(AVG(a.match_score), 2) AS avg_score
FROM jobs j
JOIN ai_analysis a ON j.job_id = a.job_id
GROUP BY j.job_id;

--  List all jobs with no AI analysis yet
SELECT j.title
FROM jobs j
LEFT JOIN ai_analysis a ON j.job_id = a.job_id
WHERE a.analysis_id IS NULL;

--  Search for resumes containing both "Python" and "SQL"
SELECT c.full_name, r.extracted_text
FROM resumes r
JOIN candidates c ON r.candidate_id = c.candidate_id
WHERE r.extracted_text LIKE '%Python%' AND r.extracted_text LIKE '%SQL%';