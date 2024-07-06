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

Insight: Overall, average_order_value remain stability over time. In contrast, the amount of distinct users in each month tend to increase significantly (from 0.04k to 7.69k in 2024-06)
