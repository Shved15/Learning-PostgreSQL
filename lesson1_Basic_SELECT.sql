--Lesson 1: Basic SELECT queries


---select all data from products table---

SELECT * FROM products


---select data from specific columns in products table---

SELECT product_id, product_name, unit_price
FROM products


_______________________________________________________

--MATH OPERATIONS THAT THE SQL SUPPORTS:
--	 + addition
--	 - subtraction
--	 * multiplication
--	 / division
--	 ˆ exponentiation
--	 |/ square root
--	 many other operators and functions
_______________________________________________________



--- calculate the total price of a particular	product in stock ---

SELECT product_id, product_name, unit_price * units_in_stock
FROM products



--## DISTINCT ##

--- display a list of cities where employees live (without duplicates) - use 'DISTINCT' ---

SELECT DISTINCT city
FROM employees


--## COUNT ##
--- display the number of countries where employees live (without duplicates) - use 'COUNT(DISTINCT ....)' ---

SELECT COUNT(DISTINCT country)
FROM employees


--- display the number of orders ---

SELECT COUNT(*)
FROM orders


--- select data from customers table ---

SELECT *
FROM customers;

SELECT contact_name, city
FROM customers


--- select how many days did it take to deliver the goods ---

SELECT order_id, shipped_date - order_date
FROM orders


--- select all unique customer cities ---

SELECT DISTINCT city
FROM customers


--- select the number of unique customer countries ---

SELECT COUNT(DISTINCT country)
FROM customers



_______________________________________________________________________________

--FILTRATION - WHERE

--SYNTAX:

--	SELECT *
--	FROM table
--	WHERE condition


--For the condition we use comparison operators:

--	 a = b
--	 a > b
--	 a >= b
--	 a < b
--	 a <= b
--	 a <> b   or   a != b
_______________________________________________________________________________



--- select all customers from USA ---

SELECT company_name, contact_name, phone, country
FROM customers
WHERE country = 'USA'


--- select all data in products where price > 20 ---

SELECT *
FROM products
WHERE unit_price > 20


--- select the number of products with price > 20 ---

SELECT COUNT(*)
FROM products
WHERE unit_price > 20


--- select all customers who don't live in Berlin ---

SELECT COUNT(*)
FROM products
WHERE unit_price > 20


--- select all orders after 01.03.1998 ---

SELECT *
FROM orders
WHERE order_date > '1998-03-01';



_______________________________________________________________________________

--FILTRATION - WHERE

--	SELECT *
--	FROM table
--	WHERE condition1 AND condition2

--	SELECT *
--	FROM table
--	WHERE condition1 OR condition2

--	SELECT *
--	FROM table
--	WHERE condition1 AND condition2 AND condition3
_______________________________________________________________________________



--- filter all products with a price > 25 and their quantity in stock > 40 ---

SELECT *
FROM products
WHERE unit_price > 25 AND units_in_stock > 40


--- select all customers who live in Berlin, London and San Francisco ---

SELECT *
FROM customers
WHERE city = 'Berlin' OR city = 'London' OR city = 'San Francisco';



--- select all orders where shipped date > 30.04.1998 and freight < 75 or freight > 150 ---

SELECT *
FROM orders
WHERE shipped_date > '1998-04-30' AND (freight < 75 OR freight > 150);



--## BETWEEN ##

--- select the number of orders with freight more than 20 and less than 40 (BETWEEN includes upper and lower bounds)---

SELECT COUNT(*)
FROM orders
WHERE freight BETWEEN 20 AND 40;


--# it is the same

--	SELECT *
--	FROM orders
--	WHERE freight >= 20 AND freight <= 40;


--- select all orders in certain dates ---

SELECT *
FROM orders
WHERE orders_date BETWEEN '1998-03-30' AND '1998-04-03';



--## IN ##

--- select all customers who live in Mexico, Germany, USA, Canada (use operator IN) ---

# without in

SELECT *
FROM customers
WHERE country = 'Mexico'OR country = 'Germany'OR country = 'USA' OR country = 'Canada';



--# it is the same only with IN operator

SELECT *
FROM customers
WHERE country IN ('Mexico', 'Germany', 'USA', 'Canada');



--- select all products with id of category = 1, 3, 5, 7 ---

SELECT *
FROM products
WHERE category_id IN (1, 3, 5, 7);



