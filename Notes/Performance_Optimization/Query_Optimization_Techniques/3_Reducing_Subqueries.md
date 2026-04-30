# Reducing Subqueries

Reducing subqueries is an important SQL optimization technique, especially when working with complex logic or large datasets. Poorly structured subqueries—particularly correlated ones—can significantly impact performance.

## Why Subqueries Can Hurt Performance

- **Correlated subqueries** execute once for every row in the outer query  
- Repeated execution increases CPU and I/O usage  
- Large datasets amplify the performance cost  

## Optimization Techniques

### Replace Subqueries with JOINs
Many subqueries can be rewritten using `JOIN` operations, which are often more efficient because:
- The optimizer can better determine execution strategies
- Joins are typically processed in a set-based manner
- Indexes are utilized more effectively

**Instead of:**
```sql
SELECT name
FROM Employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE department_id = e.department_id
);
```

**Consider rewriting with a JOIN:**

```sql
SELECT e.name
FROM Employees e
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department_id
) d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;
```

### Use Common Table Expressions (CTEs)

If a subquery is reused multiple times, replace it with a **CTE**:

* Improves readability
* Avoids repeating the same logic
* Helps structure complex queries

```sql
WITH DeptAvg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM Employees
    GROUP BY department_id
)
SELECT e.name
FROM Employees e
JOIN DeptAvg d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary;
```

---

### Limit Subquery Result Sets

* Use `LIMIT`, `TOP`, or filtering conditions
* Avoid returning unnecessary columns
* Reduce the number of rows processed

---

### Use Temporary Tables for Expensive Logic

For costly or frequently reused subqueries:

* Store results in **temporary tables**
* Reuse the computed dataset
* Reduce repeated computation

---

### Analyze Execution Plans

Always verify improvements by:

* Reviewing execution plans
* Checking for repeated scans
* Monitoring query cost and runtime

---

## Summary

Reducing subqueries improves SQL performance by minimizing repeated executions and enabling better optimization strategies. Replacing correlated subqueries with joins, using CTEs for modular logic, limiting result sets, and leveraging temporary tables are effective techniques for building efficient, scalable queries.
