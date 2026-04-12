# UPDATE

The `UPDATE` statement in SQL is used to modify existing records in a table. It allows you to change the values of one or more columns based on specified conditions.

## Key Features of UPDATE

- Modifies **existing rows** in a table  
- Allows updating **one or multiple columns**  
- Uses an optional `WHERE` clause to control which rows are affected  
- Can be combined with:
  - Subqueries
  - JOINs
  - CTEs (Common Table Expressions)

## Important Considerations

- Always use the `WHERE` clause carefully to avoid updating unintended rows  
- Without a `WHERE` clause, **all rows** in the table will be updated  
- In transactional databases, `UPDATE` operations can be **rolled back** if the transaction has not been committed

## Summary

The `UPDATE` statement is a powerful tool for modifying data, and when used carefully, it ensures accurate and controlled changes within a database.
