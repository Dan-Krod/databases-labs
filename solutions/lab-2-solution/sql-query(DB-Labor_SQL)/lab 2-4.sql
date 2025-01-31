USE Labor_SQL;
SELECT 
    o1.ship, 
    o1.battle, 
    b1.date
FROM 
    Outcomes AS o1
JOIN 
    Outcomes AS o2 ON o1.ship = o2.ship
JOIN 
    Battles AS b1 ON o1.battle = b1.name
JOIN 
    Battles AS b2 ON o2.battle = b2.name
WHERE 
    o1.result = 'damaged' 
    AND o2.result <> 'damaged' 
    AND o1.battle <> o2.battle 
    AND b1.date < b2.date;






-- SELECT 
--     s.name AS ship,
--     b1.name AS battle,
--     b1.date
-- FROM Outcomes o1
-- JOIN Ships s ON o1.ship = s.name
-- JOIN Battles b1 ON o1.battle = b1.name
-- WHERE o1.result = 'damaged' 
--   AND EXISTS (
--       SELECT 1
--       FROM Outcomes o2
--       WHERE o2.ship = o1.ship
--         AND o2.battle <> o1.battle
--         AND b1.date < (
--             SELECT b2.date
--             FROM Battles b2
--             WHERE b2.name = o2.battle
--         )
--   );