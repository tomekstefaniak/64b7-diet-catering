
import customtkinter as ctk

from backend.credentials.save_credentials import save_credentials

class SaveWindow(ctk.CTkToplevel):
    def __init__(self, login_frame):
        super().__init__()

        self.login_frame = login_frame

        self.title("Zapis danych")
        self.geometry("300x150")

        self.configure(fg_color="#1D0030")

        label = ctk.CTkLabel(self, text="Zapisz dane", font=("Arial", 16))
        label.pack(pady=10)

        self.id_entry = ctk.CTkEntry(self, placeholder_text="ID")
        self.id_entry.pack(pady=5, padx=20, fill="x")

        save_button = ctk.CTkButton(self, text="Zapisz", command=self.save_data)
        save_button.pack(pady=10)

    def save_data(self):
        provided_id = self.id_entry.get()

        endpoint = self.login_frame.endpoint_entry.get()
        port = self.login_frame.port_entry.get()
        database = self.login_frame.database_entry.get()

        if (len(provided_id ) * len(endpoint) * len(port) * len(database) != 0):
            try:
                save_credentials(provided_id, endpoint, port, database)
                self.destroy()

            except Exception as e:
                print("ERROR: Could not save cretentials!")
