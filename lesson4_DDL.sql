-- Lesson 4: DDL: create DB, tables and their modification

________________________________________________________________________________________________________
--- ## DDL: Data Definition Language ## ---

        --- CREATE TBALE table_name

            -- ALTER TABLE table_name
            -- ADD COLUMN column_name data_type
            -- RENAME TO new_table_name
            -- RENAME old_column_name TO new_column_name
            -- ALTER COLUMN column_name SET DATA TYPE data_type

        --- DROP TABLE table_name

        --- TRUNCATE TABLE table_name (delete all data in table, but !! cannot remove data referenced from other tables !!)

        --- DROP COLUMN column_name

________________________________________________________________________________________________________

-- ## table management ## --

CREATE TABLE student
(
	student_id serial,
	first_name varchar,
	last_name varchar,
	birthday date,
	phone varchar
);


CREATE TABLE cathedra
(
	cathedra_id serial,
	cathedra_name varchar,
	dean varchar
);


ALTER TABLE student
ADD COLUMN middle_name varchar;


ALTER TABLE student
ADD COLUMN rating float;


ALTER TABLE student
ADD COLUMN enrolled date;


ALTER TABLE student
DROP COLUMN middle_name;


ALTER TABLE cathedra
RENAME TO chair;


ALTER TABLE chair
RENAME cathedra_id TO chair_id;


ALTER TABLE chair
RENAME cathedra_name TO chair_name;


ALTER TABLE student
ALTER COLUMN first_name SET DATA TYPE varchar(64);

ALTER TABLE student
ALTER COLUMN last_name SET DATA TYPE varchar(64);

ALTER TABLE student
ALTER COLUMN phone SET DATA TYPE varchar(30);


CREATE TABLE faculty
(
	faculty_id serial,
	faculty_name varchar
);

INSERT INTO faculty
VALUES
('faculty1'),
('faculty2'),
('faculty3');

SELECT * FROM faculty;


--  delete data without restart identity
TRUNCATE TABLE faculty


--  delete data with restart identity
TRUNCATE TABLE faculty RESTART IDENTITY;


DROP TABLE faculty;



________________________________________________________________________________________________________

-- 1. Create table teacher with fields teacher_id serial, first_name varchar, last_name varchar, birthday date, phone varchar, title varchar

-- 2. Add a middle_name varchar column to the table after creation

-- 3. Remove the middle_name column

-- 4. Rename column birthday to birth_date

-- 5. Change the data type of the phone column to varchar(32)

-- 6. Create an exam table with fields exam_id serial, exam_name varchar(256), exam_date date

-- 7. Insert any three records with ID auto-generation

-- 8. Through a full fetch, make sure that the data was inserted normally and the identifiers were generated with an increment

-- 9. Delete all data from the table with resetting the identifier to its original state


-- 1
CREATE TABLE teacher
(
	teacher_id serial,
	first_name varchar,
	last_name varchar,
	birthday date,
	phone varchar,
	title varchar
);

-- 2
ALTER TABLE teacher
ADD COLUMN middle_name varchar;

-- 3
ALTER TABLE teacher
DROP COLUMN middle_name;

-- 4
ALTER TABLE teacher
RENAME birthday TO birth_date;

--5
ALTER TABLE teacher
ALTER COLUMN phone SET DATA TYPE varchar(32);

-- 6
CREATE TABLE exam
(
	exam_id serial,
	exam_name varchar(256),
	exam_date date
);

-- 7
INSERT INTO exam (exam_name, exam_date)
VALUES
('exam 1', '2018-01-10'),
('exam 2', '2018-02-10'),
('exam 3', '2018-03-10');

-- 8
SELECT * FROM exam;

-- 9
TRUNCATE TABLE exam RESTART IDENTITY;
________________________________________________________________________________________________________


--- ### PRIMARY KEY ### ---

DROP TABLE chair;
CREATE TABLE chair
(
	cathedra_id serial PRIMARY KEY,
	chair_name varchar,
	dean varchar
);

INSERT INTO chair
VALUES (1, 'name', 'dean');

--no duplicates
INSERT INTO chair
VALUES (1, 'name', 'dean');

--no NULLs
INSERT INTO chair
VALUES (NULL, 'name', 'dean');

--only UNIQUE NOT NULLs
INSERT INTO chair
VALUES (2, 'name', 'dean');

