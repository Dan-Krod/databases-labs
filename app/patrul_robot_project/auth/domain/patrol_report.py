from auth.domain.models import db

class PatrolReport(db.Model):
    __tablename__ = 'patrol_report'
    
    report_id = db.Column(db.Integer, primary_key=True)
    start_time = db.Column(db.DateTime, nullable=False)
    end_time = db.Column(db.DateTime, nullable=False)
    report_type = db.Column(db.Enum('routine_patrol', 'patrol_with_technical_issues', 'person_detected'), nullable=False)
    routes_id = db.Column(db.Integer, db.ForeignKey('patrol_route.routes_id'), nullable=False)

    route = db.relationship('PatrolRoute', backref='reports', lazy=True)