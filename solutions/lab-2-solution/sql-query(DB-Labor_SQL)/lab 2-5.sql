USE Labor_SQL;
SELECT DISTINCT p1.maker
FROM 
	Product p1
JOIN PC pc ON p1.model = pc.model
JOIN Product p2 ON p1.maker = p2.maker AND p2.type = 'Printer'
WHERE pc.ram = (
    SELECT MIN(ram)
    FROM PC
);







-- SELECT DISTINCT p1.maker
-- FROM Product p1
-- JOIN PC pc ON p1.model = pc.model
-- WHERE pc.ram = (
--     SELECT MIN(ram)
--     FROM PC
-- )
-- AND EXISTS (
--     SELECT 1
--     FROM Product p2
--     WHERE p2.maker = p1.maker
--     AND p2.type = 'Printer'
-- );
