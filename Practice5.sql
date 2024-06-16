#Ex1:
SELECT y.continent, FLOOR(AVG(c.population))
FROM Country as y
INNER JOIN City as c
    ON c.CountryCode = y.Code
GROUP BY y.continent;

#Ex2:
SELECT
ROUND(CAST(SUM(CASE WHEN t.signup_action = 'Confirmed' THEN 1 else 0 END) AS decimal)/COUNT(DISTINCT t.*),2) AS confirm_rate
FROM emails AS e
INNER JOIN texts AS t
  ON e.email_id = t.email_id;

#Ex3:
SELECT A2.age_bucket,
ROUND(SUM(CASE WHEN A1.activity_type = 'send' THEN A1.time_spent ELSE 0 END)/SUM(A1.time_spent) * 100, 2) AS send_pct,
ROUND(SUM(CASE WHEN A1.activity_type = 'open' THEN A1.time_spent ELSE 0 END)/SUM(A1.time_spent) * 100, 2) AS open_pct #CASE WHEN must be in SUM
FROM activities A1
JOIN age_breakdown A2
  ON A1.user_id = A2.user_id
WHERE A1.activity_type IN ('open', 'send')
GROUP BY A2.age_bucket;

#Ex4:
SELECT c.customer_id
FROM customer_contracts AS c
JOIN products AS p
  ON c.product_id = p.product_id
GROUP BY c.customer_id
HAVING COUNT(distinct p.product_category) = 3;

#Ex5:
SELECT Emp1.employee_id, Emp1.name, 
COUNT(Emp2.reports_to) as reports_count, 
ROUND(AVG(Emp2.age)) as average_age
FROM Employees Emp1
JOIN Employees Emp2
    ON Emp1.employee_id = Emp2.reports_to
GROUP BY Emp1.employee_id, Emp1.name
ORDER BY Emp1.employee_id;

#Ex6:
SELECT Pro.product_name, SUM(Ord.unit) AS unit
FROM Products as Pro
JOIN Orders as Ord
    ON Pro.product_id = Ord.product_id
    AND MONTH(order_date) = 2 
    AND YEAR(order_date) = 2020
GROUP BY Pro.product_name
HAVING SUM(Ord.unit) >= 100;

#Ex7:
SELECT pages.page_id AS page_id
FROM pages
LEFT JOIN page_likes AS likes
  ON pages.page_id = likes.page_id
WHERE likes.page_id IS NULL;
