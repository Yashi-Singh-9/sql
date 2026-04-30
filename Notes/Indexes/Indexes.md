# Indexes

Indexes in SQL are **database objects** used to improve the speed of data retrieval operations on tables. They function similarly to an index in a book, allowing the database engine to quickly locate rows based on column values instead of scanning the entire table.

## How Indexes Work

- Indexes create a **separate data structure** (often a B-tree)
- They enable faster lookup of records for specific column values
- Reduce the need for full table scans during query execution

## Benefits of Indexes

Indexes are especially useful for:
- Speeding up `SELECT` queries
- Improving performance of `WHERE`, `JOIN`, `ORDER BY`, and `GROUP BY` clauses
- Optimizing queries on **large tables**
- Enhancing performance on **frequently queried columns**

## Limitations and Trade-offs

While indexes improve read performance, they also have downsides:
- Slower `INSERT`, `UPDATE`, and `DELETE` operations due to index maintenance
- Additional **storage space** required
- Poorly designed indexes can negatively impact performance

## Best Practices

- Index columns that are frequently searched or joined
- Avoid over-indexing tables
- Regularly monitor and optimize indexes as data grows

## Summary

Indexes are a critical performance optimization tool in SQL databases. When designed and used correctly, they significantly enhance query performance, especially for large and complex datasets, while requiring careful balance to avoid unnecessary overhead.
