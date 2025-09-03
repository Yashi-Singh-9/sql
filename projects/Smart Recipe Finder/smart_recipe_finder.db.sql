-- MS SQL Project
CREATE DATABASE smart_recipe_finder

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(20) UNIQUE,
  email VARCHAR(20),
  password VARCHAR(20)
);

-- Recipes Table
CREATE TABLE recipes (
  recipe_id INT IDENTITY(1,1) PRIMARY KEY,
  recipe_name VARCHAR(20),
  description TEXT,
  user_id INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Ingredients Table
CREATE TABLE ingredients (
  ingredient_id INT IDENTITY(1,1) PRIMARY KEY,
  ingredient_name VARCHAR(20)
);

-- Recipe Ingredients Table
CREATE TABLE recipe_ingredients (
  recipe_id INT,
  ingredient_id INT,
  quantity INT,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

-- User Favorites Table
CREATE TABLE user_favorites (
  user_id INT,
  recipe_id INT,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

-- Categories Table
CREATE TABLE categories (
  category_id INT PRIMARY KEY,
  category_name VARCHAR(20)
);

-- Recipe Categories Table
CREATE TABLE recipe_categories (
  recipe_id INT,
  category_id INT,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);  

-- Insert Users
INSERT INTO users (username, email, password) VALUES
('john_doe', 'john@example.com', 'pass123'),
('jane_smith', 'jane@example.com', 'pass456'),
('chef_mike', 'mike@example.com', 'chefpass'),
('foodie_anna', 'anna@example.com', 'tastebuds'),
('mark_cook', 'mark@example.com', 'recipepro'),
('lucy_baker', 'lucy@example.com', 'sweettooth'),
('daniel_chef', 'daniel@example.com', 'spiceking'),
('emma_food', 'emma@example.com', 'yum123');

-- Insert Recipes
INSERT INTO recipes (recipe_name, description, user_id) VALUES
('Pasta Carbonara', 'Classic Italian pasta with eggs and bacon.', 1),
('Chicken Curry', 'Spicy Indian-style chicken curry.', 2),
('Chocolate Cake', 'Rich and moist chocolate cake.', 3),
('Caesar Salad', 'Fresh salad with crispy croutons and parmesan.', 4),
('Grilled Salmon', 'Healthy grilled salmon with lemon.', 5),
('Beef Tacos', 'Mexican-style beef tacos with salsa.', 6),
('Vegetable Stir Fry', 'Quick stir fry with fresh vegetables.', NULL),
('Mushroom Risotto', 'Creamy risotto with mushrooms.', NULL);

-- Insert Ingredients
INSERT INTO ingredients (ingredient_name) VALUES
('Pasta'),
('Eggs'),
('Bacon'),
('Chicken'),
('Curry Powder'),
('Chocolate'),
('Flour'),
('Butter');

-- Insert Recipe Ingredients
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity) VALUES
(1, 1, 200),  
(1, 2, 2),    
(1, 3, 100),  
(2, 4, 250),  
(2, 5, 15),   
(3, 6, 200),  
(3, 7, 250),  
(3, 8, 100);  

-- Insert User Favorites
INSERT INTO user_favorites (user_id, recipe_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(2, 4),
(3, 5),
(4, 6),
(5, 7),
(6, 8);

-- Insert Categories
INSERT INTO categories (category_id, category_name) VALUES
(1, 'Italian'),
(2, 'Indian'),
(3, 'Dessert'),
(4, 'Salad'),
(5, 'Seafood'),
(6, 'Mexican'),
(7, 'Vegetarian'),
(8, 'Rice Dishes');

-- Insert Recipe Categories
INSERT INTO recipe_categories (recipe_id, category_id) VALUES
(1, 1),  
(2, 2),  
(3, 3),  
(4, 4),  
(5, 5), 
(6, 6),  
(7, 7),  
(8, 8);  

-- Find all recipes that use a specific ingredient (e.g., "Tomato")
SELECT r.recipe_id, r.recipe_name 
FROM recipes r
JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE i.ingredient_name = 'Tomato';

-- Get the most popular recipes based on how many users have marked them as favorites
SELECT r.recipe_id, r.recipe_name, COUNT(uf.user_id) AS favorite_count
FROM recipes r
JOIN user_favorites uf ON r.recipe_id = uf.recipe_id
GROUP BY r.recipe_id, r.recipe_name
ORDER BY favorite_count DESC;

-- List all recipes created by a specific user
SELECT recipe_id, recipe_name 
FROM recipes r
JOIN users u ON r.user_id = u.user_id
WHERE u.username = 'john_doe';

-- Find recipes that belong to a specific category (e.g., "Vegan")
SELECT r.recipe_id, r.recipe_name 
FROM recipes r
JOIN recipe_categories rc ON r.recipe_id = rc.recipe_id
JOIN categories c ON rc.category_id = c.category_id
WHERE c.category_name = 'Vegan';

-- Show the top 5 most used ingredients across all recipes
SELECT TOP 5 i.ingredient_name, COUNT(ri.recipe_id) AS usage_count
FROM ingredients i
JOIN recipe_ingredients ri ON i.ingredient_id = ri.ingredient_id
GROUP BY i.ingredient_name
ORDER BY usage_count DESC;

-- Get a list of users who have favorited the same recipe
SELECT r.recipe_name, u.username 
FROM user_favorites uf
JOIN users u ON uf.user_id = u.user_id
JOIN recipes r ON uf.recipe_id = r.recipe_id
WHERE uf.recipe_id = (SELECT recipe_id FROM recipes WHERE recipe_name = 'Pasta Carbonara');

-- Find recipes that do not contain a specific ingredient (e.g., "Nuts")
SELECT r.recipe_id, r.recipe_name
FROM recipes r
WHERE r.recipe_id NOT IN (
    SELECT ri.recipe_id
    FROM recipe_ingredients ri
    JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
    WHERE i.ingredient_name = 'Nuts'
);

-- List all categories along with the count of recipes in each category
SELECT c.category_name, COUNT(rc.recipe_id) AS recipe_count
FROM categories c
LEFT JOIN recipe_categories rc ON c.category_id = rc.category_id
GROUP BY c.category_name
ORDER BY recipe_count DESC;

-- Find recipes that have at least three ingredients in common with another recipe
SELECT r1.recipe_name AS Recipe1, r2.recipe_name AS Recipe2, COUNT(*) AS common_ingredients
FROM recipe_ingredients ri1
JOIN recipe_ingredients ri2 ON ri1.ingredient_id = ri2.ingredient_id
JOIN recipes r1 ON ri1.recipe_id = r1.recipe_id
JOIN recipes r2 ON ri2.recipe_id = r2.recipe_id
WHERE r1.recipe_id <> r2.recipe_id
GROUP BY r1.recipe_name, r2.recipe_name
HAVING COUNT(*) >= 3;
