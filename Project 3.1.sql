#1: Doanh thu theo từng ProductLine, Year và DealSize
SELECT productline, SUM(priceeach*quantityordered) AS revenue, year_id, dealsize
FROM sales_dataset_rfm_prj
GROUP BY productline, year_id, dealsize;

#2: Đâu là tháng có bán tốt nhất mỗi năm
WITH revenue_each_month AS (
SELECT 
	ordernumber, month_id, year_id,
	SUM(sales) OVER(PARTITION BY TO_CHAR(orderdate, 'YYYY-MM')) AS revenue
FROM sales_dataset_rfm_prj),

rank AS (
SELECT *,
	RANK() OVER(PARTITION BY year_id ORDER BY revenue DESC) AS ranking
FROM revenue_each_month)

SELECT ordernumber, month_id, year_id, revenue
FROM rank
WHERE ranking = 1;

#3: Product line nào được bán nhiều ở tháng 11?
WITH subquery AS (
SELECT month_id, year_id, productline, 
	SUM(quantityordered) AS total_order,
	RANK() OVER (ORDER BY SUM(quantityordered) DESC) as ranking
FROM sales_dataset_rfm_prj
GROUP BY month_id, year_id, productline
HAVING month_id = 11
ORDER BY total_order DESC)

SELECT month_id, year_id, productline, total_order
FROM subquery
WHERE ranking <= 2;

#4: Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm?
WITH total_sale_of_product AS (
SELECT 
	productline, country, year_id,
	SUM(sales) AS revenue, 
	RANK() OVER (PARTITION BY year_id ORDER BY SUM(sales) DESC) AS ranking
FROM sales_dataset_rfm_prj
WHERE COUNTRY = 'UK'
GROUP BY productline, country, year_id)

SELECT year_id, productline, revenue, ranking
FROM total_sale_of_product
WHERE ranking = 1;

#5: Ai là khách hàng tốt nhất, phân tích dựa vào RFM
WITH cus_rfm AS
(SELECT cus.customer_id,
	current_date - MAX(order_date) AS R,
	COUNT(Distinct order_id) AS F,
	SUM(sales) AS M
FROM customer AS cus
JOIN sales AS sal
	ON cus.customer_id = sal.customer_id
GROUP BY cus.customer_id),
	
sort_rfm AS (
SELECT customer_id,
	ntile(5) OVER (ORDER BY R DESC) AS R,
	ntile(5) OVER (ORDER BY F DESC) AS F,
	ntile(5) OVER (ORDER BY M DESC) AS M
FROM cus_rfm),
scoring AS (
SELECT customer_id,
	CAST(R as varchar)||CAST(F as varchar)||CAST(M as varchar) as score
FROM sort_rfm )

SELECT so.*, seg.segment
FROM scoring AS so
JOIN segment_score AS seg
	ON so.score = seg.scores
WHERE score = '555';
