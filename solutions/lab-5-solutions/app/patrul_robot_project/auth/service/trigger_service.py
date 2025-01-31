from auth.dao.trigger_dao import TriggerDAO

class TriggerService:
    @staticmethod
    def insert_person_identification(person_name, timestamp, accuracy, sensor_id, camera_id, report_id):
        return TriggerDAO.insert_person_identification(person_name, timestamp, accuracy, sensor_id, camera_id, report_id)

    @staticmethod
    def log_patrol_report_update(report_id, start_time, end_time, report_type):
        return TriggerDAO.log_patrol_report_update(report_id, start_time, end_time, report_type)

    @staticmethod
    def get_logs_before_after_update():
        """
        Повертає всі записи з таблиці логів перед оновленням.
        """
        return TriggerDAO.get_patrol_report_logs()

    @staticmethod
    def insert_battery(log_time, battery_level, robot_id, temperature):
        TriggerDAO.insert_battery(log_time, battery_level, robot_id, temperature)
        
    @staticmethod
    def log_patrol_report(report_id, start_time, end_time, report_type, routes_id):
        TriggerDAO.log_patrol_report(report_id, start_time, end_time, report_type, routes_id)

    @staticmethod
    def insert_person_identification_if_not_duplicate(person_name, timestamp, accuracy, sensor_id, camera_id, report_id):
        TriggerDAO.insert_person_identification_if_not_duplicate(
            person_name, timestamp, accuracy, sensor_id, camera_id, report_id
        )
