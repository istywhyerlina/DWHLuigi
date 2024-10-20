INSERT INTO stg.product_category_name_translation 
    (product_category_name, product_category_name_english) 

SELECT product_category_name, product_category_name_english
FROM
    olist.product_category_name_translation

ON CONFLICT(product_category_name) 
DO UPDATE SET
    product_category_name_english = EXCLUDED.product_category_name_english,
    updated_at = CASE WHEN 
                        stg.product_category_name_translation.product_category_name_english <> EXCLUDED.product_category_name_english

                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        stg.product_category_name_translation.updated_at
                END;