from auth.service.cursor_service import CursorService


class CursorController:
    @staticmethod
    def create_databases_and_tables():
        """
        Контролер, який викликає сервіс для створення баз даних і таблиць.
        """
        try:
            # Викликаємо сервіс для виконання логіки
            response = CursorService.create_databases_and_tables()
            return response, 201  # Повертаємо успішний статус 201 Created
        except Exception as e:
            # Обробка помилок
            return {"error": str(e)}, 500
