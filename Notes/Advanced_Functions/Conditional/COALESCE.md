# COALESCE

`COALESCE` is an SQL function that returns the **first non-NULL value** from a list of expressions. It is commonly used to handle missing data by providing default or fallback values.

## How COALESCE Works

- Evaluates expressions **from left to right**
- Returns the **first expression that is not NULL**
- If all expressions are NULL, it returns NULL

### Example
- `COALESCE(NULL, NULL, 5, 10)` → `5`
- `COALESCE(address2, address1, 'N/A')`

## Common Use Cases

`COALESCE` is useful for:
- Handling **NULL values** gracefully
- Providing **default values** in query results
- Simplifying `CASE` statements
- Cleaning and standardizing data for reports

## Cross-Database Support

- Supported by **most SQL databases** (PostgreSQL, SQL Server, MySQL, Oracle)
- Standard SQL function with consistent behavior

## Summary

The `COALESCE` function is a powerful and readable way to manage NULL values in SQL, helping ensure cleaner outputs and more robust query logic.
