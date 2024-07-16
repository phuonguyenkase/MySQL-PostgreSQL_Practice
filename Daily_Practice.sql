#1: Datalemur Advertiser Status (Facebook): https://datalemur.com/questions/updated-status?utm_source=dl_drip&utm_medium=email&utm_campaign=pow-1-meta-advertiser-status
SELECT COALESCE(ADV.user_id, Dai.user_id) AS user_id,
  CASE WHEN Dai.paid IS NULL THEN 'CHURN'
  WHEN Dai.paid IS NOT NULL AND Adv.status IN ('NEW', 'EXISTING', 'RESURRECT') THEN 'EXISTING'
  WHEN Dai.paid IS NOT NULL AND Adv.status = 'CHURN' THEN 'RESURRECT'
  WHEN Dai.paid IS NOT NULL AND Adv.status IS NULL THEN 'NEW' END AS new_status
FROM advertiser Adv
FULL OUTER JOIN daily_pay Dai
  ON Adv.user_id = Dai.user_id
ORDER BY user_id;

#2: Datalemur Maximize Prime Item Inventory: https://datalemur.com/questions/prime-warehouse-storage
WITH basic_steps AS (SELECT
  item_type,
  SUM(square_footage) AS sum_square,
  COUNT(*) AS count_num
FROM inventory
GROUP BY item_type),
prime AS (SELECT item_type, sum_square,
FLOOR(500000/sum_square) AS max_prime,
(FLOOR(500000/sum_square)*count_num) AS prime_count
FROM basic_steps
WHERE item_type = 'prime_eligible')

SELECT item_type,
CASE 
  WHEN item_type = 'prime_eligible'
    THEN (SELECT prime_count FROM prime)
  WHEN item_type = 'not_prime'
     THEN FLOOR((500000 - (SELECT FLOOR(500000/sum_square) * sum_square FROM prime))/sum_square) * count_num
  END AS item_count
FROM basic_steps
ORDER BY item_type DESC;
