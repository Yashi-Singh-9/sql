# JOINs

SQL `JOIN` clauses are used to combine rows from two or more tables based on a related column between them. JOINs enable retrieving data from multiple tables in a single query, making them essential for complex data analysis and reporting.

## Types of SQL JOINs

### INNER JOIN
Returns only the rows that have matching values in both tables.

### LEFT JOIN
Returns all rows from the left table and the matching rows from the right table. If there is no match, NULL values are returned for the right table.

### RIGHT JOIN
Returns all rows from the right table and the matching rows from the left table. This is the opposite of a LEFT JOIN.

### FULL JOIN
Returns all rows when there is a match in either the left or right table. Rows without matches in the other table will still be included with NULL values.

## Summary

JOINs are fundamental to relational database operations, enabling data integration and exploration across related datasets stored in multiple tables.
