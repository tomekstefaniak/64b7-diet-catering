
import customtkinter as ctk

from backend.credentials.load_credentials import load_credentials

class LoadWindow(ctk.CTkToplevel):
    def __init__(self, login_frame):
        super().__init__()

        self.login_frame = login_frame

        self.title("Wczytaj dane")
        self.geometry("300x150")

        self.configure(fg_color="#1D0030")

        label = ctk.CTkLabel(self, text="Wczytaj dane", font=("Arial", 16))
        label.pack(pady=10)

        self.id_entry = ctk.CTkEntry(self, placeholder_text="ID")
        self.id_entry.pack(pady=5, padx=20, fill="x")

        load_button = ctk.CTkButton(self, text="Wczytaj", command=self.load_data)
        load_button.pack(pady=10)

    def load_data(self):
        provided_id = self.id_entry.get()

        if (provided_id):
            try:
                endpoint, port, database = load_credentials(provided_id)
                self.login_frame.endpoint_entry.insert(0, endpoint)
                self.login_frame.port_entry.insert(0, port)
                self.login_frame.database_entry.insert(0, database)

                self.destroy()

            except Exception as e:
                print("ERROR: Could not load credentials!")
