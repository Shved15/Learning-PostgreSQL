-- lesson 1 - Introduction in Postgres

--Database - a collection of related data (База данных - набор взаимосвязаныых данных)


--DBMS(Database management system - a set of software tools for data management)
--СУБД(Система управления базами данных - комплекс программных средств для управления данными)


-- DBMS types:
--	 File-server: Microsoft Access
--	 Client-server: MySQL, PostgreSQL...
--	 Built-in: SQLite



--Basic Client-server DBMS:
--	 MySQL
--	 PostgreSQL
--	 Oracle
--	 MS SQL
--	 Maria DB
--Все вышеперечисленные СУБД реляционные и все они поддерживают	язык SQL(Structured Query Language - язык структурированных запросов)
--All of the above DBMS are relational and they all support the language SQL(Structured Query Language)


--relation DBMS:

-- The theoretical basis is relational algebra (Теоретической основой служит реляционная алгебра)

-- Relational algebra defines a system of operations on relations (tables): union, intersection, subtraction, join, etc.
-- Реляционная алгебра определяет систему операций над отношениями(таблицами): объединение, пересечение, вычитание, соединение и т.д.

-- All operations are expressed via SQL
-- Все операции выражаются через SQL


-- Relation model:
--	    Entity - e.g. customers, orders, suppliers (Сущность - например, клиенты, заказы, поставщики)
--	    Table - relation (Таблица - отношение)
--	    Column - attribute (Столбец - атрибут)
--	    String / entry - tuple (Строка / запись - кортеж)
--	    Result set - query result (Результирующий набор - результат запроса) SQL:
                                                            SELECT contact_name, address, city FROM customers LIMIT 13


--SQL - Structured Query Language :
	-- SQL is a non-procedural language and not a general purpose language(SQL непроцедурный язык и не язык общего назначения)
	-- The result of the SQL query is the result set (Результатом SQL запроса является результирующий набор) (usually - table)


--Категории запросов в SQL:
	-- DDL(Data Definition Language) - CREATE, ALTER, DROP
	-- DML(Data Manipulation Language) - SELECT, INSERT, UPDATE, DELETE
	-- TCL(Transaction Control Language) - COMMIT, ROLLBACK, SAVEPOINT
	-- DCL(Data Control Language) - GRANT, REVOKE, DENY
	-- ANSI SQL-92

	-- Differences in procedural extensions (Различия в процедурных расширениях:)
	        --PL/pgSQL in PostgreSQL, PL/SQL in Oracle, T-SQL in MS SQL




--Pluses of the PostgreSQL:
	-- Free(open source)
	-- Easy install
	-- Well supported transactionality out of the box (Хорошо поддерживается транзакционность из коробки)



Основные типы данных

__________________________________________________________________________________________________________________________________________________
               | Name                          |    Bytes (in memory)  |        Description         |   Range (диапазон доступных значений)
_______________|_______________________________|_______________________|____________________________|______________________________________________
		       | smallint	                   |            2          | small-range integer        | 2ˆ16 -> -32.768 to 32.767
Integral	   |_______________________________|_______________________|____________________________|_____________________________________________
Numbers		   | integer                       |           4           | typical choice for integer | 2ˆ32 -> -2.147.483.648 to 2....647
			   |_______________________________|_______________________|____________________________|_____________________________________________
			   | bigint                        |           8           |large-range integer         | 2ˆ64 -> -9.223.372.036.854.775.808 to 9...807
_______________|_______________________________|_______________________|____________________________|_____________________________________________
               | decimal / numeric             |        variable       | user-specified precision,  | +-3.4 * 10ˆ38 to +3.4 * 10ˆ38
               |                               |                       | exact                      |
Real           |_______________________________|_______________________|____________________________|_____________________________________________
numeric        | real / float4                 |            4          | user-specified precision,  | 6 decimal digits precision
               |                               |                       | inexact                    |
               |_______________________________|_______________________|____________________________|_____________________________________________
               | double precision / float8 /   |            8          | user-specified precision,  | 15 decimal digits precision
               | float                         |                       | inexact                    |
_______________|_______________________________|_______________________|____________________________|_____________________________________________



___________________________________________________________________________________________________________________________________________________
		        |         Name        |    Bytes    |    Description                              | Range
________________|_____________________|_____________|_____________________________________________|________________________________________________
 Integral       | small serial        |     2       |  autoincrementing small-range integer       | 1 to 32.767
 Numbers        |_____________________|_____________|_____________________________________________|________________________________________________
  		        | serial		      |     4       |  autoincrementing mid-range integer         | 1 to 2.147.483.647
                |_____________________|_____________|_____________________________________________|________________________________________________
                | biserial            |     8       |  autoincrementing large-range integer       | 1 to 9.223.372.036.854.775.807
________________|_____________________|_____________|_____________________________________________|________________________________________________
		        | char		          |   variable  | fixed-length character string               | based on encoding
		        |_____________________|_____________|_____________________________________________|________________________________________________
Characters      | varchar             |   variable  | fixed-length character string               | based on encoding
                |_____________________|_____________|_____________________________________________|________________________________________________
       	        | text		          |   variable  | fixed-length character string               | based on encoding
________________|_____________________|_____________|_____________________________________________|________________________________________________
		        |			          |	            |							                  |
Logical	        | Boolean / bool	  |      1      | used in logic                               | True / False
________________|_____________________|_____________|_____________________________________________|________________________________________________


Категории типов которая отвечает за представление даты и времени

