import json 
import os 
from pathlib import Path
import requests 
from dotenv import load_dotenv



class DebeziumConnector:
    
    def __init__(self): 
        self.DEBEZIUM_URL = os.getenv("DEBEZIUM_URL")
        self.CONNECTOR_DIR = Path(__file__).parent.parent.parent.parent / "connectors" 

    def _get_config(self, config):
        for file in self.CONNECTOR_DIR.glob("*.json"):
            with open(file) as f: 
                config = json.load(f)
                
            cfg = config['config']
            cfg["database.hostname"] = "host.docker.internal"
            cfg["database.port"] = os.getenv("PROD_POSTGRES_PORT")
            cfg["database.user"] = os.getenv("PROD_POSTGRES_USER")
            cfg["database.password"] = os.getenv("PROD_POSTGRES_PASSWORD")
            cfg["database.dbname"] = os.getenv("PROD_POSTGRES_DB")
            
        return config


    def register_connector(self, config, update_if_exists=True):
        """Create or update connector in Debezium"""
        connector_name = config['name']
        resp = requests.get(f"{self.DEBEZIUM_URL}/{connector_name}")
        
        if resp.status_code == 404:
            #Connector does not exist yet
            resp = requests.post(self.DEBEZIUM_URL, json=config)
            print(connector_name, resp.status_code, resp.text)
        elif resp.status_code == 200: 
            if update_if_exists:
                resp = requests.put(self.DEBEZIUM_URL, json=config)
                
                print(connector_name, f"Connector {connector_name} updated.")
        else:
            print(connector_name, f"Error {resp.status_code}: {resp.text}")


    def register_all_connectors(self, update_if_exists=True):
        for file in self.CONNECTOR_DIR.glob("*.json"):
            with open(file) as f: 
                config = json.load(f)
            config = self._get_config(config)
            self.register_connector(config, update_if_exists=update_if_exists)
                
if __name__ == "__main__":
    load_dotenv() 
    
    debezium = DebeziumConnector()
    debezium.register_all_connectors(update_if_exists=True)
    
    