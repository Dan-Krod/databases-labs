from auth.dao.cursor_dao import CursorDAO


class CursorService:
    @staticmethod
    def create_databases_and_tables():
        """
        Викликає DAO для створення баз даних і таблиць.
        """
        try:
            CursorDAO.create_databases_and_tables()
            return {"message": "Databases and tables created successfully"}
        except Exception as e:
            # Логування помилки або подальша обробка
            raise Exception(f"Error in CursorService: {str(e)}")
