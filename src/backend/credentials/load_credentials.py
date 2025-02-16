
import os
import json

def load_credentials(provided_id: str):
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../.."))
    credentials_path = os.path.join(base_dir, "credentials/credentials_prod.json")

    with open(credentials_path, mode = "r") as credentials_file:
        data = json.load(credentials_file)

    return data[provided_id]["endpoint"], data[provided_id]["port"], data[provided_id]["database"]
