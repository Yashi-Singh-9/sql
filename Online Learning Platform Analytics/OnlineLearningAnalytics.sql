-- MS SQL Project
CREATE DATABASE OnlineLearningAnalytics;
USE OnlineLearningAnalytics;

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    registration_date DATE NOT NULL,
    user_type VARCHAR(15) CHECK (user_type IN ('student', 'instructor', 'admin')) NOT NULL,
    last_login DATETIME
);

CREATE TABLE Courses (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    instructor_id INT,
    category VARCHAR(100),
    created_date DATE NOT NULL,
    course_price DECIMAL(10,2),
    FOREIGN KEY (instructor_id) REFERENCES Users(user_id)
);

CREATE TABLE Enrollments (
    enrollment_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    course_id INT,
    enrollment_date DATE NOT NULL,
    progress_percentage DECIMAL(5,2),
    status VARCHAR(15) CHECK (status IN ('active', 'completed', 'dropped')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Lessons (
    lesson_id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT,
    lesson_title VARCHAR(255) NOT NULL,
    lesson_duration INT, 
    created_date DATE NOT NULL,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Lesson_Views (
    view_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    lesson_id INT,
    view_date DATE,
    time_spent INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (lesson_id) REFERENCES Lessons(lesson_id)
);

CREATE TABLE Assignments (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT,
    title VARCHAR(255) NOT NULL,
    due_date DATE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Submissions (
    submission_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    assignment_id INT,
    submission_date DATE,
    grade DECIMAL(5,2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id)
);

CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    course_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    status VARCHAR(15) CHECK (status IN ('completed', 'pending', 'failed')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

CREATE TABLE Reviews (
    review_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    course_id INT,
    rating DECIMAL(3,2),
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- Insert Users
INSERT INTO Users (name, email, registration_date, user_type, last_login) VALUES
('Alice Johnson', 'alice@example.com', '2023-01-05', 'student', '2024-01-10 12:34:56'),
('Bob Smith', 'bob@example.com', '2022-11-20', 'instructor', '2024-02-12 10:20:30'),
('Charlie Brown', 'charlie@example.com', '2023-03-15', 'student', NULL),
('David Lee', 'david@example.com', '2021-08-10', 'admin', '2024-01-20 15:00:00'),
('Eva Green', NULL, '2023-07-05', 'student', NULL),
('Frank Miller', 'frank@example.com', '2022-12-12', 'instructor', '2024-02-01 09:15:45');

-- Insert Courses
INSERT INTO Courses (course_name, instructor_id, category, created_date, course_price) VALUES
('Python Basics', 2, 'Programming', '2023-01-15', 49.99),
('Web Development', 2, 'Web Design', '2022-12-01', 79.99),
('Data Science', 5, 'Data Analysis', '2023-02-20', 99.99),
('Marketing 101', NULL, 'Business', '2023-03-10', 39.99);

-- Insert Enrollments
INSERT INTO Enrollments (user_id, course_id, enrollment_date, progress_percentage, status) VALUES
(1, 1, '2023-02-01', 75.50, 'active'),
(3, 2, '2023-04-10', 100.00, 'completed'),
(5, 1, '2023-05-20', NULL, 'dropped'),
(1, 3, '2023-06-15', 50.00, 'active');

-- Insert Lessons
INSERT INTO Lessons (course_id, lesson_title, lesson_duration, created_date) VALUES
(1, 'Introduction to Python', 30, '2023-01-16'),
(1, 'Data Types in Python', 40, '2023-01-18'),
(2, 'HTML Basics', 35, '2022-12-05'),
(3, 'Introduction to Data Science', 50, '2023-02-22');

-- Insert Lesson_Views
INSERT INTO Lesson_Views (user_id, lesson_id, view_date, time_spent) VALUES
(1, 1, '2023-02-02', 25),
(3, 2, '2023-04-15', NULL),
(5, 3, '2023-05-22', 30);

-- Insert Assignments
INSERT INTO Assignments (course_id, title, due_date) VALUES
(1, 'Python Variables Assignment', '2023-03-01'),
(2, 'HTML & CSS Project', '2023-05-10'),
(3, 'Data Analysis Task', '2023-06-01');

-- Insert Submissions
INSERT INTO Submissions (user_id, assignment_id, submission_date, grade) VALUES
(1, 1, '2023-03-02', 85.50),
(3, 2, '2023-05-12', 90.00),
(5, 3, NULL, NULL);

-- Insert Payments
INSERT INTO Payments (user_id, course_id, amount, payment_date, status) VALUES
(1, 1, 49.99, '2023-02-01', 'completed'),
(3, 2, 79.99, '2023-04-10', 'completed'),
(5, 3, 99.99, '2023-05-20', 'pending');

-- Insert Reviews
INSERT INTO Reviews (user_id, course_id, rating, review_text, review_date) VALUES
(1, 1, 4.5, 'Great course for beginners!', '2023-03-05'),
(3, 2, 5.0, 'Very detailed and informative.', '2023-04-15'),
(5, 3, 3.8, NULL, NULL);

-- Find the total number of students enrolled in each course.
SELECT c.course_id, c.course_name, COUNT(e.user_id) AS total_students
FROM Courses c
LEFT JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- Retrieve the top 2 highest-rated courses based on user reviews.
SELECT TOP 2 c.course_id, c.course_name, AVG(r.rating) AS avg_rating
FROM Reviews r
JOIN Courses c ON r.course_id = c.course_id
GROUP BY c.course_id, c.course_name
ORDER BY avg_rating DESC;

-- Calculate the average time spent by users on lessons for a given course.
SELECT l.course_id, c.course_name, AVG(lv.time_spent) AS avg_time_spent
FROM Lesson_Views lv
JOIN Lessons l ON lv.lesson_id = l.lesson_id
JOIN Courses c ON l.course_id = c.course_id
WHERE l.course_id = 2
GROUP BY l.course_id, c.course_name;

-- Find the instructor who has the most students enrolled across all their courses.
SELECT TOP 1 c.instructor_id, u.name AS instructor_name, COUNT(DISTINCT e.user_id) AS total_students
FROM Courses c
JOIN Users u ON c.instructor_id = u.user_id
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.instructor_id, u.name
ORDER BY total_students DESC;

-- Identify students who have completed all lessons but have not submitted any assignments.
SELECT e.user_id, u.name
FROM Enrollments e
JOIN Users u ON e.user_id = u.user_id
WHERE e.status = 'completed'
AND e.user_id NOT IN (SELECT DISTINCT user_id FROM Submissions);

-- Find the total revenue generated by each course from payments.
SELECT c.course_id, c.course_name, SUM(p.amount) AS total_revenue
FROM Payments p
JOIN Courses c ON p.course_id = c.course_id
WHERE p.status = 'completed'
GROUP BY c.course_id, c.course_name;

-- Get the most active student based on the number of lessons viewed.
SELECT TOP 1 lv.user_id, u.name, COUNT(lv.lesson_id) AS lessons_viewed
FROM Lesson_Views lv
JOIN Users u ON lv.user_id = u.user_id
GROUP BY lv.user_id, u.name
ORDER BY lessons_viewed DESC;

-- Identify courses where the majority of students drop out before completing.
SELECT c.course_id, c.course_name,
       SUM(CASE WHEN e.status = 'dropped' THEN 1 ELSE 0 END) AS dropped_students,
       COUNT(e.user_id) AS total_students,
       (SUM(CASE WHEN e.status = 'dropped' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.user_id)) AS dropout_rate
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name
HAVING (SUM(CASE WHEN e.status = 'dropped' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.user_id)) > 50;

-- Calculate the average course completion rate for each category.
SELECT c.category, 
       AVG(CASE WHEN e.status = 'completed' THEN 1 ELSE 0 END) * 100 AS avg_completion_rate
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
GROUP BY c.category;

-- Find the distribution of students across different progress percentage brackets (e.g., 0-25%, 26-50%, etc.).
SELECT 
    CASE 
        WHEN progress_percentage BETWEEN 0 AND 25 THEN '0-25%'
        WHEN progress_percentage BETWEEN 26 AND 50 THEN '26-50%'
        WHEN progress_percentage BETWEEN 51 AND 75 THEN '51-75%'
        WHEN progress_percentage BETWEEN 76 AND 100 THEN '76-100%'
        ELSE 'Unknown'
    END AS progress_range,
    COUNT(*) AS student_count
FROM Enrollments
GROUP BY 
    CASE 
        WHEN progress_percentage BETWEEN 0 AND 25 THEN '0-25%'
        WHEN progress_percentage BETWEEN 26 AND 50 THEN '26-50%'
        WHEN progress_percentage BETWEEN 51 AND 75 THEN '51-75%'
        WHEN progress_percentage BETWEEN 76 AND 100 THEN '76-100%'
        ELSE 'Unknown'
    END;

-- Find students who enrolled in a course but never accessed any lesson.
SELECT e.user_id, u.name
FROM Enrollments e
JOIN Users u ON e.user_id = u.user_id
LEFT JOIN Lesson_Views lv ON e.user_id = lv.user_id
WHERE lv.user_id IS NULL;

-- Identify courses where students have submitted assignments but haven't watched any lessons.
SELECT DISTINCT c.course_id, c.course_name
FROM Courses c
JOIN Assignments a ON c.course_id = a.course_id
JOIN Submissions s ON a.assignment_id = s.assignment_id
LEFT JOIN Lesson_Views lv ON s.user_id = lv.user_id
WHERE lv.user_id IS NULL;

-- Find the percentage of students who have completed their courses and compare it with those who dropped out.
SELECT 
    (SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS completion_percentage,
    (SUM(CASE WHEN status = 'dropped' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS dropout_percentage
FROM Enrollments;

-- Identify instructors whose courses generate the most revenue.
SELECT TOP 1 u.user_id, u.name AS instructor_name, SUM(p.amount) AS total_revenue
FROM Payments p
JOIN Courses c ON p.course_id = c.course_id
JOIN Users u ON c.instructor_id = u.user_id
WHERE p.status = 'completed'
GROUP BY u.user_id, u.name
ORDER BY total_revenue DESC;

-- Find users who have enrolled in multiple courses but never completed any.
SELECT e.user_id, u.name, COUNT(DISTINCT e.course_id) AS enrolled_courses
FROM Enrollments e
JOIN Users u ON e.user_id = u.user_id
WHERE e.status != 'completed'
GROUP BY e.user_id, u.name
HAVING COUNT(DISTINCT e.course_id) > 1;

-- Get the average number of days students take to complete a course.
SELECT AVG(DATEDIFF(DAY, e.enrollment_date, s.submission_date)) AS avg_days_to_complete
FROM Enrollments e
JOIN Submissions s ON e.user_id = s.user_id
WHERE e.status = 'completed';

-- Find courses with the highest engagement based on lessons viewed per student.
SELECT TOP 2 c.course_id, c.course_name, 
       COUNT(lv.view_id) / COUNT(DISTINCT e.user_id) AS engagement_score
FROM Courses c
JOIN Enrollments e ON c.course_id = e.course_id
JOIN Lesson_Views lv ON e.user_id = lv.user_id
GROUP BY c.course_id, c.course_name
ORDER BY engagement_score DESC;
