-- Question 1:
-- Get all customers whose first name starts with 'J' and who are active.
SELECT *
FROM sakila.customer
WHERE first_name LIKE 'J%'
  AND active = 1;

-- Question 2:
-- Find all films where the title contains 'ACTION'
-- or the description contains 'WAR'.
SELECT *
FROM sakila.film
WHERE title LIKE '%ACTION%'
   OR description LIKE '%WAR%';

-- Question 3:
-- List all customers whose last name is not 'SMITH'
-- and whose first name ends with 'A'.
Select *
FROM sakila.customer
WHERE last_name !='SMITH'
 AND first_name like '%A';

-- Question 4:
-- Get all films where the rental rate is greater than 3.00
-- and the replacement cost is not NULL.
SELECT *
FROM sakila.film
WHERE rental_rate > 3.00
AND replacement_cost IS NOT NULL;

-- Question 5:
-- Count the number of active customers in each store.
select
    store_id,
    count(*) as active_customer_count
FROM sakila.customer
WHERE active = 1
GROUP BY store_id;

-- Question 6:
-- Display all distinct film ratings available in the film table.
select distinct rating
from sakila.film;

-- Question 7:
-- Find the number of films for each rental duration
-- where the average film length is greater than 100 minutes.
Select
    rental_duration,
    COUNT(*) as number_of_films,
    ROUND(AVG(length), 2) as average_length
FROM sakila.film
GROUP BY rental_duration
HAVING AVG(length) > 100;

-- Question 8:
-- Display each payment date, the number of payments made,
-- and the total amount paid on that date.
-- Include only dates where more than 100 payments were made.
SELECT
    DATE(payment_date) as payment_date,
    COUNT(*) as number_of_payments,
    SUM(amount) as total_amount_paid
FROM sakila.payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100
ORDER BY payment_date;

-- Question 9:
-- Find customers whose email address is NULL
-- or whose email address ends with '.org'.
select *
from sakila.customer
where email is null
or email like '%org';

-- Question 10:
-- List all films with a rating of 'PG' or 'G'
-- and order them by rental rate from highest to lowest.
select *
from sakila.film
where rating in ('PG','G')
order by rental_rate desc;

-- Question 11:
-- Count the number of films for each film length
-- where the film title starts with 'T'.
-- Display only lengths that have more than five films.
select
    length,
    COUNT(*) AS number_of_films
from sakila.film
where title like 'T%'
group by length
having COUNT(*) > 5;

-- Question 12:
-- List all actors who have appeared in more than 10 films.
Select
    a.actor_id,
    a.first_name,
    a.last_name,
    COUNT(fa.film_id) as number_of_films
from sakila.actor as a
inner join sakila.film_actor as fa
    on a.actor_id = fa.actor_id
group by
    a.actor_id,
    a.first_name,
    a.last_name
having COUNT(fa.film_id) > 10
order by number_of_films desc;

-- Question 13:
-- Display the top five films with the highest rental rates
-- and longest lengths, sorting by rental rate first
-- and film length second.
select
    film_id,
    title,
    rental_rate,
    length
from sakila.film
order by
    rental_rate desc,
    length desc
limit 5;

-- Question 14:
-- Display all customers along with the total number of rentals
-- made by each customer, ordered from most to least rentals.
select
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) as total_rentals
from sakila.customer as c
left join sakila.rental as r
    on c.customer_id = r.customer_id
group by
    c.customer_id,
    c.first_name,
    c.last_name
order by total_rentals desc;

-- Question 15:
-- List the film titles that have never been rented.
select
    f.film_id,
    f.title
from sakila.film as f
left join sakila.inventory as i
    on f.film_id = i.film_id
left join sakila.rental as r
    on i.inventory_id = r.inventory_id
group by
    f.film_id,
    f.title
having COUNT(r.rental_id) = 0
order by f.title;
