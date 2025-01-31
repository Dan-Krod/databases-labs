from auth.service.trigger_service import TriggerService

class TriggerController:
    @staticmethod
    def insert_person_identification(data):
        required_fields = ['person_name', 'timestamp', 'accuracy', 'sensor_id', 'camera_id', 'report_id']
        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        try:
            TriggerService.insert_person_identification(
                person_name=data['person_name'],
                timestamp=data['timestamp'],
                accuracy=data['accuracy'],
                sensor_id=data['sensor_id'],
                camera_id=data['camera_id'],
                report_id=data['report_id']
            )
            return {'message': 'Person identification inserted successfully'}, 201
        except Exception as e:
            return {'error': str(e)}, 500

    @staticmethod
    def log_patrol_report_update(data):
        required_fields = ['report_id', 'start_time', 'end_time', 'report_type']
        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        try:
            TriggerService.log_patrol_report_update(
                report_id=data['report_id'],
                start_time=data['start_time'],
                end_time=data['end_time'],
                report_type=data['report_type']
            )
            return {'message': 'Patrol report update logged successfully'}, 200
        except Exception as e:
            return {'error': str(e)}, 500

    @staticmethod
    def get_logs_before_after_update():
        """
        Викликає DAO для отримання логів до оновлення.
        """
        try:
            logs = TriggerService.get_logs_before_after_update()
            return logs, 200
        except Exception as e:
            return {"error": str(e)}, 500

        
    @staticmethod
    def insert_battery(data):
        required_fields = ['log_time', 'battery_level', 'robot_id', 'temperature']
        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        try:
            TriggerService.insert_battery(
                log_time=data['log_time'],
                battery_level=data['battery_level'],
                robot_id=data['robot_id'],
                temperature=data['temperature']
            )
            return {'message': 'Battery data inserted successfully'}, 201
        except Exception as e:
            return {'error': str(e)}, 500
        
    @staticmethod
    def log_patrol_report(data):
        required_fields = ['report_id', 'start_time', 'end_time', 'report_type', 'routes_id']
        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        try:
            TriggerService.log_patrol_report(
                report_id=data['report_id'],
                start_time=data['start_time'],
                end_time=data['end_time'],
                report_type=data['report_type'],
                routes_id=data['routes_id']
            )
            return {'message': 'Patrol report logged successfully'}, 200
        except Exception as e:
            return {'error': str(e)}, 500

    @staticmethod
    def insert_person_identification_if_not_duplicate(data):
        required_fields = ['person_name', 'timestamp', 'accuracy', 'sensor_id', 'camera_id', 'report_id']
        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400

        try:
            TriggerService.insert_person_identification_if_not_duplicate(
                person_name=data['person_name'],
                timestamp=data['timestamp'],
                accuracy=data['accuracy'],
                sensor_id=data['sensor_id'],
                camera_id=data['camera_id'],
                report_id=data['report_id']
            )
            return {'message': 'Person identification inserted successfully if not duplicate'}, 201
        except Exception as e:
            return {'error': str(e)}, 500
