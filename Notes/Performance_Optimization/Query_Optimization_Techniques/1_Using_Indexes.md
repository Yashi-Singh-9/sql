# Using Indexes

Indexes in SQL are **database objects** that improve the speed of data retrieval operations on tables. They function much like an index in a book, enabling the database engine to locate rows quickly without scanning the entire table.

## How Indexes Improve Performance

- Provide fast lookup of rows based on column values  
- Reduce full table scans  
- Improve performance of `SELECT` queries, especially on large tables  

Indexes are particularly effective when used with:
- `WHERE` clauses
- `JOIN` conditions
- `ORDER BY` and `GROUP BY` clauses

## Common Types of Indexes

- **B-tree Indexes**  
  The default and most widely used index type; efficient for equality and range queries.

- **Bitmap Indexes**  
  Useful for columns with low cardinality (few distinct values), commonly used in data warehouses.

- **Full-Text Indexes**  
  Designed for efficient searching within large text fields.

## Trade-offs of Using Indexes

While indexes improve read performance, they also introduce overhead:
- Slower `INSERT`, `UPDATE`, and `DELETE` operations
- Additional storage requirements
- Increased maintenance effort

Balancing read performance and write overhead is essential.

## Best Practices for Using Indexes

- Index columns that are **frequently queried**
- Avoid indexing columns with low selectivity unless justified
- Do not over-index tables
- Regularly analyze query patterns and index usage
- Maintain indexes through rebuilding or reorganizing when needed

## Summary

Indexes are a powerful tool for SQL performance optimization. When used thoughtfully—based on query patterns, data distribution, and workload characteristics—they can dramatically improve query performance while maintaining an efficient and balanced database system.
