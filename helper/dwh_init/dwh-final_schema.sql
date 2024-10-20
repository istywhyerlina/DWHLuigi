CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CREATE SCHEMA FOR FINAL AREA
CREATE SCHEMA IF NOT EXISTS final AUTHORIZATION postgres;

-- time dimension
DROP TABLE if exists final.dim_time;
CREATE TABLE final.dim_time
(
	time_id integer NOT NULL,
	time_actual time NOT NULL,
	hours_24 character(2) NOT NULL,
	hours_12 character(2) NOT NULL,
	hour_minutes character (2)  NOT NULL,
	day_minutes integer NOT NULL,
	day_time_name character varying (20) NOT NULL,
	day_night character varying (20) NOT NULL,
	CONSTRAINT time_pk PRIMARY KEY (time_id)
);

DROP TABLE if exists final.dim_date;
CREATE TABLE final.dim_date
(
  date_id              INT NOT null primary KEY,
  date_actual              DATE NOT NULL,
  day_suffix               VARCHAR(4) NOT NULL,
  day_name                 VARCHAR(9) NOT NULL,
  day_of_year              INT NOT NULL,
  week_of_month            INT NOT NULL,
  week_of_year             INT NOT NULL,
  week_of_year_iso         CHAR(10) NOT NULL,
  month_actual             INT NOT NULL,
  month_name               VARCHAR(9) NOT NULL,
  month_name_abbreviated   CHAR(3) NOT NULL,
  quarter_actual           INT NOT NULL,
  quarter_name             VARCHAR(9) NOT NULL,
  year_actual              INT NOT NULL,
  first_day_of_week        DATE NOT NULL,
  last_day_of_week         DATE NOT NULL,
  first_day_of_month       DATE NOT NULL,
  last_day_of_month        DATE NOT NULL,
  first_day_of_quarter     DATE NOT NULL,
  last_day_of_quarter      DATE NOT NULL,
  first_day_of_year        DATE NOT NULL,
  last_day_of_year         DATE NOT NULL,
  mmyyyy                   CHAR(6) NOT NULL,
  mmddyyyy                 CHAR(10) NOT NULL,
  weekend_indr             VARCHAR(20) NOT NULL
);

CREATE INDEX dim_date_date_actual_idx
  ON final.dim_date(date_actual);

 ALTER TABLE final.dim_date 
    ADD CONSTRAINT uniq_date UNIQUE (date_actual);


