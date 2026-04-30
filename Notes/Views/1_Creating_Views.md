# Creating Views

Creating views in SQL is done using the `CREATE VIEW` statement, which defines a **virtual table** based on the result of a `SELECT` query. Views do not store data themselves; instead, they dynamically present data from one or more underlying tables.

## Key Characteristics

- Views are based on the result of a **SELECT query**
- They do **not store data** (unless materialized)
- Can be queried just like regular tables
- Provide a layer of abstraction over base tables

## Benefits of Creating Views

Views are useful for:
- **Simplifying complex queries** by encapsulating joins and filters
- **Enhancing security** by limiting access to specific columns or rows
- **Reusing common query logic**
- Presenting data in a **consistent and user-friendly format**

## Common Use Cases

- Encapsulating business logic
- Creating standardized reporting structures
- Restricting user access to sensitive data
- Improving maintainability of SQL code

## Summary

The `CREATE VIEW` statement allows developers to define reusable, secure, and readable virtual tables. Views help streamline querying, enforce data access rules, and provide a clean interface for working with complex data relationships.
