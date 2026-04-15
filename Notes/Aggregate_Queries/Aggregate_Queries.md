# Aggregate Queries

Aggregate queries in SQL are used to perform calculations on multiple rows of data, returning a **single summary value** or **grouped results**. They typically involve **aggregate functions** and clauses like `GROUP BY` and `HAVING`.

## Common Aggregate Functions

- **COUNT()** – Returns the number of rows that match a specific condition  
- **SUM()** – Calculates the total sum of a numeric column  
- **AVG()** – Computes the average value of a numeric column  
- **MIN() / MAX()** – Finds the smallest or largest value in a column, respectively  

## GROUP BY

- Groups rows that share a common value in one or more columns  
- Allows aggregate functions to be applied **to each group**  

## HAVING

- Filters the results of a `GROUP BY` query based on a specified condition  
- Works like `WHERE`, but operates **on groups** rather than individual rows  

## Summary

Aggregate queries are essential for generating **summary statistics**, performing **data analysis**, and creating **grouped insights** from relational database tables.
