from auth.dao.task_dao import TaskDAO

class TaskService:
    @staticmethod
    def add_task(operator_id, task_name, task_type, priority, status, due_date, description=None):
        return TaskDAO.add_task(operator_id, task_name, task_type, priority, status, due_date, description)

    @staticmethod
    def get_task(task_id):
        return TaskDAO.get_task(task_id)

    @staticmethod
    def get_all_tasks():
        return TaskDAO.get_all_tasks()

    @staticmethod
    def get_tasks_by_status(status):
        return TaskDAO.get_tasks_by_status(status)

    @staticmethod
    def get_tasks_by_operator(operator_id):
        return TaskDAO.get_tasks_by_operator(operator_id)

    @staticmethod
    def update_task(task_id, operator_id=None, task_name=None, task_type=None, priority=None, status=None, due_date=None, description=None):
        return TaskDAO.update_task(
            task_id=task_id,
            operator_id=operator_id,
            task_name=task_name,
            task_type=task_type,
            priority=priority,
            status=status,
            due_date=due_date,
            description=description
        )

    @staticmethod
    def delete_task(task_id):
        return TaskDAO.delete_task(task_id)
