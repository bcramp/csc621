-- Schema
/* ***************************************************
	merchants(mid, name, city, state)
	products(pid, name, category, description)
	sell(mid, pid, price, quantity_available)
	orders(oid, shipping_method, shipping_cost)
	contain(oid, pid)
	customers(cid, fullname, city, state)
	place(cid, oid, order_date)
*************************************************** */

-- Alter the tables to add keys
-- ALTER TABLE merchants
-- ADD PRIMARY KEY (mid);     -- Makes mid the primary key for the merchants table

-- ALTER TABLE products
-- ADD PRIMARY KEY (pid);     -- Makes pid the primary key for the products table

-- ALTER TABLE orders
-- ADD PRIMARY KEY (oid);     -- Makes oid the primary key for the orders table

-- ALTER TABLE customers
-- ADD PRIMARY KEY (cid);     -- Makes cid the primary key for the customers table

-- ALTER TABLE sell
-- ADD FOREIGN KEY (mid) REFERENCES merchants(mid),    -- Makes mid a foreign key for the sell table
-- ADD FOREIGN KEY (pid) REFERENCES products(pid);     -- Makes pid a foreign key for the sell table

-- ALTER TABLE contain
-- ADD FOREIGN KEY (oid) REFERENCES orders(oid),       -- Makes oid a foreign key for the contain table
-- ADD FOREIGN KEY (pid) REFERENCES products(pid);     -- Makes pid a foreign key for the contain table

-- ALTER TABLE place
-- ADD FOREIGN KEY (cid) REFERENCES customers(cid),    -- Makes cid a foreign key for the place table
-- ADD FOREIGN KEY (oid) REFERENCES orders(oid);       -- Makes oid a foreign key for the place table

-- -- Alter the tables to add more constraints
-- ALTER TABLE products
-- ADD CONSTRAINT name_constraint                                                   -- Creates a name constraint for the products table
-- 	CHECK (name = "Printer" OR name = "Ethernet Adapter" OR name = "Desktop"     -- Checks if the category is any of the strings listed
-- 			OR name = "Hard Drive" OR name = "Laptop" OR name = "Router"
-- 			OR name = "Network Card" OR name = "Super Drive"
-- 			OR name = "Monitor");

-- ALTER TABLE products
-- ADD CONSTRAINT cat_constraint                                     -- Creates a category constraint for the products table
-- 	CHECK (category = 'Peripheral' OR category = 'Networking'     -- Restricts the category to be only Peripheral, Networking, or Computer
-- 			OR category = 'Computer');

-- ALTER TABLE sell
-- ADD CONSTRAINT price_constraint             -- Creates a price constraint for the sell table
-- 	CHECK (price BETWEEN 0 AND 100000);     -- Restricts the price to be between $0 and $100,000

-- ALTER TABLE sell
-- ADD CONSTRAINT quant_avail_constraint                 -- Creates a quantity_available constraint for the sell table
-- 	CHECK (quantity_available BETWEEN 0 AND 1000);    -- Restricts the quantity_available to be between 0 and 1,000

-- ALTER TABLE orders
-- ADD CONSTRAINT ship_method_constraint                               -- Creates a shipping_method constraint for the orders table
-- 	CHECK (shipping_method = 'UPS' OR shipping_method = 'FedEx'     -- Restricts the shipping_method to be only UPS, FedEx, or USPS
-- 			OR shipping_method = 'USPS'),
-- ADD CONSTRAINT ship_cost_constraint                                 -- Creates a shipping_cost constraint for the orders table
-- 	CHECK (shipping_cost BETWEEN 0 and 500);                        -- Restricts the shipping_cost to be between $0 and $500
--     
-- ALTER TABLE place
-- MODIFY order_date DATE;     -- Modifies the order_date to be DATE type (making it valid if there are more values inserted)


-- Problem 1:
-- List names and sellers of products that are no longer available (quantity=0)

SELECT m.name AS sellerName, p.name AS productName            -- Grabs the merchant name (as sellerName) and the product name (as productName)
FROM (merchants AS m INNER JOIN sell AS s ON m.mid = s.mid    -- Combines merchants and sell (via the same mids)
		INNER JOIN products AS p ON p.pid = s.pid)            -- Resulting previous table combo is combined with products (via pids)
WHERE quantity_available = 0;                                 -- Finds where the quantity is 0 (no longer available)


