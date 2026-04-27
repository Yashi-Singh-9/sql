# RIGHT JOIN

A `RIGHT JOIN` in SQL is a type of **outer join** that returns **all rows from the right (second) table** and the matching rows from the left (first) table. If there is no match in the left table, `NULL` values are returned for the left table’s columns.

## Key Characteristics

- Returns **all records from the right table**
- Returns **matching records from the left table**
- Displays `NULL` for left-table columns when no match exists

## When to Use RIGHT JOIN

Although less commonly used than `LEFT JOIN`, `RIGHT JOIN` is useful when:
- You need to ensure **all records from the second table** are included
- Identifying **missing relationships** in the first table
- Working with **lookup or reference tables**
- Ensuring complete coverage of values from a related table

## Summary

`RIGHT JOIN` allows you to preserve all rows from the right table while still incorporating related data from the left table when available, making it helpful for specific reporting and analysis scenarios.
