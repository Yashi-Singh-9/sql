# HAVING

The `HAVING` clause is used in SQL together with the `GROUP BY` clause to filter grouped results. It allows you to apply conditions to **aggregate functions** such as `SUM`, `COUNT`, `AVG`, `MAX`, and `MIN`.

## Key Differences: HAVING vs WHERE

- **WHERE**
  - Applies conditions to **individual rows**
  - Filters data *before* grouping occurs

- **HAVING**
  - Applies conditions to **groups of rows**
  - Filters data *after* the `GROUP BY` operation
  - Works with **aggregate functions**

## Purpose

The `HAVING` clause is used when you need to filter summarized or aggregated data that cannot be filtered using the `WHERE` clause.

## Summary

- `WHERE` → filters individual records  
- `GROUP BY` → groups records  
- `HAVING` → filters grouped (summarized) records  

Together, these clauses enable powerful and precise data analysis in SQL.
