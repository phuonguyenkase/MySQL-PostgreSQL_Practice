#Ex1:
WITH job_count_CTE AS
(SELECT company_id, title, description, COUNT(job_id) AS job_count
FROM job_listings
GROUP BY company_id, title, description) #Tạo thêm 1 bảng để count thêm phẩn job_id

SELECT COUNT(distinct company_id) AS duplicate_companies
FROM job_count_cte
WHERE job_count > 1;

#Ex2:
WITH appliance AS
(SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT (YEAR FROM transaction_date) = 2022
AND category = 'appliance'
GROUP BY category, product
ORDER BY total_spend DESC
LIMIT 2),
electronics AS
(SELECT category, product, SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT (YEAR FROM transaction_date) = 2022
AND category = 'electronics'
GROUP BY category, product
ORDER BY total_spend DESC 
LIMIT 2)

SELECT * FROM appliance
UNION ALL
SELECT * FROM electronics
ORDER BY category, total_spend DESC;
