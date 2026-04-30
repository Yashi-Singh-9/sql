# Pivot and Unpivot Operations

**PIVOT** and **UNPIVOT** operations in SQL are used to **reshape data**, making it easier to analyze, summarize, and report from different perspectives.

These operations are especially useful in **reporting, analytics, and data visualization** scenarios.

---

## PIVOT Operation

The **PIVOT** operation transforms **rows into columns**, allowing you to summarize data and present it in a more readable, cross-tabular format.

### Key Uses of PIVOT
- Convert row values into column headers
- Summarize data using aggregate functions
- Create reports such as sales by month, region, or category

### Example Use Case
Turning monthly sales stored as rows into separate month columns:

| Month | Sales |
|------|-------|
| Jan  | 1000  |
| Feb  | 1200  |

Becomes:

| Jan | Feb |
|-----|-----|
|1000 |1200 |

---

## UNPIVOT Operation

The **UNPIVOT** operation performs the reverse of PIVOT by transforming **columns into rows**.

### Key Uses of UNPIVOT
- Normalize wide tables
- Prepare pivoted data for further analysis
- Convert report-style data back into relational form

### Example Use Case
Turning multiple month columns back into rows:

| Jan | Feb |
|-----|-----|
|1000 |1200 |

Becomes:

| Month | Sales |
|------|-------|
| Jan  | 1000  |
| Feb  | 1200  |

---

## When to Use Pivot vs Unpivot

| Operation | Purpose |
|---------|---------|
| PIVOT | Rows → Columns |
| UNPIVOT | Columns → Rows |

---

## Common Scenarios

- Reporting dashboards
- Business intelligence queries
- Data transformation for visualization tools
- Cross-tab and matrix-style reports

---

## Summary

PIVOT and UNPIVOT operations are powerful SQL techniques for reorganizing data.  
- **PIVOT** helps summarize and present data clearly  
- **UNPIVOT** restores normalized structure for further processing  

Together, they provide flexibility in how data is viewed and analyzed without changing the underlying dataset.