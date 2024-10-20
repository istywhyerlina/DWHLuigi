INSERT INTO final.dim_customer
    (id, customer_id_nk,customer_city,customer_state) 

SELECT
    id,
    customer_id,
    customer_city,
    customer_state
FROM stg.customers

ON CONFLICT(id) 
DO UPDATE SET
    customer_id_nk = EXCLUDED.customer_id_nk,
    customer_city = EXCLUDED.customer_city,
    customer_state = EXCLUDED.customer_state,
    updated_at = CASE WHEN 
                        final.dim_customer.customer_id_nk <> EXCLUDED.customer_id_nk
                        OR final.dim_customer.customer_city <> EXCLUDED.customer_city
                        OR final.dim_customer.customer_state <> EXCLUDED.customer_state 

                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.dim_customer.updated_at
                END;