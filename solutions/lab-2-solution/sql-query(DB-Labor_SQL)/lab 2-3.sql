USE Labor_SQL;
SELECT 
    c.country,
    GROUP_CONCAT(DISTINCT CASE WHEN c.type = 'bb' THEN c.class END) AS bb_classes,
    GROUP_CONCAT(DISTINCT CASE WHEN c.type = 'bc' THEN c.class END) AS bc_classes
FROM 
    Classes AS c
JOIN 
    Ships AS s ON c.class = s.class
GROUP BY 
    c.country
HAVING 
    COUNT(DISTINCT CASE WHEN c.type = 'bb' THEN c.class END) > 0 AND 
    COUNT(DISTINCT CASE WHEN c.type = 'bc' THEN c.class END) > 0;





-- SELECT 
-- 	country,
--     GROUP_CONCAT(CASE WHEN type = 'bb' THEN type END) AS bb_types,
--     GROUP_CONCAT(CASE WHEN type = 'bc' THEN type END) AS bc_types
-- FROM classes
-- WHERE type IN ('bb', 'bc')
-- GROUP BY country
-- HAVING COUNT(DISTINCT class) = 2;