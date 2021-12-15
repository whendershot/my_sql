-- 1. What query would you run to get all the customers inside city_id = 312? Your query should return customer first name, last name, email, and address.
SELECT
    customers.first_name,
    customers.last_name,
    customers.email,
    addresses.address
FROM
(
    SELECT
        address,
        address_id
    FROM
        sakila.address
    WHERE
        city_id = 312
) AS addresses
LEFT JOIN
(
    SELECT
        address_id,
        first_name,
        last_name,
        email
    FROM
        sakila.customer
) AS customers
ON
    addresses.address_id = customers.address_id
;

-- 2. What query would you run to get all comedy films? Your query should return film title, description, release year, rating, special features, and genre (category).
SELECT
    films.title AS film_title,
    films.description,
    films.release_year,
    films.rating,
    films.special_features,
    genres.name AS genre
FROM
(
    SELECT
        category_id,
        name
    FROM
        sakila.category
    WHERE
        LOWER(name) = 'comedy'
) AS genres
LEFT JOIN
(
    SELECT
        film_id,
        category_id
    FROM
        sakila.film_category
) fgs
ON
    genres.category_id = fgs.category_id

LEFT JOIN
(
    SELECT
        film_id,
        title,
        description,
        release_year,
        rating, 
        special_features
    FROM
        sakila.film
) AS films
ON 
    fgs.film_id = films.film_id
;

-- 3. What query would you run to get all the films joined by actor_id=5? Your query should return the actor id, actor name, film title, description, and release year.
SELECT
    actors.actor_id,
    CONCAT(actors.first_name, ' ', actors.last_name) AS actor_name,
    films.title AS film_title,
    films.description,
    films.release_year
FROM
(
    SELECT
        actor_id,
        first_name,
        last_name
    FROM
        sakila.actor
    WHERE
        actor_id = 5
) AS actors

LEFT JOIN
(
    SELECT
        actor_id,
        film_id
    FROM
        sakila.film_actor
) fas
ON
    actors.actor_id = fas.actor_id
    
LEFT JOIN
(
    SELECT
        film_id,
        title,
        description,
        release_year
    FROM
        sakila.film
) AS films
ON
    fas.film_id = films.film_id
;

-- 4. What query would you run to get all the customers in store_id = 1 and inside these cities (1, 42, 312 and 459)? Your query should return customer first name, last name, email, and address.
SELECT
    customers.first_name,
    customers.last_name,
    customers.email,
    addresses.address
FROM
(
    SELECT
        address_id,
        first_name,
        last_name,
        email
    FROM
        sakila.customer
    WHERE
        store_id IN (1)
) AS customers

INNER JOIN
(
    SELECT
        address_id,
        address
    FROM
        sakila.address
    WHERE
        city_id IN (1, 42, 312, 459)
) AS addresses
ON
    customers.address_id = addresses.address_id
;

-- 5. What query would you run to get all the films with a "rating = G" and "special feature = behind the scenes", joined by actor_id = 15? Your query should return the film title, description, release year, rating, and special feature. Hint: You may use LIKE function in getting the 'behind the scenes' part.

SELECT
    title as film_title,
    description,
    release_year,
    rating,
    special_features as special_feature
FROM
    sakila.film
WHERE
    LOWER(rating) = 'g' AND
    LOWER(special_features) LIKE '%behind the scenes%' AND
    film_id IN (SELECT film_id FROM sakila.film_actor WHERE actor_id = 15)
;

-- 6. What query would you run to get all the actors that joined in the film_id = 369? Your query should return the film_id, title, actor_id, and actor_name.
SELECT
    films.film_id,
    films.title,
    actors.actor_id,
    CONCAT(actors.first_name, ' ', actors.last_name) AS actor_name
FROM
(
    SELECT
        actor_id,
        film_id
    FROM
        sakila.film_actor
    WHERE
        film_id = 369
    
) AS fas

LEFT JOIN
(
    SELECT
        film_id,
        title
    FROM
        sakila.film
) AS films
ON
    fas.film_id = films.film_id
    
LEFT JOIN
(
    SELECT
        actor_id,
        first_name,
        last_name
    FROM
        sakila.actor
) AS actors
ON
    fas.actor_id = actors.actor_id
;

-- 7. What query would you run to get all drama films with a rental rate of 2.99? Your query should return film title, description, release year, rating, special features, and genre (category).
SELECT
    films.title,
    films.description,
    films.release_year,
    films.rating,
    films.special_features,
    genres.name AS genre
FROM
(
    SELECT
        category_id,
        name
    FROM
        sakila.category
    WHERE
        LOWER(name) = 'drama'
) AS genres

LEFT JOIN
(
    SELECT
        category_id,
        film_id
    FROM
        sakila.film_category
) AS fcs
ON 
    genres.category_id = fcs.category_id
    
INNER JOIN
(
    SELECT
        film_id,
        title,
        description,
        release_year,
        rating,
        special_features
    FROM
        sakila.film
    WHERE
        rental_rate = 2.99
) films
ON
    fcs.film_id = films.film_id
;

-- 8. What query would you run to get all the action films which are joined by SANDRA KILMER? Your query should return film title, description, release year, rating, special features, genre (category), and actor's first name and last name.
SELECT
    films.title,
    films.description,
    films.release_year,
    films.rating,
    films.special_features,
    'action' as genre,
    CONCAT(actors.first_name, ' ', actors.last_name) AS actor_name
FROM
(
    SELECT
        actor_id,
        first_name,
        last_name
    FROM
        sakila.actor
    WHERE
        UPPER(CONCAT(first_name, ' ', last_name)) = 'SANDRA KILMER'
) AS actors

LEFT JOIN
(
    SELECT
        actor_id,
        film_id
    FROM
        sakila.film_actor
) AS fas
ON
    actors.actor_id = fas.actor_id
    
INNER JOIN
(
    SELECT
        film_id,
        title,
        description,
        release_year, 
        rating,
        special_features
    FROM
        sakila.film
    WHERE
        film_id IN (
            SELECT
                film_id
            FROM
                sakila.film_category
            LEFT JOIN
                sakila.category            
            USING(category_id)
            WHERE
                LOWER(name) = 'action'
        )
) AS films
ON
    fas.film_id = films.film_id
;
