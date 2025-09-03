-- SQL Lite Project
sqlite3 ResearchDB.db

-- Researchers Table
CREATE TABLE researches (
  researcher_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  affiliation VARCHAR(50)
);

-- Projects Table  
CREATE TABLE projects (
  project_id INTEGER PRIMARY KEY,
  title VARCHAR(20),
  description TEXT,
  start_date DATE,
  end_date DATE,
  lead_researcher_id INTEGER,
  FOREIGN KEY (lead_researcher_id) REFERENCES researches(researcher_id)
);

-- Experiments Table 
CREATE TABLE experiments (
  experiment_id INTEGER PRIMARY KEY,
  project_id INTEGER,
  experiment_name VARCHAR(30),
  date_conducted DATE,
  result_summary TEXT,
  FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Datasets Table 
CREATE TABLE datasets (
  dataset_id INTEGER PRIMARY KEY,
  experiment_id INTEGER,
  file_path TEXT NOT NULL,
  size_mb REAL NOT NULL,
  format TEXT NOT NULL,
  FOREIGN KEY (experiment_id) REFERENCES experiments(experiment_id)
);

-- Publications Table  
CREATE TABLE publications (
  publication_id INTEGER PRIMARY Key,
  title VARCHAR(20),
  journal_name VARCHAR(50),
  publication_date DATE,
  project_id INTEGER,
  FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Funding Table  
CREATE TABLE funding (
  funding_id INTEGER PRIMARY KEY,
  project_id INTEGER,
  funder_name VARCHAR(20),
  amount DECIMAL(10,2),
  grant_number BIGINT,
  FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Collaborations Table  
CREATE TABLE collaborations (
  collaboration_id INTEGER PRIMARY KEY,
  researcher_id INTEGER,
  project_id INTEGER,
  FOREIGN KEY (researcher_id) REFERENCES researches(researcher_id),
  FOREIGN KEY (project_id) REFERENCES projects(project_id)
);  
  
-- Insert Researchers
INSERT INTO researches (researcher_id, name, email, affiliation) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'Harvard University'),
(2, 'Bob Smith', 'bob@example.com', 'MIT'),
(3, 'Charlie Brown', 'charlie@example.com', 'Stanford University'),
(4, 'Diana White', 'diana@example.com', 'Oxford University'),
(5, 'Ethan Clark', 'ethan@example.com', 'Cambridge University'),
(6, 'Fiona Green', 'fiona@example.com', 'Yale University'),
(7, 'George Harris', 'george@example.com', 'Columbia University'),
(8, 'Hannah Lee', 'hannah@example.com', 'Princeton University');

-- Insert Projects
INSERT INTO projects (project_id, title, description, start_date, end_date, lead_researcher_id) VALUES
(1, 'AI Ethics', 'Exploring AI ethical concerns', '2023-01-10', '2025-06-15', 1),
(2, 'Quantum Computing', 'Advancing quantum processors', '2022-05-22', '2026-07-30', 2),
(3, 'CRISPR Gene Editing', 'Research on gene modification', '2023-03-18', '2025-09-12', 3),
(4, 'Autonomous Vehicles', 'Improving self-driving cars', '2021-09-05', '2024-12-31', 4),
(5, 'Neural Networks', 'Enhancing deep learning models', '2023-07-01', '2026-10-22', 5),
(6, 'Renewable Energy', 'Efficient solar and wind power', '2022-11-11', '2027-01-05', 6),
(7, 'Climate Change Models', 'AI-driven climate forecasting', '2024-02-15', '2028-08-20', 7),
(8, 'Brain-Computer Interfaces', 'Merging AI with neurology', '2023-06-30', '2026-12-31', 8);

-- Insert Experiments
INSERT INTO experiments (experiment_id, project_id, experiment_name, date_conducted, result_summary) VALUES
(1, 1, 'Bias in AI', '2023-03-20', 'Significant bias detected'),
(2, 2, 'Qubit Stability', '2023-06-25', 'Improved coherence time'),
(3, 3, 'Gene Editing Efficiency', '2023-09-12', 'CRISPR was 85% effective'),
(4, 4, 'Sensor Accuracy', '2022-11-10', 'High precision in urban areas'),
(5, 5, 'Neural Network Performance', '2024-01-08', 'Increased accuracy by 10%'),
(6, 6, 'Solar Panel Optimization', '2023-12-14', 'Efficiency reached 22%'),
(7, 7, 'AI Climate Model', '2024-03-29', 'More accurate predictions'),
(8, 8, 'Neural Signal Detection', '2024-05-15', 'Detected signals with 95% accuracy');

-- Insert Datasets
INSERT INTO datasets (dataset_id, experiment_id, file_path, size_mb, format) VALUES
(1, 1, '/data/ai_bias.csv', 50.2, 'CSV'),
(2, 2, '/data/qubits.json', 75.4, 'JSON'),
(3, 3, '/data/crispr_results.xlsx', 100.1, 'XLSX'),
(4, 4, '/data/autonomous_logs.csv', 120.3, 'CSV'),
(5, 5, '/data/neural_performance.h5', 95.7, 'HDF5'),
(6, 6, '/data/solar_efficiency.csv', 65.8, 'CSV'),
(7, 7, '/data/climate_model.nc', 110.9, 'NetCDF'),
(8, 8, '/data/brain_signals.mat', 85.6, 'MAT');

-- Insert Publications
INSERT INTO publications (publication_id, title, journal_name, publication_date, project_id) VALUES
(1, 'AI Bias Study', 'Nature AI', '2023-10-15', 1),
(2, 'Quantum Stability', 'Quantum Physics Journal', '2024-02-10', 2),
(3, 'Gene Editing Advances', 'Genetics Today', '2024-05-20', 3),
(4, 'Self-Driving Breakthrough', 'Autonomous Tech', '2023-07-30', 4),
(5, 'Deep Learning Innovations', 'Neural Computation', '2024-09-12', 5),
(6, 'Green Energy Solutions', 'Renewable Science', '2023-12-18', 6),
(7, 'AI and Climate Change', 'Earth Journal', '2025-01-25', 7),
(8, 'Brain-Computer Research', 'Neuroscience Today', '2024-11-05', 8);

-- Insert Funding
INSERT INTO funding (funding_id, project_id, funder_name, amount, grant_number) VALUES
(1, 1, 'NSF', 500000.00, 1234567890),
(2, 2, 'Google Research', 750000.00, 2233445566),
(3, 3, 'NIH', 600000.00, 3344556677),
(4, 4, 'Tesla', 900000.00, 4455667788),
(5, 5, 'Microsoft AI', 800000.00, 5566778899),
(6, 6, 'DOE', 700000.00, 6677889900),
(7, 7, 'NASA', 650000.00, 7788990011),
(8, 8, 'DARPA', 850000.00, 8899001122);

-- Insert Collaborations
INSERT INTO collaborations (collaboration_id, researcher_id, project_id) VALUES
(1, 1, 2),
(2, 2, 3),
(3, 3, 4),
(4, 4, 5),
(5, 5, 6),
(6, 6, 7),
(7, 7, 8),
(8, 8, 1);
  
-- Retrieve the names of researchers working on a specific project.
SELECT r.name 
FROM researches r
JOIN collaborations c ON r.researcher_id = c.researcher_id
WHERE c.project_id = 2;

-- Find the total number of experiments conducted under a project.
SELECT COUNT(*) AS total_experiments 
FROM experiments 
WHERE project_id = 5;

-- List all datasets associated with a particular experiment.
SELECT * 
FROM datasets 
WHERE experiment_id = 7;

-- Identify projects that received funding above a certain amount.
SELECT project_id, title 
FROM projects 
WHERE project_id IN (
    SELECT project_id FROM funding WHERE amount > 500000
);

-- Get the most recent publication for each project.
SELECT p1.*
FROM publications p1
WHERE p1.publication_date = (
    SELECT MAX(p2.publication_date)
    FROM publications p2
    WHERE p2.project_id = p1.project_id
);

-- Retrieve experiments where the dataset size exceeds a certain threshold.
SELECT e.* 
FROM experiments e
JOIN datasets d ON e.experiment_id = d.experiment_id
WHERE d.size_mb > 100;

-- Get the number of collaborations each researcher has.
SELECT r.name, COUNT(c.collaboration_id) AS collaboration_count
FROM researches r
LEFT JOIN collaborations c ON r.researcher_id = c.researcher_id
GROUP BY r.researcher_id;

-- Retrieve all projects along with the number of experiments conducted in each.
SELECT p.title, COUNT(e.experiment_id) AS experiment_count
FROM projects p
LEFT JOIN experiments e ON p.project_id = e.project_id
GROUP BY p.project_id;

-- Identify the researcher with the highest number of published papers.
SELECT r.name, COUNT(pub.publication_id) AS publication_count
FROM researches r
JOIN projects p ON r.researcher_id = p.lead_researcher_id
JOIN publications pub ON p.project_id = pub.project_id
GROUP BY r.researcher_id
ORDER BY publication_count DESC
LIMIT 1;

-- Show all experiments conducted within a specific date range.
SELECT * 
FROM experiments 
WHERE date_conducted BETWEEN '2023-01-01' AND '2023-12-31';

-- Retrieve the names of researchers who have contributed to at least one dataset.
SELECT DISTINCT r.name
FROM researches r
JOIN collaborations c ON r.researcher_id = c.researcher_id
JOIN projects p ON c.project_id = p.project_id
JOIN experiments e ON p.project_id = e.project_id
JOIN datasets d ON e.experiment_id = d.experiment_id;

-- Find the average dataset size for each project.
SELECT p.title, AVG(d.size_mb) AS avg_size
FROM projects p
JOIN experiments e ON p.project_id = e.project_id
JOIN datasets d ON e.experiment_id = d.experiment_id
GROUP BY p.project_id;

-- Retrieve the details of projects that ended more than one month ago.
SELECT * 
FROM projects 
WHERE end_date < DATE('now', '-1 month');

-- Find the project that has received the highest total funding.
SELECT p.*, SUM(f.amount) AS total_funding
FROM projects p
JOIN funding f ON p.project_id = f.project_id
GROUP BY p.project_id
ORDER BY total_funding DESC
LIMIT 1;

-- Get the count of datasets stored in each format (e.g., CSV, JSON, XML).
SELECT format, COUNT(*) AS dataset_count
FROM datasets
GROUP BY format;

-- Find the journal that has published the most research papers from the database.
SELECT journal_name, COUNT(*) AS paper_count
FROM publications
GROUP BY journal_name
ORDER BY paper_count DESC
LIMIT 1;

-- Find the percentage of funded projects versus non-funded projects.
SELECT 
    (SELECT COUNT(DISTINCT project_id) FROM funding) * 100.0 / COUNT(*) AS funded_percentage,
    (COUNT(*) - (SELECT COUNT(DISTINCT project_id) FROM funding)) * 100.0 / COUNT(*) AS non_funded_percentage
FROM projects;

-- Identify experiments where the result summary contains a specific keyword.
SELECT * 
FROM experiments 
WHERE result_summary LIKE '%accurate%';

-- Retrieve the total number of experiments conducted by each lead researcher.
SELECT r.name, COUNT(e.experiment_id) AS total_experiments
FROM researches r
JOIN projects p ON r.researcher_id = p.lead_researcher_id
JOIN experiments e ON p.project_id = e.project_id
GROUP BY r.researcher_id;

-- Find the latest experiment conducted in each project.
SELECT e.*
FROM experiments e
WHERE e.date_conducted = (
    SELECT MAX(e2.date_conducted) 
    FROM experiments e2 
    WHERE e2.project_id = e.project_id
);
