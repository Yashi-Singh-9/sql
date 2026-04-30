# CTEs (Common Table Expressions)

**Common Table Expressions (CTEs)** in SQL are **named temporary result sets** that exist only for the duration of a single SQL statement. They are defined using the `WITH` clause and act like **virtual tables** that can be referenced multiple times within a query.

CTEs are widely used to improve query readability, simplify complex logic, and support recursive queries.

---

## Key Characteristics of CTEs

- Defined using the `WITH` clause  
- Exist only during query execution  
- Can be referenced multiple times within the same statement  
- Improve readability and maintainability  
- Support **recursive queries**  

---

## Basic Syntax

```sql
WITH cte_name AS (
    SELECT columns
    FROM table
    WHERE condition
)
SELECT *
FROM cte_name;
```

---

## Why Use CTEs

CTEs are particularly useful for:

* Breaking **complex queries** into logical steps
* Replacing nested subqueries
* Reusing query logic within a single statement
* Enhancing query clarity and structure
* Supporting hierarchical or recursive data traversal

---

## Example: Simplifying a Query

```sql
WITH HighSalaryEmployees AS (
    SELECT employee_id, name, salary
    FROM Employees
    WHERE salary > 70000
)
SELECT *
FROM HighSalaryEmployees;
```

This makes the query easier to read and maintain.

---

## Recursive CTEs

CTEs can reference themselves, enabling **recursive queries** for hierarchical or graph-like data.

```sql id="xv92dp"
WITH RECURSIVE OrgHierarchy AS (
    SELECT employee_id, name, manager_id
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, e.name, e.manager_id
    FROM Employees e
    JOIN OrgHierarchy o
        ON e.manager_id = o.employee_id
)
SELECT * FROM OrgHierarchy;
```

---

## Performance Considerations

* CTEs improve readability but do not always improve performance
* Some databases materialize CTEs, others inline them
* Execution plans should be reviewed for performance-critical queries

---

## CTEs vs Subqueries vs Temporary Tables

| Feature           | CTE          | Subquery | Temp Table |
| ----------------- | ------------ | -------- | ---------- |
| Readability       | High         | Low      | Medium     |
| Reusability       | Within query | Limited  | Yes        |
| Persistence       | No           | No       | Yes        |
| Recursive Support | Yes          | No       | No         |

---

## Summary

CTEs are a powerful SQL feature that make complex queries easier to write, read, and maintain. They are essential for recursive logic, hierarchical data processing, and structured query design in modern SQL applications.