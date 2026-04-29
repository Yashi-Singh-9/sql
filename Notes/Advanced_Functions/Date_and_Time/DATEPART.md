# DATEPART

`DATEPART` is a SQL function used to extract a **specific component** from a date or time value. It allows you to retrieve individual parts of a date/time expression for analysis, filtering, or reporting.

## What DATEPART Can Extract

Using `DATEPART`, you can extract components such as:
- Year  
- Quarter  
- Month  
- Day of year  
- Day  
- Week  
- Weekday  
- Hour  
- Minute  
- Second  
- Millisecond  

## Common Use Cases

`DATEPART` is commonly used for:
- Breaking down date/time values for **reporting**
- Performing **time-based analysis**
- Grouping or filtering data by specific date parts
- Extracting components for calculations or comparisons

## Important Notes

- `DATEPART` is widely supported in SQL Server  
- Other databases may offer similar functionality using different functions (e.g., `EXTRACT`)
- Results may vary based on **locale and date settings** (such as week start day)

## Summary

The `DATEPART` function is a powerful tool for working with date and time data in SQL, enabling precise extraction of individual components from datetime values for deeper analysis.