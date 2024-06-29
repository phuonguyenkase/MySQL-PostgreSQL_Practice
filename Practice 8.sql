#Ex1:
WITH diff AS (SELECT
CASE WHEN TIMESTAMPDIFF(DAY, order_date, customer_pref_delivery_date) = 0 THEN 'immediate'
ELSE 'scheduled' END AS Type_delivery,
RANK() OVER (PARTITION BY customer_id ORDER BY order_date) as ranking
FROM Delivery)

SELECT ROUND(100*COUNT(type_delivery)/(SELECT COUNT(type_delivery) FROM diff WHERE ranking = 1),2) as immediate_percentage
FROM diff
WHERE ranking = 1
AND type_delivery = 'immediate';

#Ex2:
WITH day_diff AS (
SELECT player_id, event_date,
LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS prev_date,
ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS ranking
FROM Activity)

SELECT ROUND(COUNT(DISTINCT player_id) / (SELECT COUNT(DISTINCT player_id) FROM Activity), 2) AS fraction
FROM day_diff
WHERE DATEDIFF(prev_date, event_date) = 1
AND ranking = 1;

#Ex3:
SELECT id,
CASE WHEN ID in (SELECT MAX(id)FROM Seat) AND ID % 2 = 1 THEN student
WHEN id % 2 = 1 THEN LEAD(student) OVER (ORDER BY id)
WHEN id % 2 = 0 THEN LAG(student) OVER (ORDER BY id)
END AS student
FROM Seat;
#Ex4:
WITH CTE as (SELECT customer_id, visited_on, SUM(amount) as amount
FROM customer
GROUP BY visited_on
ORDER BY visited_on),
total as (SELECT customer_id, DATE_ADD(visited_on, INTERVAL 6 DAY) AS visited_on,
SUM(amount) OVER(ORDER BY visited_on ROWS BETWEEN CURRENT ROW AND 6 FOLLOWING) AS amount,
RANK() OVER (PARTITION BY customer_id ORDER BY visited_on) AS ranking
FROM CTE)

SELECT visited_on, amount, ROUND(amount/7,2) as average_amount
FROM total
WHERE ranking = 1 AND visited_on <= (SELECT MAX(visited_on) FROM customer)
ORDER BY visited_on;

#Ex5: 
SELECT ROUND(SUM(TIV_2016),2) AS TIV_2016
FROM (SELECT *,
COUNT(*) OVER(PARTITION BY TIV_2015) AS CNT1,
COUNT(*) OVER(PARTITION BY LAT, LON) AS CNT2
FROM INSURANCE
) AS TBL
WHERE CNT1 >= 2 AND CNT2 = 1;

#Ex6:
WITH note AS 
(SELECT D.name AS department, Emp.name AS employee, Emp.salary AS salary,
DENSE_RANK() OVER (PARTITION BY D.name ORDER BY Emp.Salary DESC) AS ranking
FROM Employee Emp
LEFT JOIN Department D
    ON Emp.departmentId = D.id)

SELECT department, employee, salary
FROM note
WHERE ranking <= 3;

#Ex7:
WITH sum_weight AS (
SELECT Turn, person_name,
SUM(Weight) OVER (ORDER BY Turn) AS Total_weight
FROM Queue)

SELECT person_name
FROM sum_weight
WHERE Total_weight <= 1000
AND Turn = (SELECT MAX(Turn) FROM sum_weight WHERE Total_weight <= 1000);

#Ex8:
WITH a AS
(SELECT product_id, new_price as price, change_date,
RANK() OVER (PARTITION BY product_id ORDER BY change_date DESC) as ranking
FROM products
WHERE change_date <= '2019-08-16')

SELECT product_id, price
FROM a
WHERE ranking = 1
UNION
SELECT product_id, COALESCE(null,10) AS price
FROM Products
WHERE product_id NOT IN (SELECT product_id FROM Products WHERE change_date <= '2019-08-16');
