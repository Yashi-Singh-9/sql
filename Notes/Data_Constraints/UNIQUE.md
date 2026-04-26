# UNIQUE

`UNIQUE` is a constraint in SQL that ensures all values in a column or a set of columns are **distinct**. It prevents duplicate values from being inserted into the specified column(s).

## Key Characteristics

- Enforces **uniqueness** of values in a column or combination of columns  
- Prevents **duplicate entries**  
- Automatically creates an **index** to improve query performance  
- Can be applied during table creation or added later  

## Use Cases

The `UNIQUE` constraint is commonly used for fields such as:
- Email addresses  
- Usernames  
- Product codes  

These fields require uniqueness to maintain data integrity.

## UNIQUE vs PRIMARY KEY

- `UNIQUE` constraints **allow NULL values** (unless explicitly restricted)  
- A table can have **multiple UNIQUE constraints**  
- A `PRIMARY KEY` does **not allow NULL values** and only one primary key can exist per table  

## Summary

The `UNIQUE` constraint is essential for preserving data integrity by ensuring that certain values remain distinct while still allowing flexibility in database design.