--equivalent (almost) to:
DROP TABLE chair;
CREATE TABLE chair
(
	cathedra_id serial UNIQUE NOT NULL,
	chair_name varchar,
	dean varchar
);
ALTER TABLE chair
DROP CONSTRAINT chair_cathedra_id_key

select constraint_name
from information_schema.key_column_usage
where table_name = 'chair'
  and table_schema = 'public'
  and column_name = 'cathedra_id';

ALTER TABLE chair
ADD PRIMARY KEY(chair_id);



--- The difference between PRIMARY KEY and UNIQUE NOT NULL is that there can be only one PRIMARY KEY for the entire table,
--- and restrictions in the form of UNIQUE and UNIQUE NOT NULL can be imposed on more than one column

-- PRIMARY KEY is used to explicitly mark where the primary key resides, which is used (often) to bind to a foreign
-- key and uniquely identifies a row in an entire table


--- Code with which we can display the names that are given to the constraints
--  Код с помощью которого мы можем вывести имена, которые даны ограничениям
SELECT constraint_name
FROM information_schema.key_column_usage
WHERE table_name = 'chair'
	AND table_schema = 'public'
	AND column_name = 'chair_id'


ALTER TABLE chair
DROP CONSTRAINT chair_cathedra_id_key


ALTER TABLE chair
ADD PRIMARY KEY(chair_id);



________________________________________________________________________________________________________
--- ### FOREIGN KEY ### ---

DROP TABLE publisher;
DROP TABLE book-author;
DROP TABLE book;

CREATE TABLE publisher
(
    publisher_id integer,
    publisher_name varchar(128) NOT NULL,
    address text NOT NULL,

	CONSTRAINT PK_publisher_publisher_id PRIMARY KEY(publisher_id)
);

CREATE TABLE book
(
    book_id integer,
    title text NOT NULL,
    isbn varchar(32) NOT NULL,
    publisher_id integer,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

INSERT INTO publisher
VALUES
(1, 'Everyman''s Library', 'NY'),
(2, 'Oxford University Press', 'NY'),
(3, 'Grand Central Publishing', 'Washington'),
(4, 'Simon & Schuster', 'Chicago');


-- without FK we can enter any values
INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566', 10); -- Everyman's Library

SELECT *
FROM book;

TRUNCATE TABLE book;

ALTER TABLE book
ADD CONSTRAINT fk_books_publisher FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id);


--and now you can not insert nonsense
INSERT INTO book
VALUES
(1, 'The Diary of a Young Girl', '0199535566', 10); -- Everyman's Library


DROP TABLE book;

--if we want to immediately set a constraint when creating a table
CREATE TABLE book
(
    book_id integer NOT NULL,
    title text NOT NULL,
    isbn character varying(32) NOT NULL,
    publisher_id integer NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id),
	CONSTRAINT FK_book_publisher FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

--if we want to remove the constraint
ALTER TABLE book
DROP CONSTRAINT FK_book_publisher;



________________________________________________________________________________________________________
--- ### CHECK - Boolean Conditions ### ---

DROP TABLE IF EXISTS book;