-- dim customer
CREATE TABLE final.dim_customer (
    id uuid  PRIMARY KEY default uuid_generate_v4(),
    customer_id_nk text NOT NULL,
    customer_city text,
    customer_state text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


--dim_seller
CREATE TABLE final.dim_seller (
    id uuid PRIMARY KEY default uuid_generate_v4(),
    seller_id_nk text NOT NULL,
    seller_city text,
    seller_state text,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--dim product

CREATE TABLE final.dim_product (
    id uuid PRIMARY KEY default uuid_generate_v4(),
    product_id_nk text NOT NULL,
    product_category_name text,
    product_name_length real,
    product_weight_g real,
    product_length_cm real,
    product_height_cm real,
    product_width_cm real,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--payment_dim

create table final.dim_payment(
    id uuid PRIMARY KEY default uuid_generate_v4(),
    order_id_nk text NOT NULL,
    count_payment_sequential_nk int,
    sum_payment int,
    payment_type_not_defined varchar,
    payment_type_boleto varchar,
    payment_type_credit_card varchar,
    payment_type_voucher varchar,
    payment_type_debit_card varchar, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE final.fct_transaction (
    id uuid PRIMARY KEY default uuid_generate_v4(),
    order_id varchar NOT NULL,
    order_item_id integer NOT NULL,
    product_id uuid,
    seller_id uuid,
    customer_id uuid,
    payment_id uuid,
    product_weight_g real,
    product_length_cm real,
    product_height_cm real,
    product_width_cm real,
    customer_city text,
    customer_state text,
    seller_city text,
    seller_state text,
    order_status text,
    order_approved_at date,
    order_delivered_carrier_date date,
    order_delivered_customer_date date,
    order_estimated_delivery_date date,
    count_payment_sequential int,
    sum_payment int,
    payment_type_not_defined varchar,
    payment_type_boleto varchar,
    payment_type_credit_card varchar,
    payment_type_voucher varchar,
    payment_type_debit_card varchar, 
    price real,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Constraints
    CONSTRAINT fk_seller FOREIGN KEY (seller_id) REFERENCES final.dim_seller(id),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES final.dim_customer(id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES final.dim_product(id),
    CONSTRAINT fk_payment FOREIGN KEY (payment_id) REFERENCES final.dim_payment(id),
    CONSTRAINT fk_order_approved_at FOREIGN KEY (order_approved_at) REFERENCES final.dim_date (date_actual),
    CONSTRAINT fk_order_delivered_carrier_date FOREIGN KEY (order_delivered_carrier_date) REFERENCES final.dim_date (date_actual),
    CONSTRAINT fk_order_delivered_customer_date FOREIGN KEY (order_delivered_customer_date) REFERENCES final.dim_date (date_actual),
    CONSTRAINT fk_order_estimated_delivery_date FOREIGN KEY (order_estimated_delivery_date) REFERENCES final.dim_date (date_actual)
);

ALTER TABLE final.fct_transaction ADD CONSTRAINT unik_ct_transaction UNIQUE (order_id, order_item_id, seller_id, customer_id, product_id,payment_id);


INSERT INTO final.dim_date
SELECT TO_CHAR(datum, 'yyyymmdd')::INT AS date_id,
       datum AS date_actual,
       TO_CHAR(datum, 'fmDDth') AS day_suffix,
       TO_CHAR(datum, 'TMDay') AS day_name,
       EXTRACT(DOY FROM datum) AS day_of_year,
       TO_CHAR(datum, 'W')::INT AS week_of_month,
       EXTRACT(WEEK FROM datum) AS week_of_year,
       EXTRACT(ISOYEAR FROM datum) || TO_CHAR(datum, '"-W"IW') AS week_of_year_iso,
       EXTRACT(MONTH FROM datum) AS month_actual,
       TO_CHAR(datum, 'TMMonth') AS month_name,
       TO_CHAR(datum, 'Mon') AS month_name_abbreviated,
       EXTRACT(QUARTER FROM datum) AS quarter_actual,
       CASE
           WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
           WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
           WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
           WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
           END AS quarter_name,
       EXTRACT(YEAR FROM datum) AS year_actual,
       datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS first_day_of_week,
       datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS last_day_of_week,
       datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
       (DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month,
       DATE_TRUNC('quarter', datum)::DATE AS first_day_of_quarter,
       (DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS last_day_of_quarter,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD') AS first_day_of_year,
       TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD') AS last_day_of_year,
       TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
       TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy,
       CASE
           WHEN EXTRACT(ISODOW FROM datum) IN (6, 7) THEN 'weekend'
           ELSE 'weekday'
           END AS weekend_indr
FROM (SELECT '1998-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;

-- populate time dimension
insert into  final.dim_time

SELECT  
	cast(to_char(minute, 'hh24mi') as numeric) time_id,
	to_char(minute, 'hh24:mi')::time AS tume_actual,
	-- Hour of the day (0 - 23)
	to_char(minute, 'hh24') AS hour_24,
	-- Hour of the day (0 - 11)
	to_char(minute, 'hh12') hour_12,
	-- Hour minute (0 - 59)
	to_char(minute, 'mi') hour_minutes,
	-- Minute of the day (0 - 1439)
	extract(hour FROM minute)*60 + extract(minute FROM minute) day_minutes,
	-- Names of day periods
	case 
		when to_char(minute, 'hh24:mi') BETWEEN '00:00' AND '11:59'
		then 'AM'
		when to_char(minute, 'hh24:mi') BETWEEN '12:00' AND '23:59'
		then 'PM'
	end AS day_time_name,
	-- Indicator of day or night
	case 
		when to_char(minute, 'hh24:mi') BETWEEN '07:00' AND '19:59' then 'Day'	
		else 'Night'
	end AS day_night
FROM 
	(SELECT '0:00'::time + (sequence.minute || ' minutes')::interval AS minute 
	FROM  generate_series(0,1439) AS sequence(minute)
GROUP BY sequence.minute
) DQ
ORDER BY 1;

