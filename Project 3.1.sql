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
