
import customtkinter as ctk

from frontend.frames.login_frame import LoginFrame
from frontend.frames.main_frame import MainFrame

ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("dark-blue")

class MainWindow(ctk.CTk):
    def __init__(self):
        super().__init__()

        # Ustawienia głównego okna
        self.title("Katering Dietetyczny")
        self.geometry("1280x720")

        # Wyświetlenie LoginFrame na starcie
        self.show_login_frame()

    def show_login_frame(self):
        try:
            self.main_frame.session.close()
        except Exception as e:
            pass

        self.login_frame = LoginFrame(self)
        self.login_frame.place(relwidth=1, relheight=1)

    def show_main_frame(self, session, user):
        self.main_frame = MainFrame(self, session, user)
        self.main_frame.place(relwidth=1, relheight=1)
    