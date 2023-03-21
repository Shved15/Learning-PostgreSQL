--- № 7: VIEW ---

-- View is a saved query in the form of a DB object (virtual table)
--(сохраненный запрос в виде обхекта ДБ(виртуальная таблица))

-- To the view, we can do the usual SELECT

-- Views can be connected(JOIN), and so on.

-- The performance is the same as a regular table (if we compare comparable things)
-- Производительность такая же, как и у обычной таблицы (если сравниваем сопоставимые вещи)

-- Allows you to do caching using materialization
-- Позволяет делать кэширование с помощью материализации

-- Allows you to shorten complex queries
-- Позволяет сокращать сложные запросы

-- Allows you to undermine a real table
-- Позволяет подминить реальную таблицу

-- Allows you to create virtual tables that connect multiple tables
-- Позволяет создавать виртуальные таблицы, которые соединяют несколько таблиц

-- Allows you to hide the logic of data aggregation when working through ORM(object-relational mapping)
-- Позволяет скрыть логику агрегации данных при работе через ORM(Объектно-реляционное отображение)

-- Allows you to hide information (columns) from user groups
-- Позволяет скрыть информацию (столбцы) от групп пользователей

-- Allows you to hide information at the row level from user groups (rows are cut off by the query itself)
-- Позволяет скрыть информацию на уровне строк от групп пользователей (строки отсекаются самим запросом)




--- VIEW TYPES ---

    --* Тemporary (временные)
    --* Recursive (рекурсивные)
    --* Updated (обновляемые)
    --* Materializable (материализуемые)



--- Create View ---

CREATE VIEW view_name AS
SELECT select_statement



--- Changing views ---

  -- You can only add new columns
      -- can't delete existing columns
      -- can't change column names
      -- you can't change the order of the columns

CREATE OR REPLACE VIEW view_name AS
SELECT select_statement

  -- Views can be renamed
  ALTER VIEW old_view_name RENAME TO new_view_name

  -- Views can be deleted
  DROP VIEW [IF EXISTS] view_name



--- Modifying data through a view (Модификация данных через представление) ---

    -- There is only one table in FROM
    -- There is not DISTINCT, GROUP BY, HAVING, UNION, INTERSECT, EXCEPT, LIMIT
    -- There is not window functions: MIN, MAX, SUM, COUNT, AVG
    -- WHERE is not allowed (не под запретом)

___________________________________________________________________________________________________

--- ### CREATE VIEWS ### ---

-- create view with join products, suppliers and categories
CREATE VIEW products_suppliers_categories AS
SELECT product_name, quantity_per_unit, unit_price, units_in_stock,
company_name, contact_name, phone,
category_name, description
FROM products
JOIN suppliers USING (supplier_id)
JOIN categories USING (category_id);


SELECT *
FROM products_suppliers_categories;

-- with filter
SELECT *
FROM products_suppliers_categories
WHERE unit_price > 20;

--delete view
DROP VIEW IF EXISTS products_suppliers_categories;

___________________________________________________________________________________________________

--- ### Updated views ### ---

SELECT * FROM orders;

-- create heavy orders view with filter
CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 50;

SELECT *
FROM heavy_orders
ORDER BY freight;

-- update heavy_orders view with changing filter
CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 100;


CREATE OR REPLACE VIEW products_suppliers_categories AS
SELECT product_name, quantity_per_unit, unit_price, units_in_stock, discontinued,
company_name, contact_name, phone, country,
category_name, description
FROM products
JOIN suppliers USING (supplier_id)
JOIN categories USING (category_id);

-- rename view
ALTER VIEW products_suppliers_categories RENAME TO psc_old;


SELECT MAX(order_id)
FROM orders;

-- insert data into view
INSERT INTO heavy_orders
VALUES (11078, 'VINET', 5, '2019-12-10', '2019-12-15', '2019-12-14', 1, 120,
		'Hanari Carnes', 'Rua do Paco', 'Bern', NULL, 3012, 'Switzerland');

SELECT *
FROM heavy_orders
ORDER BY order_id DESC;

