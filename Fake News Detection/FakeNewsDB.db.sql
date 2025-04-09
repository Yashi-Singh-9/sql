sqlite3 FakeNews.db

-- Users Table 
CREATE TABLE users (
  user_id INTEGER Primary Key,
  name VARCHAR(20),
  email VARCHAR(20) Unique,
  role VARCHAR(15) CHECK (role IN ('admin', 'verifier', 'regular user')),
  created_at DATETIME
);

-- News Articles Table 
CREATE TABLE news_articles (
  article_id INTEGER Primary Key,
  title VARCHAR(20),
  content TEXT,
  published_date DATE,
  source VARCHAR(20),
  user_id INTEGER,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Classifications Table 
CREATE TABLE classifications (
  classification_id INTEGER PRIMARY KEY,
  label VARCHAR(20) CHECK (label IN ('Fake', 'Real', 'Unverified')),
  classified_at TIMESTAMP,
  article_id INTEGER,
  classified_by INTEGER,
  FOREIGN KEY (article_id) REFERENCES news_articles(article_id),
  FOREIGN KEY (classified_by) REFERENCES users(user_id)
);

-- Reports Table  
CREATE TABLE reports (
  report_id INTEGER PRIMARY KEY,
  reason TEXT,
  report_date DATETIME,
  article_id INTEGER,
  reported_by INTEGER,
  FOREIGN KEY (article_id) REFERENCES news_articles(article_id),
  FOREIGN KEY (reported_by) REFERENCES users(user_id)
);

-- Verification Table 
CREATE TABLE verifications (
  verification_id INTEGER PRIMARY KEY,
  verdict VARCHAR(20) CHECK (verdict IN ('True', 'False', 'Needs More Evidence')),
  verification_date DATE,
  article_id INTEGER,
  verified_by INTEGER,
  FOREIGN KEY (article_id) REFERENCES news_articles(article_id),  
  FOREIGN KEY (verified_by) REFERENCES users(user_id)
);

-- Insert Users
INSERT INTO users (user_id, name, email, role, created_at) VALUES
(1, 'Alice', 'alice@example.com', 'admin', '2024-02-01 10:00:00'),
(2, 'Bob', 'bob@example.com', 'verifier', '2024-02-02 11:00:00'),
(3, 'Charlie', 'charlie@example.com', 'regular user', '2024-02-03 12:00:00'),
(4, 'David', 'david@example.com', 'regular user', '2024-02-04 13:00:00'),
(5, 'Eve', 'eve@example.com', 'verifier', '2024-02-05 14:00:00'),
(6, 'Frank', 'frank@example.com', 'admin', '2024-02-06 15:00:00'),
(7, 'Grace', 'grace@example.com', 'regular user', '2024-02-07 16:00:00'),
(8, 'Hank', 'hank@example.com', 'verifier', '2024-02-08 17:00:00');

-- Insert News Articles
INSERT INTO news_articles (article_id, title, content, published_date, source, user_id) VALUES
(1, 'Fake News 1', 'Content of fake news 1', '2024-02-01', 'News Source A', 1),
(2, 'Real News 1', 'Content of real news 1', '2024-02-02', 'News Source B', 2),
(3, 'Fake News 2', 'Content of fake news 2', '2024-02-03', 'News Source C', 3),
(4, 'Unverified News 1', 'Unverified content 1', '2024-02-04', 'News Source D', 4),
(5, 'Real News 2', 'Content of real news 2', '2024-02-05', 'News Source E', 5),
(6, 'Fake News 3', 'Content of fake news 3', '2024-02-06', 'News Source F', NULL),
(7, 'Unverified News 2', 'Unverified content 2', '2024-02-07', 'News Source G', 7),
(8, 'Real News 3', 'Content of real news 3', '2024-02-08', 'News Source H', 8);

-- Insert Classifications
INSERT INTO classifications (classification_id, label, classified_at, article_id, classified_by) VALUES
(1, 'Fake', '2024-02-02 10:00:00', 1, 2),
(2, 'Real', '2024-02-03 11:00:00', 2, 5),
(3, 'Fake', '2024-02-04 12:00:00', 3, 8),
(4, 'Unverified', '2024-02-05 13:00:00', 4, 1),
(5, 'Real', '2024-02-06 14:00:00', 5, 2),
(6, 'Fake', '2024-02-07 15:00:00', 6, NULL),
(7, 'Unverified', '2024-02-08 16:00:00', 7, 6),
(8, 'Real', '2024-02-09 17:00:00', 8, 3);

-- Insert Reports
INSERT INTO reports (report_id, reason, report_date, article_id, reported_by) VALUES
(1, 'Misleading information', '2024-02-03 09:00:00', 1, 3),
(2, 'False claims', '2024-02-04 10:00:00', 2, 4),
(3, 'Spam content', '2024-02-05 11:00:00', 3, 5),
(4, 'Hate speech', '2024-02-06 12:00:00', 4, 6),
(5, 'Misinformation', '2024-02-07 13:00:00', 5, 7),
(6, 'Fake news', '2024-02-08 14:00:00', 6, NULL),
(7, 'Unverified source', '2024-02-09 15:00:00', 7, 2),
(8, 'Clickbait', '2024-02-10 16:00:00', 8, 8);

-- Insert Verifications
INSERT INTO verifications (verification_id, verdict, verification_date, article_id, verified_by) VALUES
(1, 'False', '2024-02-04', 1, 2),
(2, 'True', '2024-02-05', 2, 5),
(3, 'False', '2024-02-06', 3, 8),
(4, 'Needs More Evidence', '2024-02-07', 4, 1),
(5, 'True', '2024-02-08', 5, 2),
(6, 'False', '2024-02-09', 6, NULL),
(7, 'Needs More Evidence', '2024-02-10', 7, 6),
(8, 'True', '2024-02-11', 8, 3);

-- Retrieve all news articles that have been marked as "Fake" by the classification table.
SELECT na.* FROM news_articles na
JOIN classifications c ON na.article_id = c.article_id
WHERE c.label = 'Fake';

-- Find all news articles published by a specific source that have been reported by users.
SELECT na.* FROM news_articles na
JOIN reports r ON na.article_id = r.article_id
WHERE na.source = 'News Source F';

-- Count the number of fake news articles per source.
SELECT na.source, COUNT(*) AS fake_news_count FROM news_articles na
JOIN classifications c ON na.article_id = c.article_id
WHERE c.label = 'Fake'
GROUP BY na.source;

-- Find users who have reported more than 5 articles as suspicious.
SELECT r.reported_by, COUNT(*) AS report_count FROM reports r
GROUP BY r.reported_by
HAVING COUNT(*) > 5;

-- List all news articles that have conflicting classifications (e.g., some say "Fake" while others say "Real").
SELECT na.* FROM news_articles na
JOIN classifications c1 ON na.article_id = c1.article_id
JOIN classifications c2 ON na.article_id = c2.article_id
WHERE c1.label = 'Fake' AND c2.label = 'Real';

-- Identify users who have classified the most articles.
SELECT c.classified_by, COUNT(*) AS classification_count FROM classifications c
GROUP BY c.classified_by
ORDER BY classification_count DESC
LIMIT 1;

-- Get the percentage of articles that have been verified as "True" vs "False".
SELECT 
  (COUNT(CASE WHEN v.verdict = 'True' THEN 1 END) * 100.0 / COUNT(*)) AS true_percentage,
  (COUNT(CASE WHEN v.verdict = 'False' THEN 1 END) * 100.0 / COUNT(*)) AS false_percentage
FROM verifications v;

-- Find the most commonly used reason for reporting an article as fake.
SELECT reason, COUNT(*) AS reason_count FROM reports
GROUP BY reason
ORDER BY reason_count DESC
LIMIT 1;

-- Get a list of articles that have not yet been classified or verified.
SELECT na.* FROM news_articles na
LEFT JOIN classifications c ON na.article_id = c.article_id
LEFT JOIN verifications v ON na.article_id = v.article_id
WHERE c.article_id IS NULL AND v.article_id IS NULL;

-- Find the latest verified articles along with the verifier's details.
SELECT na.*, u.name AS verifier_name, v.verification_date FROM news_articles na
JOIN verifications v ON na.article_id = v.article_id
JOIN users u ON v.verified_by = u.user_id
ORDER BY v.verification_date DESC
LIMIT 4;