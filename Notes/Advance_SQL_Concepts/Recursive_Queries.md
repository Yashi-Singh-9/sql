# Recursive Queries

Recursive queries in SQL allow a query to **reference itself**, enabling traversal of **hierarchical or tree-like data structures**. They are especially useful for working with self-referential data where records are related in parent–child relationships.

Recursive queries are commonly implemented using **recursive Common Table Expressions (CTEs)**.

---

## When to Use Recursive Queries

Recursive queries are ideal for handling:
- Organizational hierarchies (employees and managers)
- Bill of materials (products and components)
- Category trees
- Folder structures
- Network or graph-like relationships

---

## How Recursive Queries Work

A recursive query consists of two main parts:

### 1. Anchor Member
- The **base query**
- Returns the initial rows (starting point of recursion)

### 2. Recursive Member
- References the CTE itself
- Repeatedly executes to retrieve child rows
- Continues until no more rows are returned

---

## Basic Structure

```sql
WITH RECURSIVE cte_name AS (
    -- Anchor member
    SELECT columns
    FROM table
    WHERE condition

    UNION ALL

    -- Recursive member
    SELECT columns
    FROM table
    JOIN cte_name ON condition
)
SELECT * FROM cte_name;
```
---

## Example: Employee Hierarchy

```sql
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT employee_id, name, manager_id
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, e.name, e.manager_id
    FROM Employees e
    JOIN EmployeeHierarchy eh
        ON e.manager_id = eh.employee_id
)
SELECT * FROM EmployeeHierarchy;
```

This retrieves all employees along with their hierarchical relationships.

---

## Key Characteristics

* Executes iteratively until no new rows are found
* Can traverse **multiple levels of depth**
* Eliminates the need for complex self-joins
* Supports depth-first or breadth-first traversal (depending on query design)

---

## Performance Considerations

* Ensure proper indexing on join columns
* Use safeguards (e.g., depth limits) to prevent infinite recursion
* Recursive queries can be expensive on very deep hierarchies

---

## Summary

Recursive queries provide a powerful and elegant way to work with hierarchical and self-referential data in SQL. By combining an anchor query with a recursive definition, they enable efficient traversal of complex data structures that are difficult to handle using standard SQL techniques.
