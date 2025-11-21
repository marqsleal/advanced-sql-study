# Advanced SQL
Advanced SQL study
## The Big 6
```sql
SELECT      grade_level,
            AVG(gpa) AS avg_gpa
FROM        students
WHERE       school_lunch = 'Yes'
GROUP BY    grade_level     
HAVING      avg_gpa < 3.3
ORDER BY    grade_level;
```
### Writing Order
- `SELECT`: Columns to Display
- `FROM`: Tables to pull data from
- `WHERE`: Criteria to filter rows by
- `GROUP BY`: Column to group the rows by
- `HAVING`: Criteria to filter grouped rows by  
- `ORDER BY`: Column to sort values by  
"**S**tart **F**ridays **W**ith **G**randma's **H**omemade **O**atmeal!"

### Execution Order
- `FROM`
- `JOIN`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `SELECT`
- `ORDER BY`
- `LIMIT`

## Common Keywords
```sql
SELECT      DISTINCT grade_level
FROM        students;
```
- `DISTINCT`: Return unique values
```sql
SELECT      COUNT(DISTINCT grade_level)
FROM        students;
```
```sql
SELECT      MAX(gpa) - MIN(gpa) AS gpa_range
FROM        students;
```
- `COUNT`, `SUM`, `MAX`, `AVG`, `MIN`, `MAX` : Aggregated functions are used to make calc.
```sql
SELECT      *
FROM        students
WHERE       grade_level < 12 AND school_lunch = 'Yes';
```
- `AND`, `OR`, `NOT`: Logical Operators
```sql
SELECT      *
FROM        students
WHERE       grade_level IN (10, 11, 12);
```
```sql
SELECT      *
FROM        students
WHERE       email LIKE '%.com';
```
- `IN`, `LIKE`, `BETWEEN`, `AND`, `IS NULL`: Comparison Keywords
```sql
SELECT      student_name, gpa
FROM        students
ORDER BY    gpa DESC;
```
- `ASC` and `DESC`: `ORDER BY` keywords
```sql
SELECT      student_name, gpa
FROM        students
LIMIT       10;
```
- `LIMIT`: Number of rows (`TOP` for **SQLServer** and `FETCH FIRST` for **OracleDB**)
```sql
SELECT      student_name, 
            grade_level,
            CASE
                WHEN grade_level = 9
                    THEN 'Freshman'
                WHEN grade_level = 10
                    THEN 'Sophomore'
                WHEN grade_level = 11
                    THEN 'Junior'
                ELSE 'Senior'
            END AS student_class
FROM        students;
```
- `CASE WHEN`, `THEN`, `WHEN`, `ELSE`: IF-ELSE logic in SQL
## Multi Table Analysis
- `JOIN`: adds related columns from one table to another, based on common columns
- `UNION`: stacks rows from multiple tables with the same column structure

### `JOIN`
adds related columns from one table to another, based on common columns
- The tables must have at least one column with matching values
- basic `JOIN` options include `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN` and `FULL OUTER JOIN`
```sql
SELECT      *
FROM        happiness_score hs
            INNER JOIN country_stats cs
            ON hs.country = cs.country;
```
- `INNER`: Return Records that exists in **BOTH** tables, and **EXCLUDES** unmatched records from either table;
- `LEFT`: Return **ALL** records from the **LEFT** table, and any matching records from the **RIGHT** table;
- `RIGHT`: Return **ALL** records from the **RIGHT** table, and any matching records from the **LEFT** table;
- `FULL OUTER`: Return **ALL** records from **BOTH** tables, **INCLUDING** non-matching records.  

Not Supported Joins:
- *SQLite* does not support `RIGHT JOIN` and `FULL OUTER JOIN`;
- *MySQL* does not support `FULL OUTER JOIN`;

- `CROSS JOIN`: Return all combinations of rows within two or more tables

**WARNING**: produces an enormous output (number of rows of one table times the number of the rows of the other table)

### `UNION`
Stack multiple tables or queries on top of one another
- `UNION` removes duplicate values, while `UNION ALL` retains them;
- `UNION ALL` runs FASTER than `UNION`;