--- select all customers who don't live in Mexico, Germany, USA, Canada (use operator NOT) ---

SELECT *
FROM customers
WHERE country NOT IN ('Mexico', 'Germany', 'USA', 'Canada');



--## ORDER BY ##

--- select all country where customers live with sorted in ascending order ---

SELECT DISTINCT country
FROM customers
ORDER BY country ASC



--- select all country where customers live with sorted in descending order ---

SELECT DISTINCT country
FROM customers
ORDER BY country DESC


--- more select with sorted ---

SELECT DISTINCT country, city
FROM customers
ORDER BY country DESC, city ASC


--## MIN, MAX, AVG, SUM ##

--- select the oldest order in London ---

SELECT MIN(order_date)
FROM orders
WHERE ship_city = 'London';

--- select the newest order in London ---

SELECT MAX(order_date)
FROM orders
WHERE ship_city = 'London';



--- select the average price of products on sale ---

SELECT AVG(unit_price)
FROM products
WHERE discontinued <> 1


--- select count the total number of items for sale ---

SELECT SUM(units_in_stock)
FROM products
WHERE discontinued <> 1





_______________________________________________________________________________

-- Pattern Matching with Like

-- '%' - placeholder (заполнитель) signifying (означающий) 0, 1 and more characters
-- '_' - exactly one character


--	 LIKE 'U%' - strings starting with 'U'
--	 LIKE '%a' - strings ending with 'a'
--	 LIKE '%John%' - strings containing(содержащие) 'John'
-- 	 LIKE 'J%n' - strings starting with 'J' and ending with 'n'
--	 LIKE '_oh_' - strings, where 2 and 3 characters - 'oh', and first and last characters - any
--	 LIKE '_oh%' - strings, where 2, 3 characters - 'oh', first is any and in the end 0, 1 or more any characters
_______________________________________________________________________________


--- select all the names of employees ending with 'n' ---

SELECT last_name, first_name
FROM employees
WHERE first_name LIKE '%n'


--- select all the names of employees starting with 'B' ---

SELECT last_name, first_name
FROM employees
WHERE last_name LIKE 'B%';

--- more examples ---

SELECT last_name, first_name
FROM employees
WHERE last_name LIKE '_uch%';



-- ## LIMIT ##

--- use LIMIT in select , use in the end query! ---

SELECT product_name, unit_price
FROM products
WHERE discontinued <> 1
ORDER BY unit_price DESC
LIMIT 5



-- ## NULL ##

--- select all orders where ship_region = Null and the next query without Null ---

SELECT ship_city, ship_region, ship_country
FROM orders
WHERE ship_region IS NULL;

SELECT ship_city, ship_region, ship_country
FROM orders
WHERE ship_region IS NOT NULL


-- ## GROUP BY ##

--- select weighing more than 50 by grouping them by countries to which we deliver ---

SELECT ship_country, COUNT(*)
FROM orders
WHERE freight > 50
GROUP BY ship_country
ORDER BY COUNT(*) DESC


--- select all product on sale grouped by id of category ---

SELECT category_id, SUM(units_in_stock)
FROM products
GROUP BY category_id
ORDER BY SUM(units_in_stock) DESC
LIMIT 5


-- ## HAVING - additional filtration ##

--- select all total price of products on sale with price > 5000 ---

SELECT category_id, SUM(unit_price * units_in_stock)
FROM products
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY SUM(unit_price * units_in_stock) DESC



-- ## UNION(объединение), INTERSECT(пересечение), EXCEPT(Исключение, разница) ##

--- select all countries where live all customers and employees without duplicates (just UNION) ---

SELECT country
FROM customers
UNION
SELECT country
FROM employees

--- same as above, only really all (with duplicates)

SELECT country
FROM customers
UNION ALL
SELECT country
FROM employees


--- select the list of countries where live customers and suppliers	 (INTERSECT) ---

SELECT country
FROM customers
INTERSECT
SELECT country
FROM suppliers


--- select all countries where live customers but don't live suppliers (EXCEPT) ---

SELECT country
FROM customers
EXCEPT
SELECT country
FROM suppliers


--- EXCEPT ALL looks at the number of duplicates and calculates the difference (customers(count of country) - suppliers(count of country))---

SELECT country
FROM customers
EXCEPT ALL
SELECT country
FROM suppliers
