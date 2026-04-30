# LEAD

`LEAD()` is a **SQL window function** that allows you to access data from a row that comes **after the current row** within a partition. It is commonly used to compare current values with future values in ordered datasets.

It is the counterpart of `LAG()`, which looks backward instead of forward.

---

## Key Characteristics

- Looks ahead to a future row
- Works within a defined window (`OVER()` clause)
- Does not reduce the number of rows returned
- Useful for trend analysis and comparisons

---

## Syntax

```sql
LEAD(column, offset, default_value)
OVER (
    PARTITION BY column
    ORDER BY column
)
```

### Parameters

* **column** – The column to retrieve from the future row
* **offset** – Number of rows forward to look (default = 1)
* **default_value** – Returned if the offset exceeds partition boundary

---

## Example 1: Comparing Current and Next Salary

```sql
SELECT
    employee_name,
    salary,
    LEAD(salary) OVER (ORDER BY salary) AS next_salary
FROM Employees;
```

This retrieves the next salary in order for comparison.

---

## Example 2: Calculating Difference Between Consecutive Values

```sql id="k92ncd"
SELECT
    order_date,
    amount,
    LEAD(amount) OVER (ORDER BY order_date) - amount AS difference
FROM Orders;
```

This calculates the difference between the current row’s amount and the next row’s amount.

---

## Common Use Cases

* Comparing current and next values
* Calculating forward growth
* Detecting changes between sequential records
* Time-series analysis
* Identifying gaps in ordered data

---

## LEAD vs LAG

| Function | Direction | Use Case                  |
| -------- | --------- | ------------------------- |
| LEAD     | Forward   | Compare with next row     |
| LAG      | Backward  | Compare with previous row |

---

## Summary

`LEAD()` is a powerful window function used to access future rows within a partition. It is particularly useful for forward-looking analysis, trend calculations, and comparing sequential data in SQL queries.
