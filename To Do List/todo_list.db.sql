-- MS SQL Project
CREATE DATABASE todo_list;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(50),
  password VARCHAR(50)
);

-- Tasks Table 
CREATE TABLE tasks (
  task_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  title VARCHAR(50),
  description TEXT,
  due_date DATE,
  status VARCHAR(10) CHECK (status IN ('Pending', 'Completed')),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Categories Table 
CREATE TABLE categories (
  category_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  category_name VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Task Categories Table 
CREATE TABLE task_categories(
  task_id INT,
  category_id INT,
  FOREIGN KEY (task_id) REFERENCES tasks(task_id),
  Foreign Key (category_id) REFERENCES categories(category_id)
);

-- Subtasks Table
CREATE TABLE subtasks_table(
  subtask_id INT IDENTITY(1,1) PRIMARY KEY,
  task_id INT,
  title VARCHAR(30),
  status VARCHAR(20),
  FOREIGN KEY (task_id) REFERENCES tasks(task_id)
);

-- Insert sample users
INSERT INTO users (username, email, password) VALUES
('john_doe', 'john@example.com', 'password123'),
('jane_smith', 'jane@example.com', 'securepass'),
('alex_jones', 'alex@example.com', 'alexpass'),
('emma_watson', 'emma@example.com', 'emma123'),
('chris_evans', 'chris@example.com', 'chrispass'),
('lisa_brown', 'lisa@example.com', 'lisa2024'),
('michael_clark', 'michael@example.com', 'mikepass'),
('sophia_martin', 'sophia@example.com', 'sophiapass');

-- Insert sample tasks
INSERT INTO tasks (user_id, title, description, due_date, status) VALUES
(1, 'Buy groceries', 'Milk, Bread, Eggs', '2025-02-15', 'Pending'),
(2, 'Complete project', 'Finish the final report', '2025-02-20', 'Pending'),
(3, 'Workout', 'Go to the gym', '2025-02-18', 'Completed'),
(4, 'Read book', 'Finish reading novel', '2025-02-22', 'Pending'),
(5, 'Plan vacation', 'Book flights and hotels', '2025-03-10', 'Pending'),
(6, 'Attend meeting', 'Join team discussion', '2025-02-25', 'Pending'),
(7, 'Fix bicycle', 'Repair the brakes', '2025-02-27', 'Pending'),
(8, 'Organize closet', 'Sort out clothes', '2025-02-28', 'Completed');

-- Insert sample categories
INSERT INTO categories (user_id, category_name) VALUES
(1, 'Personal'),
(2, 'Work'),
(3, 'Health'),
(4, 'Hobby'),
(5, 'Travel'),
(6, 'Meetings'),
(7, 'Maintenance'),
(8, 'Home Organization');

-- Insert sample task categories
INSERT INTO task_categories (task_id, category_id) VALUES
(1, 1),
(2, 2),
(3, 3), 
(4, 4), 
(5, 5), 
(6, 6), 
(7, 7), 
(8, 8); 

-- Insert sample subtasks
INSERT INTO subtasks_table (task_id, title, status) VALUES
(1, 'Buy Milk', 'Pending'),
(1, 'Buy Bread', 'Pending'),
(2, 'Write Report', 'Completed'),
(2, 'Review Report', 'Pending'),
(3, 'Cardio', 'Completed'),
(4, 'Read Chapter 1', 'Pending'),
(5, 'Book Flight', 'Pending'),
(6, 'Prepare Slides', 'Pending');

-- Find all tasks assigned to a specific user.
SELECT * 
FROM tasks
Where user_id = 2;

-- List all tasks that are overdue.
SELECT * 
FROM tasks 
WHERE due_date < GETDATE() 
AND status = 'Pending';

-- Retrieve all tasks grouped by their categories.
SELECT c.category_name, t.* FROM tasks t
LEFT JOIN task_categories tc ON t.task_id = tc.task_id
LEFT JOIN categories c ON tc.category_id = c.category_id
ORDER BY c.category_name;

-- Find users who have not created any tasks.
SELECT * 
FROM users 
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM tasks);

-- Get the count of completed tasks for each user.
SELECT user_id, COUNT(*) AS completed_tasks 
FROM tasks 
WHERE status = 'Completed' 
GROUP BY user_id;

-- Find all tasks that do not belong to any category.
SELECT * 
FROM tasks 
WHERE task_id NOT IN (SELECT DISTINCT task_id FROM task_categories);

-- Retrieve all subtasks for a given task.
SELECT * 
FROM subtasks_table 
WHERE task_id = 3;

-- Find users who have the most pending tasks.
SELECT user_id, COUNT(*) AS pending_tasks 
FROM tasks 
WHERE status = 'Pending' 
GROUP BY user_id 
ORDER BY pending_tasks DESC;

-- List all categories along with the number of tasks assigned to each.
SELECT c.category_name, COUNT(tc.task_id) AS task_count 
FROM categories c
LEFT JOIN task_categories tc ON c.category_id = tc.category_id
GROUP BY c.category_name;

-- Find tasks that have at least one subtask still pending.
SELECT t.* 
FROM tasks t
WHERE EXISTS (SELECT 1 FROM subtasks_table s WHERE s.task_id = t.task_id AND s.status = 'Pending');
