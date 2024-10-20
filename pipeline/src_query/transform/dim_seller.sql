INSERT INTO final.dim_seller
    (id,seller_id_nk,seller_city,seller_state) 

SELECT
    id,
    seller_id,
    seller_city,
    seller_state
FROM stg.sellers

ON CONFLICT(id) 
DO UPDATE SET
    seller_id_nk = EXCLUDED.seller_id_nk,
    seller_city = EXCLUDED.seller_city,
    seller_state = EXCLUDED.seller_state,
    updated_at = CASE WHEN 
                        final.dim_seller.seller_id_nk <> EXCLUDED.seller_id_nk
                        OR final.dim_seller.seller_city <> EXCLUDED.seller_city
                        OR final.dim_seller.seller_state <> EXCLUDED.seller_state 

                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.dim_seller.updated_at
                END;