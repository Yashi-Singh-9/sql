# HAVING

The `HAVING` clause is used in combination with the `GROUP BY` clause to filter grouped results. It allows you to apply conditions on **aggregate functions** such as `SUM`, `COUNT`, `AVG`, `MAX`, and `MIN`.

## Key Points

- Used to filter **groups**, not individual rows  
- Works with aggregate functions  
- Always used **after** the `GROUP BY` clause  

## HAVING vs WHERE

- The `WHERE` clause applies conditions to **individual rows** before grouping  
- The `HAVING` clause applies conditions to **groups** after aggregation  

In other words:
- `WHERE` filters rows  
- `HAVING` filters grouped (summarized) results  

## Use Cases

The `HAVING` clause is commonly used when:
- You need to filter results based on aggregate values  
- Creating reports that require conditions on grouped data  

## Summary

`HAVING` is essential for refining grouped query results, enabling conditions to be applied to aggregated data that cannot be filtered using the `WHERE` clause.
