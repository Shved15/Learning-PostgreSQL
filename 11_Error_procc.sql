-- № 11: Errors processing

--If an incorrect parameter is received in the function, it is necessary to stop
--the execution of the function and send a signal to the top about the problems
--Если в функцию пришел некорректный параметр - необходимо прекратить выполнение функции
--и подать сигнал наверх о проблемах

-- Exceptions are used for this.(EXCEPTION)

-- Only in PL/pgSQL functions (no in pure SQL)


--Syntax--
* RAISE [level] 'message(%)', arg_name;

level - error level:
    * DEBUG -- debugging(отладка)
    * LOG -- log(лог)
    * INFO -- information(информация)
    * NOTICE -- comment(замечание)
    * WARNING -- potential danger(потенциальная опасность)
    * EXCEPTION -- exception / error (исключение / ошибка)

-- EXCEPTION aborts the current transaction ( абортирует текущую транзакцию), если один из стэйтмонтов
-- провалился то результаты предыдущих откатываются

--Транзакция(коротко) - совокупность стэйтментов которые рассматриваются как единое целое


log_min_messages -- regulates the level of messages that will be written to the server log
--(регулирует уровень сообщений, которые будут писаться в лог сервера) (default WARNING)

client_min_messages -- regulates the level of messages that will be sent to the caller
--(регулирует уровень сообщений, которые будут передаваться вызывающей стороне) (default NOTICE)

--One of the most important parameters HINT and ERRCODE

-- Parameters are joined with USING:
    * RAISE 'invalid billing number=%', number USING HINT='Check out the billing number' ERRCODE='12881'





-- You need a block EXCEPTION WHEN to catch the exception:
    * EXCEPTION WHEN confition [others] THEN handling_logic


-- The code in the EXCEPTION block loses(теряет) performance(производительность)

-- We should try to avoid the exception as much as possible(мы должны стараться по возможности избегать исключения)




DROP FUNCTION IF EXISTS get_season;
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

--if we pass unrealistic values
SELECT get_season(15);


-- use RAISE
DROP FUNCTION IF EXISTS get_season;
CREATE OR REPLACE FUNCTION get_season(month_number int) RETURNS text AS $$
DECLARE
	season text;
BEGIN
	IF month_number NOT BETWEEN 1 AND 12 THEN
		RAISE EXCEPTION 'Invalid month. You passed:(%)', month_number USING HINT='Allowed from 1 up to 12', ERRCODE=12882;
	END IF;

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

--at now if we pass unrealistic values
SELECT get_season(15);


-- function that call get_season function
CREATE OR REPLACE FUNCTION get_season_caller(month_number int) RETURNS text AS $$
DECLARE
	err_ctx text;
	err_msg text;
	err_details text;
	err_code text;
BEGIN
    RETURN get_season(month_number);
EXCEPTION
	WHEN SQLSTATE '12882' THEN
        GET STACKED DIAGNOSTICS err_ctx = PG_EXCEPTION_CONTEXT,
						  		err_msg = MESSAGE_TEXT,
                          		err_details = PG_EXCEPTION_DETAIL,
                          		err_code = RETURNED_SQLSTATE;
		RAISE INFO 'My custom handler:';
        RAISE INFO 'Error msg:%', err_msg;
        RAISE INFO 'Error details:%', err_details;
		RAISE INFO 'Error code:%', err_code;
		RAISE INFO 'Error context:%', err_ctx;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

SELECT get_season_caller(15);


create or replace function get_season_caller2(month_number int) returns text AS $$
declare
	err_ctx text;
	text_var1 text;
	text_var2 text;
	text_var3 text;
BEGIN
    return get_season(15);
EXCEPTION
    --when others then
	WHEN SQLSTATE '12882' then
	--won't catch by another code
		RAISE INFO 'My custom handler:';
        RAISE INFO 'Error Name:%',SQLERRM;
        RAISE INFO 'Error State:%', SQLSTATE;
	RETURN NULL;
END;
$$ language plpgsql;

select get_season_caller2(15);
