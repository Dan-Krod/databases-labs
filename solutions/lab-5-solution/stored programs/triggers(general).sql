USE Patrol_Robots_SQL;

CREATE TABLE IF NOT EXISTS Tasks_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    operation_type VARCHAR(50) NOT NULL,
    old_task_name VARCHAR(255),
    old_priority ENUM('Low', 'Medium', 'High'),
    old_due_date DATE,
    old_description TEXT,
    change_time DATETIME NOT NULL,
    FOREIGN KEY (task_id) REFERENCES Tasks(task_id)
        ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Тригер для журналу модифікацій
DELIMITER $$

CREATE TRIGGER LogTaskChanges
AFTER UPDATE ON Tasks
FOR EACH ROW
BEGIN
    INSERT INTO Tasks_Log (task_id, operation_type, old_task_name, old_priority, old_due_date, old_description, change_time)
    VALUES (OLD.task_id, 'UPDATE', OLD.task_name, OLD.priority, OLD.due_date, OLD.description, NOW());
END$$

DELIMITER ;



-- Коли статус робота змінюється на Maintenance, тригер автоматично створює запис у таблиці Maintenance
DELIMITER $$

CREATE TRIGGER AddMaintenanceAndLinkOnRobotStatusChange
AFTER UPDATE ON Robot
FOR EACH ROW
BEGIN
    DECLARE new_maintenance_id INT;

    -- Перевіряємо, чи статус змінено на 'Maintenance'
    IF NEW.status = 'Maintenance' AND OLD.status != 'Maintenance' THEN
        -- Додаємо запис у таблицю Maintenance
        INSERT INTO Maintenance (maintenance_date, description, technician_name, next_maintenance)
        VALUES (NOW(), CONCAT('Robot ', NEW.robot_id, ' requires maintenance'), 'System Auto', DATE_ADD(NOW(), INTERVAL 30 DAY));
        
        -- Отримуємо ID новоствореного запису
        SET new_maintenance_id = LAST_INSERT_ID();

        -- Додаємо зв’язок у таблицю Robot_Maintenance
        INSERT INTO Robot_Maintenance (robot_id, maintenance_id)
        VALUES (NEW.robot_id, new_maintenance_id);
    END IF;
END$$

DELIMITER ;




-- Заборона вставки завдань з датою завершення у минулому
DELIMITER $$

CREATE TRIGGER PreventPastDueDate
BEFORE INSERT ON Tasks
FOR EACH ROW
BEGIN
    -- Перевіряємо, чи дата завершення менша за сьогоднішню
    IF NEW.due_date < CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Cannot insert tasks with a past due date.';
    END IF;
END$$

DELIMITER ;

