USE robot_db;
SELECT 
	r.robot_id, 
    COUNT(a.alerts_id) AS alert_count, 
    r.status
FROM 
	robot r
LEFT JOIN 
	audio_system asys ON r.robot_id = asys.robot_id
LEFT JOIN 
	alert a ON asys.audio_system_id = a.audio_system_id
GROUP BY 
	r.robot_id, 
    r.status
HAVING
	alert_count > 0