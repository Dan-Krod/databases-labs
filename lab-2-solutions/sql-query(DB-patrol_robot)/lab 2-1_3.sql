USE robot_db;
SELECT 
    r.robot_id,
    r.status,
    r.max_distance,
    o.name AS operator_name,
    AVG(pr.difficulty_level) AS avg_route_difficulty,
    MAX(m.maintenance_date) AS last_maintenance_date
FROM 
    robot r
JOIN 
    patrol_route pr ON r.robot_id = pr.robot_id
JOIN 
    operator o ON r.operator_id = o.operators_id
LEFT JOIN 
    robot_maintenance rm ON r.robot_id = rm.robot_id
LEFT JOIN 
    maintenance m ON rm.maintenance_id = m.maintenance_id
GROUP BY 
    r.robot_id, r.status, r.max_distance, o.name
HAVING 
    avg_route_difficulty >= 3 
ORDER BY 
    avg_route_difficulty DESC;
