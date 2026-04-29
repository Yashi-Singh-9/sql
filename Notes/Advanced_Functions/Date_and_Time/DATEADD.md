# DATEADD

`DATEADD` is an SQL function used to **add or subtract a specified time interval** to a date or datetime value. It is commonly used for date calculations involving past or future dates.

## How DATEADD Works

The function typically takes **three arguments**:
1. The **interval type** (e.g., day, month, year)
2. The **number of intervals** to add or subtract (negative values subtract)
3. The **date or datetime value** to modify

## Common Interval Types

`DATEADD` can work with intervals such as:
- Year  
- Quarter  
- Month  
- Day  
- Hour  
- Minute  
- Second  

## Common Use Cases

`DATEADD` is useful for:
- Calculating **future or past dates**
- Determining **expiration or due dates**
- Generating **date ranges**
- Performing **time-based calculations**

## Cross-Database Considerations

- **SQL Server:** `DATEADD`
- **MySQL:** `DATE_ADD`
- Other databases may provide similar functions with slight syntax differences

## Summary

The `DATEADD` function is a powerful and flexible tool for manipulating date and time values in SQL, making it essential for temporal calculations and date-based logic.