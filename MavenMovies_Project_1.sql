/*The company's insurance policy is up for renewal and the insurance company's underwriters
 need some updated information from us before they will issue a new policy. The will need us
 to provide the following information.
*/

/* 
1. We will need a list of all staff members, including their first and last names, email addresses,
 and the store identification number where they work.
 */
 SELECT 
   staff_id AS id,
   first_name,
   last_name,
   email,
   store_id
FROM staff
;

/*
2. We will need separate counts of inventory items held at each of your two stores.
*/
SELECT 
  store_id,
  COUNT(inventory_id) AS inventory_count
FROM inventory
GROUP BY 1
-- ORDER BY 2 desc;
;

/*
3. WE will need a count of active customers for each of your stores. Separately, please.
*/
SELECT 
 store_id,
 SUM(CASE WHEN active = 1 THEN 1 END) AS active_customers
FROM customer
GROUP BY 1
;

/* 
4. In order to assess the liability of a data breach, we will need you to provide a count of all 
customer email addresses stored in the database.
*/
SELECT 
  count(email) AS email_count
FROM customer
WHERE email IS NOT NULL
;

/*
5. We are interested in how diverse your film offering is as a means of understanding how likely you 
are to keep customers engaged in the future. Please provide a count of unique film titles you have in 
your inventory at each store and then provide a count of the unique categories of films you provide.
*/

WITH cat AS (
select distinct 
  inventory.film_id,
  film.title,
  film_category.category_id,
  inventory.store_id
from inventory
  left join film on film.film_id = inventory.film_id
  left join film_category on film.film_id = film_category.film_id
order by 2 
limit 5000) 

SELECT 
  store_id,
  count(distinct title) AS unique_films,
  count(distinct category_id) AS unique_categories
FROM cat
GROUP BY 1
;

/*
6. We would like to understand the replacement cost of your films. Please provide the replacement cost
for the film that is least expensive to replace, the most expensive to replace, and the average of all 
films you carry
*/
SELECT
  min(replacement_cost) AS minimum_replacement_cost,
  max(replacement_cost) AS maximum_replacement_cost,
  round(avg(replacement_cost), 2) AS average_replacement_cost
FROM film
;

/*
7. We are interested in having you put payment monitoring systems and maximum payment processing restrictions
 in place in order to minimize the future risk of fraud by your staff. Please provide the average payment you 
 process, as well as the maximum payment you have processed.
*/
SELECT 
  round(avg(amount),2) AS average_payment,
  max(amount) AS maximum_payment
FROM payment
;

/*
8. We would like to better understand what your customer base looks like. Please provide a list of all customer 
identification values, with a count of rentals they have made all-time, with your highest volume customers at
 the top of the list. 
*/

SELECT 
  distinct customer.customer_id,
  count(rental.rental_id) as total_rentals
FROM customer
  left join rental on customer.customer_id = rental.customer_id
GROUP BY 1
ORDER BY 2 desc
;













  