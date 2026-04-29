# CASE

The `CASE` statement in SQL is used to implement **conditional logic** within a query. It works like an **IF–ELSE** structure, allowing you to return different results based on specified conditions.

## Key Characteristics

- Evaluates conditions sequentially
- Returns a value when the first matching condition is met
- Supports an optional `ELSE` for default results
- Can be used in `SELECT`, `WHERE`, `ORDER BY`, and `HAVING` clauses

## CASE Syntax Types

### Simple CASE
Compares an expression to multiple values:
```sql
CASE expression
    WHEN value1 THEN result1
    WHEN value2 THEN result2
    ELSE result
END
````

### Searched CASE

Evaluates boolean conditions:

```sql
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    ELSE result
END
```

## Common Use Cases

The `CASE` statement is commonly used for:

* Conditional **data categorization**
* Creating **derived columns**
* Handling **business rules** inside queries
* Replacing complex `IF` logic
* Improving readability over nested conditions

## Important Notes

* `ELSE` is optional, but if omitted and no condition matches, `NULL` is returned
* Conditions are evaluated **top to bottom**
* Supported across all major SQL databases

## Summary

The `CASE` statement is a powerful SQL feature for embedding logic directly into queries, enabling dynamic results, cleaner queries, and more expressive data transformations.
