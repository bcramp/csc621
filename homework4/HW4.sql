-- Alter the tables to add keys
-- ALTER TABLE actor
-- ADD PRIMARY KEY (actor_id);     -- Makes actor_id the primary key for the actor table

-- ALTER TABLE address
-- ADD PRIMARY KEY (address_id),                           -- Makes address_id the primary key for the address table
-- ADD FOREIGN KEY (city_id) REFERENCES city(city_id);     -- Makes city_id a foreign key for the address table

-- ALTER TABLE category
-- ADD PRIMARY KEY (category_id);     -- Makes category_id the primary key for the category table

-- ALTER TABLE city
-- ADD PRIMARY KEY (city_id),                                       -- Makes city_id the primary key for the city table
-- ADD FOREIGN KEY (country_id) REFERENCES country(country_id);     -- Makes country_id a foreign key for the city table

-- ALTER TABLE country
-- ADD PRIMARY KEY (country_id);     -- Makes country_id the primary key for the country table

-- ALTER TABLE customer
-- ADD PRIMARY KEY (customer_id),                                   -- Makes customer_id the primary key for the customer table
-- ADD FOREIGN KEY (store_id) REFERENCES store(store_id),           -- Makes store_id a foreign key for the customer table
-- ADD FOREIGN KEY (address_id) REFERENCES address(address_id);     -- Makes address_id a foreign key for the customer table

-- ALTER TABLE film
-- ADD PRIMARY KEY (film_id),                                          -- Makes film_id the primary key for the film table
-- ADD FOREIGN KEY (language_id) REFERENCES language(language_id);     -- Makes language_id a foreign key for the film table

-- ALTER TABLE film_actor
-- ADD FOREIGN KEY (actor_id) REFERENCES actor(actor_id),     -- Makes actor_id a foreign key for the film_actor table
-- ADD FOREIGN KEY (film_id) REFERENCES film(film_id);        -- Makes film_id a foreign key for the film_actor table

-- ALTER TABLE film_category
-- ADD FOREIGN KEY (film_id) REFERENCES film(film_id),                 -- Makes film_id a foreign key for the film_category table
-- ADD FOREIGN KEY (category_id) REFERENCES category(category_id);     -- Makes category_id a foreign key for the film_category table

-- ALTER TABLE inventory
-- ADD PRIMARY KEY (inventory_id),                            -- Makes inventory_id the primary key for the inventory table
-- ADD FOREIGN KEY (film_id) REFERENCES film(film_id),        -- Makes film_id a foreign key for the inventory table
-- ADD FOREIGN KEY (store_id) REFERENCES store(store_id);     -- Makes store_id a foreign key for the inventory table

-- ALTER TABLE payment
-- ADD PRIMARY KEY (payment_id),                                       -- Makes payment_id the primary key for the payment table
-- ADD FOREIGN KEY (customer_id) REFERENCES customer(customer_id),     -- Makes customer_id a foreign key for the payment table
-- ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id),              -- Makes staff_id a foreign key for the payment table
-- ADD FOREIGN KEY (rental_id) REFERENCES rental(rental_id);           -- Makes rental_id a foreign key for the payment table

-- ALTER TABLE rental
-- ADD PRIMARY KEY (rental_id),                                           -- Makes rental_id the primary key for the rental table
-- ADD FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id),     -- Makes inventory_id a foreign key for the rental table
-- ADD FOREIGN KEY (customer_id) REFERENCES customer(customer_id),        -- Makes customer_id a foreign key for the rental table
-- ADD FOREIGN KEY (staff_id) REFERENCES staff(staff_id);                 -- Makes staff_id a foreign key for the rental table

-- ALTER TABLE staff
-- ADD PRIMARY KEY (staff_id),                                      -- Makes staff_id the primary key for the staff table
-- ADD FOREIGN KEY (address_id) REFERENCES address(address_id),     -- Makes address_id a foreign key for the staff table
-- ADD FOREIGN KEY (store_id) REFERENCES store(store_id);           -- Makes store_id a foreign key for the staff table

-- ALTER TABLE hw4.language
-- ADD PRIMARY KEY (language_id);     -- Makes language_id the primary key for the language table

