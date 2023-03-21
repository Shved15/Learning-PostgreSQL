-- № 12: Indices

--An index is a data structure that speeds up data retrieval from a table through additional operations.
--records and disk space used to store the data structure and maintain it
--up to date.
--Индекс - это структура данных, ускоряющая выборку данных из таблицы за счет дополнительных операций
--записи и пространства на диске, используемых для хранения структуры данных и поддержания ее
--в актуальном состоянии.


---* DB device ( устройство БД) *--

    * database cluster -- one or more databases managed from one server instance
    --(одна и более БД, управляемые из под одной инстанции сервера)

    * -- The cluster data files are in the data directory (often called PGDATA)
    -- (Файлы данных кластера лежат в лиректории data (часто называется PGDATA))

    * -- Each database has its own subfolder in PGDATA/base
    -- (Для каждой базы данных есть своя подпапка в PGDATA/base)

    * -- A separate file is allocated for each table and index
    -- (Для каждой таблицы и индекса выделяется отдельный файл)

    * -- The table consists of an array of pages (blocks, 8 kb in size - default)
    -- (Таблица состоит из массива страниц(блоков, размером 8 кб))

    * -- The table file is called Heap File - contains lists of unordered records of various lengths
    -- (Файл таблицы называется Heap File - содержат списки неупорядоченных записей различной длины)


        ** -- 1gb table
        -- (Таблица размером 1гб)

        ** -- Consists of 8kb pages
        -- (Состоит и страниц по 8кб)

        ** -- Each page contains: page title, lines with their titles
        -- (Каждая страница содержит: заголовок страницы, строки с их заголовками)

        ** -- The page contains links to rows (CTID - consists of a pair of values: page number and index)
        -- (Страница содержит ссылки на строки(CTID - состоит из пары значений: номер страницы и индекс))

        ** -- If the page exceeds 8kb, then a similar situation is processed using the TOAST mechanism
        -- (Если страница превышает 8кб то подобная ситуация обрабатывается с помощью механизма
        -- TOAST - the oversize attribute storage techique)

    * -- Next to the table file is the FSM (free space map) file
    -- Рядом с файлом таблицы лежит файл FSM(free space map)

    * -- FSM not updating on every row update or delete
    -- FSM не обновляется при каждом обновлении или удалении строк

    * VACUUM [FULL] -- command to clean up deleted row versions
    -- VACUUM [FULL] - команда для очистки удаленных версий строк

    * -- Next to the table file is the VM (visibility map) file
    -- Рядом с файлом таблицы лежит файл VM(visibility map)

___________________________________________________________________________________________________

---* VACUUM *---

    * -- If you do not maintain the database at all, then data fragmentation will increase.
    -- Если вообще не обсуживать базу данных, то фрагментация данных будет нарастать

    * VACUUM -- command to clean up dead row versions

    * VACUUM FULL -- complete "compacting" the table
    -- полный "компактинг" таблицы

    * -- Requires occasional VACUUM run
    -- Необходим переодический запуск VACUUM

    * -- Databases that are actively updated need to go through a VACUUM every night
    -- Активно обновляемым баз данным необходимо проходить VACUUM каждую ночь

    * -- VACUUM FULL is only used if a lot of data has been deleted
    -- VACUUM FULL используется только если удалили много данных

    * VACUUM ANALYZE -- combination of two operations
    -- VACUUM ANALYZE - комбинация двух операций

    * -- Autovacuum does everything automatically (default True)
    -- Autovacuum делает все автоматически

___________________________________________________________________________________________________

--- ### Indices ### ---

* -- An index is a database object that can be created and deleted
-- Индекс это объект базы данных, который можно создать и удалить

* --Allows you to search for values ​​without exhaustive enumeration
-- Позволяет искать значения без полного перебора

* -- An index is an access method that maps a key to the rows in the table in which that key occurs.
-- Индекс это метод доступа который устанавливает соответствие между ключом и строками в таблице в
-- которой этот ключ встречается

* -- Optimizing the fetch of a small number of records
-- Оптимизация выборки небольшого числа записей

* -- A small number is a number relative to the number of records in the table
-- Небольшое число - это число относительное количества записей в таблице

* -- On PRIMARY KEY AND UNIQUE columns, an index is created automatically
-- По PRIMARY KEY AND UNIQUE столбцам индекс создается автоматически

* -- Indexes have a memory cost
-- Индексы требуют затрат от памяти


SELECT amname FROM pg_am;-- show all indexes types allow in server(list)

    * B-tree -- (balance tree)

    * Hash-index

    * GiST -- (generalized search tree - обобщенное дерево поиска)

    * GIN -- (generalized reverse index - обобщенный обратный индекс)

    * SP-GiST -- (GiST with binary space partitioning - GiST с двоичным разбиением пространства)

    * BRIN -- (block-range index  -  блочно-диапазонный индекс)

___________________________________________________________________________________________________

--- ### Scanning methods - методы сканирования ### ---

1. Index scan -- индексное сканирование (например мы ищем строку по целочисленному значению id в столбце)

2. Index only scan -- исключительное индексное сканирование

3. Bitmap scan -- сканирование по битовой карте

4. Sequential scan -- последовательное сканирование

___________________________________________________________________________________________________


--- ### Balance tree ### ---

* CREATE INDEX index_name ON table_name (column_name);  --created by default

* -- Supports operations:
    <, >, <=, >=, =

* -- Supports:
    LIKE 'abc%' (but do not support LIKE '%abc')

* --Indexes(индексирует):
     NULL

* -- Search complexity(сложность поиска):
     O(logN)

___________________________________________________________________________________________________

--- ### Hash ### ---

* CREATE INDEX index_name ON table_name USING HASH (column_name);

* -- Supports only operation:
    '='

* -- Not reflected in the pre-recording log (не отражается в журнале предзаписи) (WAL)
-- !! not recommended for use due to the need to reindex -
-- не рекомендуется к применению из за необходимости реиндексировать!!

* -- Search complexity(сложность поиска):
     O(1)

____________________________________________________________________________________________________

--- ### specialized indiсes ### ---

* GiST -- used for indexing geometric data types, text for organizing full-text search

* GIN -- used to index an array or set of values

* SP-GiST -- used to index a set of data that implies(подразумевает) natural ordering but is not balanced

* BRIN -- used to index a large dataset that implies a natural ordering

___________________________________________________________________________________________________

---### EXPLAIN, EXPLAIN ANALYZE - query planner (планировщик запросов) ### ---

* --If there is a performance problem, it is necessary to determine its cause

* EXPLAIN query -- allows you to look at the query execution plan

* EXPLAIN ANALYZE query -- runs the request, shows the plan and reality

___________________________________________________________________________________________________

--- ### ANALYZE ### ---

* -- Gathers statistics on table data
--Собирает статистику по данным таблицы

* -- The planner looks at statistics when building a plan
-- Планировщик смотрит на статистику при построении плана

* ANALYZE [table_name[(column1, column2...)]] -- launch

* -- Must run at least once a day

* Autovacuum -- default True - if enabled, runs ANALYZE including

___________________________________________________________________________________________________
