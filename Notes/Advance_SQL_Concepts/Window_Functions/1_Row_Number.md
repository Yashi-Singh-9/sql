# ROW_NUMBER

`ROW_NUMBER()` is a **SQL window function** that assigns a **unique, sequential integer** to each row within a specified partition of a result set. The numbering always starts at **1** for each partition and increases sequentially based on the defined order.

## Key Characteristics

- Assigns a **unique row number** to each row  
- Restarts numbering for each `PARTITION BY` group  
- Requires an `ORDER BY` clause to define row sequence  
- Does not assign the same number to ties (unlike `RANK` or `DENSE_RANK`)

## Basic Syntax

```sql
ROW_NUMBER() OVER (
    PARTITION BY column
    ORDER BY column
)
```

* **PARTITION BY** – (Optional) Divides rows into groups
* **ORDER BY** – Determines the order in which row numbers are assigned

## Common Use Cases

`ROW_NUMBER()` is commonly used for:

* Creating **row identifiers**
* Implementing **pagination**
* Finding the **nth highest or lowest value** in a group
* Removing duplicate rows
* Ranking data where unique ordering is required

## Example: Ranking Rows Within a Group

```sql
SELECT
    department_id,
    employee_name,
    ROW_NUMBER() OVER (
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS row_num
FROM Employees;
```

This assigns a unique row number to employees within each department based on salary.

## ROW_NUMBER vs Other Ranking Functions

| Function   | Handles Ties | Skips Numbers |
| ---------- | ------------ | ------------- |
| ROW_NUMBER | ❌ No         | ❌ No          |
| RANK       | ✅ Yes        | ✅ Yes         |
| DENSE_RANK | ✅ Yes        | ❌ No          |

## Summary

`ROW_NUMBER()` is a versatile window function used to uniquely number rows within ordered partitions. It is especially useful for pagination, ranking, and precise row-level analysis in SQL queries.