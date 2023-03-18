--Lesson 3: SUBQUERIES

--SUBQUERIES

    -- Queries can be logically complex (Запросы могут быть логически сложными)

    -- If it is not possible to implement the request immediately, you must try to write a subquery that solves part
    -- of the problem (Если не получается реализовать запрос сразу, необходимо пробовать написать подзапрос, решающий
    -- часть задачи)

    -- There are tasks that are either impossible or very difficult to implement without subqueries
    -- (Бывают задачи, которые без подзапросов реализовать либо невозможно, либо очень затруднительно)

    -- Often a query with a subquery can be rewritten to get rid of the subquery (usually with a join)
    -- (Часто запрос с подзапросом можно переписать так, что бы избавиться от подзапроса (обычно с помощью соединения))

    -- If it is possible to get rid of the subquery - do we need to do this?
    -- (Если можно избавиться от подзапроса - необходимо ли нам это делать?)

        -- not required, depends on circumstances
        -- не обязательно, зависит от обстоятельств

        -- if a query with a subquery is as productive as a query with a join, focus on readability
        -- если запрос с подзапросом также производителен как и запрос с соединением, ориентируйся на читабельность

        -- often the planner expands queries with subqueries into queries with joins
        -- часто планировщик раскрывает запросы с подзапросами в запросы с соединениями




--- what if we want to find all supplier (поставщиков) companies from the countries where customers place orders ---

SELECT company_name
FROM suppliers
WHERE country IN (SELECT country FROM customers)

    --equivalent query--
    SELECT DISTINCT suppliers.company_name
    FROM suppliers
    JOIN customers USING(country)



--- If we want to display the sum of product units divided into groups, element the result set with a number that
--- needs to be calculated, finding the smallest product_id + 4
--- Если мы хотим вывести сумму единиц товара разбитых на группы, элементировать результирующий набор числом,
--- который нужно вычислить, найдя наименьший product_id + 4

SELECT category_name, SUM(units_in_stock)
FROM products
INNER JOIN categories ON products.category_id = categories.category_id
GROUP BY category_name
ORDER BY SUM(units_in_stock) DESC
LIMIT (SELECT MIN(product_id) + 4 FROM products)


---average number of items in stock---
SELECT AVG(units_in_stock)
FROM products


--- display items with more than average stock ---
SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock > (SELECT AVG(units_in_stock)
                        FROM products)
ORDER BY units_in_stock


--## WHERE EXISTS ##
--- select companies and names of customers who made orders weighing from 50 to 100 ---
SELECT company_name, contact_name
FROM customers
WHERE EXISTS (SELECT customer_id FROM orders
              WHERE customer_id=customers.customer_id AND
              freight BETWEEN 50 AND 100);


--- select companies and customer names that placed orders between February 1st 95 and February 15th of the same year---
SELECT company_name, contact_name
FROM customers
WHERE EXISTS (SELECT customer_id FROM orders
              WHERE customer_id=customers.customer_id AND
               order_date BETWEEN '1995-02-01' AND '1995-02-15');


    --who did not make such orders
    SELECT company_name, contact_name
    FROM customers
    WHERE NOT EXISTS (SELECT customer_id FROM orders
                      WHERE customer_id=customers.customer_id AND
                      order_date BETWEEN '1995-02-01' AND '1995-02-15');


--- select products that were not purchased between February 1st 95 and February 15 of the same year ---
SELECT product_name
FROM products
WHERE NOT EXISTS (SELECT orders.order_id FROM orders
                  JOIN order_details USING(order_id)
              	  WHERE order_details.product_id=products.product_id AND
                  order_date BETWEEN '1995-02-01' AND '1995-02-15');



--## Subqueries with ANY, ALL quantifiers(квантификаторы) ##
---select all unique customer companies that placed orders for more than 40 items---

    -- with JOIN
    SELECT DISTINCT company_name
    FROM customers
    JOIN orders USING(customer_id)
    JOIN order_details USING(order_id)
    WHERE quantity > 40;

    -- with subquery
    SELECT DISTINCT company_name --from course
    FROM customers
    WHERE customer_id = ANY(SELECT customer_id FROM orders
                            JOIN order_details USING(order_id)
                            WHERE quantity > 40);



