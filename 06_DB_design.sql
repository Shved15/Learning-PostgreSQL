-- № 6 - Database design

    - Domain representation problem (поблема представления предметной области) #предм. обл. - домен#
    - Logic design
    - Problems of bad design (Проблемы плохого проектирования)
        * Possibility to write invalid data (возможность записи не валидных данных)
        * The possibility of information loss (no necessary connections)( возможность потери информации (нет нужных связей))
        * Lack of necessary information (отсутствие необходимой информации)


Database design stages(стадии)
    * Domain requirement analysis (анализ требования предметной области)
    * Logical modeling of domain data (Логическое моделирование данных предметной области)
    * Physical design and normalization (Физическое проектирование и нормализация)


* Domain requirement analysis
    __ Making USE CASES - it is necessary to find out what subjects are in the subject area and with what objects they interact
    (Составление USE CASES - это необходимо что бы выяснить какие субъекты имеются в предметной области и  с какими объектами они взаимодействуют )

    __ Analytical process involving stakeholders (owners, domain experts)
    (Аналитически процесс с участием stakeholders (владельцев, экспертов предметной области))

    __ Conceptual database diagram (концептуальная схема БД)

* Logical modeling
    __ Details the conceptual model of DB (Детализирует концептуальную модель баз данных)

    __ Different sources include different components in the logical model
    (Разные источники включают разные компоненты в логическую модель)

    __ Fully describes all keys
    (Полностью описывает все ключи)

    __ Fully defines data types (regardless of the specific DBMS)
    (Полностью определяет типы данных (безотносительно конкретной СУБД))

    __ Fully describes all logical constraints (debatable)
    (Полностью описывает все логические ограничения (спорно))

    __ Relationship normalization usually up to 3NF form
    (Нормализация отношений обычно максимум до формы 3НФ)

* Physical data model (Физическая модель данных)
    __ A specific DBMS is selected
    (Выбирается конкретная СУБД)

    __ Data types are defined (specific ones that are inherent in this DBMS)
    (Определяются типы данных (конкретные, которые присущи этой СУБД))

    __ Indexes are defined
    (Определяются индексы)

    __ Views can be defined
    (Могут определяться представления)

    __ Access restrictions are defined
    (Определяются ограничения на доступ)


-- Based on the design results, it is convenient to build a ER Diagrams
-- (По результатам проектирования удобно строить ER Diagrams)


Enity Relationship Diagrams
    __ There are many paid modeling tools (Существует много платных инструментов для моделирования)

    __ MySQL Workbench

    __ Oracle SQL Developer Data Modeler

    __ pgModeler

    __ SQL Power Architect

___________________________________________________________________________________________________


Basic Design Tips (Базовые советы по проектированию)

    * Table: object, event, abstraction
    (Таблица: объект, событие, абстракция)

    * Field (column): object property
    (Поле (колонка): свойство объекта)

    * Record (string): collection of fields
    (Запись (строка): совокупность полей)

    * Values ​​in each field individually must not contain invalid data
    (Значения в каждом поле по отдельности не должны содержать не валидных данных)

    * Values ​​in the collection of fields must be consistent
    (Значения в совокупности полей должны быть непротиворечивы)


___________________________________________________________________________________________________

Bad practice !

    * Ignoring Normalization - Data Redundancy
    (Игнорирование нормализации - избыточность данных)

    * Lack of naming standards on the project
    (Отсутствие стандартов именования на проекте)

    * One table for data of different meaning
    (Одна таблица для разных по смыслу данных)

    * Poor attitude to the relevance of the representation of data - the domain of a living organism, it changes!
    (Плохое отношение к актуальности репрезентации данынх - домен живой организм, он меняется!)

    * Fields containing more than 1 logical part (full_name) - required (first_name, last_name, middle_name)
    (Поля, содержащие более 1 логической части (full_name) - необходимо (first_name, last_name, middle_name))

    * Fields containing more than 1 value (array when not needed)
    (Поля, содержащие более 1 значения (массив, когда не надо))

    * Calculated field (full salary for the entire time of work) - computational operations must be carried out separately.
     The purpose of a table is to store data
    (Вычисляемое поле (полная зарплата за все время работы) - вычислительные операции нужно проводить отдельно. Цуль таблицы - хранить данные)

    * Incorrectly chosen primary keys (which may be out of date, similar, or change)
    (Неправильно выбранные первыичные ключи (которые могут устареть, быть похожими или измениться))

    * Composite PKs should be avoided - which are built on more than one column (can lead to performance degradation)
    (Необходимо избегать композитных PK - которые строятся больше чем по одной колонке (может привести к деградации производительности))

    * Ideally, in a table, in addition to the surrogate key (for example, id, i.e. the surrogate key is a kind of unique identifier,
    which is logically unrelated to the record), there must also be a natural
    (В идеале, в таблице кроме сурогатного ключа(например id, т.е. сурогатный ключ это некий уникальный идентификатор,
    который логически никак не связан с записью), должен быть и натуральный)

________________________________________________________________________________________________________


--Normal form (NF) is a property of a relation that characterizes it in terms of redundancy
--(Нормальная форма (НФ) - это свойство отношения, характеризующее его с точки зрения избыточности)


-- Normalization - the process of minimizing the redundancy of a relation (ghost to NF)
-- (Нормализация - процесс минимизации избыточности отношения (привидение к НФ)) - удаление дубликатов - разделение больших таблиу на маленькие


## Normal forms ##
-- 1NF --
    * No duplicate lines
    (Нет строк-дубликатов)

    * All attributes of simple data types
    (Все атрибуты простых типов данных)

    * All values ​​are scalar
    (Все значения скалярные)


-- 2NF --
    * The table satisfies 1NF
    (Таблица удовлетворяет 1НФ)

    * Has a primary key

    * All attributes (fields) describe the primary key as a whole, and not just part of it
    (Все атрибуты (поля) описывают первичный ключ целиком, а не лишь его часть)


-- 3NF --
    * The table statisfies 2NF

    * There are no dependencies of some non-key attributes on others (all attributes depend only on the primary key)
    (Нет зависимостей одних неключевых атрибутов от других (все атрибуты зависят только от первичного ключа))


-- THUS, THE BASIS FOR REDUCTION TO ALL NORMAL FORMS IS DECOMPOSITION (DIVISION OF ONE COMPLEX TABLE INTO SMALL)
-- ТАКИМ ОБРАЗОМ ОСНОВОЙ ПРИВЕДЕНИЯ КО ВСЕМ НОРМАЛЬНЫМ ФОРМАМ СЛУЖИТ ДЕКОМПОЗИЦИЯ (ДЕЛЕНИЕ ОДНОЙ СЛОЖНОЙ ТАБЛИЦЫ НА МАЛЕНЬКИЕ)
