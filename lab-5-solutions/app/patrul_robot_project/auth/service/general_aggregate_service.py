from auth.domain.models import db
from sqlalchemy import text

class AggregateService:
    
    @staticmethod
    def calculate_aggregate(table_name, column_name, operation):
        valid_operations = ['MAX', 'MIN', 'SUM', 'AVG']
        if operation not in valid_operations:
            raise ValueError(f"Invalid operation: {operation}")
        
        query = text(f'SELECT {operation}({column_name}) AS calculated_value FROM {table_name}')
        
        try:
            result = db.session.execute(query)
            calculated_value = result.scalar() 
            return calculated_value
        except Exception as e:
            raise ValueError(f"Error executing query: {e}")