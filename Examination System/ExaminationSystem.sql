-- Create Database
CREATE DATABASE ExaminationSystem;
USE ExaminationSystem;

-- Users Table 
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  passwords TEXT,
  role ENUM('Student', 'Teacher', 'Admin')
);

-- Courses Table 
CREATE TABLE courses (
  course_id INT PRIMARY KEY AUTO_INCREMENT,
  course_name VARCHAR(50),
  teacher_id INT,
  FOREIGN KEY (teacher_id) REFERENCES users(user_id)
);

-- Exams Table  
CREATE TABLE exams (
  exam_id INT PRIMARY KEY AUTO_INCREMENT,
  exam_name VARCHAR(50),
  course_id INT,
  exam_date DATE,
  duration TIME,
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Questions Table  
CREATE TABLE questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT,
    question_text TEXT NOT NULL,
    option_a VARCHAR(255) NOT NULL,
    option_b VARCHAR(255) NOT NULL,
    option_c VARCHAR(255) NOT NULL,
    option_d VARCHAR(255) NOT NULL,
    correct_option CHAR(1) NOT NULL CHECK (correct_option IN ('A', 'B', 'C', 'D')),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE
);  

-- Student Exams Table 
CREATE TABLE student_exams (
  student_exam_id INT PRIMARY KEY AUTO_INCREMENT,
  student_id INT,
  exam_id INT,
  score INT,
  status ENUM('Completed', 'Pending'),
  FOREIGN KEY (student_id) REFERENCES users(user_id),
  FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);

-- Exam Answers Table
CREATE TABLE exam_answers (
  answer_id INT PRIMARY KEY AUTO_INCREMENT,
  student_exam_id INT,
  question_id INT,
  selected_option CHAR(1) CHECK (selected_option IN ('A', 'B', 'C', 'D')),
  FOREIGN KEY (student_exam_id) REFERENCES student_exams(student_exam_id),
  FOREIGN KEY (question_id) REFERENCES questions(question_id)
);  

-- Insert Users (3 Students, 2 Teachers, 1 Admin)
INSERT INTO users (name, email, passwords, role) VALUES
('Alice Johnson', 'alice@example.com', 'password123', 'Student'),
('Bob Smith', 'bob@example.com', 'password456', 'Student'),
('Charlie Brown', 'charlie@example.com', 'password789', 'Student'),
('David Miller', 'david@example.com', 'password321', 'Teacher'),
('Emma Watson', 'emma@example.com', 'password654', 'Teacher'),
('Frank White', 'frank@example.com', 'password987', 'Admin');

-- Insert Courses (Assigned to Teachers)
INSERT INTO courses (course_name, teacher_id) VALUES
('Mathematics', 4),
('Physics', 4),
('Chemistry', 5),
('Biology', 5),
('Computer Science', 4),
('History', 5);

-- Insert Exams (Linked to Courses)
INSERT INTO exams (exam_name, course_id, exam_date, duration) VALUES
('Math Final', 1, '2025-05-20', '02:00:00'),
('Physics Midterm', 2, '2025-06-15', '01:30:00'),
('Chemistry Quiz', 3, '2025-07-10', '01:00:00'),
('Biology Exam', 4, '2025-08-05', '02:30:00'),
('Computer Science Test', 5, '2025-09-01', '02:00:00'),
('History Final', 6, '2025-10-12', '01:45:00');

-- Insert Questions (Each Exam has Repeated Questions)
INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option) VALUES
(1, 'What is 2+2?', '3', '4', '5', '6', 'B'),
(2, 'What is the speed of light?', '300,000 km/s', '150,000 km/s', '1,000 km/s', '500,000 km/s', 'A'),
(3, 'What is H2O?', 'Oxygen', 'Hydrogen', 'Water', 'Helium', 'C'),
(4, 'What is the function of mitochondria?', 'Powerhouse of the cell', 'Brain of the cell', 'DNA carrier', 'Membrane creator', 'A'),
(5, 'What is binary code?', 'Base 10', 'Base 2', 'Base 16', 'Base 8', 'B'),
(6, 'Who was the first U.S. president?', 'Lincoln', 'Washington', 'Jefferson', 'Adams', 'B');

