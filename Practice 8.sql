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
