# COMMIT

The `COMMIT` command in SQL is used to **save all changes made by the current transaction** to the database. Once executed, it **ends the transaction** and makes all modifications permanent.

## Key Characteristics

- Permanently saves all changes made during the transaction
- Marks the successful completion of a transaction
- Changes **cannot be undone** after a `COMMIT`

## How COMMIT Works

- Executes after a `BEGIN` or `START TRANSACTION`
- Applies all `INSERT`, `UPDATE`, and `DELETE` operations performed
- Finalizes the transaction state

## Important Notes

- After a `COMMIT`, a `ROLLBACK` is no longer possible for that transaction
- Use `COMMIT` only when you are satisfied with the changes
- Ensures data consistency and durability

## Related Commands

- `BEGIN` – Starts a transaction  
- `ROLLBACK` – Reverts changes made during a transaction  
- `SAVEPOINT` – Allows partial rollbacks within a transaction  

## Summary

The `COMMIT` command is essential for finalizing successful transactions in SQL. It ensures that all validated changes are permanently stored, maintaining data integrity and reliability in the database.