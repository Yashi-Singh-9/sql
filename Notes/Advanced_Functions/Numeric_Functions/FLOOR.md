# FLOOR

`FLOOR` is a **numeric function** in SQL used to round a decimal or numeric value **down to the nearest whole integer**. The returned value is always **less than or equal to** the original number.

## Key Characteristics

- Rounds numbers **downward**
- Accepts **only numeric values** as input
- Always returns an **integer**

## How FLOOR Works

- `FLOOR(4.9)` → `4`  
- `FLOOR(4.1)` → `4`  
- `FLOOR(-3.2)` → `-4`

## Common Use Cases

The `FLOOR` function is commonly used for:
- Removing decimal portions of numbers
- Performing **financial calculations**
- Handling **indexing or grouping logic**
- Ensuring values do not exceed a lower bound

## Related Functions

- `CEIL` / `CEILING` – rounds numbers **up**
- `ROUND` – rounds numbers to the nearest value

## Summary

The `FLOOR` function is a precise and reliable way to round numeric values downward in SQL, making it essential for calculations that require strict lower-bound control.
