sqlite3 Tutor_Scheduler.db

-- Users Table  
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(50) UNIQUE,
  password TEXT,
  role VARCHAR(8) CHECK (role IN ('Tutor', 'Student'))
);

-- Tutors Table  
CREATE TABLE tutors (
  tutor_id INTEGER PRIMARY KEY,
  subject_specialization VARCHAR(50),
  availability_schedule TEXT,
  FOREIGN KEY (tutor_id) REFERENCES users(user_id)
);

-- Students Table  
CREATE TABLE students (
  student_id INTEGER PRIMARY KEY,
  grade_level VARCHAR(50),
  FOREIGN KEY (student_id) REFERENCES users(user_id)
);

-- Courses Table  
CREATE TABLE courses (
  course_id INTEGER PRIMARY KEY,
  course_name VARCHAR(50),
  description TEXT,
  tutor_id INTEGER,
  FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id)
);

-- Schedules Table  
CREATE TABLE schedules (
  schedule_id INTEGER PRIMARY KEY,
  tutor_id INTEGER,
  student_id INTEGER,
  course_id INTEGER,
  date_time DATETIME,
  status VARCHAR(15) CHECK (status IN ('Scheduled', 'Completed', 'Canceled', 'Pending')),
  FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Payments Table  
CREATE TABLE payments (
  payment_id INTEGER PRIMARY KEY,
  student_id INTEGER,
  tutor_id INTEGER,
  amount DECIMAL(10,2),
  payment_date DATE,
  status VARCHAR(8) CHECK (status IN ('Paid', 'Pending')),
  FOREIGN KEY (student_id) REFERENCES students(student_id),
  FOREIGN KEY (tutor_id) REFERENCES tutors(tutor_id)
);

-- Insert Users  
INSERT INTO users (user_id, name, email, password, role) VALUES  
(1, 'Alice Johnson', 'alice@example.com', 'password123', 'Tutor'),  
(2, 'Bob Smith', 'bob@example.com', 'password456', 'Student'),  
(3, 'Charlie Brown', 'charlie@example.com', 'password789', 'Tutor'),  
(4, 'David White', 'david@example.com', 'password234', 'Student'),  
(5, 'Eve Black', 'eve@example.com', 'password567', 'Tutor'),  
(6, 'Frank Green', 'frank@example.com', 'password890', 'Student');  

-- Insert Tutors  
INSERT INTO tutors (tutor_id, subject_specialization, availability_schedule) VALUES  
(1, 'Mathematics', 'Monday, Wednesday, Friday'),  
(3, 'Physics', 'Tuesday, Thursday'),  
(5, 'Chemistry', NULL);  

-- Insert Students  
INSERT INTO students (student_id, grade_level) VALUES  
(2, 'Grade 10'),  
(4, 'Grade 12'),  
(6, 'Grade 11');  

-- Insert Courses  
INSERT INTO courses (course_id, course_name, description, tutor_id) VALUES  
(1, 'Algebra Basics', 'Introductory Algebra concepts', 1),  
(2, 'Newtonian Physics', 'Fundamentals of Mechanics', 3),  
(3, 'Organic Chemistry', 'Basics of Organic Chemistry', 5),  
(4, 'Advanced Calculus', NULL, 1),  
(5, 'Thermodynamics', 'Heat and Energy concepts', NULL),  
(6, 'Electromagnetism', 'Electricity and Magnetism principles', 3);  

-- Insert Schedules  
INSERT INTO schedules (schedule_id, tutor_id, student_id, course_id, date_time, status) VALUES  
(1, 1, 2, 1, '2025-03-10 10:00:00', 'Scheduled'),  
(2, 3, 4, 2, '2025-03-11 15:00:00', 'Completed'),  
(3, 1, 6, 4, '2025-03-12 09:00:00', 'Canceled'),  
(4, 5, 2, 3, '2025-03-13 14:00:00', 'Scheduled'),  
(5, 3, 4, 6, '2025-03-14 11:00:00', 'Scheduled'),  
(6, 1, 2, 4, NULL, 'Pending');  

-- Insert Payments  
INSERT INTO payments (payment_id, student_id, tutor_id, amount, payment_date, status) VALUES  
(1, 2, 1, 50.00, '2025-03-10', 'Paid'),  
(2, 4, 3, 75.00, '2025-03-11', 'Pending'),  
(3, 6, 1, 60.00, '2025-03-12', 'Paid'),  
(4, 2, 5, 80.00, '2025-03-13', 'Paid'),  
(5, 4, 3, 90.00, NULL, 'Pending'),  
(6, 6, 3, NULL, '2025-03-14', 'Paid');  

-- Retrieve all scheduled sessions for a specific tutor.
SELECT * FROM schedules  
WHERE tutor_id = 1 AND status = 'Scheduled';

-- List students who have booked more than 2 sessions.
SELECT student_id, COUNT(*) AS session_count  
FROM schedules  
GROUP BY student_id  
HAVING COUNT(*) > 2;

-- Get the most popular courses based on the number of bookings.
SELECT course_id, COUNT(*) AS booking_count  
FROM schedules  
GROUP BY course_id  
ORDER BY booking_count DESC  
LIMIT 5;

-- Retrieve all tutors specializing in a specific subject.
SELECT * FROM tutors  
WHERE subject_specialization = 'Mathematics';

-- Get the total number of sessions conducted in the last 3 months.
SELECT COUNT(*) AS total_sessions  
FROM schedules  
WHERE date_time >= date('now', '-3 months')  
AND status = 'Completed';

-- List all upcoming sessions for a student.
SELECT * FROM schedules  
WHERE student_id = 4  
AND date_time >= datetime('now')  
AND status = 'Scheduled'  
ORDER BY date_time ASC;

-- Find the tutor with the highest number of scheduled sessions.
SELECT tutor_id, COUNT(*) AS session_count  
FROM schedules  
WHERE status = 'Scheduled'  
GROUP BY tutor_id  
ORDER BY session_count DESC  
LIMIT 1;

-- Retrieve payment details for a specific student.
SELECT * FROM payments  
WHERE student_id = 4;

-- Retrieve all scheduled sessions for a specific tutor (given tutor_id = X).
SELECT * FROM payments  
WHERE student_id = 2;

-- List students who have booked more than 2 sessions.
SELECT student_id, COUNT(*) AS session_count  
FROM schedules  
GROUP BY student_id  
HAVING COUNT(*) > 2;

-- Get the most popular courses based on the number of bookings.
SELECT c.course_id, c.course_name, COUNT(s.schedule_id) AS booking_count  
FROM schedules s  
JOIN courses c ON s.course_id = c.course_id  
GROUP BY c.course_id, c.course_name  
ORDER BY booking_count DESC  
LIMIT 5;

-- Retrieve all tutors specializing in a specific subject (e.g., 'Mathematics').
SELECT * 
FROM tutors  
WHERE subject_specialization = 'Mathematics';

-- Get the total number of sessions conducted in the last 3 months.
SELECT COUNT(*) AS total_sessions  
FROM schedules  
WHERE date_time >= date('now', '-3 months')  
AND status = 'Completed';

-- List all upcoming sessions for a student (given student_id = Y).
SELECT * FROM schedules  
WHERE student_id = 2  
AND date_time >= datetime('now')  
AND status = 'Scheduled'  
ORDER BY date_time ASC;

-- Find the tutor with the highest number of scheduled sessions.
SELECT tutor_id, COUNT(*) AS session_count  
FROM schedules  
WHERE status = 'Scheduled'  
GROUP BY tutor_id  
ORDER BY session_count DESC  
LIMIT 1;

-- Retrieve payment details for a specific student (given student_id = Z).
SELECT * FROM payments  
WHERE student_id = 6;

-- Retrieve all students who have completed at least one session
SELECT DISTINCT s.student_id, u.name  
FROM schedules s  
JOIN users u ON s.student_id = u.user_id  
WHERE s.status = 'Completed';

-- Find the student with the highest number of scheduled sessions
SELECT student_id, COUNT(*) AS session_count  
FROM schedules  
WHERE status = 'Scheduled'  
GROUP BY student_id  
ORDER BY session_count DESC  
LIMIT 1;

-- Find the most active tutor based on completed sessions
SELECT tutor_id, COUNT(*) AS completed_sessions  
FROM schedules  
WHERE status = 'Completed'  
GROUP BY tutor_id  
ORDER BY completed_sessions DESC  
LIMIT 1;

-- List courses that have never been booked
SELECT * FROM courses  
WHERE course_id NOT IN (SELECT DISTINCT course_id FROM schedules);

-- Get the total number of students per grade level
SELECT grade_level, COUNT(*) AS total_students  
FROM students  
GROUP BY grade_level;

-- Find tutors who have taught more than 1 different courses
SELECT tutor_id, COUNT(DISTINCT course_id) AS total_courses  
FROM courses  
GROUP BY tutor_id  
HAVING total_courses > 1;

-- Retrieve all pending payments
SELECT * FROM payments  
WHERE status = 'Pending';

-- Find the student who has spent the most on tutoring
SELECT student_id, SUM(amount) AS total_spent  
FROM payments  
WHERE status = 'Paid'  
GROUP BY student_id  
ORDER BY total_spent DESC  
LIMIT 1;

-- Find courses with the highest number of unique students
SELECT s.course_id, c.course_name, COUNT(DISTINCT s.student_id) AS unique_students  
FROM schedules s  
JOIN courses c ON s.course_id = c.course_id  
GROUP BY s.course_id, c.course_name  
ORDER BY unique_students DESC  
LIMIT 4;

-- Find the busiest time slots for tutoring sessions
SELECT strftime('%H:%M', date_time) AS time_slot, COUNT(*) AS session_count  
FROM schedules  
GROUP BY time_slot  
ORDER BY session_count DESC  
LIMIT 5;