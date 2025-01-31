USE Patrol_Robots_SQL;

-- Тригер для перевірки точності розпізнавання осіб
DELIMITER $$

CREATE TRIGGER PreventLowAccuracy
BEFORE INSERT ON Person_Identification
FOR EACH ROW
BEGIN
    IF NEW.accuracy < 90 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Accuracy must be at least 90% to insert a new identification.';
    END IF;
END$$

DELIMITER ;

-- Для журналізації оновлень у таблиці Patrol_Report
CREATE TABLE IF NOT EXISTS Patrol_Report_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    operation_type ENUM('UPDATE') NOT NULL,
    report_id INT NOT NULL,
    modified_data TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

DELIMITER $$

CREATE TRIGGER LogPatrolReportUpdates
AFTER UPDATE ON Patrol_Report
FOR EACH ROW
BEGIN
    INSERT INTO Patrol_Report_Log (operation_type, report_id, modified_data)
    VALUES (
        'UPDATE',
        OLD.report_id,
        CONCAT(
            'Old Start Time: ', OLD.start_time, ', New Start Time: ', NEW.start_time, '; ',
            'Old End Time: ', OLD.end_time, ', New End Time: ', NEW.end_time, '; ',
            'Old Report Type: ', OLD.report_type, ', New Report Type: ', NEW.report_type
        )
    );
END$$

DELIMITER ;

-- Тригер для автоматичного створення завдань при перевищенні температури батареї
DELIMITER $$

CREATE TRIGGER CreateTaskForBatteryIssues
AFTER INSERT ON Battery
FOR EACH ROW
BEGIN
    DECLARE battery_temp DECIMAL(5,2);
    DECLARE low_battery_threshold INT DEFAULT 20;

    SET battery_temp = CAST(SUBSTRING_INDEX(NEW.temperature, '°', 1) AS DECIMAL(5,2));

    IF battery_temp > 40 THEN
        INSERT INTO Tasks (operator_id, task_name, task_type, priority, status, due_date, description)
        VALUES (
            1, 
            'Inspect Battery Temperature', 
            'Inspection', 
            'High', 
            'Assigned', 
            CURDATE() + INTERVAL 1 DAY, 
            CONCAT('Inspect battery temperature of robot ', NEW.robot_id, '. Current temperature: ', NEW.temperature)
        );
    END IF;

    IF NEW.battery_level < low_battery_threshold THEN
        INSERT INTO Tasks (operator_id, task_name, task_type, priority, status, due_date, description)
        VALUES (
            1, 
            'Low Battery Alert', 
            'Monitoring', 
            'Medium', 
            'Assigned', 
            CURDATE() + INTERVAL 1 DAY, 
            CONCAT('Check robot ', NEW.robot_id, ' due to low battery level: ', NEW.battery_level, '%.')
        );
    END IF;
END$$

DELIMITER ;


-- Тригер для перевірки перед видаленням у Tasks
DELIMITER $$

CREATE TRIGGER PreventTaskDelete
BEFORE DELETE ON Tasks
FOR EACH ROW
BEGIN
    DECLARE task_status VARCHAR(50);
    
    SELECT status INTO task_status
    FROM Tasks
    WHERE task_id = OLD.task_id;
    
    IF task_status IN ('In Progress') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete tasks that are In Progress';
    END IF;
END$$

DELIMITER ;

-- Автоматичне оновлення рівня складності маршруту
DELIMITER $$

CREATE TRIGGER IncreaseRouteDifficultyOnTechnicalIssue
AFTER INSERT ON Patrol_Report
FOR EACH ROW
BEGIN
    IF NEW.report_type = 'patrol_with_technical_issues' THEN
        UPDATE Patrol_Route
        SET difficulty_level = difficulty_level + 0.5
        WHERE routes_id = NEW.routes_id;
    END IF;
END$$

DELIMITER ;

-- Перевірка на повторюваність записів у Person_Identification
DELIMITER $$

CREATE TRIGGER PreventDuplicatePersonIdentification
BEFORE INSERT ON Person_Identification
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Person_Identification
        WHERE person_name = NEW.person_name AND sensor_id = NEW.sensor_id
          AND TIMESTAMPDIFF(MINUTE, timestamp, NEW.timestamp) < 5
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate person identification detected within 5 minutes.';
    END IF;
END$$

DELIMITER ;



-- Тригер для автоматичної зміни статусу маршруту
-- DELIMITER $$

-- CREATE TRIGGER UpdateRouteStatusOnRobotMaintenance
-- AFTER UPDATE ON Robot
-- FOR EACH ROW
-- BEGIN
--     IF NEW.status = 'Maintenance' AND OLD.status != 'Maintenance' THEN
--         UPDATE Patrol_Route
--         SET start_point = CONCAT('Inactive-', start_point), end_point = CONCAT('Inactive-', end_point)
--         WHERE robot_id = NEW.robot_id;
--     END IF;
-- END$$

-- DELIMITER ;

-- Тригер для створення звітів про батареї
-- DELIMITER $$

-- CREATE TRIGGER AlertLowBatteryLevel
-- AFTER INSERT ON Battery
-- FOR EACH ROW
-- BEGIN
--     IF NEW.battery_level < 20 THEN
--         INSERT INTO Alert (type, timestamp, status, audio_system_id)
--         VALUES ('Battery Low', NOW(), 'Pending', 
--             (SELECT audio_system_id FROM Audio_system WHERE robot_id = NEW.robot_id LIMIT 1));
--     END IF;
-- END$$

-- DELIMITER ;