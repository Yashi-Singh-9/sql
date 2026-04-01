# DROP TABLE

The `DROP TABLE` statement is a **Data Definition Language (DDL)** operation used to completely remove a table from a database.

## Key Characteristics

- Deletes the **table structure** and **all data** stored in it  
- Removes all associated objects, including:
  - Indexes
  - Constraints
  - Triggers
- Permanently removes the table from the database system  

## DROP TABLE vs TRUNCATE TABLE

- `DROP TABLE` removes **both the data and the table structure**
- `TRUNCATE TABLE` removes **only the data** while keeping the table structure intact

## Summary

`DROP TABLE` is used when a table is no longer needed and must be entirely removed from the database, along with all its related components.
