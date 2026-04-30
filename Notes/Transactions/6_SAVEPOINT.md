# SAVEPOINT

A `SAVEPOINT` in SQL is a **named point within a transaction** that allows you to roll back part of a transaction without undoing all changes made since the transaction began.

## Key Characteristics

- Creates an **intermediate checkpoint** inside a transaction  
- Allows **partial rollbacks**
- Does not end the transaction
- Multiple savepoints can exist within a single transaction

## How SAVEPOINT Works

1. A transaction is started using `BEGIN`
2. A `SAVEPOINT` is created at a specific stage
3. If an error occurs later, you can roll back to that savepoint
4. The transaction can still continue or be committed

## Why SAVEPOINT Is Useful

`SAVEPOINT` is especially helpful when:
- Working with **complex or multi-step transactions**
- You want to undo **only part of the work**
- Implementing conditional logic within transactions
- Reducing the need for full rollbacks

## Related Commands

- `BEGIN` – Starts a transaction  
- `ROLLBACK TO SAVEPOINT` – Reverts changes up to a specific savepoint  
- `COMMIT` – Saves all changes made in the transaction  

## Summary

The `SAVEPOINT` command adds flexibility to transaction management in SQL by enabling partial rollbacks. It allows developers to safely manage complex transactions while preserving valid intermediate work.