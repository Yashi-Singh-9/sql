# Data Integrity Constraints

SQL **constraints** are rules applied to tables or columns to ensure the **accuracy, consistency, and reliability** of data stored in a database. If an operation violates a defined constraint, the database **rejects the action**, preventing invalid data from being inserted, updated, or deleted.

## Purpose of Constraints

Constraints help to:
- Enforce **data integrity**
- Prevent invalid or inconsistent data
- Maintain **business rules** at the database level
- Ensure reliable relationships between tables

## Types of Constraints

### Column-Level Constraints
- Applied to **individual columns**
- Affect only the column on which they are defined
- Common examples include:
  - `NOT NULL`
  - `UNIQUE`
  - `CHECK`
  - Single-column `PRIMARY KEY`

### Table-Level Constraints
- Applied to the **entire table**
- Can involve **one or more columns**
- Common examples include:
  - Composite `PRIMARY KEY`
  - `FOREIGN KEY`
  - Multi-column `UNIQUE`
  - Table-level `CHECK` constraints

## Common SQL Constraints

- **PRIMARY KEY** – Uniquely identifies each row  
- **FOREIGN KEY** – Maintains referential integrity between tables  
- **UNIQUE** – Ensures all values in a column or set of columns are distinct  
- **NOT NULL** – Prevents NULL values in a column  
- **CHECK** – Enforces custom conditions on data  
- **DEFAULT** – Assigns a default value when none is provided  

## Summary

Data integrity constraints are essential for maintaining high-quality data in SQL databases. By effectively using column-level and table-level constraints, databases can automatically enforce rules, prevent errors, and ensure long-term data accuracy and consistency.