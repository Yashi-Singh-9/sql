# ROUND

`ROUND` is a **numeric function** in SQL used to round a number to a specified level of precision.

## How ROUND Works

The function typically takes **two arguments**:
1. The **numeric value** to be rounded  
2. The **number of decimal places**

If the second argument is omitted, the value is rounded to the **nearest whole number**.

### Behavior by Precision
- **Positive value** → rounds to that many decimal places  
- **Zero** → rounds to the nearest integer  
- **Negative value** → rounds to the nearest ten, hundred, thousand, etc.

### Examples
- `ROUND(12.345, 2)` → `12.35`  
- `ROUND(12.345)` → `12`  
- `ROUND(1234, -2)` → `1200`

## Common Use Cases

`ROUND` is commonly used for:
- Formatting numeric values for **reports**
- Controlling **decimal precision** in calculations
- Financial and statistical computations
- Ensuring consistent numeric output

## Cross-Database Notes

- `ROUND` is supported by most SQL databases
- Exact rounding rules (especially midpoint handling) may vary slightly by database system

## Summary

The `ROUND` function helps control numeric precision in SQL, making results cleaner, more readable, and suitable for calculations and reporting.
