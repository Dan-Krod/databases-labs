from flask import Blueprint, request, jsonify
from auth.service.procedures_service import GeneralService

# Створення Blueprint для контролера
procedures_blueprint = Blueprint('general_aggregate', __name__)

# Маршрут для вставки в таблицю
@procedures_blueprint.route('/insert-into-table', methods=['POST'])
def insert_into_table():
    data = request.json
    required_fields = ['table_name', 'column_names', 'values_list']
    
    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing required fields'}), 400

    try:
        GeneralService.insert_into_table(
            data['table_name'],
            data['column_names'],
            data['values_list']
        )
        return jsonify({'message': 'Data inserted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Маршрут для зв'язку робота з технічним обслуговуванням
@procedures_blueprint.route('/link-robot-to-maintenance-by-attributes', methods=['POST'])
def link_robot_to_maintenance_by_attributes():
    data = request.json
    required_fields = ['robot_status', 'maintenance_description']
    
    if not all(field in data for field in required_fields):
        return jsonify({'error': 'Missing required fields'}), 400

    try:
        GeneralService.link_robot_to_maintenance_by_attributes(
            data['robot_status'],
            data['maintenance_description']
        )
        return jsonify({'message': 'Robot linked to maintenance successfully by attributes'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Маршрут для вставки кількох завдань
@procedures_blueprint.route('/insert-multiple-operators', methods=['POST'])
def insert_multiple_operators():
    """
    Ендпоінт для виклику збереженої процедури, яка вставляє кількох операторів.
    """
    try:
        GeneralService.insert_multiple_operators()
        return jsonify({'message': 'Operators inserted successfully'}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500
