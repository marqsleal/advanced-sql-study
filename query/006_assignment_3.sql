/*markdown
# Assignment 3
*/

/*markdown
## Subqueries in the `SELECT` clause
List of products from most to least expensive, along with how much each product differs from the average unit price
*/

SELECT      *
FROM        products
WHERE       1=1;

SELECT      *
FROM        products
WHERE       unit_price IS NOT NULL
ORDER BY    unit_price DESC;

SELECT      product_id,
            product_name,
            unit_price,
            ABS(unit_price - 
                (
                    SELECT      AVG(unit_price)
                    FROM        products
                )
            ) AS diff_price_avg
FROM        products
WHERE       unit_price IS NOT NULL
ORDER BY    unit_price DESC;

/*markdown
## Subqueries in the `FROM` clause
Return a country's happiness score for the year as well as the average happiness score for the country across years
*/

SELECT      country, 
            AVG(happiness_score) as avg_hs_by_country
FROM        happiness_scores
WHERE       1=1
GROUP BY    country;

SELECT      hs1.year,
            hs1.country,
            hs1.happiness_score,
            hs2.avg_hs_by_country
FROM        happiness_scores hs1
            LEFT JOIN(
                SELECT      country, 
                            AVG(happiness_score) as avg_hs_by_country
                FROM        happiness_scores
                GROUP BY    country
            ) AS hs2
                ON hs1.country = hs2.country

SELECT      year,
            country,
            happiness_score
            FROM happiness_scores

SELECT      2024 as year,
            country,
            ladder_score
            FROM happiness_scores_current;

SELECT      year,
            country,
            happiness_score
            FROM happiness_scores
UNION ALL
SELECT      2024 as year,
            country,
            ladder_score
            FROM happiness_scores_current;

/*markdown
### Return a country's happiness score for the year as well as the average happiness score for the country across years
*/

SELECT      hs1.year,
            hs1.country,
            hs1.happiness_score,
            hs2.avg_hs_by_country
FROM        (
                SELECT      year,
                            country,
                            happiness_score
                            FROM happiness_scores
                UNION ALL
                SELECT      2024,
                            country,
                            ladder_score
                            FROM happiness_scores_current
            ) AS hs1
            LEFT JOIN(
                SELECT      country, 
                            AVG(happiness_score) as avg_hs_by_country
                FROM        happiness_scores
                GROUP BY    country
            ) AS hs2
                ON hs1.country = hs2.country

/*markdown
### Return years where the happiness score is a whole point greater than the country's average happiness score
*/

SELECT      *
FROM        (
                SELECT      hs1.year,
                            hs1.country,
                            hs1.happiness_score,
                            hs2.avg_hs_by_country
                FROM        (
                                SELECT      year,
                                            country,
                                            happiness_score
                                            FROM happiness_scores
                                UNION ALL
                                SELECT      2024,
                                            country,
                                            ladder_score
                                            FROM happiness_scores_current
                            ) AS hs1
                            LEFT JOIN(
                                SELECT      country, 
                                            AVG(happiness_score) as avg_hs_by_country
                                FROM        happiness_scores
                                GROUP BY    country
                            ) AS hs2
                                ON hs1.country = hs2.country
            ) AS hs_country_hs
WHERE       happiness_score > avg_hs_by_country + 1;

/*markdown
## Subqueries in the `FROM` clause
List of factories, along with names of products and number of products
*/

SELECT      product_name,
            factory
FROM        products

SELECT      factory,
            COUNT(product_id) as num_products
FROM        products
GROUP BY    factory

SELECT      fp.factory,
            fp.product_name,
            fn.num_products
FROM        (
                SELECT      factory,
                        product_name            
                FROM        products
            ) AS fp
            LEFT JOIN
            (
                SELECT      factory,
                            COUNT(product_id) as num_products
                FROM        products
                GROUP BY    factory
            ) AS fn
                ON fp.factory = fn.factory
ORDER BY    fp.factory, fp.product_name

/*markdown
## Subqueries in the `WHERE` and `HAVING` clauses
*/

SELECT      AVG(happiness_score)
FROM        happiness_scores

SELECT      *
FROM        happiness_scores
WHERE       happiness_score > (
                SELECT      AVG(happiness_score)
                FROM        happiness_scores
            )

SELECT      region,
            AVG(happiness_score) AS avg_hs
FROM        happiness_scores
GROUP BY    region
HAVING      AVG(happiness_score) > (
                SELECT      AVG(happiness_score)
                FROM        happiness_scores
            )

/*markdown
## `ANY` vs `ALL`
*/

SELECT      *
FROM        happiness_scores

SELECT      2024 AS year,
            *
FROM        happiness_scores_current

SELECT      COUNT(*)
FROM        happiness_scores
WHERE       happiness_score > ANY(
                SELECT      ladder_score
                FROM        happiness_scores_current
            )

SELECT      *
FROM        happiness_scores
WHERE       happiness_score > ALL(
                SELECT      ladder_score
                FROM        happiness_scores_current
            )

SELECT      *
FROM        happiness_scores
WHERE       happiness_score > ALL(
                SELECT      AVG(ladder_score)
                FROM        happiness_scores_current
            )

/*markdown
## `EXISTS`
*/

SELECT      *
FROM        happiness_scores
LIMIT       5

SELECT      *
FROM        inflation_rates
LIMIT       5

SELECT      *
FROM        happiness_scores AS h
WHERE       EXISTS(
                SELECT      i.country_name
                FROM        inflation_rates AS i
                WHERE       i.country_name = h.country
            )
LIMIT       5

/*markdown
Correlated Subquery -> Subquery related to outside clouses  
`SLOW`
*/

SELECT      *
FROM        happiness_scores AS h
            INNER JOIN inflation_rates i
                ON h.country = i.country_name
                AND h.year = i.year
LIMIT       5

/*markdown
## Assignment: Subqueries in the `WHERE` Clause
Indentify products that have a unit price less than the unit price of all products from Wicked Choccy?
*/

SELECT      *
FROM        products
WHERE       factory = 'Wicked Choccy''s'

SELECT      *
FROM        products
WHERE       unit_price < ALL(
                SELECT      unit_price
                FROM        products
                WHERE       factory = 'Wicked Choccy''s'
            )
ORDER BY    unit_price