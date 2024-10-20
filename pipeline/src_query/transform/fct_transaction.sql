 

WITH 
	orders as (
		select *
		from stg.orders
	),
	order_items as (
		select *
		from stg.order_items
	),
	dim_dates AS (
	    SELECT *
	    FROM final.dim_date
	),
	dim_seller as (
		SELECT *
	    FROM final.dim_seller
	),
	dim_payment as (
		SELECT *
	    FROM final.dim_payment
	),
	dim_customer as (
		SELECT *
	    FROM final.dim_customer
	),
	dim_product as (
		SELECT *
	    FROM final.dim_product
	),
	stg_fct_transaction as (
		select 
			oi.order_id as order_id,
			oi.order_item_id as order_item_id, 
			pr.id as product_id,
			s.id as seller_id,
			c.id as customer_id,
			p.id as payment_id,
			pr.product_weight_g as product_weight_g,
			pr.product_length_cm as product_length_cm,
			pr.product_height_cm as product_height_cm,
			pr.product_width_cm as product_width_cm,
			c.customer_city as customer_city,
			c.customer_state as customer_state,
			s.seller_city as seller_city,
			s.seller_state as seller_state,
			o.order_status as order_status,
			cast(o.order_approved_at as date) as order_approved_at,
			cast(o.order_delivered_carrier_date as date) as order_delivered_carrier_date,
			cast(o.order_delivered_customer_date as date) as order_delivered_customer_date,
			cast(o.order_estimated_delivery_date as date) as order_estimated_delivery_date,
			p.count_payment_sequential_nk as count_payment_sequential,
			p.sum_payment as sum_payment,
			p.payment_type_not_defined as payment_type_not_defined,
			p.payment_type_boleto as  payment_type_boleto,
			p.payment_type_credit_card as payment_type_credit_card,
			p.payment_type_voucher as payment_type_voucher,
			p.payment_type_debit_card as payment_type_debit_card,
			oi.price as price
			from 
			order_items oi JOIN
			orders o on oi.order_id=o.order_id JOIN
			dim_seller s on s.seller_id_nk= oi.seller_id JOIN
			dim_customer c on c.customer_id_nk=o.customer_id JOIN
			dim_payment as p on p.order_id_nk=o.order_id JOIN
			dim_product as pr on pr.product_id_nk=oi.product_id
	)


INSERT INTO final.fct_transaction (
    order_id ,
    order_item_id ,
    product_id ,
    seller_id ,
    customer_id ,
    payment_id ,
    product_weight_g ,
    product_length_cm ,
    product_height_cm ,
    product_width_cm ,
    customer_city,
    customer_state ,
    seller_city ,
    seller_state ,
    order_status ,
    order_approved_at ,
    order_delivered_carrier_date ,
    order_delivered_customer_date ,
    order_estimated_delivery_date ,
    count_payment_sequential ,
    sum_payment ,
    payment_type_not_defined ,
    payment_type_boleto ,
    payment_type_credit_card ,
    payment_type_voucher ,
    payment_type_debit_card , 
    price )

SELECT 
	* 
FROM 
	stg_fct_transaction

ON CONFLICT(order_id, order_item_id, seller_id, customer_id, product_id,payment_id) 
DO UPDATE SET
	product_weight_g = EXCLUDED.product_weight_g,
	product_length_cm = EXCLUDED.product_length_cm,
	product_height_cm = EXCLUDED.product_height_cm,
	product_width_cm = EXCLUDED.product_width_cm,
	customer_city = EXCLUDED.customer_city,
	customer_state = EXCLUDED.customer_state,
	seller_city = EXCLUDED.seller_city,
	seller_state = EXCLUDED.seller_state,
	order_status = EXCLUDED.order_status,
	order_approved_at = EXCLUDED.order_approved_at,
	order_delivered_carrier_date = EXCLUDED.order_delivered_carrier_date,
	order_delivered_customer_date = EXCLUDED.order_delivered_customer_date,
	order_estimated_delivery_date = EXCLUDED.order_estimated_delivery_date,
	count_payment_sequential = EXCLUDED.count_payment_sequential,
	sum_payment = EXCLUDED.sum_payment,
	payment_type_not_defined = EXCLUDED.payment_type_not_defined,
	payment_type_boleto = EXCLUDED.payment_type_boleto,
	payment_type_credit_card = EXCLUDED.payment_type_credit_card,
	payment_type_voucher = EXCLUDED.payment_type_voucher,
	payment_type_debit_card = EXCLUDED.payment_type_debit_card,
	price = EXCLUDED.price,
    updated_at = CASE WHEN 
						final.fct_transaction.product_weight_g <> EXCLUDED.product_weight_g
						OR final.fct_transaction.product_length_cm <> EXCLUDED.product_length_cm
						OR final.fct_transaction.product_height_cm <> EXCLUDED.product_height_cm
						OR final.fct_transaction.product_width_cm <> EXCLUDED.product_width_cm
						OR final.fct_transaction.customer_city <> EXCLUDED.customer_city
						OR final.fct_transaction.customer_state <> EXCLUDED.customer_state
						OR final.fct_transaction.seller_city <> EXCLUDED.seller_city
						OR final.fct_transaction.seller_state <> EXCLUDED.seller_state
						OR final.fct_transaction.order_status <> EXCLUDED.order_status
						OR final.fct_transaction.order_approved_at <> EXCLUDED.order_approved_at
						OR final.fct_transaction.order_delivered_carrier_date <> EXCLUDED.order_delivered_carrier_date
						OR final.fct_transaction.order_delivered_customer_date <> EXCLUDED.order_delivered_customer_date
						OR final.fct_transaction.order_estimated_delivery_date <> EXCLUDED.order_estimated_delivery_date
                        OR final.fct_transaction.count_payment_sequential <> EXCLUDED.count_payment_sequential
                        OR final.fct_transaction.sum_payment <> EXCLUDED.sum_payment
						OR final.fct_transaction.payment_type_not_defined <> EXCLUDED.payment_type_not_defined
						OR final.fct_transaction.payment_type_boleto <> EXCLUDED.payment_type_boleto
                        OR final.fct_transaction.payment_type_credit_card <> EXCLUDED.payment_type_credit_card
                        OR final.fct_transaction.payment_type_voucher <> EXCLUDED.payment_type_voucher
						OR final.fct_transaction.payment_type_debit_card <> EXCLUDED.payment_type_debit_card
						OR final.fct_transaction.price <> EXCLUDED.price
                THEN 
                        CURRENT_TIMESTAMP
                ELSE
                        final.fct_transaction.updated_at
                END;

               
