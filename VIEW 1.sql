DROP VIEW IF EXISTS ec_datamart.vw_executive_monthly_revenue;-- Drop the view if it already exists
GO

CREATE VIEW ec_datamart.vw_executive_monthly_revenue AS -- Create the updated view

SELECT
    DATENAME(YEAR,order_date) AS year
     ,DATENAME(MONTH,order_date) AS month
     ,YEAR(order_date) AS year_no
     ,MONTH(order_date) month_no
     ,COUNT(DISTINCT(order_number)) AS unique_orders
     ,COUNT(DISTINCT(customer_id)) as customer_no
     ,SUM(total_amount) AS total_sum
     ,AVG(total_amount) AS avg_sum
  FROM ECOMDB.ec_datamart.clean_orders
 GROUP BY
     DATENAME(YEAR,order_date) 
     ,DATENAME(MONTH,order_date)
     ,MONTH(order_date)
     ,YEAR(order_date);
     
     GO
--==================================--
 DROP VIEW IF EXISTS ec_datamart.vw_customer_360_profile;-- Drop the view if it already exists
GO

CREATE VIEW ec_datamart.vw_customer_360_profile AS -- Create the updated view



WITH CTE_ltv AS (
    SELECT 
          c.cust_id
         ,c.city
         ,SUM(o.total_amount) AS spending
         ,COUNT(o.order_id) AS no_of_orders
         ,SUM(o.total_amount) AS total_lifetime_spend
    FROM ECOMDB.ec_datamart.clean_customers AS c
    LEFT JOIN ECOMDB.ec_datamart.clean_orders AS o
        ON c.cust_id = o.customer_id
    GROUP BY c.cust_id, c.city
)
SELECT 
      cust_id
     ,city
     ,no_of_orders
     ,total_lifetime_spend
     ,CASE
          WHEN ISNULL(total_lifetime_spend, 0) < 500 THEN 'VIP'
          WHEN ISNULL(total_lifetime_spend, 0) BETWEEN 500 AND 1000 THEN 'GOLD'
          WHEN ISNULL(total_lifetime_spend, 0) BETWEEN 1000 AND 2500 THEN 'STANDARD'
          ELSE 'DIAMOND'
      END AS calculated_ltv_tier
FROM CTE_ltv;
GO
--==================================--
 DROP VIEW IF EXISTS ec_datamart.vw__shipping_carrier_kpis;-- Drop the view if it already exists
GO

CREATE VIEW ec_datamart.vw__shipping_carrier_kpis AS -- Create the updated view



SELECT
      carrier
     ,status_log_clean
     ,COUNT(shipment_id) AS total_shipments
     ,AVG(CAST(actual_days_to_deliver AS DECIMAL(10,2))) AS avg_actual_delivery_days
     ,AVG(CAST(estimated_days_to_deliver AS DECIMAL(10,2))) AS avg_estimated_delivery_days
     ,SUM(CASE WHEN actual_days_to_deliver > estimated_days_to_deliver THEN 1 ELSE 0 END) AS delayed_shipments_count
FROM ECOMDB.ec_datamart.clean_shipping_logs
GROUP BY 
      carrier
     ,status_log_clean;
GO