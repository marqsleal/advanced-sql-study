-- 1. Basic Joins
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
            ON hs.country = cs.country;