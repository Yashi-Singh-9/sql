# Stored Procedures and Functions

Stored procedures and functions are **precompiled database objects** that encapsulate SQL statements and procedural logic. They help organize database operations, improve performance, and enhance security.

## Stored Procedures

A **stored procedure** is a named set of SQL statements that performs a specific task.

### Key Characteristics:
- Can perform **data manipulation** (INSERT, UPDATE, DELETE)
- Can include **control structures** (IF, LOOP, CASE)
- May return zero, one, or multiple result sets
- Can accept input and output parameters

### Advantages:
- Improve performance (precompiled execution plans)
- Reduce network traffic (multiple operations in one call)
- Promote code reuse and modular design
- Enhance security by restricting direct table access

### Example:
```sql
CREATE PROCEDURE AddEmployee
    @Name VARCHAR(100),
    @Salary DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Employees (Name, Salary)
    VALUES (@Name, @Salary);
END;
```

## Functions

A **function** is a database object designed to compute and return a value.

### Key Characteristics:

* Must return a value
* Typically used in SELECT statements
* Cannot perform certain operations (e.g., modifying data in many systems)
* Can be scalar (returns single value) or table-valued (returns a table)

### Types of Functions:

* **Scalar Functions** – Return a single value
* **Table-Valued Functions** – Return a table

### Example:

```sql
CREATE FUNCTION CalculateBonus (@Salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Salary * 0.10;
END;
```

---

## Stored Procedures vs Functions

| Feature         | Stored Procedure | Function                  |
| --------------- | ---------------- | ------------------------- |
| Returns Value   | Optional         | Mandatory                 |
| Used in SELECT  | No               | Yes                       |
| Can Modify Data | Yes              | Limited / No              |
| Purpose         | Perform actions  | Compute and return values |

---

## Benefits

* ✅ Improved performance through precompilation
* ✅ Reduced code duplication
* ✅ Better maintainability
* ✅ Enhanced security through controlled access

---

## Summary

Stored procedures and functions are essential tools in SQL for building efficient, secure, and maintainable database applications. While stored procedures are ideal for performing operations, functions are best suited for returning calculated results.
