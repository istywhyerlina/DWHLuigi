from sqlalchemy import create_engine
import warnings
warnings.filterwarnings('ignore')
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

def db_connection():
    try:
        src_database = os.getenv("SRC_POSTGRES_DB")
        src_host = os.getenv("SRC_POSTGRES_HOST")
        src_user = os.getenv("SRC_POSTGRES_USER")
        src_password = os.getenv("SRC_POSTGRES_PASSWORD")
        src_port = os.getenv("SRC_POSTGRES_PORT")

        dwh_database = os.getenv("DWH_POSTGRES_DB")
        dwh_host = os.getenv("DWH_POSTGRES_HOST")
        dwh_user = os.getenv("DWH_POSTGRES_USER")
        dwh_password = os.getenv("DWH_POSTGRES_PASSWORD")
        dwh_port = os.getenv("DWH_POSTGRES_PORT")
        
        src_conn = f'postgresql://{src_user}:{src_password}@{src_host}:{src_port}/{src_database}'
        dwh_conn = f'postgresql://{dwh_user}:{dwh_password}@{dwh_host}:{dwh_port}/{dwh_database}'
        
        src_engine = create_engine(src_conn)
        dwh_engine = create_engine(dwh_conn)
        
        return src_engine, dwh_engine

    except Exception as e:
        print(f"Error: {e}")
        return None