-- Schema
/* ***************************************************
	chefs (chefID, name, specialty)
	restaurants (restID, name, location)
	works (chefID, restID) - indicates which chef works at which restaurant
	foods (foodID, name, type, price) - information about each food item
	serves (restID, foodID, date_sold) - records of which foods are served at which restaurant
*************************************************** */

-- PT 2 Problem 1:
-- Average Price of Foods at Each Restaurant

SELECT r.name AS restName, AVG(price) AS avgPrice                  -- Grabs the restaurant name (as restName) and the average price of food per restaurant (as avgPrice)
FROM (foods AS f INNER JOIN serves AS s ON f.foodID = s.foodID     -- Combines foods and serves (via the same foodIDs)
		INNER JOIN restaurants AS r ON r.restID = s.restID)        -- Resulting previous table combo is combined with restaurants (via restIDs)
GROUP BY restName;                                                 -- Groups by the restaurant name


-- PT 2 Problem 2:
-- Maximum Food Price at Each Restaurant

SELECT r.name AS restName, MAX(price) AS maxPrice                  -- Grabs the restaurant name (as restName) and the max price per restaurant (as maxPrice)
FROM (foods AS f INNER JOIN serves AS s ON f.foodID = s.foodID     -- Combines foods and serves (via the same foodIDs)
		INNER JOIN restaurants AS r ON r.restID = s.restID)        -- Resulting previous table combo is combined with restaurants (via restIDs)
GROUP BY restName;                                                 -- Groups by the restaurant name


-- PT 2 Problem 3:
-- Count of Different Food Types Served at Each Restaurant

SELECT r.name AS restName, COUNT(DISTINCT f.type) AS foodTypeCount     -- Grabs the restaurant name and the count of unique types of food served at the restaurant
FROM (foods AS f INNER JOIN serves AS s ON f.foodID = s.foodID         -- Combines foods and serves (via the same foodIDs)
		INNER JOIN restaurants AS r ON r.restID = s.restID)            -- Resulting previous table combo is combined with restaurants (via restIDs)
GROUP BY restName;                                                     -- Groups by the restaurant name


-- PT 2 Problem 4:
-- Average Price of Foods Served by Each Chef

SELECT c.name AS chefName, AVG(price) AS avgFoodPrice                -- Grabs the name of the chef and their associated average price
FROM (foods AS f INNER JOIN serves AS s ON f.foodID = s.foodID       -- Combines foods and serves (via the same foodIDs)
		INNER JOIN restaurants AS r ON r.restID = s.restID           -- Resulting previous table combo is combined with restaurants (via restIDs)
		INNER JOIN works AS w ON w.restID = r.restID                 -- Resulting previous table combo is combined with works (via restIDs)
		INNER JOIN chefs AS c ON c.chefID = w.chefID)                -- Resulting previous table combo is combined with chefs (via chefIDs)
GROUP BY chefName;                                                   -- Groups by the chef name


-- PT 2 Problem 5:
-- Find the Restaurant with the Highest Average Food Price

SELECT r.name AS restName, AVG(price) AS avgPrice                  -- Grabs the restaurant name and the average price per restaurant
FROM (foods AS f INNER JOIN serves AS s ON f.foodID = s.foodID     -- Combines foods and serves (via the same foodIDs)
		INNER JOIN restaurants AS r ON r.restID = s.restID)        -- Resulting previous table combo is combined with restaurants (via restIDs)
GROUP BY restName                                                  -- Groups by the restaurant name
ORDER BY avgPrice DESC LIMIT 1;                                    -- In descending order, grabs the highest average price and the restaurant that has it (via limit 1)
