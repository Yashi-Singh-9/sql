# Self Join

A **SELF JOIN** in SQL is a join operation where a table is joined with **itself**. Although it may seem counterintuitive, it is very useful when comparisons or relationships need to be evaluated within the same table.

## How Self Join Works

- The same table is treated as **two separate tables**
- Rows are compared with other rows in the same table
- A join condition determines how rows are related

## Use of Aliases

Since the same table is referenced more than once, **table aliases are required** to distinguish between the two instances of the table and avoid ambiguity during the join operation.

## Common Use Cases

Self joins are commonly used for:
- Comparing rows within the same table
- Representing **hierarchical relationships** (e.g., employees and managers)
- Finding related records within a single dataset

## Summary

A self join enables powerful internal comparisons within a table, and by using aliases, SQL can clearly distinguish between different references to the same data source.
