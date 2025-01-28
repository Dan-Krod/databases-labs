from flask import Blueprint, request, jsonify
from auth.controller.trigger_controller import TriggerController

trigger_blueprint = Blueprint('trigger', __name__)

@trigger_blueprint.route('/person-identification', methods=['POST'])
def insert_person_identification():
    data = request.json
    response, status_code = TriggerController.insert_person_identification(data)
    return jsonify(response), status_code

@trigger_blueprint.route('/log-patrol-update', methods=['POST'])
def log_patrol_update():
    data = request.json
    response, status_code = TriggerController.log_patrol_report_update(data)
    return jsonify(response), status_code

@trigger_blueprint.route('/get-logs-before-after-update', methods=['GET'])
def get_logs_before_update():
    """
    Отримує журнали до оновлення звіту.
    """
    try:
        logs = TriggerController.get_logs_before_after_update()
        return jsonify({'logs_update': logs}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@trigger_blueprint.route('/insert-battery', methods=['POST'])
def insert_battery():
    data = request.json
    response, status_code = TriggerController.insert_battery(data)
    return jsonify(response), status_code

@trigger_blueprint.route('/log-patrol-report', methods=['POST'])
def log_patrol_report():
    data = request.get_json()
    response, status_code = TriggerController.log_patrol_report(data)
    return jsonify(response), status_code

@trigger_blueprint.route('/insert-person-identification-if-not-duplicate', methods=['POST'])
def insert_person_identification_if_not_duplicate():
    data = request.get_json()
    response, status_code = TriggerController.insert_person_identification_if_not_duplicate(data)
    return jsonify(response), status_code