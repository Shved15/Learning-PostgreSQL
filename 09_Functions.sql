-- № 9: SQL functions

-- * A function is a database object that takes arguments and returns a result.
-- (Функция это обхект ДБ, принимающий аргументы и возвращающий результат)

-- * What if there is client code polling the db (Что если есть клиентский код, опрашивающий ДБ)?

-- * Functions (stored procedures) are compiled and stored on the DB side. So their call is cheap
-- Функции(хранимые процедуры) - компилируемы и хранятся на стороне ДБ. Поэтому их вызов стоит дешево

-- * Differentiation between Frontent-dev and Server-side dev
-- (Разграничение работы Frontent-dev and Server-side dev)

-- * Keep code that works with tuples more logically closer to the data (SRP)
--Хранить код который работает с кортежами логичнее ближе к данным(SRP)
--(The Single Responsibility Principle, SRP - принцип единственной ответственности)

--* Reusability of functions by different client applications
--Переиспользуемость функций разными клиентскими приложениями

--* Security management through feature access throttling
--Управление безопасностью через регулирование доступа к функциям

--* Reducing network traffic
--Уменьшение трафика на сеть

--* Modular programming. What if you need to generate random numbers from 1 to 10 in different SQL scripts?
--Модульное программирование. Что если нужна генерация случайных чисел от 1 до 10 в разных SQL-скриптах?




--- Functions in Postgres ---

    -- Consist of a set of statements, returning the result of the last
    -- Состоят из набора утверждений, возвращая результат последнего

    -- Functions may contain SELECT, INSERT, UPDATE, DELETE(CRUD-create read update delete)

    -- Functions cannot contain COMMIT, SAVEPOINT(TCL), VACUUM(utility)

    ---Types PostgreSQL functions---

        --SQL functions

        --Procedural (PL/pgSQL - main dialect)

        --Server functions (written in C)

        --Own c-functions




--- Syntax creating fucntions ---
CREATE FUNCTION func_name([arg1, arg2...]) RETURNS data_type AS $$
--logic
$$ LANGUAGE lang


CREATE OR REPLACE func_name ...-
-- Modifies an already existing function with the same name
--(модифицирует уже существующую функцию с таким наименованием)

--REPLACE of fuctions has roughly the same limitations as REPLACE of views
-- REPLACE функций имеет примерно те же ограничения, что и REPLACE представлений

________________________________________________________________________________________________________


--- ### Write firsts functions ### ---


-- make select in temporary table for training
SELECT *
INTO tmp_customers
FROM customers;

SELECT *
FROM tmp_customers;

--update region
UPDATE tmp_customers
SET region = 'unknown'
WHERE region IS null


--what if this code is going to be called from the client's side?
CREATE OR REPLACE FUNCTION fix_customer_region() RETURNS void AS $$
	UPDATE tmp_customers
    SET region = 'unknown'
    WHERE region IS null
$$ LANGUAGE SQL;


--show functions section in pgAdmin
--then demonstrate
SELECT fix_customer_region();

-- region is updated
SELECT *
FROM tmp_customers;

________________________________________________________________________________________________________

--- ### Scalar functions ### ---

CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint AS $$
	SELECT SUM(units_in_stock)
	FROM products
$$ LANGUAGE SQL;

SELECT get_total_number_of_goods() AS total_goods; --as in function itself will be ignored


-- calculate averege price for all goods
CREATE OR REPLACE FUNCTION get_avg_price() RETURNS real AS $$
	SELECT AVG(unit_price)
	FROM products
$$ LANGUAGE SQL;

SELECT get_avg_price() AS avg_price;

________________________________________________________________________________________________________

--Argguments of functions in Postgres: IN, OUT, DEFAULT---


--Functions in Postgres:
    -- * IN - incoming(входящие) arguments

    -- * INOUT - outgoing(исходящие) arguments

    -- * VARIADIC - array of input parameters

    -- * DEFAULT value

CREATE OR REPLACE FUNCTION get_product_price_by_name(prod_name varchar) RETURNS real AS $$
	SELECT unit_price
	FROM products
	WHERE product_name = prod_name
$$ language sql;

-- at now client code can using our function
SELECT get_product_price_by_name('Chocolade') AS price;

SELECT *
FROM products;


--what if the client code wants to get the price bounds of all products
DROP FUNCTION IF EXISTS get_price_boundaries;
CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real) AS $$
	SELECT MAX(unit_price), MIN(unit_price)
	FROM products
$$ LANGUAGE SQL;

SELECT get_price_boundaries() AS price;

-- same with different columns
SELECT * FROM get_price_boundaries();



