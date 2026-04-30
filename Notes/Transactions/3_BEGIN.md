# BEGIN

`BEGIN` is used in SQL to **start a transaction**, which groups one or more SQL operations into a single logical unit of work.

A transaction ensures that all operations inside it are completed successfully before changes are permanently saved to the database.

## How BEGIN Works

1. `BEGIN` (or `START TRANSACTION`) starts the transaction  
2. SQL statements are executed  
3. If everything succeeds → `COMMIT` saves the changes  
4. If an error occurs → `ROLLBACK` undoes all changes  

## Why BEGIN Is Important

Transactions help:

- Maintain **data consistency**
- Prevent **partial updates**
- Handle **errors safely**
- Support **concurrent database access**

## Related Commands

- `COMMIT` – Permanently saves all changes made during the transaction  
- `ROLLBACK` – Reverts all changes made during the transaction  
- `SAVEPOINT` – Creates intermediate rollback points within a transaction  

## Summary

The `BEGIN` statement marks the start of a controlled transaction block in SQL. By grouping operations together, it ensures reliability, integrity, and proper error handling in database operations.