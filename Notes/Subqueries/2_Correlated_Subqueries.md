# Correlated Subqueries

In SQL, a **correlated subquery** is a subquery that references columns from the **outer query** in its `WHERE` clause. Because of this dependency, the subquery cannot be executed independently.

## How Correlated Subqueries Work

- The subquery uses values from the outer query  
- It is evaluated **once for each row** processed by the outer query  
- The execution of the subquery depends on the current row of the outer query  

## Key Characteristics

- Cannot run on its own without the outer query  
- Often used for **row-by-row comparisons**
- Typically placed in the `WHERE`, `SELECT`, or `HAVING` clause  

## Use Cases

Correlated subqueries are useful when:
- Comparing each row to a related set of values  
- Applying conditions that depend on **outer query data**
- Solving problems that require **dynamic, per-row evaluation**

## Summary

Correlated subqueries enable powerful, context-aware filtering and comparisons in SQL, but they should be used carefully as they may impact performance due to repeated execution.
