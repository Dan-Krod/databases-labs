from flask import Blueprint, request, jsonify
from auth.controller.task_controller import TaskController

task_blueprint = Blueprint('task', __name__)

@task_blueprint.route('/tasks', methods=['POST'])
def add_task():
    data = request.json
    response, status_code = TaskController.add_task(data)
    return jsonify(response), status_code

@task_blueprint.route('/tasks/<int:task_id>', methods=['GET'])
def get_task(task_id):
    response, status_code = TaskController.get_task(task_id)
    return jsonify(response), status_code

@task_blueprint.route('/tasks', methods=['GET'])
def get_all_tasks():
    response, status_code = TaskController.get_all_tasks()
    return jsonify(response), status_code

@task_blueprint.route('/tasks/status/<string:status>', methods=['GET'])
def get_tasks_by_status(status):
    response, status_code = TaskController.get_tasks_by_status(status)
    return jsonify(response), status_code

@task_blueprint.route('/tasks/<int:task_id>', methods=['DELETE'])
def delete_task(task_id):
    response, status_code = TaskController.delete_task(task_id)
    return jsonify(response), status_code

@task_blueprint.route('/tasks/<int:task_id>', methods=['PUT'])
def update_task(task_id):
    data = request.json
    response, status_code = TaskController.update_task(task_id, data)
    return jsonify(response), status_code
