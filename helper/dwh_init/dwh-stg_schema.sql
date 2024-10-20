CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA IF NOT EXISTS stg AUTHORIZATION postgres;

COMMENT ON SCHEMA stg IS 'stg Staging database schema';
---


-- Name: geolocation; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.geolocation (
    id uuid default uuid_generate_v4(),
    geolocation_zip_code_prefix integer NOT NULL,
    geolocation_lat real,
    geolocation_lng real,
    geolocation_city text,
    geolocation_state text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


--ALTER TABLE stg.geolocation OWNER TO postgres;


CREATE TABLE stg.customers (
    id uuid default uuid_generate_v4(),
    customer_id text NOT NULL,
    customer_unique_id text,
    customer_zip_code_prefix integer,
    customer_city text,
    customer_state text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT customer_pkey PRIMARY KEY (customer_id)
);


-- ALTER TABLE stg.customers OWNER TO postgres;


-- Name: geolocation; Type: TABLE; Schema: stg; Owner: postgres
--
--
-- Name: order_items; Type: TABLE; Schema: stg; Owner: postgres
--
CREATE TABLE stg.orders (
    id uuid default uuid_generate_v4(),
    order_id text NOT NULL,
    customer_id text,
    order_status text,
    order_purchase_timestamp text,
    order_approved_at text,
    order_delivered_carrier_date text,
    order_delivered_customer_date text,
    order_estimated_delivery_date text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT orders_pkey PRIMARY KEY (order_id),
	CONSTRAINT order_customer_order_fkey FOREIGN KEY (customer_id) REFERENCES stg.customers(customer_id)
);



CREATE TABLE stg.sellers (
    id uuid default uuid_generate_v4(),
    seller_id text NOT NULL,
    seller_zip_code_prefix integer,
    seller_city text,
    seller_state text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT sellers_pkey PRIMARY KEY (seller_id)
);



CREATE TABLE stg.product_category_name_translation (
    id uuid default uuid_generate_v4(),
    product_category_name text NOT NULL,
    product_category_name_english text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT product_category_name_translation_pkey PRIMARY KEY (product_category_name)
);


--ALTER TABLE stg.product_category_name_translation OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.products (
    id uuid default uuid_generate_v4(),
    product_id text NOT NULL,
    product_category_name text,
    product_name_length real,
    product_description_length real,
    product_photos_qty real,
    product_weight_g real,
    product_length_cm real,
    product_height_cm real,
    product_width_cm real,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT products_pkey PRIMARY KEY (product_id)
);


--ALTER TABLE stg.products OWNER TO postgres;

--
-- Name: sellers; Type: TABLE; Schema: stg; Owner: postgres
--


CREATE TABLE stg.order_items (
    id uuid default uuid_generate_v4(),
    order_id text NOT NULL,
    order_item_id integer NOT NULL,
    product_id text,
    seller_id text,
    shipping_limit_date text,
    price real,
    freight_value real,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT order_item_pkey PRIMARY KEY (order_item_id,order_id),
	CONSTRAINT orderitem_order_fkey FOREIGN KEY (order_id) REFERENCES stg.orders(order_id),
	CONSTRAINT orderitem_product_fkey FOREIGN KEY (product_id) REFERENCES stg.products(product_id),
	CONSTRAINT orderitem_seller_fkey FOREIGN KEY (seller_id) REFERENCES stg.sellers(seller_id)
);


--ALTER TABLE stg.order_items OWNER TO postgres;

--
-- Name: order_payments; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.order_payments (
    id uuid default uuid_generate_v4(),
    order_id text NOT NULL,
    payment_sequential integer NOT NULL,
    payment_type text,
    payment_installments integer,
    payment_value real,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 	CONSTRAINT payments_pkey PRIMARY KEY (order_id,payment_sequential),   
	CONSTRAINT order_payments_order_fkey FOREIGN KEY (order_id) REFERENCES stg.orders(order_id)
);


--ALTER TABLE stg.order_payments OWNER TO postgres;

--
-- Name: order_reviews; Type: TABLE; Schema: stg; Owner: postgres
--

CREATE TABLE stg.order_reviews (
    id uuid default uuid_generate_v4(),
    review_id text NOT NULL,
    order_id text NOT NULL,
    review_score integer,
    review_comment_title text,
    review_comment_message text,
    review_creation_date text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT order_reviews_pkey PRIMARY KEY (review_id,order_id),
	CONSTRAINT order_reviews_order_fkey FOREIGN KEY (order_id) REFERENCES stg.orders(order_id)
);


--ALTER TABLE stg.order_reviews OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: stg; Owner: postgres
--



--ALTER TABLE stg.orders OWNER TO postgres;

--
-- Name: product_category_name_translation; Type: TABLE; Schema: stg; Owner: postgres
--
