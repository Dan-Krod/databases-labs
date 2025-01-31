USE robot_db;
SELECT 
    m.technician_name, 
    COUNT(m.maintenance_id) AS total_maintenance,
    AVG(DATEDIFF(m.next_maintenance, m.maintenance_date)) AS avg_days_to_next
FROM 
    maintenance m
JOIN 
    robot_maintenance rm ON m.maintenance_id = rm.maintenance_id
JOIN 
    robot r ON rm.robot_id = r.robot_id
GROUP BY 
    m.technician_name
ORDER BY 
    total_maintenance DESC;