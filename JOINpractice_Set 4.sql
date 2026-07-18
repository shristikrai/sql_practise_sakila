-- QUESTION 1
-- List all customers along with the films they have rented.
--
-- SOLUTION
-- This query joins the customer, rental, inventory, and film
-- tables. The rental table connects customers to inventory
-- records, while the inventory table identifies the film
-- associated with each rental.
SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
    f.film_id,
    f.title,
    r.rental_date
FROM customer c
JOIN rental r
	ON c.customer_id = r.customer_id
JOIN inventory i
	ON r.inventory_id = i.inventory_id
JOIN film f
	ON i.film_id = f.film_id
ORDER BY
	c.customer_id,r.rental_date;

-- QUESTION NO 2
-- List all customers and show their total rental count,
-- including customers who have not rented any films.
-- SOLUTION
-- This query uses a LEFT JOIN to preserve every customer
-- record, even when no matching rental exists. COUNT of
-- rental_id returns zero for customers without rentals.
SELECT
	c.customer_id,
    c.first_name,
    c.last_name,
COUNT(r.rental_id) AS total_rentals
FROM customer c
LEFT JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id,c.first_name,c.last_name
ORDER BY total_rentals DESC;

-- QUESTION NO 3
-- Show all films along with their category, including films
-- that do not have a category assigned.
--
-- SOLUTION:
-- This query uses LEFT JOINs from the film table to the
-- film_category bridge table and then to the category table.
-- Films without a category remain in the result with NULL
-- displayed for their category.
SELECT
	f.film_id,
    f.title,
    c.category_id,
    c.name AS category_name
FROM film f
LEFT JOIN film_category fc
	ON f.film_id = fc.film_id
LEFT JOIN category c
	ON fc.category_id = c.category_id
ORDER BY
	f.title;
    
-- QUESTION NO 4
-- Display customer and staff email addresses from both tables
-- using a simulated FULL OUTER JOIN.
--
-- SOLUTION
-- MySQL does not support FULL OUTER JOIN directly. This query
-- simulates it by combining a LEFT JOIN and a RIGHT JOIN with
-- UNION.
-- Joined on store_id since that's the only column the two tables share.
SELECT
    c.customer_id,
    c.email AS customer_email,
    s.staff_id,
    s.email AS staff_email
FROM customer c
LEFT JOIN staff s ON c.store_id = s.store_id
UNION
SELECT
    c.customer_id,
    c.email AS customer_email,
    s.staff_id,
    s.email AS staff_email
FROM staff s
LEFT JOIN customer c ON c.store_id = s.store_id;

-- QUESTION NO 5
-- Find all actors who appeared in the film
-- "ACADEMY DINOSAUR".
--
-- SOLUTION
-- This query joins the actor table to the film_actor bridge
-- table and then to the film table. It filters the result by
-- the specified film title and returns every actor associated
-- with that film.
SELECT
	a.actor_id,
    a.first_name,
    a.last_name,
    f.title
FROM actor a
JOIN film_actor fa
	ON a.actor_id = fa.actor_id
JOIN film f
	ON fa.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR'
ORDER BY
	a.last_name,
    a.first_name;
    
-- QUESTION NO 6
-- List all stores and the total number of staff members
-- working in each store, including stores with no staff.
-- 
-- SOLUTION
-- -- This query uses a LEFT JOIN to combine the Store and Staff
-- tables, ensuring that every store is included in the result
-- even if no staff members are assigned to it. The query then
-- groups the records by store_id and counts the number of
-- staff members in each store. COUNT(st.staff_id) ignores
-- NULL values, so stores without staff are displayed with a
-- staff count of 0.
SELECT
    s.store_id,
    COUNT(st.staff_id) AS staff_count
FROM store s
LEFT JOIN staff st 
	ON s.store_id = st.store_id
GROUP BY s.store_id
ORDER BY s.store_id;

-- QUESTION NO 7
-- List customers who have rented films more than 5 times,
-- including their names and total rental count.
--
-- SOLUTION:
-- This query joins customers with their rental records,
-- groups rentals by customer, calculates each customer's
-- total rental count, and uses HAVING to return only
-- customers whose rental count is greater than 5.
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS total_rentals
FROM customer c
JOIN rental r
	ON c.customer_id = r.customer_id
GROUP BY
	c.customer_id,c.first_name,c.last_name
HAVING COUNT(r.rental_id)>5
ORDER BY total_rentals DESC;