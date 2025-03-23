CREATE DATABASE RecipeBox;

-- Users Table 
CREATE TABLE users (
  user_id INT IDENTITY(1,1) PRIMARY KEY,
  username VARCHAR(50),
  email VARCHAR(50),
  password VARCHAR(50)
);

-- Recipes Table 
CREATE TABLE recipes (
  recipe_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  recipe_name VARCHAR(50),
  created_at DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
  
-- Ingredients Table 
CREATE TABLE ingredients (
  ingredient_id INT IDENTITY(1,1) PRIMARY KEY,
  ingredient_name VARCHAR(50)
);

-- Recipe Ingredients Table 
CREATE TABLE recipe_ingredients (
  recipe_id INT,
  ingredient_id  INT,
  quantity INT,
  unit VARCHAR(20),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
  FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id)
);

-- Categories Table 
CREATE TABLE categories (
  category_id INT IDENTITY(1,1) PRIMARY KEY,
  category_name VARCHAR(50)
);

-- Recipe Categories Table
CREATE TABLE recipe_categories (
  recipe_id INT,
  category_id INT,
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id),
  FOREIGN KEY (category_id) REFERENCES categories(category_id)
);  

-- Comments Table 
CREATE TABLE comments (
  comment_id INT IDENTITY(1,1) PRIMARY KEY,
  user_id INT,
  recipe_id INT,
  comment_text TEXT,
  comment_date DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

-- Favorites Table 
CREATE TABLE favorites (
  user_id INT,
  recipe_id INT, 
  added_at DATE,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);  

-- Insert sample users
INSERT INTO users (username, email, password) VALUES 
('john_doe', 'john@example.com', 'password123'),
('jane_smith', 'jane@example.com', 'securepass'),
('alice_wonder', 'alice@example.com', 'alicepass');

-- Insert sample recipes
INSERT INTO recipes (user_id, recipe_name, created_at) VALUES 
(1, 'Spaghetti Bolognese', '2024-02-01'),
(2, 'Chocolate Cake', '2024-02-05'),
(3, 'Chicken Curry', '2024-02-10');

-- Insert sample ingredients
INSERT INTO ingredients (ingredient_name) VALUES 
('Spaghetti'),
('Ground Beef'),
('Tomato Sauce'),
('Chocolate'),
('Flour'),
('Chicken'),
('Curry Powder');

-- Insert sample recipe ingredients
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES 
(1, 1, 200, 'grams'), 
(1, 2, 300, 'grams'), 
(1, 3, 1, 'cup'), 
(2, 4, 200, 'grams'), 
(2, 5, 2, 'cups'),
(3, 6, 500, 'grams'), 
(3, 7, 2, 'tablespoons'); 

-- Insert sample categories
INSERT INTO categories (category_name) VALUES 
('Italian'),
('Dessert'),
('Indian');

-- Insert sample recipe categories
INSERT INTO recipe_categories (recipe_id, category_id) VALUES 
(1, 1), 
(2, 2), 
(3, 3); 

-- Insert sample comments
INSERT INTO comments (user_id, recipe_id, comment_text, comment_date) VALUES 
(2, 1, 'Delicious recipe! My family loved it.', '2024-02-02'),
(3, 2, 'The best chocolate cake I’ve ever made!', '2024-02-06'),
(1, 3, 'Nice and spicy, just the way I like it!', '2024-02-11');

-- Insert sample favorites
INSERT INTO favorites (user_id, recipe_id, added_at) VALUES 
(1, 2, '2024-02-06'), 
(2, 3, '2024-02-11'), 
(3, 1, '2024-02-02'); 

-- Find all recipes created by a specific user.
SELECT recipe_id, recipe_name, created_at 
FROM recipes 
WHERE user_id = 1;

-- List all ingredients used in a specific recipe.
SELECT i.ingredient_name, ri.quantity, ri.unit 
FROM recipe_ingredients ri
JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE ri.recipe_id = 1;

-- Get all recipes that belong to a specific category.
SELECT r.recipe_id, r.recipe_name, r.created_at
FROM recipes r
JOIN recipe_categories rc ON r.recipe_id = rc.recipe_id
WHERE rc.category_id = 2;

-- Find the most popular recipe based on the number of favorites.
SELECT TOP 1 r.recipe_id, r.recipe_name, COUNT(f.user_id) AS favorite_count
FROM recipes r
JOIN favorites f ON r.recipe_id = f.recipe_id
GROUP BY r.recipe_id, r.recipe_name
ORDER BY favorite_count DESC;

-- List all users who have commented on a specific recipe.
SELECT DISTINCT u.user_id, u.username, u.email 
FROM users u
JOIN comments c ON u.user_id = c.user_id
WHERE c.recipe_id = 1;

-- Get the latest 5 recipes added.
SELECT TOP 5 recipe_id, recipe_name, created_at 
FROM recipes 
ORDER BY created_at DESC;

-- Find recipes that do not have any ingredients.
SELECT r.recipe_id, r.recipe_name
FROM recipes r
LEFT JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id
WHERE ri.recipe_id IS NULL;

-- Retrieve recipes that belong to multiple categories (e.g., "Dessert" and "Vegan").
SELECT r.recipe_id, r.recipe_name
FROM recipes r
JOIN recipe_categories rc1 ON r.recipe_id = rc1.recipe_id
JOIN recipe_categories rc2 ON r.recipe_id = rc2.recipe_id
WHERE rc1.category_id = (SELECT category_id FROM categories WHERE category_name = 'Dessert')
AND rc2.category_id = (SELECT category_id FROM categories WHERE category_name = 'Vegan');

-- Find all recipes that use a specific ingredient (e.g., "Tomato").
SELECT r.recipe_id, r.recipe_name
FROM recipes r
JOIN recipe_ingredients ri ON r.recipe_id = ri.recipe_id
JOIN ingredients i ON ri.ingredient_id = i.ingredient_id
WHERE i.ingredient_name = 'Tomato';

-- List all recipes along with the number of comments they have received.
SELECT r.recipe_id, r.recipe_name, COUNT(c.comment_id) AS comment_count
FROM recipes r
LEFT JOIN comments c ON r.recipe_id = c.recipe_id
GROUP BY r.recipe_id, r.recipe_name
ORDER BY comment_count DESC;