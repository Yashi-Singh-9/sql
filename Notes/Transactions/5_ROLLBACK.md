# ROLLBACK

`ROLLBACK` is an SQL command used to **undo all changes** made during the current transaction that have not yet been committed. It restores the database to the state it was in **before the transaction began**.

## Key Characteristics

- Reverses all uncommitted changes in a transaction  
- Ends the current transaction without saving changes  
- Helps maintain **data integrity** when errors occur  

## How ROLLBACK Works

- Used after a `BEGIN` or `START TRANSACTION`
- Cancels all `INSERT`, `UPDATE`, and `DELETE` operations performed during the transaction
- Returns the database to its previous consistent state

## Why ROLLBACK Is Important

`ROLLBACK` is crucial for:
- Handling **errors or exceptions**
- Preventing **partial or invalid data updates**
- Implementing **conditional transaction logic**
- Ensuring transactional safety in complex operations

## Role in ACID Properties

`ROLLBACK` directly supports:
- **Atomicity** – ensures all-or-nothing execution  
- **Consistency** – keeps the database in a valid state  

## Related Commands

- `BEGIN` – Starts a transaction  
- `COMMIT` – Saves transaction changes permanently  
- `SAVEPOINT` – Allows partial rollbacks within a transaction  

## Summary

The `ROLLBACK` command is a fundamental part of SQL transaction control, providing a safe way to undo changes and preserve data consistency when transactions fail or need to be canceled.