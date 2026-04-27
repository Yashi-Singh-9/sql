# FULL OUTER JOIN

A `FULL OUTER JOIN` in SQL combines the results of both `LEFT OUTER JOIN` and `RIGHT OUTER JOIN`. It returns **all rows from both tables**, including matching records as well as unmatched records from either table.

## Key Characteristics

- Returns **all records from both tables**
- Matches rows where the join condition is satisfied
- Displays `NULL` values for columns where no matching record exists in the other table

## When to Use FULL OUTER JOIN

`FULL OUTER JOIN` is especially useful when:
- You need to see **all data from both tables**
- Identifying **missing or unmatched relationships**
- Performing **data reconciliation** between two tables
- Comparing datasets to find overlaps and gaps

## Summary

`FULL OUTER JOIN` provides a complete view of data from both tables, making it ideal for comprehensive analysis and detecting inconsistencies across related datasets.
