USE patrol_robots_sql;

-- Тригер для перевірки наявності оператора (перед вставкою)
DELIMITER $$

CREATE TRIGGER EnsureTaskOperatorExists
BEFORE INSERT ON Tasks
FOR EACH ROW
BEGIN
    DECLARE operator_exists INT;

    SELECT COUNT(*) INTO operator_exists
    FROM Operator
    WHERE operators_id = NEW.operator_id;

    IF operator_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Operator does not exist';
    END IF;
END$$

DELIMITER ;


-- Тригер для перевірки мінімальної кількості записів (кардинальність таблиці)
DELIMITER $$

CREATE TRIGGER CheckTaskCount
BEFORE INSERT ON Tasks
FOR EACH ROW
BEGIN
    DECLARE task_count INT;

    SELECT COUNT(*) INTO task_count FROM Tasks;
    
    IF task_count < 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least one task must exist in the table';
    END IF;
END$$

DELIMITER ;

-- Тригер для перевірки перед оновленням
DELIMITER $$

CREATE TRIGGER PreventTaskUpdate
BEFORE UPDATE ON Tasks
FOR EACH ROW
BEGIN
    IF NEW.operator_id != OLD.operator_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Operator cannot be changed for an existing task';
    END IF;
END$$

DELIMITER ;

-- каскадне видалення завдань при видаленні оператора
DELIMITER $$

CREATE TRIGGER CascadeDeleteTasks
AFTER DELETE ON Operator
FOR EACH ROW
BEGIN
    DELETE FROM Tasks WHERE operator_id = OLD.operators_id;
END$$

DELIMITER ;

