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
SELECT * FROM electronics;

#Ex3:
WITH a AS 
(SELECT COUNT(case_id) AS match_the_rules
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id) >= 3)

SELECT COUNT(match_the_rules) AS policy_holder_count
FROM a;

#Ex4:
SELECT page_id
FROM pages
WHERE NOT EXISTS
(SELECT page_id
FROM page_likes AS Likes
WHERE pages.page_id = Likes.page_id); #Cách dùng khác của hàm JOIN

#Ex5: Coi lại khó quãi
SELECT 
    EXTRACT(MONTH FROM current.event_date) AS month,
    COUNT(DISTINCT current.user_id) AS monthly_active_users
FROM 
    user_actions AS current
WHERE 
    current.event_type IN ('sign_in', 'like', 'comment')
    AND EXISTS
        (SELECT last.user_id
        FROM user_actions AS last
        WHERE 
            last.user_id = current.user_id
            AND EXTRACT(MONTH FROM last.event_date) = 
            EXTRACT(MONTH FROM current.event_date - interval '1 month'))
    AND TO_CHAR(current.event_date, 'MM/YYYY') = '07/2022'
GROUP BY 
    EXTRACT(MONTH FROM current.event_date);

#Ex6:
WITH a AS
(SELECT DATE_FORMAT(trans_date, '%Y-%m') AS `month`, country, COUNT(state) as approved_count, SUM(amount) as approved_total_amount 
FROM transactions
WHERE state = 'approved'
GROUP BY `month`, country)

SELECT a.`month`, a.country, COUNT(DISTINCT t.id) as trans_count, approved_count, SUM(t.amount) as trans_total_amount, approved_total_amount 
FROM Transactions t
JOIN a
	ON a.`month` = DATE_FORMAT(t.trans_date, '%Y-%m')
    AND a.country = t.country
GROUP BY a.`month`, a.country;

#Ex7:
WITH a AS
(SELECT product_id, MIN(year) as first_year
FROM Sales
GROUP BY product_id)

SELECT s.product_id, first_year, s.quantity, price
FROM Sales s
JOIN a
    ON s.product_id = a.product_id
    AND s.year = a.first_year;

#Ex8:
SELECT customer_id
FROM customer
GROUP BY customer_id
HAVING COUNT(DISTINCT product_key) = (SELECT COUNT(product_key) FROM Product);

#Ex9:
Select employee_id
FROM employees
WHERE salary < 30000
AND manager_id not in (Select employee_id from employees)
ORDER BY employee_id;

#Ex10: Em thấy nó bị lỗi bấm vào lại thành Ex1

#Ex11:
WITH name_solve AS (SELECT U.name as results
FROM users as U
JOIN MovieRating as MV
    ON U.user_id = MV.user_id
GROUP BY U.user_id, U.name
HAVING COUNT(rating) = 3
ORDER BY U.name
LIMIT 1),
highest_avg_rating AS 
(SELECT title as results
 FROM (SELECT M.movie_id, title, AVG(rating) AS avg_rating
    FROM MovieRating MR
    LEFT JOIN Movies M
       ON MR.movie_id = M.movie_id
    WHERE DATE_FORMAT(created_at, '%Y-%m') = '2020-02'
    GROUP BY movie_id, title) AS movies
ORDER BY avg_rating DESC, title
LIMIT 1)

SELECT *
FROM name_solve
UNION ALL
SELECT *
FROM highest_avg_rating;

#Ex12: #Đếm id theo group by ở từng cột accepter và requester trong CTE rồi mới SUM phía bên ngoài
WITH new AS 
((SELECT accepter_id AS id, COUNT(*) AS num 
  FROM RequestAccepted
  GROUP BY accepter_id)
UNION ALL
(SELECT requester_id AS id, COUNT(*) AS num 
 FROM RequestAccepted
 GROUP BY requester_id))

SELECT id, SUM(num) AS num 
FROM new
GROUP BY id
ORDER BY num DESC
LIMIT 1;
