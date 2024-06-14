#Ex1:
SELECT name
FROM Students
WHERE Marks > 75
ORDER BY RIGHT(name,3), ID;

#Ex2:
SELECT user_id, CONCAT(UPPER(Left(name,1)), 
LOWER(substr(name,2))) AS name
FROM Users
ORDER BY user_id;

#Ex3:
SELECT manufacturer, 
CONCAT('$', ROUND(SUM(total_sales) / 1000000), ' ', 'million') as sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer;

#Ex4:
SELECT EXTRACT(MONTH from submit_date) AS mth, product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY product_id, EXTRACT(month from submit_date)
ORDER BY mth, product_id;

#Ex5:
SELECT sender_id, COUNT(message_id) AS message_count
FROM messages
WHERE TO_CHAR(sent_date, 'FMMonth YYYY') = 'August 2022' #NOTICE THIS!!!
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

#Ex6:
Select tweet_id
From Tweets
Where LENGTH(content) > 15;

#Ex7:
SELECT activity_date AS day, COUNT(Distinct user_id) AS active_users
FROM Activity
WHERE DATEDIFF('2019-07-27', activity_date) BETWEEN 0 AND 29
GROUP BY day;

#Ex8:
SELECT COUNT(employee_id) as num_emp
FROM employees
WHERE EXTRACT(Month FROM joining_date) BETWEEN 1 and 7
AND EXTRACT(Year FROM joining_date) = 2022;

#Ex9:
Select Position('a' in first_name) AS position
From worker
WHERE first_name = 'Amitah';

#Ex10:
SELECT substr(title, length(winery)+2,4)
From winemag_pt2
WHERE country = 'Macedonia'