--we cannot delete what is not in the view itself
SELECT MIN(freight)
FROM orders;

--the request was completed, but nothing was deleted
DELETE FROM heavy_orders WHERE freight < 0.05;


--delete what is in the view
SELECT MIN(freight)
FROM heavy_orders;

-- interferes with the foreign key constraint
DELETE FROM heavy_orders WHERE freight < 100.25;


-- at first time delete
DELETE FROM order_details
WHERE order_id = 10854;

-- at now complete
DELETE FROM heavy_orders WHERE freight < 100.25;

-- data changed
SELECT MIN(freight)
FROM heavy_orders;

___________________________________________________________________________________________________

--- ### CHECK in VIEWS ### ---

CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 100;

SELECT *
FROM heavy_orders
ORDER BY freight;


-- if we wnat insert freght < 100 completed?
INSERT INTO heavy_orders
VALUES(11900, 'FOLIG', 1, '2000-01-01', '2000-01-05', '2000-01-04', 1, 80, 'Folies gourmandes', '184, chaussee de Tournai',
	   'Lille', NULL, 59000, 'FRANCE');

-- result is nothing
SELECT *
FROM heavy_orders
WHERE order_id = 11900;

-- show responce
SELECT *
FROM orders
WHERE order_id = 11900;

-- so that the filter applied in WHERE is taken into account when inserting data through VIEW
-- we should use WITH LOC.. CHECK ...
CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 100
WITH LOCAL CHECK OPTION;

-- error - new row violates check option for view "heavy_orders"
INSERT INTO heavy_orders
VALUES(11999, 'FOLIG', 1, '2000-01-01', '2000-01-05', '2000-01-04', 1, 80, 'Folies gourmandes', '184, chaussee de Tournai',
	   'Lille', NULL, 59000, 'FRANCE');

-- CASCADE - The check will also be valid for the underlying views
CREATE OR REPLACE VIEW heavy_orders AS
SELECT *
FROM orders
WHERE freight > 100
WITH CASCADE CHECK OPTION;

___________________________________________________________________________________________________

--- Practice after lesson


-- 1. Create a view that displays the following columns:
-- order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers и employees.
-- Сделать select к созданному представлению, выведя все записи, где order_date больше 1го января 1997 года.

-- 2. Create a view that displays the following columns:
-- order_date, required_date, shipped_date, ship_postal_code, ship_country, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers, employees.
-- Try adding the ship_country, postal_code, and reports_to columns to the view (after it's been created). Verify that an error occurs. Rename the view and create a new one with additional columns.
-- Make a request to it, selecting all records, sorting them by ship_county.
-- Delete the renamed view.

-- 3. Create a view of "active" (discontinued = 0) products containing all columns. The view must be protected from inserting records where discontinued = 1.
-- Try to insert a record with the discontinued = 1 field - make sure it doesn't work.


--1
CREATE VIEW orders_customers_employees AS
SELECT order_date, required_date, shipped_date, ship_postal_code,
company_name, contact_name, phone,
last_name, first_name, title
FROM orders
JOIN customers USING (customer_id)
JOIN employees USING (employee_id);

SELECT *
FROM orders_customers_employees
WHERE order_date > '1997-01-01';


--2
ALTER VIEW orders_customers_employees RENAME TO oce_old;

CREATE VIEW orders_customers_employees AS
SELECT order_date, required_date, shipped_date, ship_postal_code, ship_country
company_name, contact_name, phone, customers.postal_code
last_name, first_name, title, reports_to
FROM orders
JOIN customers USING (customer_id)
JOIN employees USING (employee_id);

SELECT *
FROM orders_customers_employees
WHERE order_date > '1997-01-01';

DROP VIEW IF EXISTS oce_old;

--3

CREATE VIEW active_products AS
SELECT * FROM products
WHERE discontinued <> 1
WITH LOCAL CHECK OPTION;

INSERT INTO
VALUES (78, 'abc', 1, 1, 'abc', 1, 1, 1, 1, 1);
