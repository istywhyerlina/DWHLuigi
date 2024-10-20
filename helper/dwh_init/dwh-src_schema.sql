CREATE SCHEMA IF NOT EXISTS olist AUTHORIZATION postgres;

COMMENT ON SCHEMA olist IS 'Olist demo database schema';
---

CREATE TABLE olist.geolocation (
    geolocation_zip_code_prefix integer NOT NULL,
    geolocation_lat real,
    geolocation_lng real,
    geolocation_city text,
    geolocation_state text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


--ALTER TABLE olist.geolocation OWNER TO postgres;


CREATE TABLE olist.customers (
    customer_id text NOT NULL,
    customer_unique_id text,
    customer_zip_code_prefix integer,
    customer_city text,
    customer_state text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT customer_pkey PRIMARY KEY (customer_id)
);


-- ALTER TABLE olist.customers OWNER TO postgres;


-- Name: geolocation; Type: TABLE; Schema: olist; Owner: postgres
--
--
-- Name: order_items; Type: TABLE; Schema: olist; Owner: postgres
--
CREATE TABLE olist.orders (
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
	CONSTRAINT order_customer_order_fkey FOREIGN KEY (customer_id) REFERENCES olist.customers(customer_id)
);



CREATE TABLE olist.sellers (
    seller_id text NOT NULL,
    seller_zip_code_prefix integer,
    seller_city text,
    seller_state text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT sellers_pkey PRIMARY KEY (seller_id)
);



CREATE TABLE olist.product_category_name_translation (
    product_category_name text NOT NULL,
    product_category_name_english text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT product_category_name_translation_pkey PRIMARY KEY (product_category_name)
);


--ALTER TABLE olist.product_category_name_translation OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: olist; Owner: postgres
--

CREATE TABLE olist.products (
    product_id text NOT NULL,
    product_category_name text,
    product_name_lenght real,
    product_description_lenght real,
    product_photos_qty real,
    product_weight_g real,
    product_length_cm real,
    product_height_cm real,
    product_width_cm real,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT products_pkey PRIMARY KEY (product_id)
);


--ALTER TABLE olist.products OWNER TO postgres;

--
-- Name: sellers; Type: TABLE; Schema: olist; Owner: postgres
--


CREATE TABLE olist.order_items (
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
	CONSTRAINT orderitem_order_fkey FOREIGN KEY (order_id) REFERENCES olist.orders(order_id),
	CONSTRAINT orderitem_product_fkey FOREIGN KEY (product_id) REFERENCES olist.products(product_id),
	CONSTRAINT orderitem_seller_fkey FOREIGN KEY (seller_id) REFERENCES olist.sellers(seller_id)
);


--ALTER TABLE olist.order_items OWNER TO postgres;

--
-- Name: order_payments; Type: TABLE; Schema: olist; Owner: postgres
--

CREATE TABLE olist.order_payments (
    order_id text NOT NULL,
    payment_sequential integer NOT NULL,
    payment_type text,
    payment_installments integer,
    payment_value real,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 	CONSTRAINT payments_pkey PRIMARY KEY (order_id,payment_sequential),   
	CONSTRAINT order_payments_order_fkey FOREIGN KEY (order_id) REFERENCES olist.orders(order_id)
);


--ALTER TABLE olist.order_payments OWNER TO postgres;

--
-- Name: order_reviews; Type: TABLE; Schema: olist; Owner: postgres
--

CREATE TABLE olist.order_reviews (
    review_id text NOT NULL,
    order_id text NOT NULL,
    review_score integer,
    review_comment_title text,
    review_comment_message text,
    review_creation_date text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT order_reviews_pkey PRIMARY KEY (review_id,order_id),
	CONSTRAINT order_reviews_order_fkey FOREIGN KEY (order_id) REFERENCES olist.orders(order_id)
);


--ALTER TABLE olist.order_reviews OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: olist; Owner: postgres
--



--ALTER TABLE olist.orders OWNER TO postgres;

--
-- Name: product_category_name_translation; Type: TABLE; Schema: olist; Owner: postgres
--
