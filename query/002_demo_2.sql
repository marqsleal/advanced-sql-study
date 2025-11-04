/*markdown
# Joins
*/

/*markdown
## 1. Basic Joins
*/

SELECT      *
FROM        happiness_scores;

SELECT      *
FROM        country_stats;

SELECT      hs.year, 
            hs.country, 
            hs.happiness_score,
            cs.continent
FROM        happiness_scores hs
            INNER JOIN country_stats cs
                ON hs.country = cs.country
WHERE       1=1;

/*markdown
## 2. Join Types
*/

--INNER
SELECT      hs.year, 
            hs.country, 
            hs.happiness_score,
            cs.country,
            cs.continent
FROM        happiness_scores hs
            INNER JOIN country_stats cs
                ON hs.country = cs.country
WHERE       1=1;

--LEFT
SELECT      hs.year, 
            hs.country, 
            hs.happiness_score,
            cs.country,
            cs.continent
FROM        happiness_scores hs
            LEFT JOIN country_stats cs
                ON hs.country = cs.country
WHERE       1=1;

--View Distinct
SELECT      DISTINCT hs.country
FROM        happiness_scores hs
            LEFT JOIN country_stats cs
                ON hs.country = cs.country
WHERE       cs.country IS NULL
WHERE       1=1;

--RIGHT
SELECT      hs.year, 
            hs.country, 
            hs.happiness_score,
            cs.country,
            cs.continent
FROM        happiness_scores hs
            RIGHT JOIN country_stats cs
                ON hs.country = cs.country
WHERE       1=1;

--View Distinct
SELECT      DISTINCT cs.country
FROM        happiness_scores hs
            RIGHT JOIN country_stats cs
                ON hs.country = cs.country
WHERE       hs.country IS NULL
WHERE       1=1;

--FULL OUTER
SELECT      hs.year, 
            hs.country, 
            hs.happiness_score,
            cs.country,
            cs.continent
FROM        happiness_scores hs
            FULL OUTER JOIN country_stats cs
                ON hs.country = cs.country
WHERE       1=1;

/*markdown
## 3. Joining on Multiple Columns
*/

SELECT      *
FROM        happiness_scores
WHERE       1=1;

SELECT      *
FROM        country_stats
WHERE       1=1;

SELECT      *
FROM        inflation_rates
WHERE       1=1;

SELECT      *
FROM        happiness_scores hs
            INNER JOIN inflation_rates ir
                ON hs.country = ir.country_name
                AND hs.year = ir.year
WHERE       1=1;

SELECT      hs.year,
            hs.country,
            hs.happiness_score,
            cs.continent,
            ir.inflation_rate
FROM        happiness_scores hs
            LEFT JOIN country_stats cs
                ON hs.country = cs.country
            LEFT JOIN inflation_rates ir
                ON hs.year = ir.year
                AND hs.country = ir.country_name
WHERE       1=1;

/*markdown
## Self Joins
*/

CREATE TABLE IF NOT EXISTS employess
(
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    salary INT,
    manager_id INT
)

INSERT INTO employess
(
    employee_id,
    employee_name,
    salary,
    manager_id
)
VALUES
(1, 'Ava', 85000, NULL),
(2, 'Bob', 72000, 1),
(3, 'Cat', 59000, 1),
(4, 'Dan', 85000, 2);

SELECT      *
FROM        employess
WHERE       1=1;

SELECT      e1.employee_id,
            e1.employee_name,
            e1.salary,
            e2.employee_id,
            e2.employee_name,
            e2.salary
FROM        employess e1
            INNER JOIN employess e2
                ON e1.salary = e2.salary
WHERE       e1.employee_id > e2.employee_id;

SELECT      e1.employee_id,
            e1.employee_name,
            e1.salary,
            e2.employee_id,
            e2.employee_name,
            e2.salary
FROM        employess e1
            INNER JOIN employess e2
                ON e1.salary > e2.salary
WHERE       1=1
ORDER BY    e1.employee_id;

SELECT      e1.employee_id,
            e1.employee_name,
            e1.manager_id,
            e2.employee_name AS manager_name
FROM        employess e1
            LEFT JOIN employess e2
                ON e1.manager_id = e2.employee_id
WHERE       1=1;