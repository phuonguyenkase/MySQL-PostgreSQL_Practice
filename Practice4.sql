#Ex1:
SELECT 
SUM(CASE
WHEN device_type = 'laptop' then 1 else 0
END) as laptop_views,
SUM(CASE
WHEN device_type != 'laptop' then 1 else 0
END) as mobile_views
FROM viewership;

#Ex2:
SELECT *, 
CASE WHEN (x+y>z and y+z>x and z+x>y)
THEN 'Yes'
Else 'No'
End as triangle
FROM Triangle;

#Ex3:
SELECT ROUND(
    CAST(SUM(CASE WHEN COALESCE(call_category, 'n/a') = 'n/a' THEN 1 ELSE 0 END) AS DECIMAL) / 
    CAST(COUNT(*) AS DECIMAL) * 100, 1) AS uncategorised_call_pct
FROM callers;

#Ex4:
SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id != 2;

#Ex5:
Select survived,
SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_clas,
SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
From titanic
GROUP BY survived;