-- functions returns with discontinued
DROP FUNCTION IF EXISTS get_price_boundaries_by_discontinuity;
CREATE OR REPLACE FUNCTION get_price_boundaries_by_discontinuity(IN is_discontinued int, OUT max_price real, OUT min_price real) AS $$
	SELECT MAX(unit_price), MIN(unit_price)
	FROM products
	WHERE discontinued = is_discontinued
$$ LANGUAGE SQL;

-- RECORD
select get_price_boundaries_by_discontinuity(1);

--WITH TWO COLUMNS
SELECT * FROM get_price_boundaries_by_discontinuity(1);


-- USE DEFAULT
DROP FUNCTION IF EXISTS get_price_boundaries_by_discontinuity;
CREATE OR REPLACE FUNCTION get_price_boundaries_by_discontinuity
	 (IN is_discontinued int DEFAULT 1, OUT max_price real, OUT min_price real) AS $$
	SELECT MAX(unit_price), MIN(unit_price)
	FROM products
	WHERE discontinued = is_discontinued
$$ LANGUAGE SQL;


SELECT get_price_boundaries_by_discontinuity(); --with default
SELECT get_price_boundaries_by_discontinuity(0);
SELECT get_price_boundaries_by_discontinuity(1);

________________________________________________________________________________________________________


--- ### Return multiply rows (set strings) ### ---
* RETURNS SETOF data_type -- return n-values of data_type type

* RETURNS SETOF table -- if need to return all columns from table or custom(пользовательского) type

* RETURNS SETOF record -- only when the column types in the result set are not known in advance(заранее неизвестны)

* RETURNS TABLE(column_name, data_type, ...) -- the same as setof table, but we have the ability to explicitly specify the returned columns

* Return via out-parameters



--*if we need to return average prices sorted by product category*--
CREATE OR REPLACE FUNCTION get_average_prices_by_product_categories()
		RETURNS SETOF double precision AS $$

	SELECT AVG(unit_price)
	FROM products
	GROUP BY category_id

$$ LANGUAGE SQL;

SELECT * FROM get_average_prices_by_product_categories() AS average_prices;


--*How to return a set of columns*--
--*With OUT parameters*--
drop function if exists get_average_prices_by_product_categories;
CREATE OR REPLACE FUNCTION get_average_prices_by_product_categories(OUT sum_price real, OUT avg_price float8)
		RETURNS SETOF RECORD AS $$

	SELECT SUM(unit_price), AVG(unit_price)
	FROM products
	GROUP BY category_id;

$$ LANGUAGE SQL;

SELECT sum_price FROM get_average_prices_by_product_categories();
select sum_price, avg_price from get_average_prices_by_product_categories();


--won't work
SELECT sum_of, in_avg FROM get_average_prices_by_product_categories();

--will work
SELECT sum_price AS sum_of, avg_price AS in_avg
FROM get_average_prices_by_product_categories();


--*How to return a set of columns*--
--*WithOUT OUT parameters*--
DROP FUNCTION IF EXISTS get_average_prices_by_product_categories;
CREATE OR REPLACE FUNCTION get_average_prices_by_product_categories()
		RETURNS SETOF RECORD AS $$

	SELECT SUM(unit_price), AVG(unit_price)
	FROM products
	GROUP BY category_id;

$$ LANGUAGE SQL;

--won't work in all 4 syntax options
SELECT sum_price FROM get_average_prices_by_product_categories();
SELECT sum_price, avg_price FROM get_average_prices_by_product_categories();
SELECT sum_of, in_avg FROM get_average_prices_by_product_categories();
SELECT * FROM get_average_prices_by_product_categories();

--works only this
SELECT * FROM get_average_prices_by_product_categories() AS (sum_price real, avg_price float8);



---*a function that returns customers sorted by country*--
DROP FUNCTION IF EXISTS get_customers_by_country;
CREATE OR REPLACE FUNCTION get_customers_by_country(customer_country varchar)
		RETURNS TABLE(char_code char, company_name varchar) AS $$

	SELECT customer_id, company_name
	FROM customers
	WHERE country = customer_country

$$ LANGUAGE SQL;


--The rule is the same as when we use RETURNS SETOF
SELECT * FROM get_customers_by_country('USA');
SELECT company_name FROM get_customers_by_country('USA');
SELECT char_code, company_name FROM get_customers_by_country('USA');


---*setof table*---
DROP FUNCTION IF EXISTS get_customers_by_country;
CREATE OR REPLACE FUNCTION get_customers_by_country(customer_country varchar)
		RETURNS SETOF customers AS $$

	-- won't work: select company_name, contact_name
	SELECT *
	FROM customers
	WHERE country = customer_country

$$ LANGUAGE SQL;

SELECT * FROM get_customers_by_country('USA');
