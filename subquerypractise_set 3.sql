-- QUESTION NO 1
-- Display all customer details who have made more than 5 payments.
-- SOLUTION:
-- This query joins the Customer and Payment tables, groups records by customer,
-- counts the total number of payments made by each customer, and returns only
-- those customers who have made more than 5 payments using the HAVING clause.
SELECT
    c.*,
    COUNT(p.payment_id) AS total_payments
FROM customer c
JOIN payment p
    ON c.customer_id = p.customer_id
GROUP BY c.customer_id
HAVING COUNT(p.payment_id) > 5
ORDER BY total_payments DESC;

-- QUESTION NO 2
-- Find the names of actors who have acted in more than 10 films.
-- SOLUTION
-- This query joins the Actor and Film_Actor tables, counts the number of films
-- each actor has appeared in, groups the results by actor, and returns actors
-- who have acted in more than 10 films using the HAVING clause.
SELECT
	a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) AS total_films
FROM actor a
JOIN film_actor fa
ON a.actor_id = fa.actor_id
GROUP BY
	a.actor_id,
    a.first_name,
    a.last_name
HAVING COUNT(fa.film_id)>10
ORDER BY total_films DESC;

-- QUESTION NO 3
-- Find the names of customers who never made a payment.
-- SOLUTION
-- This query uses a LEFT JOIN to include all customers and checks for NULL values
-- in the Payment table to identify customers who have never made a payment.
SELECT
	c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
LEFT JOIN payment p
ON c.customer_id = p.customer_id
WHERE p.payment_id IS NULL;

-- SOLVING WITH NOT EXISTS
SELECT
	c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
WHERE NOT EXISTS
(
	SELECT 1
    FROM PAYMENT p
    WHERE p.customer_id = c.customer_id
);

-- QUESTION NO 4
-- List all films whose rental rate is higher than the average rental rate of all films.
-- SOLUTION
-- This query uses a subquery to calculate the average rental rate of all films
-- and returns only those films whose rental rate is greater than the calculated average.
SELECT
	film_id,
    title,
    rental_rate
FROM film
WHERE rental_rate >
(
	SELECT AVG(rental_rate)
    FROM film
)
ORDER BY rental_rate DESC;

-- QUESTION NO 5
-- List the titles of films that were never rented.
-- SOLUTION
-- This query checks for films that do not have any associated rental records by
-- traversing the Film, Inventory, and Rental tables, returning only films that
-- have never been rented.
SELECT
	f.film_id,
    f.title
FROM film f
WHERE NOT EXISTS
(
	SELECT 1
    FROM inventory i
    JOIN rental r
     ON i.inventory_id = r.inventory_id
	WHERE i.film_id = f.film_id
)
ORDER BY f.title;

-- SOLVING USING LEFT JOIN 
SELECT
	f.film_id,
    f.title
FROM film f
LEFT JOIN inventory i
	ON f.film_id = i.film_id
LEFT JOIN rental r
	ON r.inventory_id = i.inventory_id
GROUP BY
	f.film_id,
    f.title
HAVING COUNT(r.rental_id)=0
ORDER BY f.title;

-- QUESTION 6
-- Display the customers who rented films in the same month as customer with ID 5
-- SOLUTION
-- This query first identifies the rental month(s) of Customer ID 5 using a subquery.
-- It then returns all other customers who rented films during the same month(s).
SELECT DISTINCT
	c.customer_id,
    c.first_name,
    c.last_name
FROM customer c
JOIN rental r
 ON c.customer_id = r.customer_id
WHERE (YEAR(r.rental_date),MONTH(r.rental_date)) IN
(
	SELECT
		YEAR(rs.rental_date),
        MONTH(rs.rental_date)
	FROM rental rs
    WHERE rs.customer_id = 5
)
AND c.customer_id <>5
ORDER BY
	c.last_name,
    c.first_name;

-- QUESTION NO 7
-- Find all staff members who handled a payment greater than the average payment amount.
-- SOLUTION
-- This query calculates the average payment amount using a subquery and returns
-- staff members who processed payments greater than the overall average.
SELECT DISTINCT
	s.staff_id,
    s.first_name,
    s.last_name
FROM staff s
JOIN payment p
	ON s.staff_id = p.staff_id
WHERE p.amount >
(
	SELECT AVG(AMOUNT)
    FROM payment
)
ORDER BY s.staff_id;

-- IN SAME QUESTION(Q7), I WANT TO KNOW WHATS THE AVG AMOUNT AND HOW MUCH EACH STAFF MEMBER IS USED
-- HERE IVE USED CTE
WITH AvgPayment AS
(
    SELECT AVG(amount) AS avg_amount
    FROM payment
)

SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    p.payment_id,
    p.amount AS actual_payment,
    ap.avg_amount AS average_payment
FROM staff s
JOIN payment p
    ON s.staff_id = p.staff_id
CROSS JOIN AvgPayment ap
WHERE p.amount > ap.avg_amount
ORDER BY p.amount DESC;

-- TO SEE THE PAYMENTS OF STAFF MEMBERS
SELECT
    s.staff_id,
    s.first_name,
    s.last_name,
    p.payment_id,
    p.amount,
    p.payment_date
FROM staff s
JOIN payment p
    ON s.staff_id = p.staff_id
WHERE p.amount >
(
    SELECT AVG(amount)
    FROM payment
)
ORDER BY p.amount DESC;

-- QUESTION NO 8
-- Show the title and rental duration of films whose rental duration is greater than the average.
-- SOLUTION
-- This query calculates the average rental duration of all films and returns
-- films whose rental duration is greater than the average rental duration.
SELECT
	film_id,
    title,
    rental_duration
FROM film
WHERE rental_duration >
(
	SELECT AVG(rental_duration)
    FROM film
)
ORDER BY rental_duration DESC;

-- I WANT TO SEE THE RENTAL DURATION AVERAGE
-- This query uses a Common Table Expression (CTE) to calculate
-- the average rental duration only once. The CTE is then
-- CROSS JOINED with the Film table to make the average rental
-- duration available for every film record. Finally, the query
-- filters and returns only those films whose rental duration
-- exceeds the overall average, displaying both the actual and
-- average rental durations for comparison.
WITH Avgrentalduration AS
(
	SELECT AVG(rental_duration) AS avg_rental_duration
    FROM film
)
SELECT
	f.film_id,
    f.title,
    f.rental_duration AS actual_rental_duration,
    ard.avg_rental_duration
FROM film f
CROSS JOIN Avgrentalduration ard
WHERE f.rental_duration > ard.avg_rental_duration
ORDER BY f.rental_duration DESC;
    
-- QUESTION NO 9
-- Find all customers who have the same address as customer with ID 1.
-- SOLUTION
-- This query retrieves the address of Customer ID 1 using a subquery and returns
-- all other customers who share the same address.
SELECT
	customer_id,
    first_name,
    last_name,
    address_id
FROM customer
WHERE address_id =
(
	SELECT address_id
    FROM customer
    WHERE customer_id = 1
)
AND customer_id <> 1;

-- QUESTION NO 10
-- List all payments that are greater than the average of all payments.
-- SOLUTION
-- This query calculates the average payment amount using a subquery and returns
-- all payment records whose payment amount is greater than the overall average.
SELECT 
	p.payment_id,
    c.customer_id,
    c.first_name,
    c.last_name,
    p.amount,
    p.payment_date
FROM customer c
JOIN payment p
	ON c.customer_id = p.payment_id
WHERE p.amount >
(
	SELECT AVG(amount)
    FROM payment
)
ORDER BY p.amount DESC;
    