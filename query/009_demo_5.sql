/*markdown
# Window Functions
*/

SELECT      country,
            year,
            happiness_score
FROM        happiness_scores
ORDER BY    country,
            year
LIMIT       10

SELECT      country,
            year,
            happiness_score,
            ROW_NUMBER() OVER(
            ) AS row_num
FROM        happiness_scores
ORDER BY    country,
            year
LIMIT       5

SELECT      country,
            year,
            happiness_score,
            ROW_NUMBER() OVER(
                PARTITION BY    country
                ORDER BY        happiness_score
            ) AS row_num
FROM        happiness_scores
ORDER BY    country,
            row_num
LIMIT       5

SELECT      country,
            year,
            happiness_score,
            ROW_NUMBER() OVER(
                PARTITION BY    country
                ORDER BY        happiness_score DESC
            ) AS row_num
FROM        happiness_scores
ORDER BY    country,
            row_num
LIMIT       5

/*markdown
## `LEAD` & `LAG`
*/

SELECT      country,
            year,
            happiness_score,
            LAG(happiness_score) OVER(
                PARTITION BY    country
                ORDER BY        year
            ) prior_happiness_score
FROM        happiness_scores
LIMIT 5

WITH lag_happiness_scores AS (
    SELECT      country,
                year,
                happiness_score,
                LAG(happiness_score) OVER(
                    PARTITION BY    country
                    ORDER BY        year
                ) prior_happiness_score
    FROM        happiness_scores
)
SELECT      *,
            (
                happiness_score - prior_happiness_score
            ) AS shift_happiness_score
FROM        lag_happiness_scores
LIMIT       5

/*markdown
## `NTILE`
*/

SELECT      region,
            country,
            happiness_score,
            NTILE(4) OVER(
                PARTITION BY    region
                ORDER BY        happiness_score DESC
            )
FROM        happiness_scores
WHERE       year = 2023
ORDER BY    region,
            happiness_score DESC
LIMIT       5

WITH ntile_hs AS (
    SELECT      year,
                region,
                country,
                happiness_score,
                NTILE(4) OVER(
                    PARTITION BY    region
                    ORDER BY        happiness_score DESC
                ) hs_percentile
    FROM        happiness_scores
)
SELECT      *
FROM        ntile_hs
WHERE       year = 2023
            AND hs_percentile = 1
ORDER BY    region,
            happiness_score DESC