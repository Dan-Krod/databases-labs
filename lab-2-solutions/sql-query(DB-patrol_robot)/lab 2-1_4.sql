USE robot_db;
SELECT 
    r.robot_id,
    r.status,
    r.max_distance,
    c.status AS camera_status
FROM 
    robot r
JOIN 
    camera c ON r.robot_id = c.robot_id
WHERE 
    r.alternative_power_source = 'yes' 
    AND c.night_vision = 'yes'
    AND c.status = 'Operational';
