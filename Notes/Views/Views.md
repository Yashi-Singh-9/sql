# Views

Views in SQL are **virtual tables** created from the result set of an SQL query. They do not store data themselves (unless materialized) but instead act as **saved queries** that can be queried like regular tables.

## Key Benefits of Views

- **Simplify complex queries** by encapsulating joins, filters, and subqueries  
- **Enhance security** by restricting direct access to underlying tables  
- **Present data in a user-friendly format** tailored for specific users or applications  

## Types of Views

### Simple Views
- Based on a **single table**
- Typically do not include complex logic

### Complex Views
- May involve **multiple tables**, joins, subqueries, or functions
- Used for advanced data representation and reporting

### Updatable Views
- Supported by some databases
- Allow `INSERT`, `UPDATE`, or `DELETE` operations that affect the underlying tables (with certain restrictions)

### Materialized Views
- Store the **actual query results**
- Improve performance for frequently accessed data
- Require additional **storage** and **maintenance**

## Use Cases

Views are commonly used for:
- Reporting and analytics
- Enforcing data access rules
- Reusing complex query logic
- Improving maintainability of SQL code

## Summary

Views are a powerful SQL feature that improve query readability, security, and data abstraction. They enable flexible data access while keeping the underlying schema protected and manageable.