CREATE TABLE book
(
    book_id integer NOT NULL,
    title text NOT NULL,
    isbn character varying(32) NOT NULL,
    publisher_id integer NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

ALTER TABLE book
ADD COLUMN price decimal CONSTRAINT CHK_book_price CHECK (price > 0);

--error because price cannot be < 0, and CHECK limit above
INSERT INTO book
VALUES
(1, 'title', 'isbn', 1, -1.5);

-- can do this
INSERT INTO book
VALUES
(1, 'title', 'isbn', 1, 1.5);


________________________________________________________________________________________________________
--- ### DEFAULT ### ---

---if we have optional fields that are optional, then we use DEFAULT to generate some value by default

CREATE TABLE customer
(
	customer_id serial,
	full_name text,
	status char DEFAULT 'r',

	CONSTRAINT PK_customer_customer_id PRIMARY KEY(customer_id),
	CONSTRAINT CHK_customer_status CHECK (status = 'r' OR status = 'p')
);

INSERT INTO customer (full_name)
VALUES
('name');

SELECT *
FROM customer;

-- we'll get error, because we have check
INSERT INTO customer
VALUES
('name', 'd');


ALTER TABLE customer
ALTER COLUMN status DROP DEFAULT;

ALTER TABLE customer
ALTER COLUMN status SET DEFAULT 'r';


________________________________________________________________________________________________________
--- ### SEQUENCES ### ---

-- CREATE SEQUENCE sequence_name
CREATE SEQUENCE seq1;

-- generate next values in sequence
SELECT nextval('seq1');

-- it returns the current value
SELECT currval('seq1');

-- returns the last value generated in any of the sequences in the current session
SELECT lastval();

-- sequence manipulation (setting values)
SELECT setval('seq1', 15); -- third arrg default True
SELECT currval('seq1');

-- at now return '16'
SELECT nextval('seq1');

-- with false first value = 16, next value = 15
SELECT setval('seq1', 15, false);
SELECT currval('seq1');

SELECT nextval('seq1');

-- first value = 1, next value 1+16
CREATE SEQUENCE IF NOT EXISTS seq2 INCREMENT 16;
SELECT nextval('seq2');

-- first value=0, next + 16, max 128, if over 128 = error
CREATE SEQUENCE IF NOT EXISTS seq3
INCREMENT 16
MINVALUE 0
MAXVALUE 128
START WITH 0;

SELECT nextval('seq3');

-- rename sequnce
ALTER SEQUENCE seq3 RENAME TO seq4;

-- restart sequence from value=16
ALTER SEQUENCE seq4 RESTART WITH 16;
SELECT nextval('seq4');

-- delete sequence
DROP SEQUENCE seq4;




________________________________________________________________________________________________________
--- ### SEQUNCES AND TABLES ### ---

DROP TABLE IF EXISTS book;

CREATE TABLE book
(
    book_id int NOT NULL,
    title text NOT NULL,
    isbn varchar(32) NOT NULL,
    publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

SELECT * FROM book;

CREATE SEQUENCE IF NOT EXISTS book_book_id_seq
START WITH 1 OWNED BY book.book_id;


-- doesn't work
INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 1);


--we need to set default
ALTER TABLE book
ALTER COLUMN book_id SET DEFAULT nextval('book_book_id_seq');

--now should work
INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 1);

SELECT *
FROM book;

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title2', 'isbn2', 1);

SELECT *
FROM book;

DROP TABLE IF EXISTS book;

CREATE TABLE book
(
    book_id serial NOT NULL,
    title text NOT NULL,
    isbn varchar(32) NOT NULL,
    publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 1);

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title2', 'isbn2', 1);

SELECT *
FROM book;

-- advanced level of field creation with autoincrement serial type
DROP TABLE IF EXISTS book;

CREATE TABLE book
(
    book_id int GENERATED ALWAYS AS IDENTITY NOT NULL,
    title text NOT NULL,
    isbn varchar(32) NOT NULL,
    publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 1);

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title2', 'isbn2', 1);

SELECT *
FROM book;

--will be error
INSERT INTO book
VALUES (3, 'title2', 'isbn2', 1);

-- Bypass error
INSERT INTO book
OVERRIDING SYSTEM VALUE
VALUES (3, 'title2', 'isbn2', 1);


DROP TABLE IF EXISTS book;

