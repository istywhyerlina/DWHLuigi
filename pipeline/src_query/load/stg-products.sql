INSERT INTO stg.products 
    (product_id,product_category_name,product_name_length,product_description_length,product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm) 

SELECT product_id,product_category_name,product_name_lenght,product_description_lenght,product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm
FROM
    olist.products

ON CONFLICT(product_id) 
DO UPDATE SET
    product_category_name = EXCLUDED.product_category_name,
    product_name_length = EXCLUDED.product_name_length,
    product_description_length = EXCLUDED.product_description_length,
    product_photos_qty = EXCLUDED.product_photos_qty,
    product_weight_g = EXCLUDED.product_weight_g,
    product_length_cm = EXCLUDED.product_length_cm,
    product_height_cm = EXCLUDED.product_height_cm,
    product_width_cm = EXCLUDED.product_width_cm,
    updated_at = CASE WHEN 
                        stg.products.product_category_name <> EXCLUDED.product_category_name
                        OR stg.products.product_name_length <> EXCLUDED.product_name_length
                        OR stg.products.product_description_length <> EXCLUDED.product_description_length
                        OR stg.products.product_photos_qty <> EXCLUDED.product_photos_qty
                        OR stg.products.product_weight_g <> EXCLUDED.product_weight_g
                        OR stg.products.product_length_cm <> EXCLUDED.product_length_cm
                        OR stg.products.product_height_cm <> EXCLUDED.product_height_cm
                        OR stg.products.product_width_cm <> EXCLUDED.product_width_cm

                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        stg.products.updated_at
                END;