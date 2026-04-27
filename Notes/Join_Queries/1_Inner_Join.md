# INNER JOIN

An `INNER JOIN` in SQL is a type of join that returns only the records with **matching values in both tables**. It compares rows from the first table with rows from the second table and returns those that satisfy the join condition.

## Key Points to Consider

- `INNER JOIN` is the **default join type** in SQL  
  - If you use `JOIN` without specifying a type, SQL treats it as an `INNER JOIN`
- Returns **only matching rows** from both tables
- If no matching records exist, the result set is **empty**

## How INNER JOIN Works

The join operation evaluates the join condition (usually based on a related column such as a primary key and foreign key) and includes only the rows where the condition is true in both tables.

## Summary

`INNER JOIN` is commonly used when you need data that exists in **both tables**, making it one of the most frequently used joins in SQL queries.
