# DATE

The `DATE` data type in SQL is used to store **calendar dates**, typically in the format `YYYY-MM-DD`. It represents a specific day **without any time information**.

## Key Characteristics

- Stores only **date values** (year, month, day)
- Does not include time or timezone data
- Format is usually `YYYY-MM-DD` (implementation may vary slightly)

## Common Use Cases

`DATE` columns are commonly used for:
- Birthdates  
- Event dates  
- Registration dates  
- Any data requiring **day-level precision**  

## Working with DATE Values

SQL provides various functions to work with `DATE` data, allowing you to:
- Perform **date arithmetic** (adding or subtracting days)
- Extract components such as year, month, or day
- Compare dates for filtering and analysis
- Format dates for display

## Important Considerations

- The **valid date range** may differ depending on the database management system
- Behavior can vary slightly across SQL dialects

## Summary

The `DATE` data type is essential for managing calendar-based data in SQL, offering precise and efficient handling of day-specific information without time complexity.