-- ALTER TABLE inventory
-- ADD PRIMARY KEY (inventory_id),                            -- Makes inventory_id the primary key for the inventory table
-- ADD FOREIGN KEY (film_id) REFERENCES film(film_id),        -- Makes film_id a foreign key for the inventory table
-- ADD FOREIGN KEY (store_id) REFERENCES store(store_id);     -- Makes store_id a foreign key for the inventory table

-- ALTER TABLE store
-- ADD PRIMARY KEY (store_id),                                      -- Makes store_id the primary key for the store table
-- ADD FOREIGN KEY (address_id) REFERENCES address(address_id);     -- Makes address_id a foreign key for the store table

-- Alter the tables to add more constraints
-- ALTER TABLE category
-- ADD CONSTRAINT name_constraint                                          -- Creates a name constraint for the category table
-- 	CHECK (name = "Animation" OR name = "Comedy" OR name = "Family"     -- Checks if the name is any of the strings listed
-- 			OR name = "Foreign" OR name = "Sci-Fi" OR name = "Travel"
-- 			OR name = "Children" OR name = "Drama" OR name = "Horror" 
--             OR name = "Action" OR name = "Classics" OR name = "Games"
--             OR name = "New" OR name = "Documentary" OR name = "Sports" 
--             OR name = "Music");
            
-- ALTER TABLE film
-- ADD CONSTRAINT special_feat_constraint               -- Creates a special_feature constraint for the film table
-- 	CHECK (special_features = "Behind the Scenes"    -- Checks if the special_features (2, 3, and 4) is any of the strings listed
-- 			OR special_features = "Commentaries"
-- 			OR special_features = "Deleted Scenes"
-- 			OR special_features = "Trailers"
--             OR special_features_2 = "Behind the Scenes"
-- 			OR special_features_2 = "Commentaries"
-- 			OR special_features_2 = "Deleted Scenes"
-- 			OR special_features_2 = "Trailers"
--             OR special_features_3 = "Behind the Scenes"
-- 			OR special_features_3 = "Commentaries"
-- 			OR special_features_3 = "Deleted Scenes"
-- 			OR special_features_3 = "Trailers"
--             OR special_features_4 = "Behind the Scenes"
-- 			OR special_features_4 = "Commentaries"
-- 			OR special_features_4 = "Deleted Scenes"
-- 			OR special_features_4 = "Trailers");
            
-- ALTER TABLE rental
-- MODIFY rental_date DATETIME,     -- Modifies the rental_date to be DATETIME type (making it valid if there are more values inserted)
-- MODIFY return_date DATETIME;     -- Modifies the return_date to be DATETIME type (making it valid if there are more values inserted)

-- ALTER TABLE payment
-- MODIFY payment_date DATETIME;     -- Modifies the payment_date to be DATETIME type (making it valid if there are more values inserted)

-- ALTER TABLE customer
-- ADD CONSTRAINT active_constraint          -- Creates an active constraint for the customer table
-- 	CHECK (active = 0 OR active = 1);     -- Checks if active is in the set {0,1}

-- ALTER TABLE film
-- ADD CONSTRAINT duration_constraint     -- Creates a duration constraint for the film table
-- 	CHECK (rental_duration >= 2        -- Checks if the rental duration is between 2 and 8 days (inclusive)
-- 			AND rental_duration <= 8);
            
-- ALTER TABLE film
-- ADD CONSTRAINT rate_constraint                              -- Creates a rental rate per day constraint for the film table
-- 	CHECK (rental_rate >= 0.99 AND rental_rate <= 6.99);    -- Checks if the rental rate per day is between $0.99 and $6.99 (inclusive)

-- ALTER TABLE film
-- ADD CONSTRAINT length_constraint                -- Creates a length constraint for the film table
-- 	CHECK (length >= 30 AND length <= 200);     -- Checks if the film length is between 30 and 200 min (inclusive)

