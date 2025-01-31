DELIMITER $$

CREATE PROCEDURE CreateDatabasesAndTables()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE db_name VARCHAR(64);
    DECLARE table_count INT;
    DECLARE table_name VARCHAR(64);
    DECLARE cur CURSOR FOR SELECT DISTINCT trigger_status FROM sensor; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO db_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @create_db_query = CONCAT('CREATE DATABASE IF NOT EXISTS ', db_name);
        PREPARE stmt1 FROM @create_db_query;
        EXECUTE stmt1;
        DEALLOCATE PREPARE stmt1;

        SET table_count = FLOOR(1 + (RAND() * 9)); 

        SET @table_index = 1; 

        create_tables_loop: LOOP
            IF @table_index > table_count THEN
                LEAVE create_tables_loop;
            END IF;

            SET table_name = CONCAT(db_name, '_table', @table_index);
            SET @create_table_query = CONCAT('CREATE TABLE IF NOT EXISTS ', db_name, '.', table_name, ' (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100), attribute2 INT NOT NULL,
                    attribute3 FLOAT NOT NULL)');
            PREPARE stmt2 FROM @create_table_query;
            EXECUTE stmt2;
            DEALLOCATE PREPARE stmt2;

            SET @table_index = @table_index + 1; 
        END LOOP;

    END LOOP;

    CLOSE cur;

END$$

DELIMITER ;
