USE Patrol_Robots_SQL;

-- Процедура для параметризованої вставки завдання
DELIMITER $$

CREATE PROCEDURE InsertIntoTable(
    IN table_name VARCHAR(255),
    IN column_names TEXT,
    IN values_list TEXT
)
BEGIN
    SET @sql = CONCAT('INSERT INTO ', table_name, ' (', column_names, ') VALUES (', values_list, ')');
    
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;


-- Процедура для зв’язку M:M між роботами та технічним обслуговуванням
DELIMITER $$

CREATE PROCEDURE LinkRobotToMaintenanceByAttributes (
    IN robot_status VARCHAR(255),
    IN maintenance_description VARCHAR(255)
)
BEGIN
    DECLARE robotID INT DEFAULT NULL;
    DECLARE maintenanceID INT DEFAULT NULL;

    SELECT robot_id
    INTO robotID
    FROM Robot
    WHERE status = robot_status
    LIMIT 1;

    IF robotID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No robot with the specified status found.';
    END IF;

    SELECT maintenance_id
    INTO maintenanceID
    FROM Maintenance
    WHERE description = maintenance_description
    LIMIT 1;

    IF maintenanceID IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No maintenance with the specified description found.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM Robot_Maintenance
        WHERE robot_id = robotID AND maintenance_id = maintenanceID
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This relationship already exists.';
    END IF;

    INSERT INTO Robot_Maintenance (robot_id, maintenance_id)
    VALUES (robotID, maintenanceID);
END$$

DELIMITER ;

-- Процедура для вставки 10 рядків
DELIMITER $$

CREATE PROCEDURE InsertMultipleOperators ()
BEGIN
    DECLARE i INT DEFAULT 1;

    WHILE i <= 10 DO
        INSERT INTO Operator (name, shift_start, shift_end, contact_info)
        VALUES (
            CONCAT('Noname', i),              -- Генероване ім'я
            ADDTIME('08:00:00', SEC_TO_TIME(i * 3600)), -- Початок зміни (зсув на годину для кожного рядка)
            ADDTIME('16:00:00', SEC_TO_TIME(i * 3600)), -- Кінець зміни (зсув на годину для кожного рядка)
            CONCAT('noname', i, '@example.com') -- Генерований контакт
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;