-- ALTER TABLE film
-- ADD CONSTRAINT rating_constraint                                 -- Creates a rating constraint for the film table
-- 	CHECK (rating = "PG" OR rating = "G" OR rating = "NC-17"     -- Checks if the rating is any of the strings listed
-- 			OR rating = "PG-13" OR rating = "R");

-- ALTER TABLE film
-- ADD CONSTRAINT replacement_constraint                                    -- Creates a replacement cost constraint for the film table
-- 	CHECK (replacement_cost >= 5.00 AND replacement_cost <= 100.00);     -- Checks if the replacement cost is between $5.00 and $100.00

-- ALTER TABLE payment
-- ADD CONSTRAINT total_constraint     -- Creates a total amount constraint for the payment table
-- 	CHECK (amount >= 0);            -- Checks if the total payment amount >= 0


-- Queries
-- Problem 1:
-- What is the average length of films in each category? List the results in alphabetic order of categories

SELECT name AS category, AVG(length) AS avgLength                            -- Grabs the category name and the average film length per category
FROM (film as f INNER JOIN film_category AS fc ON f.film_id = fc.film_id     -- Combines films and film_category (via the same film_id)
		INNER JOIN category AS c ON c.category_id = fc.category_id)          -- Resulting previous table combo is combined with category (via category_id)
GROUP BY category                                                            -- Groups by the film's category
ORDER BY category;                                                           -- In alphabetical order of the names of the categories


-- Problem 2:
-- Which categories have the longest and shortest average film lengths?

WITH avgFilmLengthPerCat AS (                                                    -- Creates a CTE for a table that keeps track of the average film length per category
	SELECT name AS category, AVG(length) AS avgLength                            -- Grabs the category name and the average film length per category
	FROM (film as f INNER JOIN film_category AS fc ON f.film_id = fc.film_id     -- Combines films and film_category (via the same film_id)
			INNER JOIN category AS c ON c.category_id = fc.category_id)          -- Resulting previous table combo is combined with category (via category_id)
	GROUP BY category                                                            -- Groups by the film's category
)
-- Query that gets the category with the longest average length
SELECT category, avgLength       -- Grabs the category and the average film length per category
FROM avgFilmLengthPerCat         -- Uses the CTE formed above
WHERE avgLength = (              -- Filters where the average length is equal to the max of the following query
	SELECT MAX(avgLength)        -- Grabs the max average film length per category
    FROM avgFilmLengthPerCat     -- Uses the CTE formed above
)

UNION                            -- Uses a union to combine the longest and shortest average film length per category

-- Query that gets the category with the shortest average length
SELECT category, avgLength       -- Grabs the category and the average film length per category
FROM avgFilmLengthPerCat         -- Uses the CTE formed above
WHERE avgLength = (              -- Filters where the average length is equal to the min of the following query
	SELECT MIN(avgLength)        -- Grabs the min average film length per category
    FROM avgFilmLengthPerCat     -- Uses the CTE formed above
);


-- Problem 3:
-- Which customers have rented action but not comedy or classic movies?

WITH custCategories AS (                                                                   -- Creates a CTE for a table tracking customers and the categories of movies they rented
	SELECT CONCAT(first_name, ' ', last_name) AS full_name, name AS category               -- Grabs the customers full name (using CONCAT func) and the category of the movies rented
	FROM (category AS cat JOIN film_category AS fc ON cat.category_id = fc.category_id     -- Combines category and film_category (via the same category_id)
            JOIN film AS f ON f.film_id = fc.film_id                                       -- Resulting previous table combo is combined with film (via film_id)
            JOIN inventory AS i ON i.film_id = f.film_id                                   -- Resulting previous table combo is combined with inventory (via film_id)
            JOIN rental AS r ON r.inventory_id = i.inventory_id                            -- Resulting previous table combo is combined with rental (via inventory_id)
            JOIN customer AS c ON c.customer_id = r.customer_id)                           -- Resulting previous table combo is combined with customer (via customer_id)
)
-- Query that gets the customers who have rented Action movies
SELECT full_name                                        -- Grabs the full name of the customer
FROM custCategories                                     -- Uses the CTE formed above
WHERE category = "Action"                               -- Filters where the category is Action

EXCEPT                                                  -- Uses an except to remove customers who have rented action and either comedy or classics movies