CREATE TABLE book
(
    book_id int GENERATED ALWAYS AS IDENTITY (START WITH 10 INCREMENT BY 2) NOT NULL,
    title text NOT NULL,
    isbn varchar(32) NOT NULL,
    publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title', 'isbn', 1);

INSERT INTO book (title, isbn, publisher_id)
VALUES ('title2', 'isbn2', 1);

SELECT *
FROM book;


________________________________________________________________________________________________________

--- ### INSERT ### ---

-- when we want to insert data into all columns
INSERT INTO author
VALUES (10, 'John Silver', 4.5);

SELECT * FROM author;

-- when we want to insert data partially
INSERT INTO author(author_id, full_name)
VALUES
(11, 'Max White');

-- we can insert more than 1 value
INSERT INTO author(author_id, full_name)
VALUES
(12, 'Name 1'),
(13, 'Name 2'),
(14, 'Name 3');

-- select + create table (can be backup), but unchanging
SELECT *
INTO best_authors
FROM author
WHERE rating > 4.5;

SELECT * FROM best_authors;


-- if use select and result data insert into other table
INSERT INTO best_authors
SELECT *
FROM author
WHERE rating < 4.5

________________________________________________________________________________________________________


--- ### UPDATE, DELETE, RETURNING ### ---

SELECT * FROM author;

-- update --
UPDATE author
SET full_name = 'Elias', rating = 5
WHERE author_id = 1;


-- delete line
DELETE FROM author
WHERE rating < 4.5;

-- delete all lines(but server has logs about deleted lines )
DELETE FROM author;

-- delete all lines without logs
TRUNCATE TABLE author;

DROP TABLE book;


-- returning
CREATE TABLE book
(
	book_id serial,
	title text NOT NULL,
	isbn varchar(32) NOT NULL,
	publisher_id int NOT NULL,

	CONSTRAINT PK_book_book_id PRIMARY KEY(book_id)
);

INSERT INTO book(title, isbn, publisher_id)
VALUES ('title', 'isbn', 3)
RETURNING *; --immediate result output

UPDATE author
SET full_name = 'Walter', rating = 5
WHERE author_id = 1
RETURNING author_id;

DELETE FROM author
WHERE rating = 5
RETURNING *;

________________________________________________________________________________________________________

-- practice after lesson --

-- 1. Create an exam table with fields:
-- - exam identifier - auto-incrementing, unique, forbids NULL; - exam name - exam date

-- 2. Remove the unique constraint from the ID field

-- 3. Add primary key constraint on id field

-- 4. Create a person table with fields
-- - identity identifier (simple int, primary key) - first name - last name

-- 5. Create a passport table with fields:
-- - passport ID (simple int, primary key) - serial number (simple int, forbids NULL) - registration - identity
-- reference (foreign key)

-- 6. Add a weight column to the book table (created earlier) with a constraint checking the weight
-- (greater than 0 but less than 100)

-- 7. Make sure that the weight limit works (try to insert an invalid value)

-- 8. Create a student table with fields:
-- - identifier (auto-increment) - full name - course (default 1)

-- 9. Insert a record into the student table and verify that the default value insert constraint works

-- 10. Remove "default" constraint from student table

-- 11. Connect to the northwind database and add a constraint on the unit_price field of the products table
-- (the price must be greater than 0)

-- 12. Add an auto-incrementing counter to the product_id field of the products table (northwind database).
-- The counter must begin with the number following the maximum value for this column.

-- 13. Insert into products (without explicitly inserting an identifier) and verify that auto-increment works.
-- Insert so that the result of the command is the value generated as an identifier.


DROP TABLE exam;
CREATE TABLE exam
(
	exam_id serial UNIQUE NOT NULL,
	exam_name varchar(256),
	exam_date date
);

ALTER TABLE exam
DROP CONSTRAINT exam_exam_id_key;

ALTER TABLE exam
ADD PRIMARY KEY(exam_id);

DROP TABLE person CASCADE;
DROP TABLE passport;
CREATE TABLE person
(
	person_id int NOT NULL,
    first_name varchar(64) NOT NULL,
    last_name varchar(64) NOT NULL,
    CONSTRAINT pk_person_person_id PRIMARY KEY (person_id)
);

CREATE TABLE passport
(
	passport_id int,
    serial_number int NOT NULL,
    registration text NOT NULL,
	person_id int NOT NULL,

    CONSTRAINT pk_passport_passport_id PRIMARY KEY (passport_id),
	CONSTRAINT fK_passport_person FOREIGN KEY (person_id) REFERENCES person(person_id)
);

ALTER TABLE book
ADD COLUMN weight decimal CONSTRAINT CHK_book_weight CHECK (weight > 0 AND weight < 100);

INSERT INTO book
VALUES
(1, 'title', 'isbn', 1, 120.5, 120);

CREATE TABLE student
(
	student_id serial,
	full_name varchar,
	grade int DEFAULT 1
);

INSERT INTO student
VALUES
(1, 'vasia');

SELECT *
FROM student;

ALTER TABLE student
ALTER COLUMN DROP DEFAULT;

ALTER TABLE products
ADD CONSTRAINT CHK_products_price CHECK(unit_price > 0);

SELECT MAX(product_id) FROM products;

CREATE SEQUENCE IF NOT EXISTS products_product_id_seq
START WITH 78 OWNED BY products.product_id;


ALTER TABLE products
ALTER COLUMN product_id SET DEFAULT nextval('products_product_id_seq')

INSERT INTO products(product_name, supplier_id, category_id, quantity_per_unit,
					 unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
VALUES
('prod', 1, 1, 10, 20, 20, 10, 1, 0)
RETURNING product_id;
