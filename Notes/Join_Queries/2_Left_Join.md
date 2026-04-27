# LEFT JOIN

A `LEFT JOIN` in SQL returns **all rows from the left (first) table** and the matching rows from the right (second) table. If there is no matching record in the right table, the result will contain `NULL` values for the columns from the right table.

## Key Characteristics

- Returns **all records from the left table**
- Returns **matching records from the right table**
- Displays `NULL` for right-table columns when no match exists

## When to Use LEFT JOIN

`LEFT JOIN` is especially useful when:
- You want to include **all records from a primary table**
- Identifying **missing or unmatched relationships**
- Creating reports that must show all main records, even if related data is absent
- Working with optional relationships between tables

## Summary

`LEFT JOIN` helps preserve all rows from the main table while still allowing related data to appear when available, making it a powerful tool for comprehensive data analysis and reporting.
