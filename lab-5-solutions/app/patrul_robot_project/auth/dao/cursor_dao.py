from sqlalchemy import text
from auth.domain.models import db


class CursorDAO:
    @staticmethod
    def create_databases_and_tables():
        try:
            # Виклик збереженої процедури MySQL
            db.session.execute(text("CALL CreateDatabasesAndTables()"))
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise Exception(f"Error creating databases and tables: {str(e)}")
