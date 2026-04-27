# Cross Join

A **CROSS JOIN** in SQL is used to combine **every row from the first table** with **every row from the second table**, producing a Cartesian product of the two tables.

## Key Characteristics

- Combines **all rows from both tables**  
- Does **not require a join condition**  
- Results in **all possible row combinations**  

## Important Considerations

- Can produce a very **large number of rows**, especially for large tables  
- Can be **resource-intensive**, so it should be used carefully  
- Typically used for specific scenarios, such as generating combinations or testing

## Summary

`CROSS JOIN` is useful for generating all possible pairings between two tables, but its potential for creating extremely large result sets requires careful usage.
