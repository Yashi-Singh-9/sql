sqlite3 ProjectManagementDB.db

-- Users Table  
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  email VARCHAR(50) UNIQUE,
  role VARCHAR(30) CHECK (role IN ('Admin', 'Manager', 'Developer', 'Tester', 'HR', 'Support', 'Designer', 'Analyst'))
);

-- Projects Table 
CREATE TABLE projects (
  project_id INTEGER PRIMARY KEY,
  name VARCHAR(50),
  description TEXT,
  start_date DATE,
  end_date DATE NULL,
  status VARCHAR(15) CHECK (status IN ('In Progress', 'Completed', 'On Hold'))
);

-- Tasks Table  
CREATE TABLE tasks (
  task_id INTEGER PRIMARY KEY,
  project_id INTEGER,
  assigned_to INTEGER,
  title VARCHAR(20),
  description TEXT,
  status VARCHAR(15) CHECK (status IN ('Pending', 'In Progress', 'Done')),
  due_date DATE,
  FOREIGN KEY (project_id) REFERENCES projects(project_id),
  FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);

-- Teams Table  
CREATE TABLE teams (
  team_id INTEGER PRIMARY KEY,
  team_name VARCHAR(20)
);

-- Team Members Table 
CREATE TABLE team_members (
  team_member_id INTEGER PRIMARY KEY,
  team_id INTEGER,
  user_id INTEGER,
  FOREIGN KEY (team_id) REFERENCES teams(team_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Project Teams Table  
CREATE TABLE project_teams (
  project_team_id INTEGER PRIMARY KEY,
  project_id INTEGER,
  team_id INTEGER,
  FOREIGN KEY (project_id) REFERENCES projects(project_id),
  FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

-- Comments Table  
CREATE Table comments (
  comment_id INTEGER PRIMARY KEY,
  task_id INTEGER,
  user_id INTEGER,
  comment_text TEXT,
  created_at DATETIME,
  FOREIGN KEY (task_id) REFERENCES tasks(task_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Attachments Table  
CREATE TABLE attachments (
  attachment_id INTEGER PRIMARY KEY,
  task_id INTEGER,
  file_path VARCHAR(125),
  uploaded_by INTEGER,
  FOREIGN KEY (task_id) REFERENCES tasks(task_id),
  FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

-- Insert Users
INSERT INTO users (user_id, name, email, role) VALUES
(1, 'Alice Johnson', 'alice@example.com', 'Admin'),
(2, 'Bob Smith', 'bob@example.com', 'Manager'),
(3, 'Charlie Brown', 'charlie@example.com', 'Developer'),
(4, 'David Wilson', 'david@example.com', 'Tester'),
(5, 'Emma Davis', 'emma@example.com', 'HR'),
(6, 'Frank White', 'frank@example.com', 'Support'),
(7, 'Grace Hall', 'grace@example.com', 'Designer'),
(8, 'Henry King', 'henry@example.com', 'Analyst');

-- Insert Projects
INSERT INTO projects (project_id, name, description, start_date, end_date, status) VALUES
(1, 'Website Redesign', 'Redesign company website with new UI/UX', '2024-01-01', NULL, 'In Progress'),
(2, 'Mobile App Development', 'Develop a cross-platform mobile app', '2024-02-01', NULL, 'In Progress'),
(3, 'Marketing Campaign', 'Digital marketing strategy for Q2', '2024-03-01', '2024-06-01', 'On Hold'),
(4, 'Cloud Migration', 'Migrate services to the cloud', '2024-01-15', NULL, 'In Progress'),
(5, 'E-commerce Expansion', 'Expand e-commerce capabilities', '2024-04-01', NULL, 'Completed'),
(6, 'Cybersecurity Audit', 'Company-wide security audit', '2024-05-01', NULL, 'In Progress'),
(7, 'Customer Support AI', 'Develop AI chatbot for customer support', '2024-02-10', NULL, 'In Progress'),
(8, 'Data Analytics Dashboard', 'Create a BI dashboard', '2024-03-20', NULL, 'On Hold');

-- Insert Tasks
INSERT INTO tasks (task_id, project_id, assigned_to, title, description, status, due_date) VALUES
(1, 1, 3, 'UI Update', 'Update homepage UI', 'In Progress', '2024-03-15'),
(2, 2, 4, 'Bug Fix', 'Fix login issue in the app', 'Pending', '2024-03-10'),
(3, 3, 5, 'Social Media Plan', 'Create marketing plan', 'Done', '2024-03-25'),
(4, 4, 6, 'Server Setup', 'Set up cloud servers', 'In Progress', '2024-04-01'),
(5, 5, 7, 'Product Page', 'Revamp product display', 'Pending', '2024-04-10'),
(6, 6, 8, 'Audit Reports', 'Prepare security audit report', 'Done', '2024-05-20'),
(7, 7, 2, 'AI Training', 'Train AI model for chatbot', 'In Progress', '2024-06-05'),
(8, 8, 1, 'Dashboard Metrics', 'Define key metrics for dashboard', 'Pending', '2024-06-15');

-- Insert Teams
INSERT INTO teams (team_id, team_name) VALUES
(1, 'Frontend Team'),
(2, 'Backend Team'),
(3, 'QA Team'),
(4, 'Marketing Team'),
(5, 'DevOps Team'),
(6, 'Support Team'),
(7, 'Design Team'),
(8, 'Analytics Team');

-- Insert Team Members
INSERT INTO team_members (team_member_id, team_id, user_id) VALUES
(1, 1, 3),
(2, 2, 4),
(3, 3, 5),
(4, 4, 6),
(5, 5, 7),
(6, 6, 8),
(7, 7, 1),
(8, 8, 2);

-- Insert Project Teams
INSERT INTO project_teams (project_team_id, project_id, team_id) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 4),
(4, 4, 5),
(5, 5, 7),
(6, 6, 3),
(7, 7, 6),
(8, 8, 8);

-- Insert Comments
INSERT INTO comments (comment_id, task_id, user_id, comment_text, created_at) VALUES
(1, 1, 3, 'UI improvements are almost done!', '2024-03-05 10:00:00'),
(2, 2, 4, 'Investigating the login issue.', '2024-03-06 11:30:00'),
(3, 3, 5, 'Campaign is ready to launch.', '2024-03-07 15:00:00'),
(4, 4, 6, 'Server setup in progress.', '2024-03-08 09:45:00'),
(5, 5, 7, 'New product page design looks great!', '2024-03-09 14:20:00'),
(6, 6, 8, 'Audit report completed.', '2024-03-10 16:10:00'),
(7, 7, 2, 'Chatbot training progressing well.', '2024-03-11 12:00:00'),
(8, 8, 1, 'Dashboard metrics are finalized.', '2024-03-12 13:25:00');

-- Insert Attachments
INSERT INTO attachments (attachment_id, task_id, file_path, uploaded_by) VALUES
(1, 1, '/files/ui_update.png', 3),
(2, 2, '/files/bug_fix.log', 4),
(3, 3, '/files/marketing_plan.pdf', 5),
(4, 4, '/files/server_setup.docx', 6),
(5, 5, '/files/product_page_design.psd', 7),
(6, 6, '/files/audit_report.xlsx', 8),
(7, 7, '/files/ai_model_training.pdf', 2),
(8, 8, '/files/dashboard_metrics.csv', 1);

-- Find all tasks assigned to a specific user along with the project name.
SELECT t.task_id, t.title, t.description, t.status, p.name AS project_name
FROM tasks t
JOIN projects p ON t.project_id = p.project_id
WHERE t.assigned_to = 5;  

-- Get the total number of tasks per project and sort by the highest number of tasks.
SELECT p.project_id, p.name AS project_name, COUNT(t.task_id) AS total_tasks
FROM projects p
LEFT JOIN tasks t ON p.project_id = t.project_id
GROUP BY p.project_id, p.name
ORDER BY total_tasks DESC;

-- Retrieve all projects that have not yet started (start_date in the future).
SELECT * FROM projects
WHERE start_date > DATE('now');

-- Find users who have not been assigned to any task.
SELECT u.user_id, u.name, u.email, u.role
FROM users u
LEFT JOIN tasks t ON u.user_id = t.assigned_to
WHERE t.assigned_to IS NULL;

-- List all team members of a specific project.
SELECT u.user_id, u.name, u.email, t.team_name
FROM users u
JOIN team_members tm ON u.user_id = tm.user_id
JOIN project_teams pt ON tm.team_id = pt.team_id
JOIN teams t ON tm.team_id = t.team_id
WHERE pt.project_id = 3;  

-- Fetch all overdue tasks (where due_date is past today's date and status is not 'Done').
SELECT t.task_id, t.title, t.description, t.due_date, t.status, p.name AS project_name
FROM tasks t
JOIN projects p ON t.project_id = p.project_id
WHERE t.due_date < DATE('now') AND t.status != 'Done';

-- Get the number of completed projects per team.
SELECT t.team_id, t.team_name, COUNT(p.project_id) AS completed_projects
FROM teams t
JOIN project_teams pt ON t.team_id = pt.team_id
JOIN projects p ON pt.project_id = p.project_id
WHERE p.status = 'Completed'
GROUP BY t.team_id, t.team_name;

-- Retrieve all comments made on a specific task.
SELECT c.comment_id, u.name AS user_name, c.comment_text, c.created_at
FROM comments c
JOIN users u ON c.user_id = u.user_id
WHERE c.task_id = 4;  

-- Find the top 3 users who have completed the most tasks.
SELECT u.user_id, u.name, COUNT(t.task_id) AS completed_tasks
FROM users u
JOIN tasks t ON u.user_id = t.assigned_to
WHERE t.status = 'Done'
GROUP BY u.user_id, u.name
ORDER BY completed_tasks DESC
LIMIT 3;

-- List all attachments for a given project, along with the task they belong to.
SELECT a.attachment_id, a.file_path, t.task_id, t.title, p.name AS project_name
FROM attachments a
JOIN tasks t ON a.task_id = t.task_id
JOIN projects p ON t.project_id = p.project_id
WHERE p.project_id = 7;  
