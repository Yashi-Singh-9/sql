# RANK

`RANK()` is a **SQL window function** that assigns a rank to each row within a partition of a result set based on the ordering specified in the `ORDER BY` clause.

Unlike `ROW_NUMBER()`, the `RANK()` function allows **ties**. When multiple rows have the same value, they receive the same rank, and the next rank value is **skipped**.

---

## Key Characteristics

- Assigns ranks based on ordered values  
- Rows with equal values share the same rank  
- Skips rank numbers after ties  
- Works within a defined window using `OVER()`  

---

## Syntax

```sql
RANK() OVER (
    PARTITION BY column
    ORDER BY column
)
```

* **PARTITION BY** – (Optional) Divides rows into groups
* **ORDER BY** – Determines ranking order (required)

---

## Example

```sql id="t9rnk3"
SELECT
    department_id,
    employee_name,
    salary,
    RANK() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS salary_rank
FROM Employees;
```

This ranks employees by salary within each department.

---

## Example with Ties

If salaries are:

| Employee | Salary |
| -------- | ------ |
| A        | 5000   |
| B        | 4000   |
| C        | 4000   |
| D        | 3000   |

Using `RANK()`:

| Employee | Salary | Rank |
| -------- | ------ | ---- |
| A        | 5000   | 1    |
| B        | 4000   | 2    |
| C        | 4000   | 2    |
| D        | 3000   | 4    |

Notice that rank **3 is skipped**.

---

## RANK vs DENSE_RANK vs ROW_NUMBER

| Function   | Ties Share Rank | Gaps in Ranking |
| ---------- | --------------- | --------------- |
| ROW_NUMBER | ❌ No            | ❌ No            |
| RANK       | ✅ Yes           | ✅ Yes           |
| DENSE_RANK | ✅ Yes           | ❌ No            |

---

## Common Use Cases

* Ranking within groups
* Leaderboards with ties
* Performance comparisons
* Analytical and reporting queries

---

## Summary

`RANK()` is ideal when ranking data where ties are meaningful and skipped ranking positions are acceptable. It is widely used in analytical queries that require relative positioning within grouped datasets.