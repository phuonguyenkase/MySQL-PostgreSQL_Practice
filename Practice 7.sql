#Ex1:
WITH a AS(
SELECT EXTRACT(YEAR FROM transaction_date), product_id, spend as curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id) as prev_year_spend
FROM user_transactions)

SELECT *, ROUND(100*(curr_year_spend - prev_year_spend)/prev_year_spend, 2)
FROM a;

#Ex2:
WITH ranking as (
SELECT card_name, issued_amount,
RANK() OVER (PARTITION BY card_name ORDER BY issue_year, issue_month) as rnk
FROM monthly_cards_issued)

SELECT card_name, issued_amount
FROM ranking
WHERE rnk = 1
ORDER BY issued_amount DESC;

#Ex3:
WITH ranking AS (
SELECT *,
RANK() OVER (PARTITION BY user_id ORDER BY transaction_date) as rnk
FROM transactions)

SELECT user_id, spend, transaction_date
FROM ranking
WHERE rnk = 3;

#Ex4:
WITH ranking as(
SELECT transaction_date, user_id,
COUNT(spend) OVER (PARTITION BY user_id,transaction_date) as purchase_count,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) as rnk
FROM user_transactions)

SELECT transaction_date, user_id, purchase_count
FROM ranking
WHERE rnk = 1
ORDER BY transaction_date;

#Ex5:
SELECT user_id, tweet_date,
ROUND(AVG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) #Defines the window frame to include the current row and the two rows before it.
  ,2) AS rolling_avg_3d 
FROM tweets;

#Ex6:
WITH prepare as(
SELECT transaction_timestamp,
EXTRACT(MINUTE FROM (transaction_timestamp - LAG(transaction_timestamp) OVER 
(PARTITION BY merchant_id, credit_card_id, amount ORDER BY transaction_timestamp))) AS time_difference
FROM transactions)

SELECT COUNT(time_difference) as payment_count
FROM prepare
WHERE time_difference < 10;

#Ex7:
WITH ranking as(
SELECT category, product, 
SUM(spend) AS total_spend,
RANK() OVER (PARTITION BY category ORDER BY SUM(spend) DESC) AS rnk 
FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product)

SELECT category, product, total_spend
FROM ranking
WHERE rnk <= 2
ORDER BY category, rnk;

#Ex8:
