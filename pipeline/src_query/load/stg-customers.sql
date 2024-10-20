INSERT INTO stg.customers 
    (customer_id,customer_unique_id,customer_zip_code_prefix,customer_city,customer_state) 

SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM olist.customers

ON CONFLICT(customer_id) 
DO UPDATE SET
    customer_city = EXCLUDED.customer_city,
    customer_unique_id = EXCLUDED.customer_unique_id,
    customer_zip_code_prefix = EXCLUDED.customer_zip_code_prefix,
    customer_state = EXCLUDED.customer_state,
    updated_at = CASE WHEN 
                        stg.customers.customer_city <> EXCLUDED.customer_city
                        OR stg.customers.customer_unique_id <> EXCLUDED.customer_unique_id 
                        OR stg.customers.customer_zip_code_prefix <> EXCLUDED.customer_zip_code_prefix 
                        OR stg.customers.customer_state <> EXCLUDED.customer_state 

                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        stg.customers.updated_at
                END;