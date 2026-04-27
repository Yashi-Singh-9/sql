# JOIN Queries

SQL `JOIN` queries are used to combine rows from two or more tables based on a related column between them. JOINs are fundamental in relational databases, enabling data retrieval across multiple related tables in a single query.

## Types of JOINs

### INNER JOIN
Returns only the rows that have matching values in both tables.

### LEFT JOIN (LEFT OUTER JOIN)
Returns all rows from the left table and the matching rows from the right table. If there is no match, `NULL` values are returned for columns from the right table.

### RIGHT JOIN (RIGHT OUTER JOIN)
Returns all rows from the right table and the matching rows from the left table. If there is no match, `NULL` values are returned for columns from the left table.

### FULL JOIN (FULL OUTER JOIN)
Returns all rows when there is a match in either the left or the right table. Rows without matches in the other table will contain `NULL` values.

## Importance of JOINs

JOIN queries allow users to:
- Retrieve data from **multiple tables** in a single query  
- Establish and work with **relationships between tables**  
- Perform **complex data analysis** across related datasets  

## Summary

JOINs are essential for leveraging the full power of relational databases, making it possible to efficiently query and analyze data spread across multiple related tables.