-- Problem 2:
-- List names and descriptions of products that are not sold

SELECT p.name AS productName, description                     -- Grabs the product name (as productName) and desciption of the product
FROM (products AS p LEFT JOIN sell AS s ON p.pid = s.pid)     -- Uses a left join to combine products and sell (via the same pids), making the mids null for products not sold
WHERE s.mid IS NULL;                                          -- Finds where the merchant id's are null means the product is not sold by a merchant


-- Problem 3:
-- How many customers bought SATA drives but not any routers

SELECT COUNT(cust.cid) AS totalCustomers                                -- Grabs the count of the customers
FROM (customers AS cust INNER JOIN place AS pl ON cust.cid = pl.cid     -- Combines customers and place (via the same cids)
		INNER JOIN orders AS o ON o.oid = pl.oid                        -- Resulting previous table combo is combined with orders (via oids)
        INNER JOIN contain AS cn ON o.oid = cn.oid                      -- Resulting previous table combo is combined with contain (via oids)
        INNER JOIN products AS pr ON pr.pid = cn.pid)                   -- Resulting previous table combo is combined with products (via pids)
WHERE description LIKE '%SATA%' AND pr.name NOT LIKE '%Router%';        -- Filters on the description containing 'SATA' and where the product name is not 'Router' 


-- Problem 4:
-- HP has a 20% sale on all its Networking products

SELECT p.name, quantity_available, description, price AS origPrice,     -- Grabs product name, quantity, decription, and the original price of the product
		(price - (price * 0.2)) AS salePrice                            -- Finally, calculates the on-sale price of the product
FROM (merchants AS m INNER JOIN sell AS s ON m.mid = s.mid              -- Combines merchants and sell (via the same mids)
		INNER JOIN products AS p ON p.pid = s.pid)                      -- Resulting previous table combo is combined with products (via pids)
WHERE m.name = "HP" AND category = "Networking";                        -- Filters on just the products sold by HP and in the Networking category


-- Problem 5:
-- What did Uriel Whitney order from Acer (make sure to at least retrieve product names and prices)

SELECT pr.name AS productName, description, price                       -- Grabs the product name, description of the product, and price of the product
FROM (customers AS cust INNER JOIN place AS pl ON cust.cid = pl.cid     -- Combines customers and place (via the same cids)
		INNER JOIN orders AS o ON o.oid = pl.oid                        -- Resulting previous table combo is combined with orders (via oids)
        INNER JOIN contain AS cn ON o.oid = cn.oid                      -- Resulting previous table combo is combined with contain (via oids)
        INNER JOIN products AS pr ON pr.pid = cn.pid                    -- Resulting previous table combo is combined with products (via pids)
        INNER JOIN sell AS s ON pr.pid = s.pid                          -- Resulting previous table combo is combined with sell (via pids)
        INNER JOIN merchants AS m ON m.mid = s.mid)                     -- Resulting previous table combo is combined with merchants (via mids)
WHERE cust.fullname = "Uriel Whitney" AND m.name = "Acer";              -- Filters on just the products Uriel Whitney bought from Acer


-- Problem 6:
-- List the annual total sales for each company (sort the results along the company and the year attributes)
-- Assumption: We can assume that the shipping cost is not factored into the sales.

SELECT m.name AS company, YEAR(order_date) AS year,            -- Grabs the company name, year of the order, and
		SUM(price * quantity_available) AS totalSales          -- creates an aggregate of the totalSales with the sum of price multiplied by quantity
FROM (merchants AS m INNER JOIN sell AS s ON m.mid = s.mid     -- Combines merchants and sell (via the same mids)
		INNER JOIN products AS pr ON pr.pid = s.pid            -- Resulting previous table combo is combined with products (via pids)
        INNER JOIN contain AS cn ON cn.pid = pr.pid            -- Resulting previous table combo is combined with contain (via pids)
        INNER JOIN place AS pl ON pl.oid = cn.oid)             -- Resulting previous table combo is combined with place (via oids)
GROUP BY company, year                                         -- Groups the results by company name and the year
ORDER BY company, year;                                        -- In ascending order (alphanumerically), orders the company names and years


-- Problem 7:
-- Which company had the highest annual revenue and in what year?

SELECT m.name AS company, YEAR(order_date) AS year,            -- Grabs the company name, year of the order, and
		SUM(price * quantity_available) AS totalSales          -- creates an aggregate of the totalSales with the sum of price multiplied by quantity
