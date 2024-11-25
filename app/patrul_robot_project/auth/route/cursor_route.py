from flask import Blueprint, jsonify
from auth.controller.cursor_controller import CursorController

# Ініціалізуємо Blueprint
cursor_blueprint = Blueprint('cursor', __name__)

# Маршрут для виклику створення баз даних і таблиць
@cursor_blueprint.route('/create-databases-and-tables', methods=['POST'])
def create_databases_and_tables():
    response, status_code = CursorController.create_databases_and_tables()
    return jsonify(response), status_code
