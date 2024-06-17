--Question 1:
SELECT DISTINCT(replacement_cost)
FROM film
ORDER BY replacement_cost
LIMIT 1;

--Question 2:
SELECT 
SUM(CASE WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 1 ELSE 0 END) AS Low,
SUM(CASE WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 1 ELSE 0 END) AS Meidum,
SUM(CASE WHEN replacement_cost BETWEEN 25.00 AND 29.99 THEN 1 ELSE 0 END) AS High
FROM film;

--Question 3:
SELECT Cat.name, F.length
FROM category Cat
JOIN film_category FCat
	ON Cat.category_id = FCat.category_id
JOIN film F
	ON FCat.film_id = F.film_id
WHERE Cat.name IN ('Drama', 'Sports')
ORDER BY F.length DESC
LIMIT 1;

--Question 4:
SELECT Cat.name, COUNT(F.title) as total_titles
FROM category Cat
JOIN film_category FCat
	ON Cat.category_id = FCat.category_id
JOIN film F
	ON FCat.film_id = F.film_id
GROUP BY Cat.name
ORDER BY total_of_each_type DESC
LIMIT 1;

--Question 5:
SELECT CONCAT(Act.first_name, ' ', Act.last_name) AS full_name, 
COUNT(F.film_id) As Sum_of_film
FROM actor Act
JOIN film_actor FAct
	ON Act.actor_id = FAct.actor_id
JOIN film F
	ON FAct.film_id = F.film_id
GROUP BY full_name
ORDER BY Sum_of_film DESC
LIMIT 1;

--Question 6:
SELECT COUNT(Addr.address_id) FILTER (WHERE Addr.address_id IS NULL) as invalid_address
FROM customer Cus
LEFT JOIN address Addr
	ON Cus.address_id = Addr.address_id;

--Question 7:
SELECT City.city, SUM(Pay.amount) as Revenue
FROM Payment Pay
JOIN Customer Cus
	ON Pay.customer_id = Cus.customer_id
JOIN Address Addr
	ON Cus.address_id = Addr.address_id
JOIN City
	ON Addr.city_id = City.city_id
GROUP BY City.city
ORDER BY Revenue DESC
LIMIT 1;

--Question 8:
SELECT CONCAT(Coun.country,',', City.city) as Country_City, 
SUM(Pay.amount) as Revenue
FROM Payment Pay
JOIN Customer Cus
	ON Pay.customer_id = Cus.customer_id
JOIN Address Addr
	ON Cus.address_id = Addr.address_id
JOIN City
	ON Addr.city_id = City.city_id
JOIN Country Coun
	ON City.country_id = Coun.country_id
GROUP BY Country_City
ORDER BY Revenue DESC
LIMIT 1;
