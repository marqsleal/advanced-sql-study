USE maven_advanced_sql;

-- 1. View the student table
SELECT      * 
FROM        students;

-- 2. The Big 6
SELECT      grade_level,
            AVG(gpa) as avg_gpa
FROM        students
WHERE       school_lunch = 'Yes'
GROUP BY    grade_level 
HAVING      AVG(gpa) < 3.3
ORDER BY    grade_level;

-- 3. Column Keywords
-- DISTINC
SELECT      DISTINCT grade_level
FROM        students;
-- COUNT
SELECT      COUNT(DISTINCT grade_level)
FROM        students;
-- MAX & MIN
SELECT      MAX(gpa) - MIN(gpa) AS gpa_range
FROM        students;

-- 4. Where Keywords
-- AND
SELECT      * 
FROM        students
WHERE       grade_level < 12
            AND school_lunch = 'Yes';
-- IN
SELECT      * 
FROM        students
WHERE       grade_level in (9, 10, 11);
-- IS NULL
SELECT      *
FROM        students
WHERE       email IS NULL;
-- LIKE
SELECT      *
FROM        students
WHERE       email LIKE '%.edu';
-- ORDER BY
SELECT      *
FROM        students
ORDER BY    gpa DESC;
-- LIMIT
SELECT      *
FROM        students
ORDER BY    gpa DESC
LIMIT       5;
-- CASE
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