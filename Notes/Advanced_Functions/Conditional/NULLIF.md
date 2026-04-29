# NULLIF

`NULLIF` is an SQL function that compares two expressions and returns **NULL if they are equal**; otherwise, it returns the **first expression**.

## How NULLIF Works

The function takes **two arguments**:
1. The first expression
2. The second expression to compare against

- If both expressions are equal → returns `NULL`
- If they are not equal → returns the first expression

### Example
- `NULLIF(10, 10)` → `NULL`  
- `NULLIF(10, 5)` → `10`

## Common Use Cases

`NULLIF` is especially useful for:
- **Avoiding division by zero** errors
- Treating specific values as `NULL`
- Cleaning or normalizing data
- Handling edge cases in calculations and reports

## Usage with Other Functions

`NULLIF` is often used with:
- **Aggregate functions** (e.g., `AVG`, `SUM`)
- `CASE` statements
- Mathematical expressions where certain values should be ignored

## Summary

The `NULLIF` function provides a simple and effective way to handle special cases in SQL logic by conditionally converting values to `NULL`, improving query safety and clarity.
