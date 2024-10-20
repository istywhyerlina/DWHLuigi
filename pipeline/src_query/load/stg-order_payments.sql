INSERT INTO stg.order_payments 
    (order_id, payment_sequential, payment_type,payment_installments,payment_value) 

SELECT
order_id, payment_sequential, payment_type,payment_installments,payment_value
FROM
    olist.order_payments

ON CONFLICT(order_id, payment_sequential) 
DO UPDATE SET
    payment_type = EXCLUDED.payment_type,
    payment_installments = EXCLUDED.payment_installments,
    payment_value = EXCLUDED.payment_value,
    updated_at = CASE WHEN 
                        stg.order_payments.payment_type <> EXCLUDED.payment_type
                        OR stg.order_payments.payment_installments <> EXCLUDED.payment_installments
                        OR stg.order_payments.payment_value <> EXCLUDED.payment_value
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        stg.order_payments.updated_at
                END;