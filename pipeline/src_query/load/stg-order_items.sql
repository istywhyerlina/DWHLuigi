INSERT INTO stg.order_items 
    (order_id,order_item_id,product_id,seller_id,shipping_limit_date,price,freight_value)

SELECT 
order_id,order_item_id,product_id,seller_id,shipping_limit_date,price,freight_value 
FROM
    olist.order_items

ON CONFLICT(order_id,order_item_id) 
DO UPDATE SET
    product_id = EXCLUDED.product_id,
    seller_id = EXCLUDED.seller_id,
    shipping_limit_date = EXCLUDED.shipping_limit_date,
    price = EXCLUDED.price,
    freight_value = EXCLUDED.freight_value,
    updated_at = CASE WHEN 
                        stg.order_items.product_id <> EXCLUDED.product_id
                        OR stg.order_items.seller_id <> EXCLUDED.seller_id
                        OR stg.order_items.shipping_limit_date <> EXCLUDED.shipping_limit_date
                        OR stg.order_items.price <> EXCLUDED.price
                        OR stg.order_items.freight_value <> EXCLUDED.freight_value
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        stg.order_items.updated_at
                END;