-- Query that gets the customers who have rented Comedy or Classics movies
SELECT full_name                                       -- Grabs the full name of the customer
FROM custCategories                                    -- Uses the CTE formed above
WHERE category = "Comedy" OR category = "Classics"     -- Filters where the category is either Comedy or Classics
ORDER BY full_name;                                    -- Alphabetically orders by the customers full name


-- Problem 4:
-- Which actor has appeared in the most English-language movies?

SELECT CONCAT(first_name, ' ', last_name) AS actor, COUNT(title) AS moviesIn     -- Grabs the concatenated name (first and last) of the actor and count of the num of movies 
FROM (actor AS a INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id         -- Combines actor and film_actor (via the same actor_id)
		INNER JOIN film AS f ON f.film_id = fa.film_id                           -- Resulting previous table combo is combined with film (via film_id)
		INNER JOIN language AS l ON l.language_id = f.language_id)               -- Resulting previous table combo is combined with language (via language_id)
WHERE name = "English"                                                           -- Filters on movies that are in English 
GROUP BY actor                                                                   -- Groups the aggregate on the actor name
ORDER BY moviesIn DESC LIMIT 1;                                                  -- In descending order, orders by the English movies the actors are in and grabs the highest amount


-- Problem 5:
-- How many distinct movies were rented for exactly 10 days from the store where Mike works?

WITH distMoviesRentedForTenDays AS (                                             -- Creates a CTE for a table that tracks distinct movies that were rented for 10 days at the store where Mike works
	SELECT DISTINCT title                                                        -- Grabs the distinct movie titles
	FROM (rental AS r JOIN inventory AS i ON i.inventory_id = r.inventory_id     -- Combines rental and inventory (via the same inventory_id)
            JOIN staff AS s ON s.store_id = i.store_id                           -- Resulting previous table combo is combined with staff (via store_id)
			JOIN film AS f ON f.film_id = i.film_id)                             -- Resulting previous table combo is combined with film (via film_id)
	WHERE first_name = "Mike" AND DATEDIFF(return_date, rental_date) = 10        -- Filters on where Mike works and the difference in return and rental dates is 10 days
)
SELECT COUNT(title) AS distinctMoviesRentedForTenDays                            -- Grabs the aggregate count of the distinct movie titles rented for 10 days (where Mike works)
FROM distMoviesRentedForTenDays;                                                 -- Uses the CTE formed above


-- Problem 6:
-- Alphabetically list actors who appeared in the movie with the largest cast of actors.

WITH actorsPerMovie AS (                                                       -- Creates a CTE for a table that tracks the number of actors per movie
	SELECT title, COUNT(CONCAT(first_name, ' ', last_name)) AS numOfActors     -- Grabs the movie title and count of the actor names (concat first and last) in the movie
	FROM (actor AS a JOIN film_actor AS fa ON a.actor_id = fa.actor_id         -- Combines actor and film_actor (via the same actor_id)
			JOIN film AS f ON f.film_id = fa.film_id)                          -- Resulting previous table combo is combined with film (via film_id)
	GROUP BY title                                                             -- Groups the aggregate on the title
)
SELECT CONCAT(first_name, ' ', last_name) AS actor, title              -- Grabs the concatenated name (first and last) of the actor and movie they were in 
FROM (actor AS a JOIN film_actor AS fa ON a.actor_id = fa.actor_id     -- Combines actor and film_actor (via the same actor_id)
			JOIN film AS f ON f.film_id = fa.film_id)                  -- Resulting previous table combo is combined with film (via film_id)
WHERE title = (                                                        -- Filters on where the title is the movie with the most actors
	SELECT title                                                       -- Grabs the movie title
	FROM actorsPerMovie                                                -- Uses the CTE formed above
    WHERE numOfActors = (                                              -- Filters on where the number of actors is the max
		SELECT MAX(numOfActors)                                        -- Grabs the max number of actors in a movie
        FROM actorsPerMovie                                            -- Uses the CTE formed above
	)
)
ORDER BY actor;                                                        -- Orders on the actor name in alphabetical order
