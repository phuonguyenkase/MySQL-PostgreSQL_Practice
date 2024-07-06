#1: Số lượng đơn hàng và số lượng khách hàng mỗi tháng
SELECT FORMAT_TIMESTAMP('%Y-%m', ord.created_at) AS formatted_date, COUNT(ord.user_id) AS total_user, 
COUNT(ord_it.order_id) total_orde
FROM bigquery-public-data.thelook_ecommerce.order_items AS ord_it
JOIN bigquery-public-data.thelook_ecommerce.orders AS ord
ON ord_it.order_id = ord.order_id
WHERE ord_it.status = 'Complete'
GROUP BY formatted_date
ORDER  BY formatted_date;

Insight: The total number of users and orders generally increased over time, with a notable decline in February 2023, followed by a rebound in the subsequent month

#2: Giá trị đơn hàng trung bình (AOV) và số lượng khách hàng mỗi tháng
SELECT FORMAT_TIMESTAMP('%Y-%m', ord.created_at) AS formatted_date, COUNT(DISTINCT ord.user_id) AS distinct_users, 
ROUND(SUM(ord_it.sale_price)/COUNT(ord.order_id),2) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items AS ord_it
JOIN bigquery-public-data.thelook_ecommerce.orders AS ord
ON ord_it.order_id = ord.order_id
GROUP BY formatted_date
ORDER  BY formatted_date;

Insight: Overall, the average order value remained stable over time. In contrast, the number of distinct users per month showed a significant increase, rising dramatically 
from 0.04k to 7.69k by June 2024. This indicates a substantial growth in user engagement despite the steady average order value.

#3: Nhóm khách hàng theo độ tuổi:
WITH RankedUsers AS (
  SELECT first_name, last_name, gender, age,
         RANK() OVER (PARTITION BY gender ORDER BY age ASC) as rank_asc,
         RANK() OVER (PARTITION BY gender ORDER BY age DESC) as rank_desc
  FROM bigquery-public-data.thelook_ecommerce.users
), 
Result AS (
SELECT first_name, last_name, gender, age, 'youngest' AS tag
FROM RankedUsers
WHERE rank_asc = 1

UNION ALL

SELECT first_name, last_name, gender, age, 'oldest' AS tag
FROM RankedUsers
WHERE rank_desc = 1)

SELECT gender, tag, COUNT(tag) AS total_from_each_group
FROM Result
GROUP BY gender, tag
ORDER BY tag;

Insight:
+ Youngest: Male: 817, Female: 873
+ Oldest: Male: 876, Female: 862

#4: Top 5 sản phẩm mỗi tháng
WITH prepare_source AS (SELECT 
  FORMAT_TIMESTAMP('%Y-%m', ord_it.created_at) AS month_year, 
  ord_it.product_id, 
  pro.name as product_name,
  ord_it.sale_price AS sales,
  pro.cost,
  ord_it.sale_price - pro.cost AS profit,
  DENSE_RANK() OVER (PARTITION BY EXTRACT(MONTH FROM ord_it.created_at), EXTRACT(YEAR FROM ord_it.created_at) ORDER BY ord_it.sale_price - pro.cost DESC) AS rank_per_month
FROM bigquery-public-data.thelook_ecommerce.order_items ord_it
JOIN bigquery-public-data.thelook_ecommerce.products pro
ON ord_it.ID = pro.ID)

SELECT *
FROM prepare_source
WHERE rank_per_month <= 5
ORDER BY month_year, rank_per_month;

#5: Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
WITH sample AS (SELECT 
  FORMAT_TIMESTAMP('%Y-%m', ord_it.created_at) AS month_year,
  pro.category AS product_categories,
  SUM(ord_it.sale_price) AS revenue
FROM bigquery-public-data.thelook_ecommerce.order_items ord_it
JOIN bigquery-public-data.thelook_ecommerce.products pro
ON ord_it.ID = pro.ID
GROUP BY pro.category, FORMAT_TIMESTAMP('%Y-%m', ord_it.created_at))

SELECT *
FROM sample; #Em ko biết làm 3 năm gần đây nhất ạ
