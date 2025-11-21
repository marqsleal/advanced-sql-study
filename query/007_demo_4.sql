/*markdown
# CTE
*/

/*markdown
## Conversion
*/

/*markdown
### Subquery
*/

SELECT      hs.year,
            hs.country,
            hs.happiness_score,
            country_hs.avg_hs_by_country
FROM        happiness_scores hs
            LEFT JOIN
            (
                SELECT      country,
                            AVG(happiness_score) as avg_hs_by_country
                FROM        happiness_scores
                GROUP BY    country
            ) AS country_hs
                ON hs.country = country_hs.country
LIMIT       10

/*markdown
### CTE
*/

WITH country_hs AS (
    SELECT      country,
                AVG(happiness_score) as avg_hs_by_country
    FROM        happiness_scores
    GROUP BY    country
)
SELECT      hs.year,
            hs.country,
            hs.happiness_score,
            country_hs.avg_hs_by_country
FROM        happiness_scores hs
            LEFT JOIN country_hs
                ON hs.country = country_hs.country
LIMIT       10

/*markdown
## CTE Reusability
*/

WITH hs AS (
    SELECT      *
    FROM        happiness_scores
    WHERE       year = 2023
)
SELECT      hs1.region,
            hs1.country,
            hs1.happiness_score,
            hs2.country,
            hs2.happiness_score
FROM        hs hs1
            INNER JOIN hs hs2
                ON hs1.region = hs2.region
WHERE       hs1.country < hs2.country
LIMIT       10