#Ex1:
SELECT Distinct City
FROM Station
WHERE ID % 2 = 0;

#Ex2:
SELECT COUNT(City) - COUNT(Distinct City)
From Station;

#Ex3:
SELECT CEILING(AVG(SALARY) - AVG(REPLACE(SALARY,'0', ' ')))
FROM Employees;

#Ex4:
SELECT ROUND(SUM(item_count::DECIMAL*order_occurrences)/sum(order_occurrences),1) as mean
FROM items_per_order; #Phải chuyển inter thành decimal trước đã

#Ex5:
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python','Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill) = 3;

#Ex6:
SELECT user_id, 
MAX(DATE(post_date)) - MIN(DATE(post_date)) as days_between #MySQL thì DATEDIFF(datepart, startdate, enddate) vs datepart = day, month, year
FROM posts
WHERE DATE_PART('year',post_date) = 2021 #MySQL mới support YEAR(post_date) còn postgreSQL thì EXTRACT(YEAR FROM post_date)
GROUP BY user_id
HAVING COUNT(post_id) >= 2;

#Ex7:
SELECT card_name, MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

#Ex8:
SELECT manufacturer, COUNT(drug) AS drug_count, 
ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales - cogs <= 0
GROUP BY manufacturer
ORDER BY drug_count DESC, total_loss DESC;

#Ex9:
SELECT *
FROM Cinema
WHERE id %2 != 0
AND description != 'boring'
ORDER BY rating DESC;

#Ex10:
SELECT teacher_id, COUNT(distinct subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id;

#Ex11:
SELECT user_id, COUNT(follower_id) as followers_count
FROM Followers
GROUP BY user_id
ORDER BY user_id;

#Ex12:
SELECT class
FROM Courses
GROUP BY class
HAVING Count(Student) >= 5;
