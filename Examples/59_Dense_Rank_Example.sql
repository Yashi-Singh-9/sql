-- Use DENSE_RANK function in employees table
-- This function is used to assign ranking without skipping numbers

-- Table used:
-- employees → stores employee details like id, name, department, salary

-- Rank employees based on salary
SELECT name, salary,
DENSE_RANK() OVER (ORDER BY salary DESC) AS rank_position
FROM employees;

-- Rank within department
SELECT name, department, salary,
DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank
FROM employees;

-- Explanation
-- DENSE_RANK() → assigns rank to each row
-- OVER() → defines ranking logic
-- ORDER BY salary DESC → highest salary gets rank 1
-- PARTITION BY department → separate ranking per department

-- Important Note:
-- Same values get same rank
-- Does NOT skip rank numbers after tie
-- Difference from RANK(): no gaps in ranking

-- Example Table Data

-- | id | name  | department | salary |
-- | -- | ----- | ---------- | ------ |
-- | 1  | Rahul | IT         | 60000  |
-- | 2  | Anita | IT         | 60000  |
-- | 3  | Ravi  | HR         | 45000  |
-- | 4  | Mohan | HR         | 40000  |

-- Example Output (Global Rank)

-- | name  | salary | rank_position |
-- | ----- | ------ | ------------- |
-- | Rahul | 60000  | 1             |
-- | Anita | 60000  | 1             |
-- | Ravi  | 45000  | 2             |
-- | Mohan | 40000  | 3             |

-- Example Output (Department Rank)

-- | name  | department | salary | dept_rank |
-- | ----- | ---------- | ------ | --------- |
-- | Rahul | IT         | 60000  | 1         |
-- | Anita | IT         | 60000  | 1         |
-- | Ravi  | HR         | 45000  | 1         |
-- | Mohan | HR         | 40000  | 2         |