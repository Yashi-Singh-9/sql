sqlite3 fitness_tracker.db

-- Users Table 
CREATE TABLE users (
  user_id INTEGER PRIMARY KEY,
  name VARCHAR(20),
  email VARCHAR(20) UNIQUE,
  age INTEGER,
  gender VARCHAR(8) CHECK (gender IN ('Female', 'Male', 'Others')),
  weight DECIMAL(5,2) CHECK (weight > 0),
  height INTEGER,
  created_at DATETIME
);

-- Workouts Table 
CREATE TABLE workouts (
  workout_id INTEGER PRIMARY KEY,
  workout_name VARCHAR(20),
  category VARCHAR(20) CHECK (category IN ('Cardio', 'Strength', 'Flexibility', 'Endurance', 'Balance', 'HIIT', 'Mobility'))
);

-- Exercises Table 
CREATE TABLE exercises (
  exercise_id INTEGER PRIMARY KEY,
  exercise_name VARCHAR(20),
  description TEXT,
  muscle_group VARCHAR(20) CHECK (muscle_group IN ('Chest', 'Back', 'Legs', 'Arms', 'Shoulders', 'Core', 'Full Body', 'Cardio'))
);

-- User Workout Table 
CREATE TABLE user_workout (
  user_workout_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  workout_id INTEGER,
  date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id)
);

-- Workout Exercises Table 
CREATE TABLE workout_exercises (
  workout_exercise_id INTEGER PRIMARY KEY,
  workout_id INTEGER,
  exercise_id INTEGER,
  sets INT CHECK (sets > 0),
  reps INT CHECK (reps > 0),
  rest_time INT CHECK (rest_time >= 0),  
  FOREIGN KEY (workout_id) REFERENCES workouts(workout_id),
  FOREIGN KEY (exercise_id) REFERENCES exercises(exercise_id)
);

