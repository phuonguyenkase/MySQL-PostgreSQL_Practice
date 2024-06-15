#Ex1:
SELECT name
FROM City
WHERE population > 120000
AND countrycode LIKE 'USA';

#Ex2:
SELECT *
FROM City
WHERE Countrycode LIKE 'JPN';

#Ex3:
SELECT City, `State`
FROM Station;

#Ex4:
SELECT Distinct City
FROM Station
WHERE CITY LIKE 'a%'
OR CITY LIKE 'e%'
OR CITY LIKE 'i%'
OR CITY LIKE 'o%'
OR CITY LIKE 'u%';

#Ex5 (tương tự):
SELECT Distinct City
FROM Station
WHERE CITY LIKE '%a'
OR CITY LIKE '%e'
OR CITY LIKE '%i'
OR CITY LIKE '%o'
OR CITY LIKE '%u';

#Ex6:
SELECT Distinct City
FROM Station
WHERE CITY NOT LIKE 'a%'
AND CITY NOT LIKE 'e%'
AND CITY NOT LIKE 'i%'
AND CITY NOT LIKE 'o%'
AND CITY NOT LIKE 'u%';

#Ex7:
SELECT name
FROM Employee
ORDER BY name;

#Ex8:
Select name
FROM Employee
WHERE salary > 2000
AND months < 10
ORDER BY employee_id;

#Ex9:
SELECT product_id
FROM Products
WHERE low_fats = 'Y' AND recyclable = 'Y';

#Ex10:
SELECT name
FROM Customer
WHERE referee_id IS NULL OR referee_id != 2;

#Ex11:
SELECT name, population, `area`
FROM World
WHERE population >= 25000000 OR `area` >= 3000000;

#Ex12:
SELECT distinct(author_id) AS id
FROM Views
WHERE author_id = viewer_id
ORDER BY author_id;

#Ex13:
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;

#Ex14:
SELECT * 
FROM lyft_drivers
WHERE yearly_salary <= 30000
OR yearly_salary >= 70000;

#Ex15:
SELECT * 
FROM uber_advertising
WHERE money_spent > 100000
AND year = 2019;

