


/* Q1 (From Question Set 1 - Question 1)

We want to understand more about the movies that families are watching.
The following categories are considered family movies: Animation, Children,
Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in,
and the number of times it has been rented out.

Check Your Solution

For this query, you will need 5 tables: Category, Film_Category, Inventory,
Rental and Film. Your solution should have three columns: Film title, Category
name and Count of Rentals.

The following table header provides a preview of what the resulting table should
look like if you order by category name followed by the film title:
- film_title,
- category_name
- rental_count

HINT: One way to solve this is to create a count of movies using aggregations,
subqueries and Window functions. */

WITH t1 AS (SELECT *
  FROM film f
  JOIN film_category fc
  ON f.film_id = fc.film_id
  JOIN category c
  ON fc.category_id = c.category_id
  JOIN inventory i
  ON i.film_id = f.film_id
  JOIN rental r
  ON r.inventory_id = i.inventory_id)

SELECT title AS film_title, name AS category_name, COUNT(rental_id) AS rental_count
FROM t1
GROUP BY 1,2
ORDER BY 3 DESC;


/* Q2 (From Question Set 1 - Question 2)

Now we need to know how the length of rental duration of these family-friendly
movies compares to the duration that all movies are rented for. Can you provide
a table with the movie titles and divide them into 4 levels (first_quarter,
second_quarter, third_quarter, and final_quarter) based on the quartiles (25%,
50%, 75%) of the rental duration for movies across all categories? Make sure to
also indicate the category that these family-friendly movies fall into.

Check Your Solution
The data are not very spread out to create a very fun looking solution, but you
should see something like the following if you correctly split your data. You
should only need the
- category
- film_category
- film

tables to answer this and the next questions.

HINT: One way to solve it requires the use of percentiles, Window functions,
subqueries or temporary tables.*/


  SELECT
  f.title film_title,
  c.name category_name,
  f.rental_duration AS rental_duration,
  NTILE(4) OVER (ORDER BY f.rental_duration) AS quartiles
FROM film f
JOIN film_category fc
  ON f.film_id = fc.film_id
JOIN category c
  ON c.category_id = fc.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1,
         2,
         3
ORDER BY 3 DESC



/* Q3 (From Question Set 1 - Question 3)

Question 3
Finally, provide a table with the family-friendly film category, each of the
quartiles, and the corresponding count of movies within each combination of film
category for each corresponding rental duration category. The resulting table
should have three columns:

- Category
- Rental length category
- Count


Check Your Solution
The following table header provides a preview of what your table should look like.
The Count column should be sorted first by Category and then by Rental Duration
category.

HINT: One way to solve this question requires the use of Percentiles, Window
functions and Case statements.*/

SELECT
  category_name,
  quartiles,
  COUNT(category_name)
FROM (SELECT
  c.name category_name,
  NTILE(4) OVER (ORDER BY f.rental_duration) AS quartiles
FROM film f
JOIN film_category fc
  ON f.film_id = fc.film_id
JOIN category c
  ON c.category_id = fc.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')) t1
GROUP BY 1,
         2
ORDER BY 1, 2


/* Q4 (From Question Set 2 - Question 1)
We want to find out how the two stores compare in their count of rental orders
during every month for all the years we have data for. Write a query that returns
the store ID for the store, the year and month and the number of rental orders each
store has fulfilled for that month. Your table should include a column for each
of the following: year, month, store ID and count of rental orders fulfilled during that month.

Check Your Solution
The following table header provides a preview of what your table should look like.
The count of rental orders is sorted in descending order.

HINT: One way to solve this query is the use of aggregations.*/

SELECT
  DATE_PART('YEAR', rental_date) YEARs,
  DATE_PART('MONTH', rental_date) MONTHs,
  store.store_id,
  COUNT(*)
FROM rental
JOIN payment
  ON payment.rental_id = rental.rental_id
JOIN staff
  ON staff.staff_id = payment.staff_id
JOIN store
  ON store.store_id = staff.store_id
GROUP BY 1,
         2,
         3
order by 4 desc
