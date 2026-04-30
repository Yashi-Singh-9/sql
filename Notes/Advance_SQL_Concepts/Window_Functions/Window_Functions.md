# Window Functions

SQL **window functions** allow you to perform calculations across a set of rows that are related to the current row. This related set of rows is called a **window**.

They are called *window functions* because they operate over a “window” of rows—similar to a sliding window—without collapsing the result into a single grouped row.

---

## Key Characteristics

- Operate across a set of related rows
- Do **not** reduce the number of rows returned (unlike `GROUP BY`)
- Use the `OVER()` clause to define the window
- Commonly used in analytics and reporting

---

## Basic Syntax

```sql
FUNCTION_NAME(column)
OVER (
    PARTITION BY column
    ORDER BY column
)
```

* **PARTITION BY** – Divides rows into groups (like GROUP BY, but without collapsing rows)
* **ORDER BY** – Defines row order within each partition
* **ROWS / RANGE** – Defines the frame (optional advanced clause)

---

## Common Window Functions

### Ranking Functions

* `ROW_NUMBER()` – Assigns a unique number to each row
* `RANK()` – Assigns rank with gaps
* `DENSE_RANK()` – Assigns rank without gaps

### Aggregate Window Functions

* `SUM()`
* `AVG()`
* `COUNT()`
* `MIN()`
* `MAX()`

### Analytical Functions

* `LEAD()` – Access next row value
* `LAG()` – Access previous row value
* `FIRST_VALUE()`
* `LAST_VALUE()`

---

## Example 1: Ranking Employees by Salary

```sql
SELECT 
    name,
    salary,
    RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Employees;
```

This ranks employees without grouping them.

---

## Example 2: Running Total

```sql
SELECT 
    order_date,
    amount,
    SUM(amount) OVER (ORDER BY order_date) AS running_total
FROM Orders;
```

This calculates a cumulative total without reducing rows.

---

## Window Functions vs GROUP BY

| Feature            | Window Function | GROUP BY |
| ------------------ | --------------- | -------- |
| Reduces rows       | ❌ No            | ✅ Yes    |
| Keeps detail rows  | ✅ Yes           | ❌ No     |
| Used for analytics | ✅ Yes           | Limited  |

---

## Summary

Window functions are powerful tools for analytical queries. They allow calculations across related rows while preserving individual row details, making them essential for ranking, running totals, moving averages, and advanced reporting tasks.