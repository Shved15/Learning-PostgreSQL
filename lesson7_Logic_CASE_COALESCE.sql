--- Lesson 7: Logical operators


--- ### CASE WHEN ### ---

--General form of CASE WHEN
    CASE
        WHEN condition_1 THEN result_1
        WHEN condition_2 THEN result_2
        [WHEN...]
        [ELSE result_n]
    END

--* condition - conditional returning bool (if True -> THEN, if False -> next WHEN, else -> ELSE)
--* result1 - result or action when with PL\pgSQL

SELECT product_name, unit_price, units_in_stock,
	CASE WHEN units_in_stock >= 100 THEN 'lots of'
	 	WHEN units_in_stock >= 50 AND units_in_stock < 100 THEN 'average'
	 	WHEN units_in_stock < 50 THEN 'low number'
	 	ELSE 'unknown'
	END AS amount
FROM products
ORDER BY units_in_stock DESC;



SELECT order_id, order_date,
	CASE WHEN date_part('month', order_date) BETWEEN 3 and 5 THEN 'spring'
     	 WHEN date_part('month', order_date) BETWEEN 6 and 8 THEN 'summer'
	 	 WHEN date_part('month', order_date) BETWEEN 9 and 11 THEN 'autumn'
	     ELSE 'winter'
	END AS season
FROM orders;


SELECT product_name, unit_price,
	CASE WHEN unit_price >= 30 THEN 'Expensive'
	 	 WHEN unit_price < 30 THEN 'Inexpensive'
	 	 ELSE 'Undetermined'
	END AS price_description
FROM products;

________________________________________________________________________________________________________


--- ### COALESCE & NULLIF ### ---

COALESCE(arg1, arg2, ...); -- return first arg which not null, if all arg=null then return null

NULLIF(arg1, arg2) -- if arg1=arg2 return null, else return arg1


SELECT *
FROM orders
LIMIT 10;

-- if we want to display the word we need instead of null
SELECT order_id, order_date, COALESCE(ship_region, 'unknown') AS ship_region
FROM orders
LIMIT 10;



SELECT *
FROM employees;

SELECT last_name, first_name, COALESCE(region, 'N/A') as region
FROM employees;


--nullif is used to replace a value we don't like and it's not null
SELECT *
FROM customers;

SELECT contact_name, COALESCE(NULLIF(city, ''), 'Unknown') as city
FROM customers;



CREATE TABLE budgets
(
	dept serial,
	current_year decimal NULL,
	previous_year decimal NULL
);
INSERT INTO budgets(current_year, previous_year) VALUES(100000, 150000);
INSERT INTO budgets(current_year, previous_year) VALUES(NULL, 300000);
INSERT INTO budgets(current_year, previous_year) VALUES(0, 100000);
INSERT INTO budgets(current_year, previous_year) VALUES(NULL, 150000);
INSERT INTO budgets(current_year, previous_year) VALUES(300000, 250000);
INSERT INTO budgets(current_year, previous_year) VALUES(170000, 170000);
INSERT INTO budgets(current_year, previous_year) VALUES(150000, NULL);

SELECT dept,
	COALESCE(TO_CHAR(NULLIF(current_year, previous_year), 'FM99999999'), 'Same as last year') AS budget
FROM budgets
WHERE current_year IS NOT NULL;

________________________________________________________________________________________________________

--- Practice after lesson

-- 1. Run the following code (records are required to test the correctness of the remote sensing):
insert into customers(customer_id, contact_name, city, country, company_name)
values
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');

-- After that, complete the task:
-- Display the name of the customer's contact, his city and country, sorted in ascending order by contact name and city,
-- and if the city is NULL, then by contact name and country. Check the result using pre-inserted rows.


-- 2. Display product name, product price and value column

-- too expensive if price >= 100

-- average if price >=50 but < 100

-- low price if price < 50

-- 3. Find customers who have not made a single order. Print customer name and 'no orders' value if order_id = NULL.

-- 4. Display the full name of employees and their positions. If position = Sales Representative, display Sales Stuff instead.


--1
INSERT INTO customers(customer_id, contact_name, city, country, company_name)
VALUES
('AAAAAB', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBBV', 'Alfred Mann', NULL, 'Austria', 'fake_company');

SELECT contact_name, city, country
FROM customers
ORDER BY contact_name,
(
	CASE WHEN city IS NULL THEN country
		 ELSE city
	END
);

INSERT INTO customers(customer_id, contact_name, city, country, company_name)
VALUES
('AAAAAB', 'John Mann', 'abc', 'USA', 'fake_company'),
('BBBBBV', 'John Mann', 'acd', 'Austria', 'fake_company');


--2
SELECT product_name, unit_price,
CASE WHEN unit_price >= 100 THEN 'too expensive'
	 WHEN unit_price >= 50 AND unit_price < 100 THEN 'average'
	 ELSE 'low price'
END AS price
FROM products
ORDER BY unit_price DESC;

--3
SELECT DISTINCT contact_name, COALESCE(order_id::text, 'no orders')
FROM customers
LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL;

--4

SELECT CONCAT(last_name, ' ', first_name), COALESCE(NULLIF(title, 'Sales Representative'), 'Sales Stuff') AS title
FROM employees;
