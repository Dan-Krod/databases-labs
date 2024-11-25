from auth.domain.models import db
from auth.domain.task import Task

class TaskDAO:
    @staticmethod
    def add_task(operator_id, task_name, task_type, priority, status, due_date, description=None):
        new_task = Task(
            operator_id=operator_id,
            task_name=task_name,
            task_type=task_type,
            priority=priority,
            status=status,
            due_date=due_date,
            description=description
        )
        db.session.add(new_task)
        db.session.commit()
        return new_task

    @staticmethod
    def get_task(task_id):
        return Task.query.get(task_id)

    @staticmethod
    def get_all_tasks():
        return Task.query.all()

    @staticmethod
    def update_task(task_id,  operator_id=None, task_name=None, task_type=None, priority=None, status=None, due_date=None, description=None):
        task = Task.query.get(task_id)
        if task:
            if operator_id is not None:
                task.operator_id = operator_id
            if task_name:
                task.task_name = task_name
            if task_type:
                task.task_type = task_type
            if priority:
                task.priority = priority
            if status:
                task.status = status
            if due_date:
                task.due_date = due_date
            if description:
                task.description = description
            db.session.commit()
        return task

    @staticmethod
    def delete_task(task_id):
        task = Task.query.get(task_id)
        if task:
            db.session.delete(task)
            db.session.commit()
        return task
