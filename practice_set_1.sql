SELECT *
FROM sakila.customer
WHERE first_name LIKE 'J%'
  AND active = 1;
  
SELECT *
FROM sakila.film
WHERE title LIKE '%ACTION%'
   OR description LIKE '%WAR%';
   
Select *
from sakila.customer
 where last_name !='SMITH'
 AND first_name like '%A';

select *
from sakila.film
where rental_rate > 3.00
and replacement_cost is not null;

select
    store_id,
    count(*) as active_customer_count
FROM sakila.customer
WHERE active = 1
GROUP BY store_id;

select distinct rating
from sakila.film;

Select
    rental_duration,
    COUNT(*) as number_of_films,
    ROUND(AVG(length), 2) as average_length
FROM sakila.film
GROUP BY rental_duration
HAVING AVG(length) > 100;

select
    DATE(payment_date) as payment_date,
    COUNT(*) as number_of_payments,
    SUM(amount) as total_amount_paid
FROM sakila.payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100
ORDER BY payment_date;

select *
from sakila.customer
where email is null
or email like '%org';

select *
from sakila.film
where rating in ('PG','G')
order by rental_rate desc;

select
    length,
    COUNT(*) AS number_of_films
from sakila.film
where title like 'T%'
group by length
having COUNT(*) > 5;

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
