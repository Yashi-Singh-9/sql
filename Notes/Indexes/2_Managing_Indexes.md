# Managing Indexes

Managing indexes in SQL involves **creating, modifying, monitoring, and dropping indexes** to maintain optimal database performance. Effective index management ensures faster query execution while minimizing overhead on data modification operations.

## Key Index Management Activities

### Identifying Index Candidates
- Index columns frequently used in:
  - `WHERE` clauses
  - `JOIN` conditions
  - `ORDER BY` and `GROUP BY` clauses
- Avoid indexing columns with low selectivity unless necessary

### Creating Appropriate Index Types
Common index types include:
- **Single-column indexes** for simple lookups
- **Composite indexes** for queries filtering on multiple columns
- **Unique indexes** to enforce data uniqueness and improve lookup speed

### Monitoring Index Usage
- Analyze index usage to identify:
  - Unused or redundant indexes
  - Missing indexes that could improve performance
- Remove indexes that are not providing measurable benefits

### Balancing Performance Trade-offs
- Indexes improve `SELECT` performance
- Indexes add overhead to `INSERT`, `UPDATE`, and `DELETE` operations
- Balance read performance gains against write performance costs

### Index Maintenance
Regular maintenance helps keep indexes efficient:
- **Rebuild indexes** to eliminate fragmentation
- **Reorganize indexes** for minor fragmentation
- Perform maintenance as data volume and access patterns change

## Summary

Proper index management is essential for database performance tuning. By carefully selecting index candidates, choosing the right index types, monitoring usage, and performing regular maintenance, database administrators can ensure efficient query execution while minimizing unnecessary overhead.
