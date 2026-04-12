# INSERT

The `INSERT` statement in SQL is used to add new rows of data to a table in a database.

## Forms of INSERT

### INSERT INTO (All Columns)
When column names are not specified, the `INSERT` statement expects values for **all columns** in the table, in the same order as the table definition.

### INSERT INTO with Specific Columns
You can specify particular columns to insert data into. Only the listed columns will be filled, while others may use default values or allow `NULL`.

```sql
INSERT INTO table_name (column1, column2, ...)
```

## Purpose

The `INSERT` command is essential for adding new records to a database, enabling data creation and population of tables.