--ec_datamart.clean_customers

--Checking for nulls
SELECT cust_id,COUNT(cust_id)
FROM ec_datamart.clean_customers
GROUP BY cust_id
HAVING  COUNT(cust_id)>1;

SELECT first_name,last_name,full_name,city,email,phone_number,cust_id
FROM ec_datamart.clean_customers
WHERE first_name IS NULL OR last_name IS NULL
OR full_name IS NULL OR city IS NULL OR  loyalty_tier IS NULL
OR email IS NULL OR phone_number  IS NULL  OR cust_id IS NULL;

--Checking for invalid spaces
SELECT first_name,last_name,full_name,city,email, phone_number
FROM ec_datamart.clean_customers
WHERE first_name!=TRIM(first_name) OR last_name !=TRIM(last_name) 
OR full_name !=TRIM(full_name) OR city !=TRIM(city ) OR loyalty_tier!=TRIM(loyalty_tier)
OR email !=TRIM(email) OR  phone_number!=TRIM(phone_number);

--Checking dates quality
SELECT MIN(dob)
FROM ec_datamart.clean_customers

SELECT MAX(dob)
FROM ec_datamart.clean_customers;

--Checking the data quality
SELECT marketing_opt_in,COUNT(*) 
FROM ec_datamart.clean_customers
WHERE marketing_opt_in NOT IN (0,1)
GROUP BY marketing_opt_in;

SELECT country, COUNT(*) AS customer_count
FROM ec_datamart.clean_customers
GROUP BY country;

SELECT cust_id, email
FROM ec_datamart.clean_customers
WHERE email NOT LIKE '%@%.%';
--===================================--
--ec_datamart.clean_orders

--Checking for duplicates

SELECT order_id,COUNT(order_id)
FROM ec_datamart.clean_orders
GROUP BY order_id
HAVING  COUNT(order_id)>1;

SELECT order_number,COUNT(order_number)
FROM ec_datamart.clean_orders
GROUP BY order_number
HAVING  COUNT(order_number)>1;

SELECT *
FROM ec_datamart.clean_orders
WHERE order_number ='ord-227740';

SELECT customer_id,COUNT(customer_id)
FROM ec_datamart.clean_orders
GROUP BY customer_id
HAVING  COUNT(customer_id)>1;

SELECT *
FROM ec_datamart.clean_orders
WHERE customer_id =261;

--Validating dates
SELECT MAX(order_date) AS mxod,MIN(order_date) AS mnod,MAX(ship_date) AS mxsd
,MIN(ship_date) AS mnsd
FROM ec_datamart.clean_orders;

SELECT *
FROM ec_datamart.clean_orders
WHERE order_date>ship_date;
--Checking nulls
SELECT discount_code,payment_method,payment_status, shipping_method, order_notes
FROM ec_datamart.clean_orders
WHERE discount_code IS NULL OR payment_method IS NULL OR payment_status IS NULL OR shipping_method IS NULL OR order_notes IS NULL ;

SELECT order_id, customer_id, order_date, total_amount, quantity
FROM ec_datamart.clean_orders
WHERE order_id IS NULL 
   OR customer_id IS NULL 
   OR order_date IS NULL 
   OR total_amount IS NULL 
   OR quantity IS NULL;
--Checking for invalid spaces

SELECT order_number,discount_code,payment_method,payment_status, shipping_method, order_notes
FROM ec_datamart.clean_orders
WHERE discount_code !=TRIM(discount_code) OR payment_method !=TRIM(payment_method)OR payment_status !=TRIM(payment_status) OR shipping_method !=TRIM(shipping_method) OR order_notes !=TRIM(order_notes);

--Validating categories
SELECT DISTINCT payment_method
FROM ec_datamart.clean_orders;

SELECT DISTINCT discount_code
FROM ec_datamart.clean_orders;

SELECT DISTINCT payment_status
FROM ec_datamart.clean_orders;

SELECT DISTINCT shipping_method
FROM ec_datamart.clean_orders;

SELECT DISTINCT order_notes
FROM ec_datamart.clean_orders;
--================================--
--ec_datamart.clean_products_inventory

--Checking for duplicates

SELECT prod_id,COUNT(prod_id)
FROM ec_datamart.clean_products_inventory
GROUP BY prod_id
HAVING  COUNT(prod_id)>1;
--Checking for nulls
-- Checking for nulls on your actual columns
SELECT prod_id, sku, product_name, category_hierarchy, brand, currency, warehouse_location, color, material
FROM ec_datamart.clean_products_inventory
WHERE prod_id IS NULL 
   OR sku IS NULL 
   OR product_name IS NULL 
   OR category_hierarchy IS NULL 
   OR brand IS NULL 
   OR currency IS NULL 
   OR warehouse_location IS NULL 
   OR color IS NULL 
   OR material IS NULL;
--Checking for invalid spaces
SELECT 
 sku
,product_name
,category_hierarchy
,brand
,currency
,warehouse_location
,color
,material
FROM ec_datamart.clean_products_inventory
WHERE sku != TRIM(sku) OR
product_name != TRIM(product_name)OR
category_hierarchy!= TRIM(category_hierarchy)OR
brand != TRIM(brand) OR
currency != TRIM(currency) OR
warehouse_location != TRIM(warehouse_location) OR
color != TRIM(color) OR
material!= TRIM(material);

SELECT DISTINCT brand
FROM ec_datamart.clean_products_inventory;

SELECT DISTINCT warehouse_location
FROM ec_datamart.clean_products_inventory;

SELECT DISTINCT color
FROM ec_datamart.clean_products_inventory;

