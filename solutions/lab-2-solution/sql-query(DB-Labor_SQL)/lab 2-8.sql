USE Labor_SQL;
SELECT 
    p.maker,
    (SELECT COUNT(DISTINCT pc.model) FROM Product pc WHERE pc.maker = p.maker AND pc.type = 'PC') AS pc,
    (SELECT COUNT(DISTINCT lt.model) FROM Product lt WHERE lt.maker = p.maker AND lt.type = 'Laptop') AS laptop,
    (SELECT COUNT(DISTINCT pr.model) FROM Product pr WHERE pr.maker = p.maker AND pr.type = 'Printer') AS printer
FROM 
    Product p
GROUP BY 
    p.maker;








-- use Labor_SQL;
-- SELECT 
--     p.maker,
--     SUM(CASE WHEN p.type = 'PC' THEN 1 ELSE 0 END) AS pc,
--     SUM(CASE WHEN p.type = 'Laptop' THEN 1 ELSE 0 END) AS laptop,
--     SUM(CASE WHEN p.type = 'Printer' THEN 1 ELSE 0 END) AS printer
-- FROM 
--     Product p
-- GROUP BY 
--     p.maker;