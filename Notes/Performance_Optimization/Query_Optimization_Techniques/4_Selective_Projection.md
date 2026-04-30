# Selective Projection

Selective projection in SQL refers to selecting **only the specific columns needed** from a table or query result, rather than retrieving all columns using `SELECT *`.

This technique improves **performance, clarity, and efficiency**, especially when working with large tables or complex joins.

---

## Why Selective Projection Matters

### 1. Improved Performance
- Reduces the amount of data read from disk
- Lowers memory usage
- Minimizes network transfer between database and application

### 2. Faster Query Execution
- Smaller result sets are processed more quickly
- Sorting and grouping operations become more efficient

### 3. Better Index Utilization
- Enables covering indexes (when all requested columns are in the index)
- Reduces the need to access the base table

### 4. Improved Readability and Maintainability
- Makes queries clearer
- Explicitly documents required data
- Prevents unexpected issues if table structure changes

---

## Avoid Using `SELECT *`

Using `SELECT *`:

- Retrieves unnecessary columns
- Increases I/O cost
- Breaks application logic if new columns are added
- Reduces clarity

---

## Example

### ❌ Not Recommended
```sql
SELECT *
FROM Employees;
```

### ✅ Recommended

```sql
SELECT employee_id, name, department_id
FROM Employees;
```

Only the required columns are retrieved, making the query more efficient and easier to understand.

---

## Best Practices

* Always explicitly list required columns
* Combine selective projection with proper indexing
* Use it consistently in joins and subqueries
* Review queries in performance-critical systems

---

## Summary

Selective projection is a simple yet powerful optimization technique. By retrieving only necessary columns, you reduce system load, improve performance, and create cleaner, more maintainable SQL queries.