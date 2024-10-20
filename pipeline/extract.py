import luigi
from datetime import datetime
import logging
import time
import pandas as pd
from utils.db_conn import db_connection
from utils.read_sql import read_sql_file
import os

# Define DIR
DIR_ROOT_PROJECT = os.getenv("DIR_ROOT_PROJECT")
DIR_TEMP_LOG = os.getenv("DIR_TEMP_LOG")
DIR_TEMP_DATA = os.getenv("DIR_TEMP_DATA")
DIR_EXTRACT_QUERY = os.getenv("DIR_EXTRACT_QUERY")
DIR_LOG = os.getenv("DIR_LOG")


class Extract(luigi.Task):
    
    # Define tables to be extracted from db sources
    tables_to_extract = ['public.geolocation', 
                         'public.customers', 
                         'public.orders',
                         'public.sellers',
                         'public.product_category_name_translation',
                         'public.products',
                         'public.order_items', 
                         'public.order_payments', 
                         'public.order_reviews']
    
    def requires(self):
        pass


    def run(self):        
        try:
            # Configure logging
            logging.basicConfig(filename = f'{DIR_TEMP_LOG}/logs.log', 
                                level = logging.INFO, 
                                format = '%(asctime)s - %(levelname)s - %(message)s')
            
            # Define db connection engine
            src_engine, _ = db_connection()
            conn=src_engine.connect()
            
            # Define the query using the SQL content
            extract_query = read_sql_file(
                file_path = f'{DIR_EXTRACT_QUERY}/all-tables.sql'
            )
            
            start_time = time.time()  # Record start time
            logging.info("==================================STARTING EXTRACT DATA=======================================")
            
            for index, table_name in enumerate(self.tables_to_extract):
                try:
                    # Read data into DataFrame
                    df = pd.read_sql_query(extract_query.format(table_name = table_name), con=conn.connection)

                    # Write DataFrame to CSV
                    df.to_csv(f"{DIR_TEMP_DATA}/{table_name}.csv", index=False)
                    
                    logging.info(f"EXTRACT '{table_name}' - SUCCESS.")
                    
                except Exception:
                    logging.error(f"EXTRACT '{table_name}' - FAILED.")  
                    raise Exception(f"Failed to extract '{table_name}' tables")
            
            logging.info(f"Extract All Tables From Sources - SUCCESS")
            
            end_time = time.time()  # Record end time
            execution_time = end_time - start_time  # Calculate execution time
            
            # Get summary
            summary_data = {
                'timestamp': [datetime.now()],
                'task': ['Extract'],
                'status' : ['Success'],
                'execution_time': [execution_time]
            }
            
            # Get summary dataframes
            summary = pd.DataFrame(summary_data)
            
            # Write DataFrame to CSV
            summary.to_csv(f"{DIR_TEMP_DATA}/extract-summary.csv", index = False)
                    
        except Exception:   
            logging.info(f"Extract All Tables From Sources - FAILED")
             
            # Get summary
            summary_data = {
                'timestamp': [datetime.now()],
                'task': ['Extract'],
                'status' : ['Failed'],
                'execution_time': [0]
            }
            
            # Get summary dataframes
            summary = pd.DataFrame(summary_data)
            
            # Write DataFrame to CSV
            summary.to_csv(f"{DIR_TEMP_DATA}/extract-summary.csv", index = False)
            
            # Write exception
            raise Exception(f"FAILED to execute EXTRACT TASK !!!")
        
        logging.info("==================================ENDING EXTRACT DATA=======================================")
                
    def output(self):
        outputs = []
        for table_name in self.tables_to_extract:
            outputs.append(luigi.LocalTarget(f'{DIR_TEMP_DATA}/{table_name}.csv'))
            
        outputs.append(luigi.LocalTarget(f'{DIR_TEMP_DATA}/extract-summary.csv'))
            
        outputs.append(luigi.LocalTarget(f'{DIR_TEMP_LOG}/logs.log'))
        return outputs
    
if __name__ == "__main__":
    luigi.build([Extract()])