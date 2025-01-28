SELECT 
    a.has_speaker,
    a.has_microphone,
    COUNT(r.robot_id) AS robots_count
FROM 
    Audio_system a
JOIN 
    Robot r ON a.robot_id = r.robot_id
GROUP BY 
    a.has_speaker, a.has_microphone;
