import luigi
import logging
import pandas as pd
import time
import sqlalchemy
from datetime import datetime
from load import Load
from utils.db_conn import db_connection
from utils.read_sql import read_sql_file
from sqlalchemy.orm import sessionmaker
import os

# Define DIR
DIR_ROOT_PROJECT = os.getenv("DIR_ROOT_PROJECT")
DIR_TEMP_LOG = os.getenv("DIR_TEMP_LOG")
DIR_TEMP_DATA = os.getenv("DIR_TEMP_DATA")
DIR_TRANSFORM_QUERY = os.getenv("DIR_TRANSFORM_QUERY")
DIR_LOG = os.getenv("DIR_LOG")

class Transform(luigi.Task):
    
    def requires(self):
        return Load()
    
    def run(self):
         
        # Configure logging
        logging.basicConfig(filename = f'{DIR_TEMP_LOG}/logs.log', 
                            level = logging.INFO, 
                            format = '%(asctime)s - %(levelname)s - %(message)s')
        
        #----------------------------------------------------------------------------------------------------------------------------------------
        # Read query to be executed
        try:
            # Read query to truncate bookings schema in dwh
            # truncate_query = read_sql_file(
            #     file_path = f'{DIR_TRANSFORM_QUERY}/truncate-fact-tables.sql'
            # )

            # Read transform query to final schema
            dim_customers_query = read_sql_file(
                file_path = f'{DIR_TRANSFORM_QUERY}/dim_customers.sql'
            )
            
            dim_payment_query = read_sql_file(
                file_path = f'{DIR_TRANSFORM_QUERY}/dim_payment.sql'
            )
            
            dim_product_query = read_sql_file(
                file_path = f'{DIR_TRANSFORM_QUERY}/dim_product.sql'
            )
            
            dim_seller_query = read_sql_file(
                file_path = f'{DIR_TRANSFORM_QUERY}/dim_seller.sql'
            )


            fct_transaction = read_sql_file(
                file_path = f'{DIR_TRANSFORM_QUERY}/fct_transaction.sql'
            )

            logging.info("Read Transform Query - SUCCESS")
            
        except Exception:
            logging.error("Read Transform Query - FAILED")
            raise Exception("Failed to read Transform Query")
        
        
        #----------------------------------------------------------------------------------------------------------------------------------------
        # Establish connections to DWH
        try:
            _, dwh_engine = db_connection()
            logging.info(f"Connect to DWH - SUCCESS")
            
        except Exception:
            logging.info(f"Connect to DWH - FAILED")
            raise Exception("Failed to connect to Data Warehouse")
        
        
        #----------------------------------------------------------------------------------------------------------------------------------------
        # Record start time for transform tables
        start_time = time.time()
        logging.info("==================================STARTING TRANSFROM DATA=======================================")  
               
        # Transform to dimensions tables
        try:
            # Create session
            Session = sessionmaker(bind = dwh_engine)
            session = Session()
            
            # Transform to final.dim_customers
            query = sqlalchemy.text(dim_customers_query)
            session.execute(query)
            logging.info("Transform to 'final.dim_customers' - SUCCESS")
            
            # Transform to final.dim_payment
            query = sqlalchemy.text(dim_payment_query)
            session.execute(query)
            logging.info("Transform to 'final.dim_payment' - SUCCESS")
            
            # Transform to final.dim_product
            query = sqlalchemy.text(dim_product_query)
            session.execute(query)
            logging.info("Transform to 'final.dim_product' - SUCCESS")
            
            # Transform to final.dim_seller
            query = sqlalchemy.text(dim_seller_query)
            session.execute(query)
            logging.info("Transform to 'final.dim_seller' - SUCCESS")
            
            # Commit transaction
            session.commit()
            
            # Transform to final.fct_transaction
            query = sqlalchemy.text(fct_transaction)
            session.execute(query)
            logging.info("Transform to 'final.fct_transaction' - SUCCESS")
          
            # Commit transaction
            session.commit()
            
            # Close session
            session.close()

            logging.info(f"Transform to All Dimensions and Fact Tables - SUCCESS")
            
            # Record end time for loading tables
            end_time = time.time()  
            execution_time = end_time - start_time  # Calculate execution time
            
            # Get summary
            summary_data = {
                'timestamp': [datetime.now()],
                'task': ['Transform'],
                'status' : ['Success'],
                'execution_time': [execution_time]
            }

            # Get summary dataframes
            summary = pd.DataFrame(summary_data)
            
            # Write Summary to CSV
            summary.to_csv(f"{DIR_TEMP_DATA}/transform-summary.csv", index = False)
            
        except Exception:
            logging.error(f"Transform to All Dimensions and Fact Tables - FAILED")
        
            # Get summary
            summary_data = {
                'timestamp': [datetime.now()],
                'task': ['Transform'],
                'status' : ['Failed'],
                'execution_time': [0]
            }

            # Get summary dataframes
            summary = pd.DataFrame(summary_data)
            
            # Write Summary to CSV
            summary.to_csv(f"{DIR_TEMP_DATA}/transform-summary.csv", index = False)
            
            logging.error("Transform Tables - FAILED")
            raise Exception('Failed Transforming Tables')   
        
        logging.info("==================================ENDING TRANSFROM DATA=======================================") 

    #----------------------------------------------------------------------------------------------------------------------------------------
    def output(self):
        return [luigi.LocalTarget(f'{DIR_TEMP_LOG}/logs.log'),
                luigi.LocalTarget(f'{DIR_TEMP_DATA}/transform-summary.csv')]
    
if __name__ == "__main__":
    luigi.build([Transform()])