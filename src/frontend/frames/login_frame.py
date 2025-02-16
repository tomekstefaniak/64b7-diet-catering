import customtkinter as ctk

from frontend.windows.save_window import SaveWindow
from frontend.windows.load_window import LoadWindow
from backend.database.db_session import DBSession

class LoginFrame(ctk.CTkFrame):

    def __init__(self, parent):
        super().__init__(parent, fg_color="#1D0030")

        self.parent = parent

        # Etykieta nagłówkowa
        label = ctk.CTkLabel(self, text="Logowanie do bazy danych", font=("Arial", 18))
        label.pack(pady=10)

        # Ramka na przyciski Zapisz i Wczytaj
        button_frame = ctk.CTkFrame(self, fg_color="#1D0030")
        button_frame.pack(pady=10, padx=20)

        # Przycisk Zapisz
        save_button = ctk.CTkButton(button_frame, text="Zapisz", command=self.open_save_window, width=140)
        save_button.pack(side="left", padx=10)

        # Przycisk Wczytaj
        load_button = ctk.CTkButton(button_frame, text="Wczytaj", command=self.open_load_window, width=140)
        load_button.pack(side="left", padx=10)

        # Pola wejściowe do danych
        self.endpoint_entry = ctk.CTkEntry(self, placeholder_text="Endpoint", width=300)
        self.endpoint_entry.pack(pady=5)

        self.port_entry = ctk.CTkEntry(self, placeholder_text="Port", width=300)
        self.port_entry.pack(pady=5)

        self.database_entry = ctk.CTkEntry(self, placeholder_text="Baza Danych", width=300)
        self.database_entry.pack(pady=5)

        self.user_entry = ctk.CTkEntry(self, placeholder_text="Użytkownik", width=300)
        self.user_entry.pack(pady=5)

        self.password_entry = ctk.CTkEntry(self, placeholder_text="Hasło", show="*", width=300)
        self.password_entry.pack(pady=5)

        # Przycisk Połącz
        connect_button = ctk.CTkButton(self, text="Połącz", command=self.connect_to_database, width=300)
        connect_button.pack(pady=20)

    def open_save_window(self):
        SaveWindow(self)

    def open_load_window(self):
        LoadWindow(self)

    def connect_to_database(self):
        endpoint = self.endpoint_entry.get()
        port = self.port_entry.get()
        database = self.database_entry.get()
        user = self.user_entry.get()
        password = self.password_entry.get()

        if (session := DBSession.create(endpoint, port, database, user, password)):
            self.parent.show_main_frame(session, user)
