from flask import Blueprint, request, jsonify
from auth.service.general_aggregate_service import AggregateService

aggregate_blueprint = Blueprint('aggregate', __name__)

@aggregate_blueprint.route('/aggregate', methods=['GET'])
def get_aggregate():
    try:
        table_name = request.args.get('table_name')
        column_name = request.args.get('column_name')
        operation = request.args.get('operation')
        
        if not table_name or not column_name or not operation:
            return jsonify({"error": "Missing parameters"}), 400
        
        valid_operations = ['MAX', 'MIN', 'SUM', 'AVG']
        
        if operation not in valid_operations:
            return jsonify({"error": f"Invalid operation. Valid operations are {', '.join(valid_operations)}."}), 400
        
        # Викликаємо сервіс для виконання агрегації
        result = AggregateService.calculate_aggregate(table_name, column_name, operation)
        
        return jsonify({f"{operation}_{column_name}": result}), 200
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
