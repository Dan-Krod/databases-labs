from auth.service.task_service import TaskService

class TaskController:
    @staticmethod
    def add_task(data):
        required_fields = ['operator_id', 'task_name', 'task_type', 'priority', 'due_date']
        if not all(field in data for field in required_fields):
            return {'error': 'Missing required fields'}, 400
        

        task = TaskService.add_task(
            operator_id=data['operator_id'],
            task_name=data['task_name'],
            task_type=data['task_type'],
            priority=data['priority'],
            status=data.get('status', 'Assigned'),
            due_date=data['due_date'],
            description=data.get('description')
        )
            
        success_message = f"Task '{task.task_name}' for operator ID {task.operator_id} has been successfully added."
            
        response = {
            'message': success_message,  # Повідомлення виводиться першим
            'data': {  # Інші дані групуємо в окремий блок
                'task_id': task.task_id,
                'operator_id': task.operator_id,
                'task_name': task.task_name,
                'status': task.status,
                'description': task.description
            }
        }

        return response, 201

    @staticmethod
    def get_task(task_id):
        task = TaskService.get_task(task_id)
        if task:
            return {
                'task_id': task.task_id,
                'operator_id': task.operator_id,
                'task_name': task.task_name,
                'task_type': task.task_type,
                'priority': task.priority,
                'status': task.status,
                'created_at': task.created_at,
                'due_date': task.due_date,
                'description': task.description
            }, 200
        return {'error': 'Task not found'}, 404

    @staticmethod
    def get_all_tasks():
        tasks = TaskService.get_all_tasks()
        return [{
            'task_id': task.task_id,
            'operator_id': task.operator_id,
            'task_name': task.task_name,
            'task_type': task.task_type,
            'priority': task.priority,
            'status': task.status,
            'created_at': task.created_at,
            'due_date': task.due_date,
            'description': task.description
        } for task in tasks], 200

    @staticmethod
    def get_tasks_by_status(status):
        tasks = TaskService.get_tasks_by_status(status)
        return [{
            'task_id': task.task_id,
            'task_name': task.task_name,
            'status': task.status,
            'due_date': task.due_date
        } for task in tasks], 200

    @staticmethod
    def delete_task(task_id):
        task = TaskService.delete_task(task_id)
        if task:
            return {'message': 'Task deleted'}, 200
        return {'error': 'Task not found'}, 404

    @staticmethod
    def update_task(task_id, data):
        required_fields = ['task_name', 'task_type', 'priority', 'status', 'due_date']
        if not any(field in data for field in required_fields):
            return {'error': 'No fields to update provided'}, 400

        # Оновлення завдання через сервіс
        task = TaskService.update_task(
            task_id,
            operator_id=data.get('operator_id'),
            task_name=data.get('task_name'),
            task_type=data.get('task_type'),
            priority=data.get('priority'),
            status=data.get('status'),
            due_date=data.get('due_date'),
            description=data.get('description')
        )
        
        if task:
            # Повертаємо повідомлення та змінені дані
            response = {
                'message': f"Task '{task.task_name}' has been successfully updated.",
                'data': {
                    'task_id': task.task_id,
                    'operator_id': task.operator_id,
                    'task_name': task.task_name,
                    'task_type': task.task_type,
                    'priority': task.priority,
                    'status': task.status,
                    'due_date': task.due_date,
                    'description': task.description
                }
            }
            return response, 200

        # Якщо завдання не знайдене
        return {'error': 'Task not found'}, 404
