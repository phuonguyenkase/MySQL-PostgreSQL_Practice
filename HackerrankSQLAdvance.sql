#Ex1:
WITH trans_quart AS (
SELECT algorithm, SUM(volume) AS volume, Quarter(dt) AS quarters
FROM coins C
JOIN transactions T
    ON C.code = T.coin_code
WHERE YEAR(dt) = 2020
GROUP BY algorithm, Quarter(dt))

SELECT 
    c.algorithm, Q1.volume AS transactions_Q1,
    Q2.volume AS transactions_Q2,
    Q3.volume AS transactions_Q3,
    Q4.volume AS transactions_Q4
FROM coins C
LEFT JOIN trans_quart Q1
    ON C.algorithm = Q1.algorithm
    AND Q1.quarters = 1
LEFT JOIN trans_quart Q2
    ON C.algorithm = Q2.algorithm
    AND Q2.quarters = 2
LEFT JOIN trans_quart Q3
    ON C.algorithm = Q3.algorithm
    AND Q3.quarters = 3
LEFT JOIN trans_quart Q4
    ON C.algorithm = Q4.algorithm
    AND Q4.quarters = 4
WHERE C.code != 'DOGE'
ORDER BY c.algorithm;

#Ex2:
WITH prepare_CTE AS (
SELECT 
    emp_id,
    `timestamp` AS end_day,
    LAG(`timestamp`) OVER (PARTITION BY emp_id ORDER BY `timestamp`) AS start_day
FROM attendance
WHERE DAYOFWEEK(`timestamp`) IN (1,7)
ORDER BY emp_id, `timestamp`)

SELECT emp_id,
    SUM(TIMESTAMPDIFF(HOUR, start_day, end_day)) AS work_hours
FROM prepare_CTE
WHERE DAYOFWEEK(start_day) = DAYOFWEEK(end_day)
GROUP BY emp_id;
