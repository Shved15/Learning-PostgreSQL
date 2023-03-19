-- Lesson 8: SQL functions

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
