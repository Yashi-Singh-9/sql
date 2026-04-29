# ABS

`ABS` is a **numeric function** in SQL that returns the **absolute value** of a given number. This means it converts negative values into positive ones while leaving positive values unchanged.

## Key Characteristics

- Removes the **sign** of a number
- Works only with **numeric data types**
- Always returns a **non-negative value**

## How ABS Works

- `ABS(-5)` → `5`  
- `ABS(7)` → `7`  
- `ABS(0)` → `0`

## Common Use Cases

The `ABS` function is commonly used for:
- Calculating **distances or differences**
- Comparing numeric values regardless of direction
- Normalizing data where **negative values are not meaningful**
- Error margin and variance calculations

## Related Functions

- `FLOOR` – rounds numbers down
- `CEIL` / `CEILING` – rounds numbers up
- `ROUND` – rounds to the nearest value

## Summary

The `ABS` function is essential for ensuring numeric values are treated as positive in SQL calculations, making it especially useful in mathematical, analytical, and comparison-based operations.