___________________________________________________________________________________________________________________________________________________
		    |       Name    |  Bytes   |            Description                        |     Range
____________|_______________|__________|_______________________________________________|________________________________________________________
		    | date          |    4     | stores only date                              | 4713 B.C. -> 294.276 AD
		    |_______________|__________|_______________________________________________|________________________________________________________
		    | time	        |    8     | stores only date                              | 00:00:00 -> 24:00:00
            |_______________|__________|_______________________________________________|________________________________________________________
 Temporal   | timestamp     |    8     | stores date & time                            | 4713 B.C. -> 294.276 AD
		    |_______________|__________|_______________________________________________|________________________________________________________
		    | interval      |    16    | stores difference between timestamps          | -178.000.000 -> +178.000.000
		    |_______________|__________|_______________________________________________|________________________________________________________
		    | timestamptz   |    8     | stores a timestamp + timezone	               | 4713 B.C. -> 294.276 AD + tz
____________|_______________|__________|_______________________________________________|________________________________________________________



--Другие типы данных:
	-- Arrays (массивы)
	-- JSON
	-- XML
	-- Geometric types and other spec. types (Геометрические типы и др. спец. типы)
	-- Custom-types
	-- NULL - lack of data (отсутствие данных)


---Code that removes all connections to the database, in this case to
---Код который удаляет все подключения к базе данных, в данном случае к testdb---

SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'testdb'
	AND pid <> pg_backend_pid()


---Delete database---

DROP DATABASE testdb


---create database---

CREATE DATABASE testdb


---create tables---

CREATE TABLE publisher
(
	publisher_id integer PRIMARY KEY,
	org_name varchar(128) NOT NULL,
	address text NOT NULL
);

CREATE TABLE book
(
	book_id integer PRIMARY KEY,
	title text NOT NULL,
	isbn varchar(32) NOT NULL
)


---delete tables---

DROP TABLE publisher;
DROP TABLE book

---Insert data in tables---

INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566'),
(2, 'Pride and Prejudice', '9780307594006'),
(3, 'To Kill a Mockingbird', '0446310786'),
(4, 'The Book of Gutsy Women: Favorite Stories of Courage and Resilience', '1501178415'),
(5, 'War and Peace', '1788886526');

INSERT INTO publisher
VALUES
(1, 'Everyman''s Library', 'NY'),
(2, 'Oxford University Press', 'NY'),
(3, 'Grand Cetral Publishing', 'Washington'),
(4, 'simon & Schuster', 'Chicago')


---Check inserting table and select all data from table---

SELECT * FROM book


---Add column and provide a link to the column (и указываем ссылку на колонку) foreign key---

ALTER TABLE book ADD COLUMN fk_publisher_id integer;

ALTER TABLE book
ADD CONSTRAINT fk_book_publisher
FOREIGN KEY(fk_publisher_id) REFERENCES publisher(publisher_id



---delete table and then create table book with full columns without adding---

DROP TABLE book

--create table---

CREATE TABLE book
(
	book_id integer PRIMARY KEY,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	fk_publisher_id integer REFERENCES publisher(publisher_id) NOT NULL
)


---again insert data in book table---

INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566', 1),
(2, 'Pride and Prejudice', '9780307594006', 1),
(3, 'To Kill a Mockingbird', '0446310786', 2),
(4, 'The Book of Gutsy Women: Favorite Stories of Courage and Resilience', '1501178415', 2),
(5, 'War and Peace', '1788886526', 2);



--- create new tables ---

CREATE TABLE person
(
	person_id integer PRIMARY KEY,
	first_name varchar(64) NOT NULL,
	last_name varchar(64) NOT NULL
);

CREATE TABLE passport
(
	passport_id integer PRIMARY KEY,
	serial_number integer NOT NULL,
	fk_passport_person integer REFERENCES person(person_id)
)


---to execute a piece of code in one request, you need to select it and execute the code
---что бы выполнить кусок кода в одном запросе его надо выделить и исполнить код---
ALTER TABLE passport
ADD COLUMN registration text NOT NULL


---insert data to person table---

INSERT INTO person VALUES (1, 'John', 'Snow');
INSERT INTO person VALUES (2, 'Ned', 'Stark');
INSERT INTO person VALUES (3, 'Rob', 'Baratheon');


---insert data to passport table---

INSERT INTO passport VALUES
(1, 123456, 1, 'Winterfell'),
(2, 789012, 2, 'Winterfell'),
(3, 345678, 3, 'King''s Landing')


--delete tables if exists

DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS author;


---create new tables and insert data---

CREATE TABLE book
(
	book_id int PRIMARY KEY,
	title text NOT NULL,
	isbn text NOT NULL
);

CREATE TABLE author
(
	author_id integer PRIMARY KEY,
	full_name text NOT NULL,
	rating real
);

CREATE TABLE book_author
(
	book_id integer REFERENCES book(book_id),
	author_id integer REFERENCES author(author_id),

	CONSTRAINT book_author_pkey PRIMARY KEY (book_id, author_id) -- composite key
);

INSERT INTO book
VALUES
(1, 'Book for Dummies', '123456'),
(2, 'Book for Smart Guys', '7890123'),
(3, 'Book for Happy People', '456789'),
(4, 'Book for Unhappy People', '1234567');

INSERT INTO author
VALUES
(1, 'Bob', 4.5),
(2, 'Alice', 4.0),
(3, 'John', 4.7);

INSERT INTO book_author
VALUES
(1, 1),
(2, 1),
(3, 1),
(3, 2),
(4, 1),
(4, 2),
(4, 3);
