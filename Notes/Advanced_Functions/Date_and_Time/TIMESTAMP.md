# TIMESTAMP

`TIMESTAMP` is an SQL data type used to store **both date and time** values. It is commonly used to track **when a record is created or updated**, providing a precise chronological record of events.

## Key Characteristics

- Stores **date and time together**
- Often used for **auditing and logging changes**
- Can include **fractional seconds** depending on the database system

## Common Formats

The exact format and storage details vary by SQL platform:
- **MySQL:** `YYYY-MM-DD HH:MI:SS`
- **PostgreSQL:** `YYYY-MM-DD HH:MI:SS` (with support for **microseconds**)

## Common Use Cases

`TIMESTAMP` is widely used for:
- Tracking record creation and modification times
- Logging system events
- Maintaining historical data changes

## Important Considerations

- Storage size and precision may differ across database systems
- Time zone handling may vary depending on configuration and SQL dialect

## Summary

The `TIMESTAMP` data type is essential for capturing precise date and time information in SQL, making it invaluable for tracking events, changes, and system activity.