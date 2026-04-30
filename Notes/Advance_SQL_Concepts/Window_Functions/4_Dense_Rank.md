# DENSE_RANK

`DENSE_RANK()` is a **SQL window function** that assigns a rank to each row within a partition of a result set, **without gaps in ranking numbers**.

Unlike `RANK()`, `DENSE_RANK()` does **not skip ranking positions** when there are ties.

---

## Key Characteristics

- Assigns ranks based on ordered values  
- Rows with equal values receive the same rank  
- Does **not** leave gaps after ties  
- Works within a defined window using `OVER()`  

---

## Syntax

```sql
DENSE_RANK() OVER (
    PARTITION BY column
    ORDER BY column
)
```

* **PARTITION BY** – Divides rows into groups (optional)
* **ORDER BY** – Defines ranking order (required)

---

## Example

```sql id="x92ldk"
SELECT
    employee_name,
    salary,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM Employees;
```

This ranks employees by salary in descending order.

---

## Example with Ties

If salaries are:

| Employee | Salary |
| -------- | ------ |
| A        | 5000   |
| B        | 4000   |
| C        | 4000   |
| D        | 3000   |

Using `DENSE_RANK()`:

| Employee | Salary | Rank |
| -------- | ------ | ---- |
| A        | 5000   | 1    |
| B        | 4000   | 2    |
| C        | 4000   | 2    |
| D        | 3000   | 3    |

Notice there is **no gap** after rank 2.

---

## DENSE_RANK vs RANK vs ROW_NUMBER

| Function   | Ties Share Rank | Gaps in Ranking |
| ---------- | --------------- | --------------- |
| ROW_NUMBER | ❌ No            | ❌ No            |
| RANK       | ✅ Yes           | ✅ Yes           |
| DENSE_RANK | ✅ Yes           | ❌ No            |

---

## Common Use Cases

* Ranking with no skipped positions
* Leaderboards
* Sales rankings
* Performance comparisons
* Analytical reporting

---

## Summary

`DENSE_RANK()` is a ranking window function that assigns equal ranks to equal values while maintaining continuous ranking numbers. It is ideal for scenarios where ties should not create gaps in ranking positions.
