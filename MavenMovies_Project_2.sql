/* I and my business partner were recently approached by another local business owner who is interested in 
purchasing Maven Movies. he primarily owns restaurants and bars, so he has lots of questions about our business
and the rental business in general. The following are questions he has asked to provide information for.
*/

/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
USE mavenmovies;
SELECT
  store.store_id AS Store,
  CONCAT(staff.first_name, ' ', staff.last_name) AS Manager,
  CONCAT(address.address, ', ', address.district, ', ', city.city, ', ', country.country) AS Full_Address

FROM store
  LEFT JOIN staff
    ON store.manager_staff_id = staff.staff_id
  LEFT JOIN address
    ON store.address_id = address.address_id
  LEFT JOIN city
    ON address.city_id = city.city_id
  LEFT JOIN country
    ON city.country_id = country.country_id
;

/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT
 inventory.inventory_id,
 inventory.store_id,
 film.title,
 film.rating,
 film.rental_rate,
 film.replacement_cost

FROM inventory
LEFT JOIN film
    ON film.film_id = inventory.film_id
ORDER BY 1
LIMIT 5000
;

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
WITH inv AS (SELECT
 inventory.inventory_id,
 inventory.store_id,
 film.title,
 film.rating,
 film.rental_rate,
 film.replacement_cost
FROM inventory
LEFT JOIN film
    ON film.film_id = inventory.film_id
ORDER BY 1
LIMIT 5000
) 
SELECT 
  distinct rating,
  store_id,
  count(inventory_id) AS inventory_count
FROM inv
GROUP BY 1,2
ORDER BY 1
;

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
SELECT
  inventory.store_id AS Store,
  category.name AS Film_category,
  COUNT(inventory.film_id) AS No_of_films,
  round(AVG(film.replacement_cost),2) AS Average_replacement_cost,
  SUM(film.replacement_cost) AS Total_replacement_cost
FROM inventory
  LEFT JOIN film
    ON film.film_id = inventory.film_id
  LEFT JOIN film_category
    ON film.film_id = film_category.film_id
  LEFT JOIN category
    ON film_category.category_id = category.category_id
GROUP BY
  1,2
ORDER BY
  2 desc, 3 desc
;

/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
SELECT
  DISTINCT CONCAT(customer.first_name, ' ', customer.last_name) AS Customer_name,
  customer.store_id AS Store,
  CASE 
    WHEN customer.active = 1 THEN 'Active'
    WHEN customer.active = 0 THEN 'Inactive'
    ELSE 'Are you sureeeee??'
  END AS Active_status,
  CONCAT(address.address, ', ', address.district, ', ', city.city, ', ', country.country) AS Full_address
FROM customer
  LEFT JOIN address ON customer.address_id = address.address_id
  LEFT JOIN city ON address.city_id = city.city_id
  LEFT JOIN country ON city.country_id = country.country_id
ORDER BY
  1
;

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

SELECT
  CONCAT(customer.first_name, ' ', customer.last_name) AS Customer_name,
  COUNT(payment.rental_id) AS Total_lifetime_rentals,
  SUM(payment.amount) AS Total_lifetime_value
FROM customer
  LEFT JOIN payment
    ON customer.customer_id = payment.customer_id
GROUP BY 1
ORDER BY 3 DESC
;

/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
SELECT 
  CONCAT(advisor.first_name, ' ', advisor.last_name) AS Name,
  'Advisor' AS Role,
  'NIL' AS Company
FROM advisor
UNION
SELECT 
  CONCAT(investor.first_name, ' ', investor.last_name) AS Name,
  'Investor' AS Role,
   investor.company_name AS Company
FROM investor
;

/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

SELECT 

  distinct CASE  
	WHEN actor_award.awards LIKE  ('%, %, %' )THEN 3
	WHEN LENGTH(actor_award.awards) > 7 AND LENGTH(actor_award.awards) < 13 THEN 2
    WHEN actor_award.awards IN('Emmy', 'Oscar','Tony') THEN 1
    ELSE 'Cross-check'
  END AS award_count,
  COUNT(actor_award.first_name) AS actor_count,
  COUNT(actor_award.actor_id) AS actor_count2,
  ROUND(COUNT(actor_award.actor_id)*100/COUNT(actor_award.first_name)) AS percentage
  
  
FROM actor_award
-- left join film_actor on film_actor.actor_id = actor_award.actor_id
group by 1
;









