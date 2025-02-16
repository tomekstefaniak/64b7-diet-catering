
import mysql.connector
from mysql.connector import Error

class DBSession:

    def __init__(self, connection):
        self.connection = connection

    @classmethod
    def create(cls, endpoint, port, database, user, password):
        try:
            # Ustawienia połączenia
            connection = mysql.connector.connect(
                host=endpoint,
                port=port,
                database=database,
                user=user,
                password=password,
                charset='utf8mb4',  # Ustawienie kodowania znaków
                collation='utf8mb4_general_ci'  # Obsługiwana kolacja
            )

            if connection.is_connected():
                print(f"Logged to database as {user}")
                return cls(connection)

        except Error as e:
            print("ERROR: Could not create connection with database!")
            return None

    def query(self, query):
        try:
            cursor = self.connection.cursor()
            cursor.execute(query)  # Wykonanie zapytania bez parametrów

            if query.strip().lower().startswith("select"):
                # Jeśli zapytanie jest typu SELECT, zwracamy wyniki
                results = cursor.fetchall()
                return results
            else:
                # W przypadku INSERT, UPDATE, DELETE, zatwierdzamy transakcję
                self.connection.commit()
                return None
        except Error as e:
            print(f"Query failed: {e}")
            return None
        finally:
            cursor.close()

    def built_in_query():
        pass

    def close(self):
        if self.connection.is_connected():
            self.connection.close()
