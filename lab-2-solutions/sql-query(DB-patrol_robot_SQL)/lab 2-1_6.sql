USE robot_db;
SELECT 
    pi.person_name,
    COUNT(pi.identification_id) AS identification_count,
    AVG(pi.accuracy) AS avg_accuracy,
    GROUP_CONCAT(DISTINCT pr.routes_id ORDER BY pr.routes_id) AS route_ids
FROM 
    person_identification pi
JOIN 
    patrol_report pr ON pi.report_id = pr.report_id
WHERE 
    pi.accuracy >= 95  
GROUP BY 
    pi.person_name
ORDER BY 
    avg_accuracy DESC

