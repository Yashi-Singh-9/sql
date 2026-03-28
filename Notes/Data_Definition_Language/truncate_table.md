# TRUNCATE TABLE

The `TRUNCATE TABLE` statement is a **Data Definition Language (DDL)** operation used to remove all data from a table by marking its extents for deallocation, making the space available for reuse.

## Key Characteristics

- Quickly removes **all records** from a table  
- Does **not delete the table structure** itself  
- Bypasses many **integrity enforcement mechanisms**, such as triggers  
- Does not generate individual row delete operations  

## TRUNCATE TABLE vs DELETE

Unlike the `DELETE` statement:
- `TRUNCATE TABLE` does **not log individual row deletions**
- It requires **less overhead** for logging and locking
- It executes **much faster**, especially on large tables

## Summary

`TRUNCATE TABLE` is an efficient way to remove all data from a table when row-by-row deletion and transactional rollback are not required.
