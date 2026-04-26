# CHECK

A `CHECK` constraint in SQL is used to enforce **data integrity** by specifying a condition that must be true for each row in a table. It allows you to define **custom rules or restrictions** on the values that can be inserted or updated.

## Key Characteristics

- Enforces a **logical condition** on column values  
- Can be applied to one or more columns  
- Validates data during `INSERT` and `UPDATE` operations  

## Purpose of CHECK Constraint

The `CHECK` constraint helps:
- Prevent **invalid or inconsistent data**
- Maintain **data quality**
- Enforce **business rules** directly within the database  

## Common Use Cases

Examples of where `CHECK` is useful include:
- Ensuring a salary is greater than zero  
- Restricting age values to a specific range  
- Limiting status values to a predefined set  

## Summary

The `CHECK` constraint is a powerful tool for validating data at the database level, ensuring that only values meeting defined criteria are stored.