-- User Progress Table 
CREATE TABLE user_progress (
  progress_id INTEGER PRIMARY KEY,
  user_id INTEGER,
  date DATE,
  weight DECIMAL(5,2) CHECK (weight > 0),
  body_fat_percentage DECIMAL(5,2) CHECK (body_fat_percentage BETWEEN 0 AND 100),
  notes TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Calories Intake Table 
CREATE TABLE calories_intake (  
    intake_id INT PRIMARY KEY,
    user_id INT,
    date DATE,
    calories INT CHECK (calories >= 0),
    protein DECIMAL(5,2) CHECK (protein >= 0),  
    carbs DECIMAL(5,2) CHECK (carbs >= 0), 
    fats DECIMAL(5,2) CHECK (fats >= 0),  
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert data into users table
INSERT INTO users (user_id, name, email, age, gender, weight, height, created_at) VALUES
(1, 'Alice', 'alice@example.com', 25, 'Female', 60.5, 165, '2024-01-10'),
(2, 'Bob', 'bob@example.com', 30, 'Male', 75.2, 175, '2024-01-11'),
(3, 'Charlie', 'charlie@example.com', 28, 'Male', 80.0, 180, '2024-01-12'),
(4, 'David', 'david@example.com', 35, 'Male', 85.3, 178, '2024-01-13'),
(5, 'Eve', 'eve@example.com', 27, 'Female', 55.0, 160, '2024-01-14'),
(6, 'Fay', 'fay@example.com', 29, 'Female', 62.3, 170, '2024-01-15'),
(7, 'Grace', 'grace@example.com', 32, 'Female', 68.1, 168, '2024-01-16'),
(8, 'Hank', 'hank@example.com', 26, 'Male', 78.4, 182, '2024-01-17');

-- Insert data into workouts table
INSERT INTO workouts (workout_id, workout_name, category) VALUES
(1, 'Morning Cardio', 'Cardio'),
(2, 'Leg Day', 'Strength'), 
(3, 'Yoga Flow', 'Flexibility'),
(4, 'HIIT Burn', 'HIIT'),
(5, 'Endurance Run', 'Endurance'),
(6, 'Upper Body Strength', 'Strength'),
(7, 'Core Stability', 'Balance'), 
(8, 'Mobility Routine', 'Mobility');

-- Insert data into exercises table
INSERT INTO exercises (exercise_id, exercise_name, description, muscle_group) VALUES
(1, 'Push-up', 'Upper body strength exercise', 'Chest'),
(2, 'Squat', 'Lower body strength exercise', 'Legs'),
(3, 'Deadlift', 'Full-body strength exercise', 'Full Body'),
(4, 'Plank', 'Core stability exercise', 'Core'),
(5, 'Jump Rope', 'Cardio workout', 'Cardio'),
(6, 'Pull-up', 'Upper body exercise', 'Back'),
(7, 'Lunges', 'Leg exercise', 'Legs'),
(8, 'Bicep Curl', 'Arm exercise', 'Arms');

-- Insert data into user_workout table
INSERT INTO user_workout (user_workout_id, user_id, workout_id, date) VALUES
(1, 1, 1, '2024-02-01'),
(2, 2, 2, '2024-02-02'),
(3, 3, 3, '2024-02-03'),
(4, 4, 4, '2024-02-04'),
(5, 5, 5, '2024-02-05'),
(6, 6, 6, '2024-02-06'),
(7, 7, 7, '2024-02-07'),
(8, 8, 8, '2024-02-08');

-- Insert data into workout_exercises table
INSERT INTO workout_exercises (workout_exercise_id, workout_id, exercise_id, sets, reps, rest_time) VALUES
(1, 1, 5, 3, 30, 60),
(2, 2, 2, 4, 12, 90),
(3, 3, 4, 3, 45, 30),
(4, 4, 1, 4, 15, 45),
(5, 5, 5, 5, 20, 30),
(6, 6, 6, 3, 10, 60),
(7, 7, 7, 4, 10, 45),
(8, 8, 8, 3, 15, 60);

-- Insert data into user_progress table
INSERT INTO user_progress (progress_id, user_id, date, weight, body_fat_percentage, notes) VALUES
(1, 1, '2024-02-01', 61.0, 22.5, 'Feeling good'),
(2, 2, '2024-02-02', 74.5, 18.2, 'Slight improvement'),
(3, 3, '2024-02-03', 79.0, 20.0, 'Increased endurance'),
(4, 4, '2024-02-04', 84.0, 25.0, 'Stronger legs'),
(5, 5, '2024-02-05', 54.8, 21.3, 'Maintaining weight'),
(6, 6, '2024-02-06', 62.0, 20.1, 'More flexible'),
(7, 7, '2024-02-07', 67.5, 22.0, 'Core strength improved'),
(8, 8, '2024-02-08', 77.9, 19.5, 'Good energy levels');

-- Insert data into calories_intake table
INSERT INTO calories_intake (intake_id, user_id, date, calories, protein, carbs, fats) VALUES
(1, 1, '2024-02-01', 2200, 120.5, 250.3, 70.5),
(2, 2, '2024-02-02', 2500, 130.0, 300.5, 80.2),
(3, 3, '2024-02-03', 2700, 140.5, 320.0, 85.3),
(4, 4, '2024-02-04', 2300, 110.0, 280.5, 75.1),
(5, 5, '2024-02-05', 2100, 100.5, 260.3, 65.2),
(6, 6, '2024-02-06', 2400, 125.0, 290.0, 78.5),
(7, 7, '2024-02-07', 2600, 135.5, 310.2, 82.6),
(8, 8, '2024-02-08', 2800, 145.0, 330.0, 90.0);

-- Retrieve all workouts a user has completed.
SELECT u.user_id, u.name, w.workout_name, uw.date
FROM users u
JOIN user_workout uw ON u.user_id = uw.user_id
JOIN workouts w ON uw.workout_id = w.workout_id;

-- Find users who have done a specific exercise.
SELECT DISTINCT u.user_id, u.name
FROM users u
JOIN user_workout uw ON u.user_id = uw.user_id
JOIN workout_exercises we ON uw.workout_id = we.workout_id
WHERE we.exercise_id = 5;

-- List all exercises in a specific workout.
SELECT e.exercise_id, e.exercise_name, e.description, e.muscle_group
FROM exercises e
JOIN workout_exercises we ON e.exercise_id = we.exercise_id
WHERE we.workout_id = 3;

-- Get total workouts done by each user.
SELECT u.user_id, u.name, COUNT(uw.workout_id) AS total_workouts
FROM users u
LEFT JOIN user_workout uw ON u.user_id = uw.user_id
GROUP BY u.user_id, u.name;

-- Calculate average calories intake per user per month.
SELECT user_id, strftime('%Y-%m', date) AS month, AVG(calories) AS avg_calories
FROM calories_intake
GROUP BY user_id, month;

-- Find the top 5 most popular workouts based on user participation.
SELECT w.workout_id, w.workout_name, COUNT(uw.user_id) AS participation_count
FROM workouts w
JOIN user_workout uw ON w.workout_id = uw.workout_id
GROUP BY w.workout_id, w.workout_name
ORDER BY participation_count DESC
LIMIT 5;

-- Retrieve user progress over the last 6 months.
SELECT user_id, date, weight, body_fat_percentage, notes
FROM user_progress
WHERE date >= date('now', '-6 months');

-- Get all exercises targeting a specific muscle group.
SELECT exercise_id, exercise_name, description
FROM exercises
WHERE muscle_group = 'Chest';

-- Find users whose body fat percentage decreased over time.
SELECT DISTINCT up1.user_id, u.name
FROM user_progress up1
JOIN users u ON up1.user_id = u.user_id
WHERE up1.body_fat_percentage > (SELECT up2.body_fat_percentage FROM user_progress up2 WHERE up2.user_id = up1.user_id AND up2.date > up1.date LIMIT 1);

-- Get the last workout done by each user.
SELECT uw.user_id, u.name, w.workout_name, MAX(uw.date) AS last_workout_date
FROM user_workout uw
JOIN users u ON uw.user_id = u.user_id
JOIN workouts w ON uw.workout_id = w.workout_id
GROUP BY uw.user_id, u.name, w.workout_name;