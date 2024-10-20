INSERT INTO final.dim_payment
    (id, order_id_nk,    count_payment_sequential_nk,
    sum_payment,
    payment_type_not_defined,
    payment_type_boleto,
    payment_type_credit_card,
    payment_type_voucher,
    payment_type_debit_card)  


SELECT id, order_id,count(order_id) as count_payment_sequential,sum(payment_value) as sum_payment,
       Max(CASE
             WHEN payment_type = 'not_defined' THEN 'yes' else 'no'
           END) payment_type_not_defined,
       Max(CASE
             WHEN payment_type = 'boleto' THEN 'yes' else 'no'
           END) payment_type_boleto,
       Max(CASE
             WHEN payment_type = 'debit_card' THEN 'yes' else 'no'
           END) payment_type_debit_card,
      Max(CASE
             WHEN payment_type = 'voucher' THEN 'yes' else 'no'
           END) payment_type_voucher,
       Max(CASE
             WHEN payment_type = 'credit_card' THEN 'yes' else 'no'
           END) payment_type_credit_card           
FROM   stg.order_payments
GROUP  BY id, order_id

ON CONFLICT(id) 
DO UPDATE SET
    order_id_nk = EXCLUDED.order_id_nk,
    count_payment_sequential_nk = EXCLUDED.count_payment_sequential_nk,
    sum_payment = EXCLUDED.sum_payment,
    payment_type_not_defined = EXCLUDED.payment_type_not_defined,
    payment_type_boleto = EXCLUDED.payment_type_boleto,
    payment_type_credit_card = EXCLUDED.payment_type_credit_card,
    payment_type_voucher = EXCLUDED.payment_type_voucher,
    payment_type_debit_card = EXCLUDED.payment_type_debit_card,

    updated_at = CASE WHEN 
                        final.dim_payment.order_id_nk <> EXCLUDED.order_id_nk
                        OR final.dim_payment.count_payment_sequential_nk <> EXCLUDED.count_payment_sequential_nk
                        OR final.dim_payment.sum_payment <> EXCLUDED.sum_payment 
                        OR final.dim_payment.payment_type_not_defined <> EXCLUDED.payment_type_not_defined
                        OR final.dim_payment.payment_type_boleto <> EXCLUDED.payment_type_boleto                        
                        OR final.dim_payment.payment_type_credit_card <> EXCLUDED.payment_type_credit_card
                        OR final.dim_payment.payment_type_voucher <> EXCLUDED.payment_type_voucher
                        OR final.dim_payment.payment_type_debit_card <> EXCLUDED.payment_type_debit_card
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.dim_payment.updated_at
                END;