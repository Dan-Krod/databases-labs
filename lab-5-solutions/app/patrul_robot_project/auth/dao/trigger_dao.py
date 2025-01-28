from sqlalchemy import text
from auth.domain.models import db

class TriggerDAO:
    @staticmethod
    def insert_person_identification(person_name, timestamp, accuracy, sensor_id, camera_id, report_id):
        try:
            query = text("""
                INSERT INTO Person_Identification (
                    person_name, timestamp, accuracy, sensor_id, camera_id, report_id
                ) VALUES (
                    :person_name, :timestamp, :accuracy, :sensor_id, :camera_id, :report_id
                )
            """)
            db.session.execute(query, {
                'person_name': person_name,
                'timestamp': timestamp,
                'accuracy': accuracy,
                'sensor_id': sensor_id,
                'camera_id': camera_id,
                'report_id': report_id
            })
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise Exception(f"Error inserting data into Person_Identification: {str(e)}")

    @staticmethod
    def log_patrol_report_update(report_id, start_time, end_time, report_type):
        """
        Емулюємо оновлення для перевірки логування змін у звіті.
        """
        try:
            query = text("""
                UPDATE Patrol_Report 
                SET start_time = :start_time, end_time = :end_time, report_type = :report_type
                WHERE report_id = :report_id
            """)
            db.session.execute(query, {
                'report_id': report_id,
                'start_time': start_time,
                'end_time': end_time,
                'report_type': report_type
            })
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise Exception(f"Failed to log patrol report update: {str(e)}")

    @staticmethod
    def get_patrol_report_logs():
        """
        Отримує всі журнали оновлень звітів про патруль.
        """
        query = text("SELECT * FROM Patrol_Report_Log")
        result = db.session.execute(query)
        logs = []
        for row in result:
            logs.append({
                'log_id': row.log_id,
                'operation_type': row.operation_type,
                'report_id': row.report_id,
                'modified_data': row.modified_data,
                'timestamp': row.timestamp
            })
        
        return logs


    @staticmethod
    def insert_battery(log_time, battery_level, robot_id, temperature):
        """
        Вставка нових даних у таблицю Battery.
        """
        try:
            query = text("""
                INSERT INTO Battery (log_time, battery_level, robot_id, temperature)
                VALUES (:log_time, :battery_level, :robot_id, :temperature)
            """)
            db.session.execute(query, {
                'log_time': log_time,
                'battery_level': battery_level,
                'robot_id': robot_id,
                'temperature': temperature
            })
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise Exception(f"Error inserting data into Battery: {str(e)}")

    @staticmethod
    def log_patrol_report(report_id, start_time, end_time, report_type, routes_id):
        try:
            query = text("""
                INSERT INTO Patrol_Report (report_id, start_time, end_time, report_type, routes_id)
                VALUES (:report_id, :start_time, :end_time, :report_type, :routes_id)
            """)
            db.session.execute(query, {
                'report_id': report_id,
                'start_time': start_time,
                'end_time': end_time,
                'report_type': report_type,
                'routes_id':routes_id
            })
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise Exception(f"Error logging Patrol_Report: {str(e)}")

    @staticmethod
    def insert_person_identification_if_not_duplicate(person_name, timestamp, accuracy, sensor_id, camera_id, report_id):
        try:
            duplicate_check_query = text("""
                SELECT 1 
                FROM Person_Identification
                WHERE person_name = :person_name 
                AND sensor_id = :sensor_id
                AND TIMESTAMPDIFF(MINUTE, timestamp, :timestamp) < 5
            """)
            
            result = db.session.execute(duplicate_check_query, {
                'person_name': person_name,
                'timestamp': timestamp,
                'sensor_id': sensor_id
            }).fetchone()
            
            if result:  
                raise Exception("Duplicate person identification detected within 5 minutes.")

            insert_query = text("""
                INSERT INTO Person_Identification (person_name, timestamp, accuracy, sensor_id, camera_id, report_id)
                VALUES (:person_name, :timestamp, :accuracy, :sensor_id, :camera_id, :report_id)
            """)
            db.session.execute(insert_query, {
                'person_name': person_name,
                'timestamp': timestamp,
                'accuracy': accuracy,
                'sensor_id': sensor_id,
                'camera_id': camera_id,
                'report_id': report_id
            })
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise Exception(f"Error inserting person identification without duplicates: {str(e)}")
