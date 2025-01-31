use Labor_SQL;
SELECT
    COALESCE(i.point, o.point) AS point,
    COALESCE(i.date, o.date) AS date,
    CASE WHEN i.inc IS NOT NULL THEN i.inc ELSE 0 END AS inc,
    CASE WHEN o.out IS NOT NULL THEN o.out ELSE 0 END AS `out`
FROM
    Income_o i
LEFT JOIN
    Outcome_o o ON i.point = o.point AND i.date = o.date

UNION ALL

SELECT
    COALESCE(i.point, o.point) AS point,
    COALESCE(i.date, o.date) AS date,
    CASE WHEN i.inc IS NOT NULL THEN i.inc ELSE 0 END AS inc,
    CASE WHEN o.out IS NOT NULL THEN o.out ELSE 0 END AS `out`
FROM
    Outcome_o o
LEFT JOIN
    Income_o i ON i.point = o.point AND i.date = o.date
WHERE
    i.point IS NULL

ORDER BY 
    point, date;

use Labor_SQL;
SELECT 
    i.point AS point,
    i.date AS date,
    COALESCE(i.inc, 0) AS inc,
    COALESCE(o.`out`, 0) AS `out`
FROM 
    Income_o i
LEFT JOIN 
    Outcome_o o ON i.point = o.point AND i.date = o.date

UNION ALL

SELECT 
    o.point AS point,
    o.date AS date,
    COALESCE(i.inc, 0) AS inc,
    COALESCE(o.`out`, 0) AS `out`
FROM 
    Outcome_o o
LEFT JOIN 
    Income_o i ON i.point = o.point AND i.date = o.date
WHERE 
    i.point IS NULL 

ORDER BY 
    point, date;

-- use Labor_SQL;
-- SELECT 
--     i.point AS point,
--     i.date AS date,
--     COALESCE(i.inc, 0) AS inc,
--     COALESCE(o.`out`, 0) AS `out`
-- FROM 
--     Income_o i
-- LEFT JOIN 
--     Outcome_o o
--     ON i.point = o.point AND i.date = o.date

-- UNION

-- SELECT 
--     o.point AS point,
--     o.date AS date,
--     COALESCE(i.inc, 0) AS inc,
--     COALESCE(o.`out`, 0) AS `out`
-- FROM 
--     Outcome_o o
-- LEFT JOIN 
--     Income_o i
--     ON i.point = o.point AND i.date = o.date

-- ORDER BY 
--     point, date;