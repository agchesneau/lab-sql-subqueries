USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory_id) AS number_of_copies FROM inventory
WHERE film_id IN (
	SELECT film_id FROM film
    WHERE title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average of all the films.
SELECT title FROM film
WHERE length > 
	(SELECT AVG(length) FROM film);
    
-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name FROM actor
WHERE actorrental_id IN(
	SELECT actor_id FROM film_actor
	WHERE film_id IN (
        SELECT film_id from film
        WHERE title ='Alone Trip'));

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT title FROM film
WHERE film_id IN(
SELECT film_id FROM film_category
WHERE category_id IN(
SELECT category_id FROM category
WHERE name = 'Family'));

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join,
-- you will have to identify the correct tables with their primary keys and foreign keys,
-- that will help you get the relevant information.
SELECT first_name, last_name, email FROM customer
WHERE address_id IN(
	SELECT address_id FROM address
    WHERE city_id IN(
		SELECT city_id FROM city
        WHERE country_id IN(
			SELECT country_id FROM country
            WHERE country = 'Canada')));
            
select first_name, last_name, email FROM customer
JOIN address USING (address_id)
JOIN city USING (city_id)
JOIN country USING (country_id)
WHERE country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted
-- in the most number of films. First you will have to find the most prolific actor and then use that actor_id to
-- find the different films that he/she starred.
USE sakila;

select title from film
where film_id in(
select film_id from film
where film_id in(select film_id from film_actor
where actor_id=(
select actor_id from(
select actor_id, count(film_id) from film_actor
group by actor_id
order by count(film_id) desc
limit 1) as sub1)));


-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made
-- the largest sum of payments
select title from film
where film_id in(
select film_id from inventory
where inventory_id in(select inventory_id from rental
where customer_id=(
select customer_id from(
select customer_id, sum(amount) from payment
group by customer_id
order by sum(amount) desc
limit 1) as sub1)));





-- 8. Customers who spent more than the average payments.
SELECT first_name, last_name from customer
where customer_id in(
select customer_id from payment
where amount>(
	select avg(amount) from payment));
