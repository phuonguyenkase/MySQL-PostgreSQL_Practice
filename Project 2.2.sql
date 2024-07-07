#The dataset:
WITH growth AS (
SELECT ID,
  sale_price AS revenue,
  LAG(sale_price) OVER (ORDER BY FORMAT_DATE('%Y-%m',created_at)) AS previous_date,
  order_id AS num_ord,
  LAG(order_id) OVER (ORDER BY FORMAT_DATE('%Y-%m',created_at)) AS previous_numord_date
FROM bigquery-public-data.thelook_ecommerce.order_items),

sum_monthly AS (SELECT
  FORMAT_DATE('%Y-%m',ord.created_at) AS Month,
  SUM(ord_it.sale_price) AS TPV,
  SUM(ord_it.order_id) AS TPO,
  SUM(pro.cost) AS Total_cost
FROM bigquery-public-data.thelook_ecommerce.orders ord
JOIN bigquery-public-data.thelook_ecommerce.order_items ord_it
  ON ord.order_id = ord_it.order_id
JOIN bigquery-public-data.thelook_ecommerce.products pro
  ON pro.id = ord_it.id
GROUP BY Month
),

sub_CTE AS (
SELECT 
  ord_it.id,
  FORMAT_DATE('%Y-%m',ord.created_at) AS Month,
  FORMAT_DATE('%Y',ord.created_at) AS Year,
  Pro.category AS Product_category
FROM bigquery-public-data.thelook_ecommerce.orders ord
JOIN bigquery-public-data.thelook_ecommerce.order_items ord_it
  ON ord.order_id = ord_it.order_id
JOIN bigquery-public-data.thelook_ecommerce.products pro
  ON pro.id = ord_it.id)

SELECT 
  sub.Month,
  sub.Year,
  sub.Product_category,
  Sm.TPV,
  Sm.TPO,
  ROUND(100*(Gr.revenue - Gr.previous_date)/ Gr.previous_date,2)||'%' AS revenue_growth,
  ROUND(100*(Gr.num_ord - Gr.previous_numord_date)/Gr.previous_numord_date,2)||'%' AS order_growth,
  Sm.Total_cost,
  Sm.TPV - Sm.Total_cost AS Total_profit,
  ROUND(TPV - Total_cost/Total_cost,2) AS Profit_to_cost_ratio
FROM growth Gr
JOIN sub_CTE Sub
  ON Sub.id = Gr.id
JOIN sum_monthly Sm
  ON Sub.month = Sm.month
ORDER BY sub.Month;

#Retention Cohort Analysis:
WITH online_orders_index AS 
(SELECT 
  user_id, amount,
  FORMAT_DATE('%Y-%m', first_purchase_date) AS cohort_month, created_at,
  (EXTRACT(YEAR FROM created_at) - EXTRACT(YEAR FROM first_purchase_date))* 12 + (EXTRACT(MONTH FROM created_at) - EXTRACT(MONTH FROM first_purchase_date)) + 1 AS index
FROM(
SELECT 
  user_id, 
  ROUND(sale_price,2) AS amount,
  MIN(created_at) OVER (PARTITION BY user_id) AS first_purchase_date,
  created_at
FROM bigquery-public-data.thelook_ecommerce.order_items) as b),
cohort_data as (
SELECT 
  cohort_month, index, COUNT(Distinct user_id) AS cnt,
  ROUND(SUM(amount),2) AS revenue
FROM online_orders_index
GROUP BY cohort_month, index
HAVING index BETWEEN 1 AND 4
ORDER BY index),
pivottab AS (
SELECT cohort_month,
  SUM(CASE WHEN index = 1 THEN cnt ELSE 0 END) AS `1`,
  SUM(CASE WHEN index = 2 THEN cnt ELSE 0 END) AS `2`,
  SUM(CASE WHEN index = 3 THEN cnt ELSE 0 END) AS `3`,
   SUM(CASE WHEN index = 4 THEN cnt ELSE 0 END) AS `4`
FROM cohort_data
GROUP BY cohort_month
ORDER BY cohort_month)

SELECT cohort_month,
  ROUND(100*`1`/`1`,2) ||'%' AS `0`,
  ROUND(100*`2`/`1`,2) ||'%' AS `1`,
  ROUND(100*`3`/`1`,2) ||'%' AS `2`,
  ROUND(100*`4`/`1`,2) ||'%' AS `3`
FROM pivottab;

#Excel visualize and comment: https://docs.google.com/spreadsheets/d/182ax-oBOCGOwjfgPAXyL6ON6-LImy2xl/edit?usp=sharing&ouid=101441017126657552304&rtpof=true&sd=true
