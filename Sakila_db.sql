use sakila;
SELECT first_name, last_name FROM actor;
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name' FROM actor;

SELECT actor_id, first_name, last_name FROM actor WHERE first_name='Joe';
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';
SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name, first_name;
SELECT country_id, country FROM country WHERE country IN('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE actor ADD description BLOB;
ALTER TABLE actor DROP COLUMN description;

SELECT last_name, COUNT(*) as 'Last Name Count' FROM actor GROUP BY last_name;
SELECT last_name, COUNT(*) as 'Last Name Count' FROM actor GROUP BY last_name HAVING COUNT(*) >=2; 
UPDATE actor SET first_name = 'HARPO' WHERE first_name='GROUCHO' AND last_name='WILLIAMS';
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name='HARPO' AND last_name='WILLIAMS';

SHOW CREATE TABLE address; 

SELECT first_name, last_name, address FROM staff INNER JOIN address ON staff.address_id = address.address_id;
SELECT first_name, last_name, SUM(amount) as 'Total Amount' FROM staff INNER JOIN payment ON staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%' GROUP BY first_name, last_name;
SELECT title, COUNT(actor_id) as 'Actor Count' FROM film_actor INNER JOIN film ON film_actor.film_id = film.film_id GROUP BY title;
SELECT title, COUNT(title) as 'Copies Available' FROM film INNER JOIN inventory ON film.film_id = inventory.film_id WHERE title = 'Hunchback Impossible';
SELECT first_name, last_name, SUM(amount) as 'Total Paid by Each Customer' FROM payment INNER JOIN customer ON payment.customer_id = customer.customer_id GROUP BY first_name, last_name ORDER BY last_name; 

SELECT title
FROM film
WHERE (title LIKE 'K%' OR title LIKE 'Q%')
AND language_id IN
	(
	SELECT language_id 
	FROM language
	WHERE name ='English'
); 
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN
		(
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
		)
);
SELECT first_name, last_name, email 
FROM customer 
JOIN address 
ON (customer.address_id = address.address_id)
JOIN city 
ON (city.city_id = address.city_id)
JOIN country
ON (country.country_id = city.country_id)
WHERE country.country= 'Canada';

SELECT title 
FROM film 
WHERE film_id IN 
	(
    SELECT film_id 
	FROM film_category 
    WHERE category_id IN 
		(
		SELECT category_id 
        FROM category 
        WHERE name='Family'
        )
);

SELECT title, COUNT(rental_id) as 'Rental Count'
FROM rental 
JOIN inventory
ON (rental.inventory_id = inventory.inventory_id)
JOIN film 
ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY COUNT(rental_id) DESC;

SELECT store.store_id, SUM(amount)
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment 
ON payment.staff_id = staff.staff_id
GROUP BY store.store_id;

SELECT store_id, city, country
FROM store 
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city
ON city.city_id = address.city_id
INNER JOIN country
ON country.country_id = city.country_id;

SELECT name, SUM(amount)
FROM category 
INNER JOIN film_category 
ON category.category_id = film_category.category_id
INNER JOIN inventory 
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC LIMIT 5;

CREATE VIEW top_genres_by_revenue AS
SELECT name, SUM(amount)
FROM category 
INNER JOIN film_category 
ON category.category_id = film_category.category_id
INNER JOIN inventory 
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY name
ORDER BY SUM(amount) DESC LIMIT 5;

SELECT * FROM top_genres_by_revenue;
DROP VIEW top_genres_by_revenue;