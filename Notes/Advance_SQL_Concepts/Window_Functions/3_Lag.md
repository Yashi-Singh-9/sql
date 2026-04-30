# LAG

`LAG()` is a **SQL window function** that allows you to access data from a row that comes **before the current row** within a partition. It is commonly used to compare current values with previous values without using self-joins.

`LAG()` is especially useful for time-series analysis, trend detection, and calculating differences between sequential records.

---

## Key Characteristics

- Looks backward to a previous row  
- Works within a defined window using `OVER()`  
- Does not reduce the number of rows returned  
- Eliminates the need for self-joins for sequential comparisons  

---

## Syntax

```sql
LAG(column, offset, default_value)
OVER (
    PARTITION BY column
    ORDER BY column
)
```

### Parameters

* **column** – The column to retrieve from the previous row
* **offset** – Number of rows backward to look (default = 1)
* **default_value** – Returned if the offset exceeds partition boundary

---

## Example 1: Comparing Current and Previous Salary

```sql 
SELECT
    employee_name,
    salary,
    LAG(salary) OVER (ORDER BY salary) AS previous_salary
FROM Employees;
```

This retrieves the previous salary for comparison.

---

## Example 2: Calculating Running Difference

```sql 
SELECT
    order_date,
    amount,
    amount - LAG(amount) OVER (ORDER BY order_date) AS difference
FROM Orders;
```

This calculates the difference between the current amount and the previous amount.

---

## Common Use Cases

* Calculating period-over-period growth
* Identifying trends
* Comparing sequential data
* Detecting changes between records
* Time-series analysis

---

## LAG vs LEAD

| Function | Direction | Use Case                  |
| -------- | --------- | ------------------------- |
| LAG      | Backward  | Compare with previous row |
| LEAD     | Forward   | Compare with next row     |

---

## Summary

`LAG()` is a powerful window function that enables backward-looking comparisons within ordered data. It simplifies sequential analysis and eliminates the need for complex self-joins, making it essential for analytical SQL queries.