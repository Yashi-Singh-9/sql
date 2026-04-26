# NOT NULL

The `NOT NULL` constraint in SQL ensures that a column **cannot contain NULL values**. This means every row must have a valid value for that column.

## Key Characteristics

- Prevents `NULL` values in a column  
- Ensures that a value is **always provided** when inserting or updating records  
- Used to enforce **mandatory fields** in a table  

## Use Case Example

When designing a table for employee data, certain fields—such as an employee’s **ID** and **name**—are essential. Applying the `NOT NULL` constraint ensures these critical fields are always populated.

## Importance of NOT NULL

Using the `NOT NULL` constraint helps:
- Maintain **data completeness**
- Prevent missing or undefined values
- Enforce **business rules** at the database level

## Summary

The `NOT NULL` constraint is a simple yet powerful way to ensure required fields always contain valid data, improving overall data quality and reliability.
