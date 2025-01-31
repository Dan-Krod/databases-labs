use Labor_SQL;
SELECT 
	trip_no, 
    plane, 
    town_from, 
    town_to
FROM 
	trip
WHERE 
	plane = 'TU-134'
ORDER BY time_out DESC;