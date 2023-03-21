-- № 3: JOIN

________________________________________________________________
--JOIN (соединения):

	-- INNER JOIN (внутренние)
	-- LEFT JOIN, RIGHT JOIN
	-- FULL JOIN
	-- CROSS JOIN
	-- SELF JOIN
________________________________________________________________



--## INNER JOIN ##

--- display product name from product table, company name from suppliers table and goods on sale in stock---

SELECT product_name, suppliers.company_name, units_in_stock
FROM products
INNER JOIN suppliers ON products.supplier_id = suppliers.supplier_id
ORDER BY units_in_stock DESC


--- display how many units of good are on sale by product category ---

SELECT category_name, SUM(units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
GROUP BY category_name
ORDER BY SUM(units_in_stock) DESC
LIMIT 5


--- one more with INNER JOIN ---

SELECT category_name, SUM(unit_price * units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
WHERE discontinued <> 1
GROUP BY category_name
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY SUM(unit_price * units_in_stock) DESC


--- select which employees are assigned orders ---

SELECT order_id, customer_id, first_name, last_name, title
FROM orders
INNER JOIN employees ON orders.employee_id = employees.employee_id


--- work with three tables

SELECT order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id




--- more INNER JOIN ---

SELECT contact_name, company_name, phone, first_name, last_name, title,
	order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN products ON order_details.product_id = products.product_id
JOIN customers ON orders.customer_id = customers.customer_id
JOIN employees ON orders.employee_id = employees.employee_id
WHERE ship_country = 'USA'

-- the same, but with less text

SELECT contact_name, company_name, phone, first_name, last_name, title,
	order_date, product_name, ship_country, products.unit_price, quantity, discount
FROM orders
JOIN order_details USING(order_id)
JOIN products USING(product_id)
JOIN customers USING(customer_id)
JOIN employees USING(employee_id)
WHERE ship_country = 'USA'





--## LEFT JOIN ##
--- select all companies without orders ---

SELECT company_name, order_id
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id
WHERE order_id IS NULL

-- display all employees without orders ---

SELECT last_name, order_id
FROM employees
LEFT JOIN orders ON orders.employee_id = employees.employee_id
WHERE order_id IS NULL


--## SLEF JOIN ##

CREATE TABLE employee
(
	employee_id integer PRIMARY KEY,
	first_name varchar(255) NOT NULL,
	last_name varchar (255) NOT NULL,
	manager_id integer,
	FOREIGN KEY (manager_id) REFERENCES employee (employee_id)
);

INSERT INTO employee
(
	employee_id,
	first_name,
	last_name,
	manager_id
)
VALUES
	(1, 'Windy', 'Hays', NULL),
	(2, 'Ava', 'Christensen', 1),
	(3, 'Hassan', 'Conner', 1),
	(4, 'Anna', 'Reeves', 2),
	(5, 'Sau', 'Norman', 2),
	(6, 'Kelsie', 'Hays', 3),
	(7, 'Tory', 'Goff', 3),
	(8, 'Sallye', 'Lester', 3);


--- use self join ---

SELECT e.first_name || ' ' || e.last_name AS employee,
	   m.first_name || ' ' || m.last_name AS manager
FROM employee e
LEFT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY manager




--## NATURAL JOIN ##

--- natural join working like inner join, and the join itself goes through all columns that are named the same ---
--- natural join работает как inner join а само соединение проходит по всем столбцам, которые проименованны одинаково ---

SELECT order_id, customer_id, first_name, last_name, title
FROM orders
NATURAL JOIN employees


--!!! the problem is that this code is not explicit and can be bugged !!!
--!!!!!! DO NOT  USE IN NORMAL PRACTICE !!!!!!




--## ALIASES - псевдонимы ##

--- using aliases, you can name the resulting columns (syntax: 'AS' ) ---

SELECT COUNT(*) AS employees_count
FROM employees;

SELECT COUNT(DISTINCT country) AS country
FROM employees;

--!!! We can not use aliases in WHERE, because WHERE, and FROM work before SELECT,
--    but we can use ORDER BY and GROUP BY !!!


SELECT category_id, SUM(units_in_stock) AS units_in_stock
FROM products
GROUP BY category_id
ORDER BY units_in_stock DESC
LIMIT 5


SELECT category_id, SUM(unit_price * units_in_stock) AS total_price
FROM products
WHERE discontinued <> 1
GROUP BY category_id
HAVING SUM(unit_price * units_in_stock) > 5000
ORDER BY total_price DESC


__________________________________________________________________________________________________

-- practice after lesson

-- 1. Find customers and serve them with such employees as customers and employees from the city of London,
-- and delivery is carried out by Speedy Express. Display the customer's company and the full name of the employees.

--
	SELECT c.company_name AS customer,
       	  CONCAT(e.first_name, ' ', e.last_name) AS employee
	FROM orders as o
	JOIN customers as c USING(customer_id)
	JOIN employees as e USING(employee_id)
	JOIN shippers as s ON o.ship_via = s.shipper_id
	WHERE c.city = 'London'
 	AND e.city = 'London'
 	AND s.company_name = 'Speedy Express';



-- 2. Find active (see discontinued) products in the Beverages and Seafood categories that have fewer than 20 units on sale.
-- Display the name of the products, the number of units on sale, the supplier's contact name and phone number.

--
	SELECT product_name, units_in_stock, contact_name, phone
	FROM products
	JOIN categories USING(category_id)
	JOIN suppliers USING(supplier_id)
	WHERE category_name IN ('Beverages', 'Seafood')
	AND discontinued = 0
	AND units_in_stock < 20
	ORDER BY units_in_stock;


--3. Find customers who have not made a single order. Display customer name and order_id.

--
	SELECT distinct contact_name, order_id
	FROM customers
	LEFT JOIN orders USING(customer_id)
	WHERE order_id IS NULL
	ORDER BY contact_name;


--4. Rewrite the previous query using the symmetrical form of the join (hint: we are talking about LEFT and RIGHT).

--
	SELECT contact_name, order_id
	FROM orders
	RIGHT JOIN customers USING(customer_id)
	WHERE order_id IS NULL
	ORDER BY contact_name;
