use Labor_SQL;
SELECT 
	'PC' AS type, 
    model, 
    MAX(price) AS max_price
FROM 
	PC
GROUP BY 
	model

UNION ALL

SELECT 
	'Laptop' AS type, 
    model, 
    MAX(price) AS max_price
FROM 
	Laptop
GROUP BY 
	model

UNION ALL

SELECT 
	'Printer' AS type, 
    model, 
    MAX(price) AS max_price
FROM 
	Printer
GROUP BY 
	model;