SELECT DISTINCT material
FROM ec_datamart.clean_products_inventory;

SELECT DISTINCT currency 
FROM ec_datamart.clean_products_inventory;

SELECT DISTINCT category_hierarchy 
FROM ec_datamart.clean_products_inventory;
--================================--
--ec_datamart.clean_shipping_logs
--Checking for duplicates

SELECT shipment_id,COUNT(shipment_id)
FROM ec_datamart.clean_shipping_logs
GROUP BY shipment_id
HAVING  COUNT(shipment_id)>1;

--Checking for nulls
SELECT shipment_id, order_ref, carrier, tracking_code, recipient_name,
       delivery_zone, package_length_in, package_width_in, status_log_clean
FROM ec_datamart.clean_shipping_logs
WHERE shipment_id IS NULL 
   OR order_ref IS NULL 
   OR carrier IS NULL 
   OR tracking_code IS NULL 
   OR recipient_name IS NULL 
   OR delivery_zone IS NULL 
   OR package_length_in IS NULL 
   OR package_width_in IS NULL 
   OR status_log_clean IS NULL;

   SELECT shipment_id
FROM ec_datamart.clean_shipping_logs
WHERE shipping_cost IS NULL 
   OR fuel_surcharge IS NULL 
   OR total_shipping_cost IS NULL 
   OR package_length_in IS NULL 
   OR package_width_in IS NULL 
   OR dispatch_timestamp IS NULL 
   OR delivery_timestamp IS NULL;
--Checking for invalid spaces
SELECT order_ref, carrier, tracking_code, recipient_name, delivery_zone, status_log_clean
FROM ec_datamart.clean_shipping_logs
WHERE order_ref != TRIM(order_ref) 
   OR carrier != TRIM(carrier) 
   OR tracking_code != TRIM(tracking_code) 
   OR recipient_name != TRIM(recipient_name) 
   OR delivery_zone != TRIM(delivery_zone) 
   OR status_log_clean != TRIM(status_log_clean);
--Validating categories
SELECT DISTINCT carrier
FROM ec_datamart.clean_shipping_logs;

SELECT DISTINCT status_log_clean
FROM ec_datamart.clean_shipping_logs;

SELECT DISTINCT delivery_zone 
FROM ec_datamart.clean_shipping_logs;

--Validating the dates

SELECT *
FROM ec_datamart.clean_shipping_logs
WHERE dispatch_timestamp>delivery_timestamp;
--Checking total cost
SELECT shipment_id, shipping_cost, fuel_surcharge, total_shipping_cost
FROM ec_datamart.clean_shipping_logs
WHERE (shipping_cost + fuel_surcharge) != total_shipping_cost;
--Checking for invalid negative values
SELECT shipment_id, package_length_in, package_width_in, shipping_cost, total_shipping_cost
FROM ec_datamart.clean_shipping_logs
WHERE package_length_in <= 0 
   OR package_width_in <= 0 
   OR shipping_cost < 0 
   OR total_shipping_cost < 0;

--==================================--
--ec_datamart.clean_website_events;
--Checking for duplicates

SELECT event_id,COUNT(*)
FROM ec_datamart.clean_website_events
GROUP  BY  event_id
HAVING COUNT(*)>1;

--Checking for nulls
SELECT event_id, session_id, visitor_id, cust_id, event_timestamp, new_product_id, load_time_ms, error_codes
FROM ec_datamart.clean_website_events
WHERE event_id IS NULL 
   OR session_id IS NULL 
   OR visitor_id IS NULL 
   OR cust_id IS NULL 
   OR event_timestamp IS NULL 
   OR load_time_ms IS NULL 
   OR error_codes IS NULL;

   SELECT event_type, traffic_source, device_type, os, browser, ip_address, geo_country, geo_city
FROM ec_datamart.clean_website_events
WHERE event_type IS NULL 
   OR traffic_source IS NULL 
   OR device_type IS NULL 
   OR os IS NULL 
   OR browser IS NULL 
   OR ip_address IS NULL 
   OR geo_country IS NULL 
   OR geo_city IS NULL;

   -- Checking for invalid leading/trailing spaces in string columns
SELECT event_id, event_type, traffic_source, device_type, os, browser, ip_address, geo_country, geo_city
FROM ec_datamart.clean_website_events
WHERE event_type != TRIM(event_type) 
   OR traffic_source != TRIM(traffic_source) 
   OR device_type != TRIM(device_type) 
   OR os != TRIM(os) 
   OR browser != TRIM(browser) 
   OR ip_address != TRIM(ip_address) 
   OR geo_country != TRIM(geo_country) 
   OR geo_city != TRIM(geo_city);

   ---- Validating event_type

   SELECT DISTINCT event_type 
FROM ec_datamart.clean_website_events;
-- Validating traffic sources
SELECT DISTINCT traffic_source 
FROM ec_datamart.clean_website_events;
-- Validating device types
SELECT DISTINCT device_type 
FROM ec_datamart.clean_website_events;

-- Validating operating systems
SELECT DISTINCT os 
FROM ec_datamart.clean_website_events;

-- Validating browsers
SELECT DISTINCT browser 
FROM ec_datamart.clean_website_events;

-- Validating geographic countries
SELECT DISTINCT geo_country 
FROM ec_datamart.clean_website_events;

-- Validating  error codes
SELECT DISTINCT error_codes 
FROM ec_datamart.clean_website_events;

-- Checking for invalid negative load times
SELECT event_id, load_time_ms
FROM ec_datamart.clean_website_events
WHERE load_time_ms < 0;



















