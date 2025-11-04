/*markdown
# Subqueries and Common Table Expressions (CTE)
*/

/*markdown
## Subqueries
*/

SELECT      *
FROM        happiness_scores
WHERE       1=1;

SELECT      AVG(happiness_score)
FROM        happiness_scores
WHERE       1=1;

SELECT      year,
            country,
            happiness_score,
            (
                SELECT      AVG(happiness_score)
                FROM        happiness_scores
            ) as avg_hs,
            ABS(
                happiness_score - 
                (
                    SELECT      AVG(happiness_score)
                    FROM        happiness_scores
                )
            ) as diff_from_avg_hs
            
FROM        happiness_scores

/*markdown
## Common Table Expressions (CTE)
*/