--- we can combine joins with subqueries ---

    -- average number of items across all orders --
    SELECT AVG(quantity)
    FROM order_details;

    -- select such products, the number of which is more than the average for orders
    -- using the previous query as a subquery, we can write the following query:
    SELECT DISTINCT product_name, quantity
    FROM products
    JOIN order_details USING(product_id)
    WHERE quantity >
        (SELECT AVG(quantity)
        FROM order_details)
    ORDER BY quantity;



--- find all products whose quantity is greater than the average value of the number of ordered products
--- from groups obtained(полученных) by grouping(группированием) by product_id
SELECT DISTINCT product_name, quantity
FROM products
JOIN order_details USING(product_id)
WHERE quantity > ALL (SELECT AVG(quantity)
					  FROM order_details
					  GROUP BY product_id)
ORDER BY quantity;


________________________________________________________________________________________________________

---PRACTICE AFTER LESSON


--- 1. Display products whose quantity on sale is less than the smallest average quantity of products in order details
--- (grouped by product_id). The resulting table should have product_name and units_in_stock columns.
SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock < ALL (SELECT AVG(quantity)
							FROM order_details
							GROUP BY product_id)
ORDER BY units_in_stock DESC;


--- 2. Write a query that displays the total amount of order freights for ordering companies for orders whose
--- freight cost is greater than or equal to the average freight cost of all orders, and the order shipment date
--- must be in the second half of July 1996. The resulting table should have columns customer_id and freight_sum,
--- the rows of which should be sorted by the amount of freight orders.

--- Напишите запрос, который выводит общую сумму фрахтов заказов для компаний-заказчиков для заказов,
--- стоимость фрахта которых больше или равна средней величине стоимости фрахта всех заказов, а также дата отгрузки
--- заказа должна находится во второй половине июля 1996 года. Результирующая таблица должна иметь колонки customer_id
--- и freight_sum, строки которой должны быть отсортированы по сумме фрахтов заказов.
SELECT o.customer_id, SUM(o.freight) AS freight_sum
FROM orders AS o
INNER JOIN (SELECT customer_id, AVG(freight) AS freight_avg
            FROM orders
            GROUP BY customer_id) AS oa
ON oa.customer_id = o.customer_id
WHERE o.freight >= oa.freight_avg
AND o.shipped_date BETWEEN '1996-07-16' AND '1996-07-31'
GROUP BY o.customer_id
ORDER BY freight_sum;



--- 3. Write a query that returns the top 3 orders that were created after September 1, 1997 and shipped to countries
--- in South America. The total cost is calculated as the sum of the cost of the order details, taking into account the
--- discount. The resulting table should have customer_id, ship_country and order_price columns, the rows of which
--- should be sorted by order value in reverse order.
SELECT customer_id, ship_country, order_price
FROM orders
INNER JOIN (SELECT order_id, SUM(unit_price * quanTity - unit_price * quantity * discount) AS order_price
			FROM order_details
			GROUP BY order_id) AS od
USING(order_id)
WHERE ship_country IN ('Argentina' , 'Bolivia', 'Brazil', 'Chile', 'Colombia', 'Ecuador',
					   'Guyana', 'Paraguay', 'Peru', 'Suriname', 'Uruguay', 'Venezuela')
AND order_date >= '1997-09-01'
ORDER BY order_price DESC
LIMIT 3;



--- 4. Display all products (unique names of products) of which exactly 10 units are ordered
--- (of course, this can be solved without a subquery).

    -- without subquery
    SELECT DISTINCT product_name, quantity
    FROM products
    INNER JOIN order_details USING(product_id)
    WHERE order_details.quantity = 10

    -- with subquery
    SELECT product_name
    FROM products
    WHERE product_id = ANY(SELECT product_id
                        FROM order_details
                        WHERE quantity = 10);
