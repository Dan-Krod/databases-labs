USE robot_db;
SELECT 
    s.technology_used,
    COUNT(r.robot_id) AS robot_count
FROM 
    sensor s
JOIN 
    robot r ON s.robot_id = r.robot_id
GROUP BY 
    s.technology_used
ORDER BY 
    robot_count DESC;
