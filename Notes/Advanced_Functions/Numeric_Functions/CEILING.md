# CEILING

`CEILING()` is a **numeric function** in SQL that returns the **smallest integer greater than or equal to** a given numeric value. In other words, it always rounds a number **upward** to the nearest whole number.

## Key Characteristics

- Always rounds **up**
- Works with numeric values
- Returns an **integer**

## How CEILING Works

- `CEILING(4.2)` → `5`  
- `CEILING(4.0)` → `4`  
- `CEILING(-4.7)` → `-4`  

## Common Use Cases

The `CEILING` function is commonly used for:
- Calculating the **number of pages** needed when items are displayed in fixed-size groups
- Rounding up quantities in **billing or allocation** scenarios
- Ensuring minimum thresholds are met in calculations

## Related Functions

- `FLOOR` – rounds numbers down
- `ROUND` – rounds to the nearest value

## Summary

`CEILING()` is a reliable SQL function for rounding numbers upward, making it especially useful when partial values must be treated as complete units in calculatio
