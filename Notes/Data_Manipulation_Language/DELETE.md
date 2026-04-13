# DELETE

The `DELETE` statement in SQL is used to remove one or more rows from a table. It is part of the **Data Manipulation Language (DML)** and is commonly used for data maintenance.

## Key Features of DELETE

- Removes **specific rows** using a `WHERE` clause  
- Can remove **all rows** if no condition is specified  
- Preserves the **table structure** after deletion  
- Supports transactions, allowing changes to be **rolled back** (in transactional databases)

## DELETE vs TRUNCATE

- `DELETE` without a `WHERE` clause removes all rows but **keeps the table structure**
- `TRUNCATE` removes all rows more quickly but **cannot be rolled back** in many systems

## Purpose

The `DELETE` statement is used to:
- Remove outdated or incorrect data  
- Maintain data accuracy  
- Implement business rules that require record removal

## Summary

`DELETE` provides controlled and flexible data removal, making it an essential command for managing data within relational databases.
