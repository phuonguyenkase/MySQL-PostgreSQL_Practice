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