FROM (merchants AS m INNER JOIN sell AS s ON m.mid = s.mid     -- Combines merchants and sell (via the same mids)
		INNER JOIN products AS pr ON pr.pid = s.pid            -- Resulting previous table combo is combined with products (via pids)
        INNER JOIN contain AS cn ON cn.pid = pr.pid            -- Resulting previous table combo is combined with contain (via pids)
        INNER JOIN place AS pl ON pl.oid = cn.oid)             -- Resulting previous table combo is combined with place (via oids)
GROUP BY company, year                                         -- Groups the results by company name and the year
ORDER BY totalSales DESC LIMIT 1;                              -- In descending order of price, grab the top value returned


-- Problem 8:
-- On average, what was the cheapest shipping method used ever?

SELECT shipping_method, AVG(shipping_cost) AS avgShipCost     -- Grabs the method of shipping and the average shipping cost per method
FROM orders                                                   -- Uses the orders table
GROUP BY shipping_method                                      -- Groups by the method of shipping to find the average shipping cost
ORDER BY avgShipCost LIMIT 1;                                 -- In ascending order of the average shipping cost, grab the top value of the returned


-- Problem 9:
-- What is the best sold ($) category for each company?

WITH bestSoldCatPerComp AS (                                                         -- Creates a CTE for a table that keeps track of the best sold category per company
	SELECT m.name AS company, category, SUM(price * quantity_available) AS total     -- Grabs the company, category, and the sum of price multiplied by quantity as the total
	FROM (orders AS o INNER JOIN contain AS cn ON o.oid = cn.oid                     -- Combines orders and contain (via the same oids)
			INNER JOIN products AS pr ON pr.pid = cn.pid                             -- Resulting previous table combo is combined with products (via pids)
			INNER JOIN sell AS s ON pr.pid = s.pid                                   -- Resulting previous table combo is combined with sell (via pids)
			INNER JOIN merchants AS m ON m.mid = s.mid)                              -- Resulting previous table combo is combined with merchants (via mids)
	GROUP BY company, category                                                       -- Groups by the company and category for the sum aggregate                                                    -- Orders alphabetically by company and by descreasing total
)
SELECT company, MAX(total) AS totalSold     -- Grabs the company and the max total sold for the company
FROM bestSoldCatPerComp                     -- Uses the CTE formed above
GROUP BY company;                           -- Groups the aggregate on the company


-- Problem 10:
-- For each company find out which customers have spent the most and the least amounts.

WITH totalSpentByCustPerComp AS (                                           -- Creates a CTE for a table that keeps track of the total spent by customer per company
	SELECT  m.name AS company, fullname, SUM(price) AS totalSpent           -- Grabs the company name, name of customer, and sum of the price of products bought as the totalSpent
	FROM (customers AS cust INNER JOIN place AS pl ON cust.cid = pl.cid     -- Combines customers and place (via the same cids)
			INNER JOIN orders AS o ON o.oid = pl.oid                        -- Resulting previous table combo is combined with orders (via oids)
			INNER JOIN contain AS cn ON o.oid = cn.oid                      -- Resulting previous table combo is combined with contain (via oids)
			INNER JOIN products AS pr ON pr.pid = cn.pid                    -- Resulting previous table combo is combined with products (via pids)
			INNER JOIN sell AS s ON pr.pid = s.pid                          -- Resulting previous table combo is combined with sell (via pids)
			INNER JOIN merchants AS m ON m.mid = s.mid)                     -- Resulting previous table combo is combined with merchants (via mids)
	GROUP BY company, fullname                                              -- Groups the sorting on company and the name of the customer
)
-- Query that gets the most spent
SELECT company, MAX(totalSpent) AS amountSpent     -- Grabs the company and the max total that the customer spent
FROM totalSpentByCustPerComp                       -- Uses the CTE formed above
GROUP BY company                                   -- Groups the aggregate on the company

UNION                                              -- Uses a union to combine the highest and lowest spent

-- Query that gets the least spent
SELECT company, MIN(totalSpent) AS amountSpent     -- Grabs the company and the min total that the customer spent
FROM totalSpentByCustPerComp                       -- Uses the CTE formed above
GROUP BY company                                   -- Groups the aggregate on the company
ORDER BY company;                                  -- Orders by the name of the company alphabetically
