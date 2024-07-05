ALTER TABLE online_retail
ALTER COLUMN quantity TYPE integer USING (TRIM(quantity)::integer),
ALTER COLUMN invoicedate TYPE TIMESTAMP USING TO_TIMESTAMP(invoicedate, 'MM/DD/YYYY HH24:MI'),
ALTER COLUMN unitprice TYPE numeric USING(TRIM(unitprice)::numeric);

#Lọc dữ liệu:
WITH check_source AS (
SELECT *
FROM online_retail
WHERE customerid <> ' '
AND quantity > 0 
AND unitprice > 0),
online_retail_new AS (
SELECT * FROM (SELECT *,
ROW_NUMBER() OVER(PARTITION BY invoiceno, stockcode, quantity ORDER BY invoicedate) as ranking
FROM check_source) AS check_duplicate
WHERE ranking = 1)

#Xóa dữ liệu:
WITH check_dup AS (
SELECT invoiceno, stockcode, quantity,
ROW_NUMBER() OVER(PARTITION BY invoiceno, stockcode, quantity ORDER BY invoicedate) AS stt
FROM online_retail)
  
DELETE FROM online_retail
WHERE TRIM(customerid) = ''
   OR quantity <= 0
   OR unitprice <= 0
   OR (invoiceno, stockcode, quantity) IN (
SELECT invoiceno, stockcode, quantity
FROM check_dup
WHERE stt > 1);

#Analyze:
WITH online_retail_index AS (
SELECT customerid, amount, invoicedate, 
TO_CHAR(first_purchase_date, 'yyyy-mm') AS cohort_date,
(EXTRACT('YEAR' FROM invoicedate) - EXTRACT('YEAR' FROM first_purchase_date)) * 12
+ (EXTRACT('MONTH' FROM invoicedate) - EXTRACT('MONTH' FROM first_purchase_date)) + 1 AS index
FROM (SELECT customerid, unitprice * quantity AS amount,
MIN(invoicedate) OVER (PARTITION BY customerid) AS first_purchase_date,
invoicedate
FROM online_retail1) AS A)

SELECT cohort_date, index, COUNT(DISTINCT customerid) AS cnt, SUM(amount) AS revenue
FROM online_retail_index
GROUP BY cohort_date, index; #From this we will use excel to visualize

#Build Pivot Table
WITH xxx AS (
    SELECT cohort_date, index, COUNT(DISTINCT customerid) AS cnt,
           SUM(amount) AS revenue
    FROM online_retail_index
    GROUP BY cohort_date, index
) #Kết hợp dòng này với cái trên thành 1 CTE chung
SELECT cohort_date,
       SUM(CASE WHEN index = 1 THEN cnt ELSE 0 END) AS "1",
       SUM(CASE WHEN index = 2 THEN cnt ELSE 0 END) AS "2",
       SUM(CASE WHEN index = 3 THEN cnt ELSE 0 END) AS "3",
       SUM(CASE WHEN index = 4 THEN cnt ELSE 0 END) AS "4",
       SUM(CASE WHEN index = 5 THEN cnt ELSE 0 END) AS "5",
       SUM(CASE WHEN index = 6 THEN cnt ELSE 0 END) AS "6",
       SUM(CASE WHEN index = 7 THEN cnt ELSE 0 END) AS "7",
       SUM(CASE WHEN index = 8 THEN cnt ELSE 0 END) AS "8",
       SUM(CASE WHEN index = 9 THEN cnt ELSE 0 END) AS "9",
       SUM(CASE WHEN index = 10 THEN cnt ELSE 0 END) AS "10",
       SUM(CASE WHEN index = 11 THEN cnt ELSE 0 END) AS "11",
       SUM(CASE WHEN index = 12 THEN cnt ELSE 0 END) AS "12",
       SUM(CASE WHEN index = 13 THEN cnt ELSE 0 END) AS "13"
FROM xxx
GROUP BY cohort_date; #Bỏ đống này vô CTE tiếp

#Calculate the retention,... (Thì dùng cái CTE kia lấy 2/1, 3/1,...)
