CREATE DATABASE IF NOT EXISTS Patrol_Robots_SQL;
USE Patrol_Robots_SQL;

DROP TABLE IF EXISTS `Person_Identification`;
DROP TABLE IF EXISTS `Sensor`;
DROP TABLE IF EXISTS `Camera`;
DROP TABLE IF EXISTS `Patrol_Report`;
DROP TABLE IF EXISTS `Patrol_Route`;
DROP TABLE IF EXISTS `Alert`;
DROP TABLE IF EXISTS `Audio_system`;
DROP TABLE IF EXISTS `Battery`;
DROP TABLE IF EXISTS `Robot_Maintenance`;
DROP TABLE IF EXISTS `Maintenance`;
DROP TABLE IF EXISTS `Robot`;
DROP TABLE IF EXISTS `Operator`;
DROP TABLE IF EXISTS `Solar_System`;
DROP TABLE IF EXISTS `Charging_station`;


CREATE TABLE IF NOT EXISTS `Operator` (
  `operators_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `shift_start` TIME NOT NULL,
  `shift_end` TIME NOT NULL,
  `contact_info` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`operators_id`),
  CONSTRAINT `unique_operator_contact_info` UNIQUE (`contact_info`) 
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Charging_station` (
  `station_id` INT NOT NULL AUTO_INCREMENT,
  `location` VARCHAR(45) NOT NULL,
  `capacity` INT NOT NULL,
  `available` ENUM('yes', 'no') NOT NULL,
  PRIMARY KEY (`station_id`),
  CONSTRAINT `unique_charging_station_location` UNIQUE (`location`)
) ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Solar_System` (
  `solar_id` INT NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(45) NOT NULL,
  `power_output` FLOAT NOT NULL,
  `technology_used` VARCHAR(45) NOT NULL,
  `station_id` INT NOT NULL,
  PRIMARY KEY (`solar_id`),
  FOREIGN KEY (`station_id`) REFERENCES `Charging_station`(`station_id`) ON DELETE CASCADE,
  CONSTRAINT `unique_solar_technology_station` UNIQUE (`technology_used`, `station_id`) 
) ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Robot` (
  `robot_id` INT NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(50) NOT NULL,
  `max_distance` INT NOT NULL,
  `operator_id` INT NOT NULL,
  `station_id` INT NOT NULL,
  `alternative_power_source` ENUM('yes', 'no') NOT NULL,
  PRIMARY KEY (`robot_id`),
  FOREIGN KEY (`operator_id`) REFERENCES `Operator`(`operators_id`) ON DELETE CASCADE,
  FOREIGN KEY (`station_id`) REFERENCES `Charging_station`(`station_id`) ON DELETE CASCADE,
  CONSTRAINT `unique_robot_operator_station` UNIQUE (`operator_id`, `station_id`) 
) ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Audio_system` (
  `audio_system_id` INT NOT NULL AUTO_INCREMENT,
  `has_speaker` ENUM('yes', 'no') NOT NULL,
  `status` VARCHAR(50) NOT NULL,
  `has_panic_button` ENUM('yes', 'no') NOT NULL,
  `robot_id` INT NOT NULL,
  PRIMARY KEY (`audio_system_id`),
  FOREIGN KEY (`robot_id`) REFERENCES `Robot`(`robot_id`) ON DELETE CASCADE,
  CONSTRAINT `unique_audio_system_robot_status` UNIQUE (`robot_id`, `status`) 
) ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Alert` (
  `alerts_id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(50) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `status` VARCHAR(50) NOT NULL,
  `audio_system_id` INT NOT NULL,
  PRIMARY KEY (`alerts_id`),
  FOREIGN KEY (`audio_system_id`) REFERENCES `Audio_system`(`audio_system_id`) ON DELETE CASCADE
) ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Battery` (
  `battery_id` INT NOT NULL,
  `log_time` DATETIME NOT NULL,
  `battery_level` INT NOT NULL,
  `robot_id` INT NOT NULL,
  `temperature` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`battery_id`),
  FOREIGN KEY (`robot_id`) REFERENCES `Robot`(`robot_id`) ON DELETE CASCADE
) ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Camera` (
  `camera_id` INT NOT NULL AUTO_INCREMENT,
  `robot_id` INT NOT NULL,
  `resolution` VARCHAR(45) NOT NULL,
  `zoom_level` INT NOT NULL,
  `status` VARCHAR(50) NOT NULL,
  `night_vision` ENUM('yes', 'no') NOT NULL,
  `panoramic_view` ENUM('yes', 'no') NOT NULL,
  PRIMARY KEY (`camera_id`),
  FOREIGN KEY (`robot_id`) REFERENCES `Robot`(`robot_id`) ON DELETE CASCADE
) ENGINE = InnoDB
AUTO_INCREMENT = 9
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Sensor` (
  `sensor_id` INT NOT NULL AUTO_INCREMENT,
  `robot_id` INT NOT NULL,
  `technology_used` VARCHAR(50) NOT NULL,
  `detection_range` INT NOT NULL,
  `trigger_status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`sensor_id`),
  FOREIGN KEY (`robot_id`) REFERENCES `Robot`(`robot_id`) ON DELETE CASCADE
) ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Patrol_Route` (
  `routes_id` INT NOT NULL AUTO_INCREMENT,
  `start_point` VARCHAR(100) NOT NULL,
  `end_point` VARCHAR(100) NOT NULL,
  `difficulty_level` FLOAT NOT NULL,
  `robot_id` INT NOT NULL,
  PRIMARY KEY (`routes_id`),
  FOREIGN KEY (`robot_id`) REFERENCES `Robot`(`robot_id`) ON DELETE CASCADE,
  CONSTRAINT `unique_route_start_end` UNIQUE (`start_point`, `end_point`) 
) ENGINE = InnoDB
AUTO_INCREMENT = 12
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Patrol_Report` (
  `report_id` INT NOT NULL AUTO_INCREMENT,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  `report_type` ENUM('routine_patrol', 'patrol_with_technical_issues', 'person_detected') NOT NULL,
  `routes_id` INT NOT NULL,
  PRIMARY KEY (`report_id`),
  FOREIGN KEY (`routes_id`) REFERENCES `Patrol_Route`(`routes_id`) ON DELETE CASCADE
) ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Person_Identification` (
  `identification_id` INT NOT NULL AUTO_INCREMENT,
  `person_name` VARCHAR(50) NOT NULL,
  `timestamp` DATETIME NOT NULL,
  `accuracy` DECIMAL(5,2) NOT NULL,
  `sensor_id` INT NOT NULL,
  `camera_id` INT NOT NULL,
  `report_id` INT NOT NULL,
  PRIMARY KEY (`identification_id`),
  FOREIGN KEY (`sensor_id`) REFERENCES `Sensor`(`sensor_id`) ON DELETE CASCADE,
  FOREIGN KEY (`camera_id`) REFERENCES `Camera`(`camera_id`) ON DELETE CASCADE,
  FOREIGN KEY (`report_id`) REFERENCES `Patrol_Report`(`report_id`) ON DELETE CASCADE
) ENGINE = InnoDB
AUTO_INCREMENT = 8
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE IF NOT EXISTS `Maintenance` (
  `maintenance_id` INT NOT NULL AUTO_INCREMENT,
  `maintenance_date` DATETIME NOT NULL,
  `description` TEXT NOT NULL,
  `technician_name` VARCHAR(50) NOT NULL,
  `next_maintenance` DATETIME NOT NULL,
  PRIMARY KEY (`maintenance_id`)
) ENGINE = InnoDB
AUTO_INCREMENT = 11
DEFAULT CHARACTER SET = utf8mb4;

CREATE TABLE `Robot_Maintenance` (
    `robot_id` INT NOT NULL,
    `maintenance_id` INT NOT NULL,
    PRIMARY KEY (`robot_id`, `maintenance_id`),
    FOREIGN KEY (`robot_id`) REFERENCES `Robot`(`robot_id`) ON DELETE CASCADE,
    FOREIGN KEY (`maintenance_id`) REFERENCES `Maintenance`(`maintenance_id`) ON DELETE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;

COMMIT;

CREATE INDEX `idx_status` ON `Robot` (`status` ASC);
CREATE INDEX `idx_location` ON `Charging_station` (`location` ASC);
CREATE INDEX `idx_patrol_report_type` ON `Patrol_Report` (`report_type`);
CREATE INDEX `idx_person_identification_timestamp` ON `Person_Identification` (`timestamp`);
CREATE INDEX `idx_sensor_technology_trigger` ON `Sensor` (`technology_used`, `trigger_status`);

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Operator` (`operators_id`, `name`, `shift_start`, `shift_end`, `contact_info`) VALUES 
(1, 'Alina Koval', '08:00:00', '16:00:00', 'alina.koval@robotics-patrol.com'),
(2, 'Maxim Petrenko', '16:00:00', '00:00:00', 'maxim.petrenko@robotics-patrol.com'),
(3, 'Oleksandr Sydorenko', '00:00:00', '08:00:00', 'oleksandr.sydorenko@robotics-patrol.com'),
(4, 'Iryna Melnyk', '08:00:00', '16:00:00', 'iryna.melnyk@robotics-patrol.com'),
(5, 'Volodymyr Hnatyuk', '16:00:00', '00:00:00', 'volodymyr.hnatyuk@robotics-patrol.com'),
(6, 'Sofia Yaroshenko', '00:00:00', '08:00:00', 'sofia.yaroshenko@robotics-patrol.com'),
(7, 'Dmytro Kravchenko', '08:00:00', '16:00:00', 'dmytro.kravchenko@robotics-patrol.com'),
(8, 'Oleh Marchenko', '16:00:00', '00:00:00', 'oleh.marchenko@robotics-patrol.com'),
(9, 'Yulia Polishchuk', '08:00:00', '16:00:00', 'yulia.polishchuk@robotics-patrol.com'),
(10, 'Taras Ivanchenko', '00:00:00', '08:00:00', 'taras.ivanchenko@robotics-patrol.com'),
(11, 'Maryna Pylypchuk', '08:00:00', '16:00:00', 'maryna.pylypchuk@robotics-patrol.com'),
(12, 'Oleksii Kravets', '16:00:00', '00:00:00', 'oleksii.kravets@robotics-patrol.com'),
(13, 'Anna Levchenko', '00:00:00', '08:00:00', 'anna.levchenko@robotics-patrol.com');

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Charging_station` (`station_id`, `location`, `capacity`, `available`) VALUES 
(1, 'Sector Alpha', 10, 'yes'),
(2, 'Sector Beta', 15, 'no'),
(3, 'Sector Gamma', 12, 'yes'),
(4, 'Sector Delta', 8, 'yes'),
(5, 'Sector Epsilon', 20, 'no'),
(6, 'Sector Zeta', 5, 'yes'),
(7, 'Sector Eta', 7, 'yes'),
(8, 'Sector Theta', 12, 'no'),
(9, 'Sector Iota', 18, 'yes'),
(10, 'Sector Kappa', 6, 'no');

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Solar_System` (`solar_id`, `status`, `power_output`, `technology_used`, `station_id`) VALUES 
(1, 'Operational', 1500.5, 'Monocrystalline', 2),
(2, 'Inactive', 0, 'Polycrystalline', 3),
(3, 'Operational', 1200, 'Monocrystalline', 1),
(4, 'Operational', 1800.2, 'Thin-Film', 1),
(5, 'Operational', 2000, 'Monocrystalline', 5),
(6, 'Inactive', 0, 'Polycrystalline', 6),
(7, 'Operational', 1600.8, 'Monocrystalline', 4),
(8, 'Operational', 1750, 'Monocrystalline', 7),
(9, 'Inactive', 0, 'Thin-Film', 8),
(10, 'Operational', 1900.5, 'Polycrystalline', 9);

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Robot` (`robot_id`, `status`, `max_distance`, `operator_id`, `station_id`, `alternative_power_source`) VALUES 
(1, 'Active', 100, 1, 1, 'yes'),
(2, 'Active', 120, 2, 2, 'no'),
(3, 'Maintenance', 150, 3, 3, 'yes'),
(4, 'Active', 80, 4, 4, 'no'),
(5, 'Maintenance', 130, 5, 5, 'yes'),
(6, 'Active', 110, 6, 6, 'no'),
(7, 'Maintenance', 90, 7, 7, 'yes'),
(8, 'Active', 80, 3, 6, 'yes'),
(9, 'Active', 80, 1, 7, 'no'),
(10, 'Active', 90, 8, 8, 'yes'),
(11, 'Active', 120, 9, 9, 'no'),
(12, 'Maintenance', 110, 10, 10, 'yes'),
(13, 'Maintenance', 95, 11, 1, 'no');

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Audio_system` (`audio_system_id`, `has_speaker`, `status`, `has_panic_button`, `robot_id`) VALUES 
(1, 'yes', 'Active', 'yes', 1),    
(2, 'yes', 'Inactive', 'yes', 1),  
(3, 'yes', 'Active', 'no', 2),    
(4, 'no', 'Inactive', 'yes', 2),   
(5, 'yes', 'Active', 'no', 4),     
(6, 'no', 'Inactive', 'yes', 5),  
(7, 'yes', 'Active', 'yes', 6),  
(8, 'no', 'Inactive', 'yes', 6),   
(9, 'yes', 'Active', 'yes', 8),    
(10, 'no', 'Inactive', 'no', 8),   
(11, 'yes', 'Active', 'yes', 9),   
(12, 'yes', 'Inactive', 'no', 10),
(13, 'yes', 'Active', 'yes', 10),  
(14, 'yes', 'Active', 'yes', 11),  
(15, 'no', 'Inactive', 'yes', 12), 
(16, 'no', 'Inactive', 'no', 13); 

COMMIT;

INSERT INTO `Alert` (`alerts_id`, `type`, `timestamp`, `status`, `audio_system_id`) VALUES 
(1, 'Battery Low', '2024-09-19 14:30:00', 'Active', 1),
(2, 'Temperature Alert', '2024-09-18 16:00:00', 'Resolved', 3),
(3, 'Camera Dirty', '2024-09-17 10:45:00', 'Active', 5),
(4, 'Signal Lost', '2024-09-16 08:00:00', 'Pending', 7),
(5, 'Power Fluctuation', '2024-09-15 19:30:00', 'Resolved', 9),
(6, 'Battery Depletion', '2024-09-14 12:00:00', 'Active', 11),
(7, 'Overheating Warning', '2024-09-13 14:15:00', 'Pending', 13),
(8, 'Signal Interference', '2024-09-10 11:15:00', 'Pending', 1),
(9, 'Power Failure', '2024-09-13 19:15:00', 'Pending', 3),
(10, 'Battery Low', '2024-09-13 23:15:00', 'Pending', 5),
(11, 'Temperature Alert', '2024-09-20 15:00:00', 'Active', 7),
(12, 'Camera Dirty', '2024-09-21 18:45:00', 'Active', 9),
(13, 'System Overheating', '2024-09-22 10:30:00', 'Pending', 11),
(14, 'Power Loss', '2024-09-23 09:15:00', 'Resolved', 13),
(15, 'Battery Low', '2024-09-23 10:45:00', 'Resolved', 14);

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Battery` (`battery_id`, `log_time`, `battery_level`, `robot_id`, `temperature`) VALUES 
(1, '2024-09-19 08:00:00', 85, 1, '35.5°C'),
(2, '2024-09-18 16:00:00', 40, 2, '37.2°C'),
(3, '2024-09-17 10:00:00', 55, 3, '36.1°C'),
(4, '2024-09-16 12:00:00', 20, 4, '38.0°C'),
(5, '2024-09-15 19:00:00', 70, 5, '34.8°C'),
(6, '2024-09-14 14:00:00', 60, 6, '36.7°C'),
(7, '2024-09-13 09:00:00', 50, 7, '35.9°C'),
(8, '2024-09-13 23:00:00', 15, 3, '38.5°C'),
(9, '2024-09-23 11:00:00', 75, 5, '34.6°C'),
(10, '2024-09-10 19:00:00', 45, 3, '36.4°C'),
(11, '2024-09-20 08:00:00', 65, 8, '35.2°C'),
(12, '2024-09-21 15:00:00', 55, 9, '37.0°C'),
(13, '2024-09-22 12:00:00', 40, 10, '36.8°C'),
(14, '2024-09-23 09:00:00', 30, 11, '35.6°C'),
(15, '2024-09-24 10:00:00', 90, 12, '34.5°C'),
(16, '2024-09-25 11:00:00', 75, 13, '36.0°C');

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Camera` (`camera_id`, `robot_id`, `resolution`, `zoom_level`, `status`, `night_vision`, `panoramic_view`) VALUES 
(1, 1, '1920x1080', 10, 'Operational', 'yes', 'no'),   
(2, 2, '1280x720', 20, 'Operational', 'no', 'yes'),     
(3, 3, '3840x2160', 15, 'Malfunctioning', 'yes', 'yes'), 
(4, 4, '1920x1080', 8, 'Operational', 'yes', 'no'),     
(5, 5, '1280x720', 12, 'Malfunctioning', 'no', 'no'),   
(6, 6, '3840x2160', 18, 'Operational', 'yes', 'yes'), 
(7, 7, '1920x1080', 14, 'Malfunctioning', 'no', 'yes'),  
(8, 5, '1280x1080', 10, 'Operational', 'no', 'yes'),  
(9, 6, '2560x1440', 12, 'Operational', 'yes', 'yes'),  
(10, 7, '1920x1080', 16, 'Malfunctioning', 'no', 'no'), 
(11, 8, '3840x2160', 20, 'Operational', 'yes', 'no'),   
(12, 9, '1920x1080', 10, 'Operational', 'yes', 'yes'),  
(13, 10, '1280x720', 12, 'Operational', 'no', 'no'),    
(14, 11, '2560x1440', 15, 'Operational', 'yes', 'yes'),  
(15, 12, '1920x1080', 8, 'Malfunctioning', 'no', 'no'),  
(16, 13, '3840x2160', 20, 'Operational', 'yes', 'no');   

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Sensor` (`sensor_id`, `robot_id`, `technology_used`, `detection_range`, `trigger_status`) VALUES 
(1, 1, 'Infrared', 50, 'Active'),  
(2, 2, 'Motion', 100, 'Active'),   
(3, 3, 'Thermal', 70, 'Malfunctioning'),  
(4, 4, 'Motion', 80, 'Active'),   
(5, 5, 'Infrared', 60, 'Malfunctioning'), 
(6, 6, 'Thermal', 90, 'Active'),  
(7, 7, 'Motion', 50, 'Malfunctioning'),  
(8, 8, 'Ultrasonic', 40, 'Active'),  
(9, 1, 'Lidar', 120, 'Malfunctioning'), 
(10, 1, 'Thermal', 75, 'Active'),  
(11, 9, 'Infrared', 50, 'Active'), 
(12, 10, 'Ultrasonic', 60, 'Active'),  
(13, 11, 'Thermal', 80, 'Active'),  
(14, 12, 'Motion', 100, 'Malfunctioning'), 
(15, 13, 'Lidar', 120, 'Malfunctioning'); 

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Patrol_Route` (`routes_id`, `start_point`, `end_point`, `difficulty_level`, `robot_id`) VALUES 
(1, 'Point A', 'Point B', 2, 1),
(2, 'Point C', 'Point D', 3, 2),
(3, 'Point E', 'Point F', 1, 3),
(4, 'Point G', 'Point H', 2, 4),
(5, 'Point I', 'Point J', 3, 5),
(6, 'Point K', 'Point L', 2, 6),
(7, 'Point M', 'Point N', 4, 7),
(8, 'Point A', 'Point L', 1, 8),
(9, 'Point C', 'Point J', 2, 9),
(10, 'Point G', 'Point D', 5, 4),
(11, 'Point L', 'Point A', 5, 2),
(12, 'Point B', 'Point G', 3, 9),
(13, 'Point H', 'Point M', 4, 10),
(14, 'Point F', 'Point N', 2, 11),
(15, 'Point J', 'Point D', 5, 12),
(16, 'Point E', 'Point I', 3, 13);

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Patrol_Report` (`report_id`, `start_time`, `end_time`, `report_type`, `routes_id`) VALUES 
(1, '2024-09-10 08:00:00', '2024-09-10 18:00:00', 'routine_patrol', 2), 
(2, '2024-09-16 08:00:00', '2024-09-16 16:30:00', 'person_detected', 4), 
(3, '2024-09-14 07:30:00', '2024-09-14 15:30:00', 'routine_patrol', 8),  
(4, '2024-09-17 08:00:00', '2024-09-17 18:00:00', 'person_detected', 1), 
(5, '2024-09-13 08:30:00', '2024-09-13 16:30:00', 'patrol_with_technical_issues', 10),
(6, '2024-09-14 08:00:00', '2024-09-14 16:00:00', 'person_detected', 2),
(7, '2024-09-13 10:30:00', '2024-09-13 19:00:00', 'person_detected', 8), 
(8, '2024-09-12 08:00:00', '2024-09-12 18:00:00', 'patrol_with_technical_issues', 1), 
(9, '2024-09-12 10:00:00', '2024-09-12 16:00:00', 'routine_patrol', 6),  
(10, '2024-09-10 08:30:00', '2024-09-10 18:30:00', 'person_detected', 11), 
(11, '2024-09-14 07:30:00', '2024-09-14 15:30:00', 'patrol_with_technical_issues', 6), 
(12, '2024-09-12 08:30:00', '2024-09-12 16:30:00', 'routine_patrol', 10), 
(13, '2024-09-16 07:00:00', '2024-09-16 15:00:00', 'routine_patrol', 4), 
(14, '2024-09-12 08:30:00', '2024-09-12 18:30:00', 'person_detected', 8),
(15, '2024-09-18 09:30:00', '2024-09-18 17:00:00', 'person_detected', 12), 
(16, '2024-09-12 08:00:00', '2024-09-12 18:00:00', 'routine_patrol', 13), 
(17, '2024-09-15 08:00:00', '2024-09-15 16:30:00', 'patrol_with_technical_issues', 14); 

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Person_Identification` (`identification_id`, `person_name`, `timestamp`, `accuracy`, `sensor_id`, `camera_id`, `report_id`) 
VALUES 
(1, 'Michael Johnson', '2024-09-17 10:50:00', 95.80, 1, 1, 4), 
(2, 'Sarah Williams', '2024-09-16 08:05:00', 96.30, 4, 4, 2), 
(3, 'Emily Davis', '2024-09-14 12:05:00', 93.60, 2, 2, 6), 
(4, 'Chris Evans', '2024-09-13 14:20:00', 98.10, 8, 8, 7),
(5, 'David Black', '2024-09-17 14:00:00', 91.50, 1, 1, 4),
(6, 'Anna White', '2024-09-18 10:30:00', 94.20, 4, 4, 2), 
(7, 'James Green', '2024-09-14 13:15:00', 97.10, 2, 2, 6), 
(8, 'Laura Blue', '2024-09-13 11:00:00', 98.10, 5, 5, 5), 
(9, 'James Green', '2024-09-16 15:45:00', 93.30, 4, 4, 4), 
(10, 'Lucy Brown', '2024-09-12 10:30:00', 96.00, 8, 8, 14), 
(11, 'Chris Evans', '2024-09-12 14:20:00', 92.50, 11, 9, 15),
(12, 'Alice Green', '2024-09-10 11:30:00', 94.40, 2, 2, 10);

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Maintenance` (`maintenance_id`, `maintenance_date`, `description`, `technician_name`, `next_maintenance`) VALUES 
(1, '2024-09-19 09:00:00', 'Routine check-up', 'Emily Davis', '2024-10-19 09:00:00'),
(2, '2024-09-18 11:00:00', 'Sensor replacement', 'Michael Johnson', '2024-10-18 11:00:00'),
(3, '2024-09-17 14:00:00', 'Battery calibration', 'John Smith', '2024-10-17 14:00:00'),
(4, '2024-09-16 10:00:00', 'Software update', 'Sara Lee', '2024-10-16 10:00:00'),
(5, '2024-09-15 13:00:00', 'Component replacement', 'Paul Walker', '2024-10-15 13:00:00'),
(6, '2024-09-14 15:00:00', 'System diagnostic', 'Anna Clark', '2024-10-14 15:00:00'),
(7, '2024-09-13 16:00:00', 'Routine check-up', 'David Green', '2024-10-13 16:00:00'),
(8, '2024-09-30 06:00:00', 'Battery calibration', 'John Smith', '2024-10-20 16:00:00'),
(9, '2024-09-20 09:00:00', 'Software update', 'Sara Lee', '2024-10-10 16:00:00'),
(10, '2024-09-24 00:00:00', 'Component replacement', 'Paul Walker', '2024-10-03 16:00:00');

COMMIT;

START TRANSACTION;
USE Patrol_Robots_SQL;
INSERT INTO `Robot_Maintenance` (`robot_id`, `maintenance_id`) VALUES 
(3, 3),
(3, 4),
(5, 5),
(5, 6),
(7, 7),
(7, 4),
(12, 3),
(12, 10),
(13, 4),
(13, 5),
(1, 9),
(2, 10),
(4, 8),
(6, 9),
(9, 8);

COMMIT;