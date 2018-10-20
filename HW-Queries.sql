# 1a. Display the first and last names of all actors from the table actor
SELECT 
    first_name, last_name
FROM
    sakila.actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name
SELECT 
    CONCAT(first_name, ' ', last_name) AS `Actor Name`
FROM
    sakila.actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
# What is one query would you use to obtain this information?
SELECT 
    actor_id, first_name, last_name
FROM
    sakila.actor
WHERE
    first_name LIKE '%Joe%';

# 2b
SELECT 
    actor_id, first_name, last_name
FROM
    sakila.actor
WHERE
    last_name LIKE '%GEN%';

#2c
SELECT 
    actor_id, first_name, last_name
FROM
    sakila.actor
WHERE
    last_name LIKE '%LI%'
ORDER BY last_name , first_name;

#2d
SELECT 
    country_id, country
FROM
    sakila.country
WHERE
    country IN ('Afghanistan' , 'Bangladesh', 'China');

#3a
alter table sakila.actor add column `description` blob after last_name;
desc sakila.actor;

#3b
alter table sakila.actor drop column `description`;
desc sakila.actor;

#4a 
SELECT 
    last_name, COUNT(last_name) AS col_count
FROM
    sakila.actor
GROUP BY last_name
ORDER BY col_count DESC;

#4b
SELECT 
    first_name, last_name, COUNT(last_name) AS col_count
FROM
    sakila.actor
GROUP BY last_name
HAVING col_count > 1;

#4c
UPDATE sakila.actor 
SET 
    first_name = 'HARPO'
WHERE
    last_name = 'WILLIAMS'
        AND first_name = 'GROUCHO';

#4d
UPDATE sakila.actor 
SET 
    first_name = 'GROUCHO'
WHERE
    last_name = 'WILLIAMS'
        AND first_name = 'HARPO';

#5a
desc sakila.address;

#6a
SELECT 
    s.first_name, s.last_name, a.address
FROM
    sakila.staff AS s
        JOIN
    sakila.address AS a ON s.address_id = a.address_id;

#6b
SELECT 
    s.first_name, s.last_name, SUM(p.amount)
FROM
    sakila.staff AS s
        JOIN
    sakila.payment AS p ON s.staff_id = p.staff_id
WHERE
    p.payment_date > '2005-08-01 00:00:00'
GROUP BY p.staff_id;

#6c
SELECT 
    fi.title, COUNT(fa.film_id) AS `Actor Count`
FROM
    sakila.film AS fi
        INNER JOIN
    sakila.film_actor AS fa ON fi.film_id = fa.film_id
GROUP BY fa.film_id;

#6d
SELECT 
    COUNT(film_id)
FROM
    sakila.inventory
WHERE
    film_id = (SELECT 
            film_id
        FROM
            sakila.film
        WHERE
            title = 'Hunchback Impossible');

#6e
SELECT 
    c.first_name, c.last_name, SUM(p.amount)
FROM
    sakila.customer AS c
        JOIN
    sakila.payment AS p ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name;

#7a    
SELECT 
    title
FROM
    sakila.film
WHERE
    language_id = (SELECT 
            language_id
        FROM
            sakila.language
        WHERE
            name LIKE '%English%')
        AND title LIKE 'K%'
        OR title LIKE 'Q%';

#7b
SELECT 
    first_name, last_name
FROM
    sakila.actor
WHERE
    actor_id IN (SELECT 
            actor_id
        FROM
            sakila.film_actor
        WHERE
            film_id = (SELECT 
                    film_id
                FROM
                    sakila.film
                WHERE
                    title = 'Alone Trip'));

#7c
SELECT 
    cu.first_name, cu.last_name, cu.email, co.country
FROM
    sakila.customer AS cu
        JOIN
    sakila.address AS ad ON cu.address_id = ad.address_id
        JOIN
    sakila.city AS ct ON ad.city_id = ct.city_id
        JOIN
    sakila.country AS co ON ct.country_id = co.country_id
WHERE
    co.country LIKE '%canada%';

#7d
SELECT 
    f.title, c.name
FROM
    sakila.category AS c
        JOIN
    sakila.film_category AS fc ON c.category_id = fc.category_id
        JOIN
    sakila.film AS f ON fc.film_id = f.film_id
WHERE
    c.name LIKE '%family%';
    
#7e
SELECT 
    f.title, COUNT(i.film_id) AS rental_count
FROM
    sakila.rental AS r
        JOIN
    sakila.inventory AS i ON r.inventory_id = i.inventory_id
        JOIN
    sakila.film AS f ON i.film_id = f.film_id
GROUP BY i.film_id
ORDER BY rental_count DESC;

#7f
SELECT 
    st.store_id, st.address_id, SUM(py.amount)
FROM
    sakila.store AS st
        JOIN
    sakila.inventory AS i ON st.store_id = i.store_id
        JOIN
    sakila.rental AS re ON re.inventory_id = i.inventory_id
        JOIN
    sakila.payment AS py ON re.rental_id = py.rental_id
GROUP BY st.store_id
LIMIT 10;

#7g
SELECT 
    st.store_id, ct.city, co.country
FROM
    sakila.store AS st
        JOIN
    sakila.address AS ad ON st.address_id = ad.address_id
        JOIN
    sakila.city AS ct ON ct.city_id = ad.city_id
        JOIN
    sakila.country AS co ON ct.country_id = co.country_id;

#7h. List the top five genres in gross revenue in descending order. category, film_category, inventory, payment, and rental.

SELECT 
    ca.name, SUM(py.amount) AS revenue
FROM
    sakila.category AS ca
        JOIN
    sakila.film_category AS fc ON ca.category_id = fc.category_id
        JOIN
    sakila.inventory AS iv ON fc.film_id = iv.film_id
        JOIN
    sakila.rental AS re ON iv.inventory_id = re.inventory_id
        JOIN
    sakila.payment AS py ON re.rental_id = py.rental_id
GROUP BY ca.category_id
ORDER BY revenue DESC
LIMIT 5;

#8a
CREATE VIEW sakila.top_revenue_view AS
    SELECT 
        ca.name, SUM(py.amount) AS revenue
    FROM
        sakila.category AS ca
            JOIN
        sakila.film_category AS fc ON ca.category_id = fc.category_id
            JOIN
        sakila.inventory AS iv ON fc.film_id = iv.film_id
            JOIN
        sakila.rental AS re ON iv.inventory_id = re.inventory_id
            JOIN
        sakila.payment AS py ON re.rental_id = py.rental_id
    GROUP BY ca.category_id
    ORDER BY revenue DESC
    LIMIT 5;

#8b
select * from sakila.top_revenue_view;

#8c
drop view if exists sakila.top_revenue_view;