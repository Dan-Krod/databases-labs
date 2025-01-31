USE Labor_SQL;
SELECT 
	maker
FROM
	Product
WHERE
	type = 'PC'
GROUP BY 
	maker
HAVING
	COUNT(model) > COUNT(CASE WHEN model IN (SELECT model from PC) THEN 1 END);





-- SELECT p.maker
-- FROM Product p
-- LEFT JOIN PC pc ON p.model = pc.model
-- GROUP BY p.maker
-- HAVING COUNT(p.model) > COUNT(pc.model);