## Subqueries and Common Table Expressions (CTE)

### Subqueries
Is query nested within a main query
- Subqueries starts with parentesis and a `SELECT` statement;
- the code on the subquery always runs first than the code on the main query;
```sql
SELECT      *
FROM        happiness_scores
WHERE       happiness_score >
            (
                SELECT      AVG(happiness_score)
                FROM        happiness_scores
            ) 
```
Where the subquery can occur?
- Calculations in the `SELECT` clause
- As part of a `JOIN` in the `FROM` clause
- Filtering in the `WHERE` and `HAVING` clauses


### Common Table Expressions (CTE)
A **common table experssion (CTE)** creates a named, temporary output that can be referenced within another query

Why CTEs instead of subqueries?
- Readability
- Reuseability
- Recursiveness

```sql
WITH avg_hs AS (
    SELECT      AVG(happiness_score) as avg_hs
    FROM        happiness_scores
)
SELECT      *
FROM        happiness_scores,
            avg_hs
WHERE       happiness_score > avg_hs
```

Consider subqueries for simple queries and old RDBMS

## Window Functions
Used to apply a function to a "window" of data
- Window: groups of rows

How are window functions different than `GROUP BY`?
- **Aggregate Functions**: Collapse the rows in each group and apply calculations
- **Window Functions**: Leave the rows as they are and apply calculations

Aggregate Function:
```sql
SELECT      country,
            AVG(happiness_score) AS avg_hs
FROM        happiness_scores
GROUP BY    country
```
Window Function:
```sql
SELECT      country,
            year,
            happiness_score,
            ROW_NUMBER() OVER (
                PARTITION BY    country
                ORDER BY        year        
            ) AS row_num
FROM        happiness_scores
```

4 main components:
- Function to Apply (required): `ROW_NUMBER`, `FIRST_VALUE`, `LAG`, etc
- Window Function Declaration (required): `OVER`
- Define Window (optional): `PARTITION BY` column, blank = entire table
- Sorting the rows (optional, required in Oracle and MSSQL): `ORDER BY` column

Basic Window Function
```sql
ROW_NUMBER() OVER (
    PARTITION BY    country
    ORDER BY        happiness_score
)
```

### Functions
| Function | Category |
|---|---|
| Row Numbering | `ROW_NUMBER` <br> `RANK` <br> `DENSE_RANK`|
| Value Within a Window | `FIRST_VALUE` <br> `LAST_VALUE` <br> `NTH_VALUE`|
| Value Relative to a Row | `LEAD` <br> `LAG`|
| Aggregate Functions | `SUM`, `AVG`, `COUNT` <br> `MIN`, `MAX`|
| Statistical Functions | `NTILE` <br> `CUME_DIST` <br> `PERCENT_RANK`|

#### Row Numbering
- `ROW_NUMBER`: assigns a unique sequential index to each row within the partition.
- `RANK`: assigns the same rank to tied values, leaving gaps in the ranking sequence.
- `DENSE_RANK`: assigns the same rank to tied values, keeping the sequence continuous with no gaps.

#### Value Within a Window
- `FIRST_VALUE(column)`: retrieves the first value in the window based on the defined order.
- `LAST_VALUE(column)`: retrieves the last value in the window.
- `NTH_VALUE(column, N)` (MSSQL does not support): retrieves the value at the N-th position in the window.

#### Value Relative to a Row
- `LEAD(column)`: returns the value from the next row relative to the current row.
- `LAG(column)`: returns the value from the previous row relative to the current row.

#### Aggregate Functions
- `SUM`, `AVG`, `COUNT`: compute cumulative or windowed totals, averages, and row counts over the defined window.
- `MIN`, `MAX`: return the minimum or maximum value within the window frame.

#### Statistical Functions
- `NTILE(n)` (SQLite does not support): divides rows into *n* approximately equal groups and assigns a bucket number to each row.
- `CUME_DIST`: returns the cumulative distribution of a value, representing the proportion of rows with values less than or equal to the current row.
- `PERCENT_RANK`: returns the relative rank of a row as a percentage, based on its position within the partition.
