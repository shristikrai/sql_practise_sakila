-- Question 1:
-- Identify duplicate records in the customer table
-- without using customer_id to check for duplicates.
SELECT
    store_id,
    first_name,
    last_name,
    email,
    address_id,
    active,
    create_date,
    COUNT(*) AS duplicate_count
FROM sakila.customer
GROUP BY
    store_id,
    first_name,
    last_name,
    email,
    address_id,
    active,
    create_date
HAVING COUNT(*) > 1;

-- Question 2:
-- Count the total number of times the letter 'A'
-- appears in all film descriptions.
SELECT
    SUM(
        CHAR_LENGTH(LOWER(description))
        - CHAR_LENGTH(REPLACE(LOWER(description), 'a', ''))
    ) AS total_a_count
FROM sakila.film;

-- Question 3:
-- Count the total number of times each vowel
-- (A, E, I, O, and U) appears in all film descriptions.

SELECT
    SUM(
        CHAR_LENGTH(LOWER(description))
        - CHAR_LENGTH(REPLACE(LOWER(description), 'a', ''))
    ) AS a_count,

    SUM(
        CHAR_LENGTH(LOWER(description))
        - CHAR_LENGTH(REPLACE(LOWER(description), 'e', ''))
    ) AS e_count,

    SUM(
        CHAR_LENGTH(LOWER(description))
        - CHAR_LENGTH(REPLACE(LOWER(description), 'i', ''))
    ) AS i_count,

    SUM(
        CHAR_LENGTH(LOWER(description))
        - CHAR_LENGTH(REPLACE(LOWER(description), 'o', ''))
    ) AS o_count,

    SUM(
        CHAR_LENGTH(LOWER(description))
        - CHAR_LENGTH(REPLACE(LOWER(description), 'u', ''))
    ) AS u_count
FROM sakila.film;


-- Question 4:
-- Display the payments made by each customer:
-- a. Month-wise
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date) AS payment_year,
    MONTH(p.payment_date) AS month_number,
    MONTHNAME(p.payment_date) AS payment_month,
    COUNT(p.payment_id) AS number_of_payments,
    SUM(p.amount) AS total_amount_paid
FROM sakila.customer AS c
INNER JOIN sakila.payment AS p
    ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date),
    MONTH(p.payment_date),
    MONTHNAME(p.payment_date)
ORDER BY
    c.customer_id,
    payment_year,
    month_number;

-- b. Year-wise
    SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date) AS payment_year,
    COUNT(p.payment_id) AS number_of_payments,
    SUM(p.amount) AS total_amount_paid
FROM sakila.customer AS c
INNER JOIN sakila.payment AS p
    ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    YEAR(p.payment_date)
ORDER BY
    c.customer_id,
    payment_year;

-- c. Week-wise
    SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    YEARWEEK(p.payment_date, 1) AS payment_year_week,
    WEEK(p.payment_date, 1) AS payment_week,
    COUNT(p.payment_id) AS number_of_payments,
    SUM(p.amount) AS total_amount_paid
FROM sakila.customer AS c
INNER JOIN sakila.payment AS p
    ON c.customer_id = p.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    YEARWEEK(p.payment_date, 1),
    WEEK(p.payment_date, 1)
ORDER BY
    c.customer_id,
    payment_year_week;

-- Question 5:
-- Check whether a hardcoded year is a leap year.
-- Do not use any table from the Sakila database.
    SELECT
    CASE
        WHEN DAY(LAST_DAY('2024-02-01')) = 29
            THEN '2024 is a Leap Year'
        ELSE '2024 is Not a Leap Year'
    END AS leap_year_status;

-- Question 6:
-- Display the number of days remaining
-- in the current year from today's date.
   SELECT
    DATEDIFF(
        MAKEDATE(YEAR(CURDATE()) + 1, 1),
        CURDATE()
    ) AS days_remaining_including_today;

-- Question 7:
-- Display the quarter number as Q1, Q2, Q3, or Q4
-- for each payment date in the payment table.
    SELECT
    payment_id,
    customer_id,
    amount,
    payment_date,
    CONCAT('Q', QUARTER(payment_date)) AS payment_quarter
FROM sakila.payment;

