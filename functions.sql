USE Patrol_Robots_SQL;

DELIMITER $$

CREATE PROCEDURE CalculateAggregateDynamic(
    IN table_name VARCHAR(64),
    IN column_name VARCHAR(64),
    IN operation VARCHAR(10),
    OUT result DECIMAL(20, 2)
)
BEGIN
    SET @query = CONCAT(
        'SELECT ', operation, '(', column_name, ') AS calculated_value FROM ', table_name
    );
    PREPARE stmt FROM @query;
    EXECUTE stmt;

    SELECT @result INTO result;
    DEALLOCATE PREPARE stmt;
END$$

DELIMITER ;
