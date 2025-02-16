
import customtkinter as ctk

class MainFrame(ctk.CTkFrame):
    def __init__(self, parent, session, user):
        super().__init__(parent)
        self.configure(fg_color="#1D0030")  # Fioletowe tło

        # Ustawienie sesji
        self.session = session

        # Główna struktura pozioma: lewy i prawy panel
        self.main_frame = ctk.CTkFrame(self, fg_color="#1D0030")
        self.main_frame.pack(fill="both", expand=True, padx=10, pady=10)

        # Lewy panel
        self.left_frame = ctk.CTkFrame(self.main_frame, fg_color="#1D0030", width=300)
        self.left_frame.pack(side="left", fill="both", expand=True, padx=10, pady=10)

        # Górna etykieta "Logged as <username>"
        self.user_label = ctk.CTkLabel(
            self.left_frame, text=f"Logged as {user}", font=("Arial", 16)
        )
        self.user_label.pack(pady=(10, 5))

        # Górna sekcja z przyciskami
        self.button_frame = ctk.CTkFrame(self.left_frame, fg_color="#1D0030")
        self.button_frame.pack(pady=10, padx=10)

        self.built_in_button = ctk.CTkButton(
            self.button_frame, text="Wbudowane", command=self.show_built_in, width=140
        )
        self.built_in_button.pack(side="left", padx=5)

        self.custom_button = ctk.CTkButton(
            self.button_frame, text="Dowolne", command=self.show_custom_query, width=140
        )
        self.custom_button.pack(side="left", padx=5)

        # Dynamiczny panel (zmienna zawartość w zależności od wybranego trybu)
        self.dynamic_panel = ctk.CTkFrame(self.left_frame, fg_color="#1D0030")
        self.dynamic_panel.pack(fill="both", expand=True, padx=10, pady=10)

        # Przyciski na dole
        self.logout_button = ctk.CTkButton(
            self.left_frame, text="Wyloguj się", fg_color="red", command=parent.show_login_frame
        )
        self.logout_button.pack(pady=10, side="bottom")

        # Prawy panel (output)
        self.right_frame = ctk.CTkFrame(self.main_frame, fg_color="#2E004A")
        self.right_frame.pack(side="right", fill="both", expand=True, padx=10, pady=10)

        # Pole tekstowe na output
        self.output_textbox = ctk.CTkTextbox(self.right_frame, wrap="none")
        self.output_textbox.configure(font=("Courier New", 14)) 
        self.output_textbox.pack(fill="both", expand=True, padx=10, pady=(10, 5))

        # Przycisk "Wyczyść output"
        self.clear_output_button = ctk.CTkButton(
            self.right_frame, text="Wyczyść output", command=self.clear_output
        )
        self.clear_output_button.pack(pady=(0, 10))  # Przycisk poniżej pola tekstowego

        # Wywołanie początkowego widoku
        self.show_built_in()

    def update_username(self, user):
        self.user_label.configure(text=f"Logged as {user}")

    def show_built_in(self):
        self.clear_dynamic_panel()
        label = ctk.CTkLabel(
            self.dynamic_panel, text="Opcje wbudowane", font=("Arial", 14)
        )
        label.pack(pady=10)

    def show_custom_query(self):
        self.clear_dynamic_panel()
        label = ctk.CTkLabel(
            self.dynamic_panel, text="Wpisz zapytanie SQL", font=("Arial", 14)
        )
        label.pack(pady=10)

        self.sql_textbox = ctk.CTkTextbox(self.dynamic_panel, height=10)
        self.sql_textbox.pack(pady=5, padx=10, fill="both", expand=True)

        send_button = ctk.CTkButton(
            self.dynamic_panel, text="Wyślij", command=self.execute_custom_query
        )
        send_button.pack(pady=5)

    def clear_dynamic_panel(self):
        for widget in self.dynamic_panel.winfo_children():
            widget.destroy()

    def execute_custom_query(self):
        query = self.sql_textbox.get("1.0", "end").strip()
        try:
            # Wykonaj zapytanie
            cursor = self.session.connection.cursor()
            cursor.execute(query)

            # Pobierz dane i nagłówki
            results = cursor.fetchall()
            column_names = [desc[0] for desc in cursor.description]  # Pobierz nazwy kolumn

            # Oblicz maksymalną szerokość dla każdej kolumny
            col_widths = [
                max(len(str(row[i])) for row in results) if results else 0
                for i in range(len(column_names))
            ]
            col_widths = [max(col_widths[i], len(column_names[i])) for i in range(len(column_names))]

            # Tworzenie nagłówka tabeli
            header = " | ".join(f"{column_names[i]:<{col_widths[i]}}" for i in range(len(column_names)))
            separator = "-+-".join("-" * col_widths[i] for i in range(len(column_names)))

            # Tworzenie wierszy tabeli
            rows = "\n".join(
                " | ".join(f"{str(row[i])}{(col_widths[i] - len(str(row[i]))) * ' '}" for i in range(len(row)))
                for row in results
            )

            # Wyświetl tabelę w polu tekstowym
            self.output_textbox.insert("1.0", f"{header}\n{separator}\n{rows}")

            cursor.close()

        except Exception as e:
            # Obsługa błędów i wyświetlenie ich w polu tekstowym
            self.output_textbox.delete("1.0", "end")
            self.output_textbox.insert("end", f"Błąd: {e}\n")

    def clear_output(self):
        # Czyści zawartość pola tekstowego output
        self.output_textbox.delete("1.0", "end")

    def logout(self):
        # Zajmiesz się logiką później
        print("Wylogowywanie...")
