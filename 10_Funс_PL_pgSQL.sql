-- № 10: PL/pgSQL

--- Syntax ---
CREATE FUNCTION func_name([arg1, arg2...]) RETURNS data_type AS $$
BEGIN
--logic
END; -- кавычки не обязательны
$$ LANGUAGE plpgsql;


BEGIN / END -- Method body (it's not about transactions)

---* need for *---

    --creating variables

    --the ability to use loos and there is a developed logic

    --Returning a value with RETURN (instead(вместо ) fo SELECT)
    -- or RETURN QUERY (in addition(в дополнение) to SELECT)


____________________________________________________________________________________________________________

--- ### Return and assignment ### ---



--*RETURN in plpgsql*--
--create function which return the sum og goods on sale
CREATE OR REPLACE FUNCTION get_total_number_of_goods() RETURNS bigint AS $$
BEGIN
	RETURN sum(units_in_stock)
	FROM products;
END;
$$ LANGUAGE plpgsql;

SELECT get_total_number_of_goods();


--return max price of goods that is discontinued(исключены из продаж)
CREATE OR REPLACE FUNCTION get_max_price_from_discontinued() RETURNS real AS $$
BEGIN
	RETURN MAX(unit_price)
	FROM products
	WHERE discontinued = 1;
END;
$$ LANGUAGE plpgsql;

SELECT get_max_price_from_discontinued();


-- function return max and min boundaries of goods price (with OUT)
CREATE OR REPLACE FUNCTION get_price_boundaries(OUT max_price real, OUT min_price real) AS $$
BEGIN
	--max_price := MAX(unit_price) FROM products;
	--min_price := MIN(unit_price) FROM products;
	SELECT MAX(unit_price), MIN(unit_price)
	INTO max_price, min_price
	FROM products;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_price_boundaries();


-- simple function for example
CREATE OR REPLACE FUNCTION get_sum(x int, y int, out result int) AS $$
BEGIN
	result = x + y;--same as result := x + y (присвоение)
	RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_sum(2, 3);


--function return customers filtred by country, and country is incoming argument
-- use RETURN QUERY
DROP FUNCTION IF EXISTS get_customers_by_country;
CREATE FUNCTION get_customers_by_country(customer_country varchar) RETURNS SETOF customers AS $$
BEGIN
	RETURN QUERY
	SELECT *
	FROM customers
	WHERE country = customer_country;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_customers_by_country('USA');

____________________________________________________________________________________________________________

--- ### Declaring variables ### ---

--Syntax--

CREATE FUNCTION func_name([arg1, arg2...]) RETURNS data_type AS $$
DECLARE
    -- assignment
    variable type;
BEGIN
--logic
END;
$$ LANGUAGE plpgsql;




-- function calculates square of triangle by sides
DROP FUNCTION IF EXISTS get_square;
CREATE OR REPLACE FUNCTION get_square(ab real, bc real, ac real) RETURNS real AS $$
DECLARE
	perimeter real;
BEGIN
	perimeter:=(ab+bc+ac)/2;
	return sqrt(perimeter * (perimeter - ab) * (perimeter - bc) * (perimeter - ac));
END;
$$ LANGUAGE plpgsql;

SELECT get_square(6, 6, 6);


-- calculate average unit_price of goods
CREATE OR REPLACE FUNCTION calc_middle_price()
RETURNS SETOF products AS $$

	DECLARE
		average_price real;
		low_price real;
		top_price real;
	BEGIN
		SELECT AVG(unit_price) INTO average_price
		FROM products;

		low_price := average_price * .75;
		top_price := average_price * 1.25;

		RETURN QUERY SELECT * FROM products
		WHERE unit_price BETWEEN low_price AND top_price;
	END;
$$ LANGUAGE plpgsql;

SELECT * FROM calc_middle_price();

____________________________________________________________________________________________________________

--- ### Logic with IF / ELSE ### ---

--Syntax--
IF expression THEN
    logic
ELSIF expression THEN -- can use ELSEIF
    logic
ELSIF expression THEN
    logic
ELSE
    logic
END IF;



--*IF-THEN-ELSE*--
--A function that converts fahrenheit to celsius and vice versa depending on the flag passed as an argument
DROP FUNCTION IF EXISTS convert_temp_to;
CREATE OR REPLACE FUNCTION convert_temp_to(temperature real, to_celsius bool DEFAULT true) RETURNS real AS $$
DECLARE
	result_temp real;
BEGIN
	IF to_celsius THEN
		result_temp = (5.0/9.0)*(temperature-32);
	ELSE
		result_temp:=(9*temperature+(32*5))/5.0;
	END IF;

	RETURN result_temp;
END;
$$ LANGUAGE plpgsql;

--fahtenheit to celcius
SELECT convert_temp_to(80);
--celcius to fahrenheit
SELECT convert_temp_to(26.7, false);



--*IF-ELSIF-ELSE*--
--the function takes the number of the month as an argument, and returns the name of the season of the year
CREATE OR REPLACE FUNCTION get_season(month_number int) RETURNS text AS $$
DECLARE
	season text;
BEGIN
	IF month_number BETWEEN 3 AND 5 THEN
		season = 'Spring';
	ELSIF month_number BETWEEN 6 AND 8 THEN
		season = 'Summer';
	ELSIF month_number BETWEEN 9 AND 11 THEN
		season = 'Autumn';
	ELSE
		season = 'Winter';
	END IF;

	RETURN season;

END;
$$ LANGUAGE plpgsql;

SELECT get_season(12);

____________________________________________________________________________________________________________


--- ### Loops in PL/pgSQL ### ---

--Syntax--

* WHILE expression
  LOOP
      logic
  END LOOP;


* LOOP
      EXIT WHEN expression
      logic
  END LOOP;


* FOR counter IN a..b [BY x]
  LOOP
      logic
  END LOOP;


* CONTINUE WHEN expression




-- Fibonacci sequence: 1, 1, 2, 3, 5, 8, 13, 21...
CREATE OR REPLACE FUNCTION fibonacci (n integer)
   RETURNS integer AS $$
DECLARE
   counter integer := 0 ;
   i integer := 0 ;
   j integer := 1 ;
BEGIN
   IF (n < 1) THEN
      RETURN 0 ;
   END IF;

   WHILE counter <= n
   LOOP
      counter := counter + 1 ;
      SELECT j, i + j INTO i, j;
   END LOOP ;

   RETURN i ;
END ;
$$ LANGUAGE plpgsql;

SELECT fibonacci(7);

-- rewritten with explicit exit instead if WHILE--
CREATE OR REPLACE FUNCTION fibonacci (n integer)
   RETURNS integer AS $$
DECLARE
   counter integer := 0 ;
   i integer := 0 ;
   j integer := 1 ;
BEGIN

   IF (n < 1) THEN
      RETURN 0 ;
   END IF;

   LOOP
      EXIT WHEN counter > n;
      counter := counter + 1 ;
      SELECT j, i + j INTO i,   j ;
   END LOOP ;

   RETURN i ;
END ;
$$ LANGUAGE plpgsql;

SELECT fibonacci(7);



-- FOR IN --
-- function without returning - anonymous piece of code
DO $$
BEGIN
   FOR counter IN 1..5 LOOP
   		RAISE NOTICE 'Counter: %', counter;
   END LOOP;
END; $$

DO $$
BEGIN
   FOR counter IN REVERSE 5..1 LOOP
      RAISE NOTICE 'Counter: %', counter;
   END LOOP;
END; $$


DO $$
BEGIN
  FOR counter IN 1..6 BY 2 LOOP
    RAISE NOTICE 'Counter: %', counter;
  END LOOP;
END; $$

____________________________________________________________________________________________________________


--- ### RETURN NEXT ### ---

--Sometimes it is necessary to accumulate(накапливать) records in the result set (row-by-row processing)
--this expression can be called multiple times and each call will result in a new row in the output dataset.
* RETURN NEXT expression



CREATE OR REPLACE FUNCTION return_setof_int() RETURNS SETOF int AS
$$
BEGIN
  RETURN NEXT 1;
  RETURN NEXT 2;
  RETURN NEXT 3;
  RETURN; -- Optional (Необязательный)
END
$$ LANGUAGE plpgsql;

SELECT * FROM return_setof_int();


--the function goes through the products, processes each line: if the category of goods
--falls into a certain id, then we reduce or increase the price and sequentially accumulate it
CREATE OR REPLACE FUNCTION after_christmas_sale() RETURNS SETOF products AS $$
DECLARE
	product record;
BEGIN
	FOR product IN
		SELECT * FROM products
	LOOP
		IF product.category_id IN (1,4,8) THEN
			product.unit_price = product.unit_price * .80;
		ELSIF product.category_id IN (2,3,7) THEN
			product.unit_price = product.unit_price * .75;
		ELSE
			product.unit_price = product.unit_price * 1.10;
		END IF;
		--accumulate in result set
		RETURN NEXT product;
	END LOOP;

	RETURN;

END;
$$ LANGUAGE plpgsql;

SELECT * FROM after_christmas_sale();


--- !!! it is desirable to avoid such loops as they lose performance compared to pure SQL
--желательно избегать таких циклов так как они теряют производительность в сравнении с чистым SQL !!!
