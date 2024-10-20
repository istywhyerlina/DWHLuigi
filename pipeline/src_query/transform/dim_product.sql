INSERT INTO final.dim_product 
    (id, product_id_nk,product_weight_g,product_length_cm,product_height_cm,product_width_cm) 

SELECT id, product_id,product_weight_g,product_length_cm,product_height_cm,product_width_cm
FROM
    stg.products

ON CONFLICT(id) 
DO UPDATE SET
    product_id_nk = EXCLUDED.product_id_nk,
    product_weight_g = EXCLUDED.product_weight_g,
    product_length_cm = EXCLUDED.product_length_cm,
    product_height_cm = EXCLUDED.product_height_cm,
    product_width_cm = EXCLUDED.product_width_cm,
    updated_at = CASE WHEN 
                        final.dim_product.product_id_nk <> EXCLUDED.product_id_nk
                        OR final.dim_product.product_weight_g <> EXCLUDED.product_weight_g
                        OR final.dim_product.product_length_cm <> EXCLUDED.product_length_cm
                        OR final.dim_product.product_height_cm <> EXCLUDED.product_height_cm
                        OR final.dim_product.product_width_cm <> EXCLUDED.product_width_cm

                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.dim_product.updated_at
                END;