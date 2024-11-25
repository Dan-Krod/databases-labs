from auth.domain.models import db

class Task(db.Model):
    __tablename__ = 'tasks'

    task_id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    operator_id = db.Column(db.Integer, nullable=False)  
    task_name = db.Column(db.String(255), nullable=False)
    task_type = db.Column(
        db.Enum('Monitoring', 'Reporting', 'Inspection', 'Other'), 
        nullable=False
    )
    priority = db.Column(
        db.Enum('Low', 'Medium', 'High'), 
        default='Medium', 
        nullable=False
    )
    status = db.Column(
        db.Enum('Assigned', 'In Progress', 'Completed'), 
        default='Assigned', 
        nullable=False
    )
    created_at = db.Column(db.DateTime, default=db.func.current_timestamp(), nullable=False)
    due_date = db.Column(db.Date, nullable=False)
    description = db.Column(db.Text, nullable=True)

    def __repr__(self):
        return f"<Task {self.task_id}: {self.task_name}, Status: {self.status}>"