-- Insert Student Exams (Each Student takes Random Exams)
INSERT INTO student_exams (student_id, exam_id, score, status) VALUES
(1, 1, 85, 'Completed'),
(2, 2, 90, 'Completed'),
(3, 3, 78, 'Completed'),
(1, 4, 88, 'Pending'),
(2, 5, 95, 'Pending'),
(3, 6, 80, 'Completed');

-- Insert Exam Answers (Each Student Exam has Answered Randomly)
INSERT INTO exam_answers (student_exam_id, question_id, selected_option) VALUES
(1, 1, 'B'),
(2, 2, 'A'),
(3, 3, 'C'),
(4, 4, 'A'),
(5, 5, 'B'),
(6, 6, 'B');

-- Retrieve all students who have completed a specific exam.
SELECT u.user_id, u.name, u.email, se.exam_id, se.score
FROM users u
JOIN student_exams se ON u.user_id = se.student_id
WHERE se.exam_id = 3 AND se.status = 'Completed';

-- Get the highest, lowest, and average score for a given exam.
SELECT 
    exam_id,
    MAX(score) AS highest_score,
    MIN(score) AS lowest_score,
    AVG(score) AS average_score
FROM student_exams
WHERE exam_id = 1;

-- List all courses with the number of exams associated with them.
SELECT c.course_id, c.course_name, COUNT(e.exam_id) AS total_exams
FROM courses c
LEFT JOIN exams e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_name;

-- Find the total number of questions in each exam.
SELECT exam_id, COUNT(question_id) AS total_questions
FROM questions
GROUP BY exam_id;

-- Get a list of teachers with the number of courses they teach.
SELECT u.user_id, u.name, COUNT(c.course_id) AS total_courses
FROM users u
JOIN courses c ON u.user_id = c.teacher_id
WHERE u.role = 'Teacher'
GROUP BY u.user_id, u.name;

-- Fetch all students along with their exam scores (even if they haven’t taken any exams yet).
SELECT u.user_id, u.name, se.exam_id, COALESCE(se.score, 'Not Attempted') AS score
FROM users u
LEFT JOIN student_exams se ON u.user_id = se.student_id
WHERE u.role = 'Student';

-- List all students along with the number of exams they have attempted.
SELECT u.user_id, u.name, COUNT(se.exam_id) AS total_exams_attempted
FROM users u
LEFT JOIN student_exams se ON u.user_id = se.student_id
WHERE u.role = 'Student'
GROUP BY u.user_id, u.name;

-- Retrieve Teacher Details with Their Courses and Exam Counts
SELECT 
  u.user_id AS teacher_id,
  u.name AS teacher_name,
  c.course_id,
  c.course_name,
  COUNT(e.exam_id) AS total_exams
FROM users u
JOIN courses c ON u.user_id = c.teacher_id
LEFT JOIN exams e ON c.course_id = e.course_id
WHERE u.role = 'Teacher'
GROUP BY c.course_id, u.user_id, c.course_name;

-- Retrieve the top 3 highest-scoring students in a given exam.
SELECT u.user_id, u.name, se.exam_id, se.score
FROM users u
JOIN student_exams se ON u.user_id = se.student_id
WHERE se.exam_id = 2
ORDER BY se.score DESC
LIMIT 3;

-- Calculate Each Student’s Average Score Across All Exams
SELECT 
  u.user_id, 
  u.name, 
  AVG(se.score) AS average_score
FROM users u
JOIN student_exams se ON u.user_id = se.student_id
WHERE u.role = 'Student'
GROUP BY u.user_id, u.name;

-- Retrieve Courses with Teacher Names and Total Enrolled Students
SELECT 
  c.course_id, 
  c.course_name, 
  t.name AS teacher_name, 
  COUNT(se.student_exam_id) AS total_students
FROM courses c
JOIN users t ON c.teacher_id = t.user_id
LEFT JOIN exams e ON c.course_id = e.course_id
LEFT JOIN student_exams se ON e.exam_id = se.exam_id
GROUP BY c.course_id, c.course_name, t.name;

-- List Exams with Total Number of Correct Answers
SELECT 
  e.exam_id, 
  e.exam_name, 
  COUNT(*) AS total_correct_answers
FROM exam_answers ea
JOIN questions q ON ea.question_id = q.question_id
JOIN student_exams se ON ea.student_exam_id = se.student_exam_id
JOIN exams e ON se.exam_id = e.exam_id
WHERE ea.selected_option = q.correct_option
GROUP BY e.exam_id, e.exam_name;