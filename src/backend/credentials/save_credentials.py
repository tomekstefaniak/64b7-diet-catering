
import os
import json

def save_credentials(provided_id: str, endpoint: str, port: str, database: str):
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../.."))
    credentials_path = os.path.join(base_dir, "credentials/credentials.json")

    with open(os.path.join(credentials_path), mode = "r") as credentials_file:
        data = json.load(credentials_file)

    data[provided_id] = {"endpoint": endpoint, "port": port, "database": database}
    
    with open(os.path.join(credentials_path), mode = "w") as credentials_file:
        json.dump(data, credentials_file, indent = 4)
