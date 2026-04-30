# ACID

**ACID** refers to a set of four fundamental properties of relational database systems that ensure **reliable and consistent transaction processing**. These properties guarantee that database transactions are executed safely, even in the presence of errors, failures, or concurrent access.

ACID is an acronym that stands for:

## Atomicity
- Ensures that a transaction is treated as a **single unit**
- Either **all operations succeed**, or **none are applied**
- If any part of the transaction fails, the entire transaction is rolled back

## Consistency
- Ensures that a transaction brings the database from one **valid state to another**
- All defined rules, constraints, and relationships must be satisfied after the transaction completes

## Isolation
- Ensures that **concurrent transactions do not interfere** with each other
- Each transaction behaves as if it is executed independently
- Prevents issues such as dirty reads, non-repeatable reads, and phantom reads

## Durability
- Guarantees that once a transaction is **committed**, its changes are **permanently saved**
- Data remains intact even in the event of system crashes or power failures

## Importance of ACID

ACID properties are essential for:
- Reliable transaction processing
- Maintaining data integrity
- Supporting concurrent multi-user environments
- Ensuring correctness in critical applications such as banking, finance, and inventory systems

## Summary

ACID properties form the foundation of transactional reliability in relational databases, ensuring that data remains accurate, consistent, and secure under all conditions.