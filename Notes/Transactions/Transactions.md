# Transactions

Transactions in SQL are **units of work** that group one or more database operations into a single, logical execution block. They ensure that database operations are processed reliably and maintain data integrity.

## ACID Properties

Transactions follow the **ACID** principles:

- **Atomicity**  
  Ensures that all operations within a transaction are completed successfully. If any operation fails, the entire transaction is rolled back.

- **Consistency**  
  Guarantees that the database remains in a valid state before and after the transaction.

- **Isolation**  
  Ensures that transactions execute independently and do not interfere with one another, even when running concurrently.

- **Durability**  
  Ensures that once a transaction is committed, its changes are permanently saved, even in the event of a system failure.

## Why Transactions Are Important

Transactions are essential for:
- Maintaining **data consistency**
- Handling **concurrent database access**
- Executing complex operations safely
- Preventing partial updates and data corruption

## Common Transaction Commands

- `BEGIN` / `START TRANSACTION` – starts a transaction  
- `COMMIT` – saves all changes made in the transaction  
- `ROLLBACK` – undoes all changes if an error occurs  

## Summary

Transactions are a foundational concept in SQL that ensure reliable, consistent, and safe database operations. By adhering to ACID properties, they play a critical role in preserving data integrity in multi-user and complex database environments.