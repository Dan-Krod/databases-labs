from auth.dao.procedures_dao import ProcedureDAO

class GeneralService:
    @staticmethod
    def insert_into_table(table_name, column_names, values_list):
        # Викликаємо DAO для вставки в таблицю
        ProcedureDAO.insert_into_table(table_name, column_names, values_list)

    @staticmethod
    def link_robot_to_maintenance_by_attributes(robot_status, maintenance_description):
        ProcedureDAO.link_robot_to_maintenance_by_attributes(robot_status, maintenance_description)
        
    @staticmethod
    def insert_multiple_operators():
        """
        Викликає DAO для виконання збереженої процедури InsertMultipleOperators.
        """
        ProcedureDAO.insert_multiple_operators()
