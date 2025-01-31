from sqlalchemy import text
from auth.domain.models import db

class ProcedureDAO:
    @staticmethod
    def insert_into_table(table_name, column_names, values_list):
        # Створюємо динамічний SQL для вставки даних
        sql = text(f"""
            CALL InsertIntoTable(:table_name, :column_names, :values_list)
        """)
        
        # Виконуємо SQL-запит
        db.session.execute(sql, {
            'table_name': table_name,
            'column_names': column_names,
            'values_list': values_list
        })
        db.session.commit()

    @staticmethod
    def link_robot_to_maintenance_by_attributes(robot_status, maintenance_description):
        # Викликаємо збережену процедуру для зв’язку робота з обслуговуванням за статусом та описом
        sql = text("""
            CALL LinkRobotToMaintenanceByAttributes(:robot_status, :maintenance_description)
        """)
        db.session.execute(sql, {
            'robot_status': robot_status,
            'maintenance_description': maintenance_description
        })
        db.session.commit()


    @staticmethod
    def insert_multiple_operators():
        """
        Викликає збережену процедуру для вставки кількох операторів.
        """
        sql = text("""
            CALL InsertMultipleOperators()
        """)
        db.session.execute(sql)
        db.session.commit()
