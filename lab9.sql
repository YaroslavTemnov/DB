-- ============================================================
-- Laboratory Work 9: Stored Procedures and User-Defined Functions
-- Part 1: Database Setup  (CityBike rental network)
-- ============================================================

DROP TABLE IF EXISTS rentals, bikes, members, stations CASCADE;

-- Create table: stations
CREATE TABLE stations (
    station_id   INT PRIMARY KEY,
    station_name VARCHAR(50) NOT NULL,
    city         VARCHAR(40) NOT NULL,
    capacity     INT NOT NULL
);

-- Create table: bikes
CREATE TABLE bikes (
    bike_id    INT PRIMARY KEY,
    model      VARCHAR(50) NOT NULL,
    station_id INT REFERENCES stations(station_id),
    daily_rate NUMERIC(8,2) NOT NULL
);

-- Create table: members
CREATE TABLE members (
    member_id INT PRIMARY KEY,
    full_name VARCHAR(60) NOT NULL,
    city      VARCHAR(40) NOT NULL,
    joined_on DATE NOT NULL
);

-- Create table: rentals
CREATE TABLE rentals (
    rental_id  INT PRIMARY KEY,
    member_id  INT REFERENCES members(member_id),
    bike_id    INT REFERENCES bikes(bike_id),
    start_date DATE NOT NULL,
    end_date   DATE,
    fee        NUMERIC(8,2)
);

INSERT INTO stations VALUES
 (10, 'Central Park', 'Almaty',   4),
 (20, 'Riverside',    'Almaty',   3),
 (30, 'Expo Gate',    'Astana',   5),
 (40, 'Old Town',     'Shymkent', 2),
 (50, 'Depot',        'Astana',   0);

INSERT INTO bikes VALUES
 (101, 'City Cruiser', 10,  4.50),
 (102, 'City Cruiser', 10,  4.50),
 (103, 'Mountain X',   20,  7.00),
 (104, 'Mountain X',   30,  7.00),
 (105, 'Road Sprint',  30,  9.25),
 (106, 'Folding Mini', 40,  3.75),
 (107, 'Cargo Hauler', 20, 12.00),
 (108, 'Road Sprint',  10,  9.25);

INSERT INTO members VALUES
 (1, 'Aisha Nurlanova', 'Almaty',   DATE '2023-03-14'),
 (2, 'Daniyar Serik',   'Almaty',   DATE '2023-07-02'),
 (3, 'Marta Kowalski',  'Astana',   DATE '2024-01-20'),
 (4, 'Chen Wei',        'Astana',   DATE '2024-05-11'),
 (5, 'Omar Haddad',     'Shymkent', DATE '2024-09-30'),
 (6, 'Elena Petrova',   'Almaty',   DATE '2025-02-05');

INSERT INTO rentals VALUES
 ( 1, 1, 101, DATE '2024-04-05', DATE '2024-04-08', 13.50),
 ( 2, 1, 103, DATE '2024-06-11', DATE '2024-06-16', 35.00),
 ( 3, 1, 108, DATE '2025-02-02', DATE '2025-02-04', 18.50),
 ( 4, 1, 102, DATE '2025-05-20', DATE '2025-05-27', 31.50),
 ( 5, 2, 101, DATE '2024-05-01', DATE '2024-05-02',  4.50),
 ( 6, 2, 107, DATE '2024-11-15', DATE '2024-11-19', 48.00),
 ( 7, 2, 107, DATE '2025-03-08', DATE '2025-03-14', 72.00),
 ( 8, 3, 104, DATE '2024-02-14', DATE '2024-02-18', 28.00),
 ( 9, 3, 105, DATE '2024-08-03', DATE '2024-08-06', 27.75),
 (10, 3, 104, DATE '2025-01-09', DATE '2025-01-10',  7.00),
 (11, 3, 105, DATE '2025-06-01', DATE '2025-06-09', 74.00),
 (12, 4, 104, DATE '2024-07-19', DATE '2024-07-21', 14.00),
 (13, 4, 105, DATE '2025-04-12', DATE '2025-04-15', 27.75),
 (14, 4, 103, DATE '2025-07-23', DATE '2025-07-29', 42.00),
 (15, 5, 106, DATE '2024-10-05', DATE '2024-10-12', 26.25),
 (16, 5, 106, DATE '2025-01-18', DATE '2025-01-20',  7.50),
 (17, 5, 106, DATE '2025-08-14', DATE '2025-08-21', 26.25),
 (18, 2, 102, DATE '2025-09-02', DATE '2025-09-05', 13.50),
 (19, 1, 101, DATE '2025-10-10', NULL,              NULL),
 (20, 4, 108, DATE '2024-12-28', DATE '2025-01-03', 55.50),
 (21, 3, 103, DATE '2025-02-26', DATE '2025-03-02', 28.00),
 (22, 5, 104, DATE '2025-05-05', DATE '2025-05-08', 21.00);


-- Part 1
SELECT (SELECT COUNT(*) FROM stations) AS stations,
(SELECT COUNT(*) FROM bikes) AS bikes,
(SELECT COUNT(*) FROM members) AS members,
(SELECT COUNT(*) FROM rentals) AS rentals;

-- Part 2
-- TASK 2.1

CREATE OR REPLACE FUNCTION rental_days(p_rental_id INT)
    RETURNS INTEGER
    AS $$
    DECLARE
        result INTEGER;
        BEGIN
        SELECT end_date - start_date
        INTO result
        FROM rentals
        WHERE rental_id = p_rental_id;
        RETURN result;

    END;
    $$ LANGUAGE plpgsql;

SELECT rental_days(19);
SELECT rental_days(999);

-- For both queries it returns null.
-- In first case because of end_date is null.
-- In second case because of there is no rows with rental_id 999.

-- Task 2.1

CREATE OR REPLACE FUNCTION member_rental_count(p_member_id INT)
    RETURNS INTEGER
    AS $$
    DECLARE
    result INTEGER;
        BEGIN
        SELECT count(member_id)
        INTO result
        FROM rentals
        WHERE member_id = p_member_id;
        RETURN result;
    end;

    $$ LANGUAGE plpgsql;


SELECT member_rental_count(1);
SELECT member_rental_count(5);
SELECT member_rental_count(6);
SELECT member_rental_count(99);

-- it returns 0 because the count functions counts rows,
-- and select returns 1 empty row if all rows are nulls

-- Task 2.3
CREATE OR REPLACE FUNCTION station_city(p_station_id INT)
    RETURNS VARCHAR
    AS $$
    DECLARE
    result VARCHAR;
        BEGIN
        SELECT city
        INTO result
        FROM stations
        WHERE station_id = p_station_id;
        RETURN result;
    end;

    $$ LANGUAGE plpgsql;

SELECT station_city(30);
SELECT station_city(77);

-- Task 2.4

SELECT rental_id, member_id, rental_days(rental_id)
FROM rentals
WHERE rental_days(rental_id) > 4
ORDER BY rental_days(rental_id) DESC;

-- Part 3
-- Task 3.1
CREATE OR REPLACE FUNCTION fee_with_discount(p_fee NUMERIC, p_percent NUMERIC )
    RETURNS NUMERIC(8, 2)
    AS $$
    DECLARE
    result NUMERIC(8, 2);
        BEGIN
        SELECT p_fee - (p_fee * p_percent * 0.01)
            INTO
        result;
        RETURN result;
    end;

    $$ LANGUAGE plpgsql;

SELECT fee_with_discount(74.00, 15);

-- Task 3.2

CREATE OR REPLACE FUNCTION member_stats(
    p_member_id INT,
    OUT rental_cnt INT,
    OUT total_fee NUMERIC,
    OUT last_start DATE)
AS $$
    BEGIN
    SELECT count(rental_id)
    INTO rental_cnt
    FROM rentals
    WHERE member_id = p_member_id;

    SELECT sum(COALESCE(fee, 0))
        INTO
            total_fee
    FROM rentals
        WHERE member_id = p_member_id;

    SELECT MAX(start_date)
    INTO last_start
    FROM  rentals
        WHERE member_id = p_member_id;

    END;
$$ LANGUAGE plpgsql;

SELECT member_stats(3);
SELECT * FROM member_stats(3);
SELECT * FROM member_stats(6);

-- It differs by their form of representation
-- I would use second form in a larger query to make it more easily to understand columns
-- I get 0, null, null for member 6

-- Task 3.3

CREATE OR REPLACE FUNCTION apply_late_fee(INOUT p_fee NUMERIC(8, 0))
    AS $$
        BEGIN
        p_fee = p_fee + 5.00;
    end;

    $$ LANGUAGE plpgsql;

-- small check for me:
SELECT apply_late_fee(120);
-- yes, it works correctly

-- It still produces the value because of INOUT parameter
-- It takes value, and then returns new value after manipulations inside the function

-- Task 3.4

CREATE OR REPLACE FUNCTION fee_summary(
VARIADIC p_fees NUMERIC[],
OUT total NUMERIC(8, 2),
OUT average NUMERIC(8, 2),
OUT largest NUMERIC(8, 2))
AS $$
    BEGIN
    SELECT SUM(p_fees), AVG(p_fees), MAX(p_fees)
        INTO total, average, largest
    FROM generate_subscripts(p_fees, 1) g(i);
    END;
$$ LANGUAGE plpgsql;

-- If i will call fee_sumary() it will return nulls because function will work with empty array
-- Because all parameters, which starts from variadic are packaging in the array
-- so if there was another parameter before variadic postgres won't understand where is the end for values for array and where is starts next argumennt

-- Task 3.5

-- a) IN id is not changing during look up
-- b) INOUT the parameter is updating during function execution
-- c) Variadic the length is unknown
-- d) OUT both statistics only returns

-- Part 4
-- Task 4.1

CREATE OR REPLACE FUNCTION total_fees(p_member_id INT)
    RETURNS INT
AS $$
    DECLARE
        result INT;
    BEGIN
    SELECT sum(COALESCE(fee, 0))
    INTO result
    FROM rentals
    WHERE member_id = p_member_id;
    RETURN COALESCE(result, 0);
    END;
$$ LANGUAGE plpgsql;

SELECT total_fees(1);
SELECT total_fees(6);

--Task 4.2
CREATE OR REPLACE FUNCTION total_fees(p_member_id INT, p_from_date DATE)
    RETURNS INT
AS $$
    DECLARE
        result INT;
    BEGIN
    SELECT sum(COALESCE(fee, 0))
    INTO result
    FROM rentals
    WHERE member_id = p_member_id and start_date >= p_from_date;
    RETURN COALESCE(result, 0);
    END;
$$ LANGUAGE plpgsql;


SELECT total_fees(1, DATE '2024-01-01');
SELECT total_fees(1, DATE '2025-01-01');
\df total_fees

SELECT proname, pg_get_function_arguments(oid) AS args
FROM pg_proc
WHERE proname = 'total_fees';

-- Exercise 4.3

CREATE OR REPLACE FUNCTION total_fees(p_member_id INT, p_from_date DATE DEFAULT DATE '2025-01-01')
    RETURNS INT
AS $$
    DECLARE
        result INT;
    BEGIN
    SELECT sum(COALESCE(fee, 0))
    INTO result
    FROM rentals
    WHERE member_id = p_member_id and start_date >= p_from_date;
    RETURN COALESCE(result, 0);
    END;
$$ LANGUAGE plpgsql;

SELECT total_fees(1);

-- The error was:
-- " функция total_fees(integer) не уникальна
--   Подсказка: Не удалось выбрать лучшую кандидатуру функции.
--   Возможно, вам следует добавить явные приведения типов."
-- This is because postgres cannot understand do we call function total_fees where there is no date check
-- or we call function total_fees with date check with default value.

-- Task 4.4

DROP FUNCTION total_fees(INTEGER);
SELECT total_fees(1);

-- Now the version with date check answers, the version without date check was deleted
-- Now it returns 50
-- If we drop the other version and return the version without date check the result will be 90

-- Task 4.5

CREATE OR REPLACE FUNCTION total_fees(p_member_name VARCHAR, p_from_date DATE DEFAULT DATE '2025-01-01')
    RETURNS NUMERIC(5, 2)
AS $$
    DECLARE
        result NUMERIC(5, 2);
    BEGIN
    SELECT sum(COALESCE(fee, 0))
    INTO result
    FROM rentals r, members m
    WHERE m.full_name = p_member_name and r.start_date >= p_from_date;
    RETURN result;
    END;
$$ LANGUAGE plpgsql;

SELECT total_fees('Aisha Nurlanova');
SELECT total_fees(1);

-- It is because of date types. The postrges can understand which function we call by date type


-- Part 5

-- Task 5.1

CREATE OR REPLACE FUNCTION find_bikes(IN p_pattern VARCHAR)
RETURNS TABLE (found_id INT, found_model VARCHAR, found_rate NUMERIC(4,2))
AS $$
    BEGIN
    RETURN QUERY
    SELECT bike_id, model, daily_rate
        FROM bikes
        WHERE LOWER(model) LIKE LOWER(p_pattern);
    END;
$$ LANGUAGE plpgsql;

SELECT * FROM find_bikes('%road%');
SELECT * FROM find_bikes('%Mini');
SELECT find_bikes('%road%');

-- Before the function returns query
-- Without FROM the function returns its result not as a query but as an array

-- Task 5.2

CREATE OR REPLACE FUNCTION member_history(p_member_id INT)
RETURNS TABLE (h_rental_id INT, h_model VARCHAR, h_station VARCHAR,
               h_days INT, h_fee NUMERIC)
AS $$
BEGIN
    RETURN QUERY
    SELECT r.rental_id, b.model, s.station_name,
           r.end_date - r.start_date,
           r.fee
    FROM rentals r
    JOIN bikes    b ON b.bike_id    = r.bike_id
    JOIN stations s ON s.station_id = b.station_id
    WHERE r.member_id = p_member_id
    ORDER BY r.start_date;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM member_history(3);

-- Task 5.3

CREATE OR REPLACE FUNCTION bike_list(p_station_id INT)
RETURNS TABLE (bike_id INT, model VARCHAR) AS $$
BEGIN
RETURN QUERY SELECT bike_id, model FROM bikes WHERE station_id = p_station_id;
END; $$ LANGUAGE plpgsql;

SELECT * FROM bike_list(10);
DROP FUNCTION bike_list(p_station_id INT);

CREATE OR REPLACE FUNCTION bike_list(p_station_id INT)
RETURNS TABLE (p_bike_id INT, p_model VARCHAR) AS $$
BEGIN
RETURN QUERY SELECT bike_id, model FROM bikes WHERE station_id = p_station_id;
END; $$ LANGUAGE plpgsql;

SELECT * FROM bike_list(10);

CREATE OR REPLACE FUNCTION bike_list(p_station_id INT)
RETURNS TABLE (p_bike_id INT, p_model VARCHAR) AS $$
BEGIN
RETURN QUERY SELECT b.bike_id, b.model FROM bikes b WHERE station_id = p_station_id;
END; $$ LANGUAGE plpgsql;

SELECT * FROM bike_list(10);

-- Task 5.4

CREATE OR REPLACE FUNCTION station_board(p_city VARCHAR)
RETURNS TABLE (s_name VARCHAR, s_bikes INT, s_free INT) AS $$
BEGIN
    RETURN QUERY
    SELECT s.name,
           COUNT(b.bike_id)::INT,
           s.capacity - COUNT(b.bike_id)::INT
    FROM stations s
    LEFT JOIN bikes b ON b.station_id = s.station_id
    WHERE s.city = p_city
    GROUP BY s.station_id, s.name, s.capacity
    ORDER BY s.name;
END; $$ LANGUAGE plpgsql;

SELECT * FROM station_board(3);

--  функция station_board(integer) не существует
--  Подсказка: Функция с данными именем и типами аргументов не найдена.
--  Возможно, вам следует добавить явные приведения типов.


-- Part 6

-- Task 6.1

DO $$
<<rental_report>>
DECLARE
    total_rentals INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO total_rentals FROM rentals;

    RAISE NOTICE 'The rentals table holds % rows.', total_rentals;
END rental_report $$;

-- It will return an error

-- 6.2

DO $$
<<rental_report>>
DECLARE
    total_rentals INTEGER := 0;
    fee_total     NUMERIC := 0;
BEGIN
    SELECT COUNT(*) INTO total_rentals FROM rentals;
    RAISE NOTICE 'The rentals table holds % rows.', total_rentals;

    SELECT SUM(fee) INTO fee_total FROM rentals;
    RAISE NOTICE '1) outer, before subblock: %', fee_total;

    <<inner_block>>
    DECLARE
        fee_total NUMERIC := 0;
    BEGIN
        SELECT SUM(fee) INTO fee_total
        FROM rentals
        WHERE start_date >= DATE '2025-01-01';

        RAISE NOTICE '2) inner own value: %', fee_total;
        RAISE NOTICE '3) outer via label: %', rental_report.fee_total;
    END inner_block;

    RAISE NOTICE '4) outer, after subblock: %', fee_total;
END rental_report $$;

-- 1) outer, before subblock: 621.50
-- 2) inner own value:        369.00
-- 3) outer via label:        621.50
-- 4) outer, after subblock:  621.50

-- Task 6.3

DO $$
<<rental_report>>
DECLARE
    total_rentals INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO total_rentals FROM rentals;

    <<first_sub>>
    DECLARE
        recent_count INTEGER := 0;
    BEGIN
        SELECT COUNT(*) INTO recent_count
        FROM rentals
        WHERE start_date >= DATE '2025-01-01';

        RAISE NOTICE 'first_sub: recent_count = %', recent_count;
    END first_sub;

    <<second_sub>>
    BEGIN
        RAISE NOTICE 'second_sub: recent_count = %', recent_count;
    END second_sub;
END rental_report $$;


DO $$
<<rental_report>>
DECLARE
    total_rentals INTEGER := 0;
    recent_count  INTEGER := 0;
BEGIN
    SELECT COUNT(*) INTO total_rentals FROM rentals;

    <<first_sub>>
    BEGIN
        SELECT COUNT(*) INTO recent_count
        FROM rentals
        WHERE start_date >= DATE '2025-01-01';

        RAISE NOTICE 'first_sub: recent_count = %', recent_count;
    END first_sub;

    <<second_sub>>
    BEGIN
        RAISE NOTICE 'second_sub: recent_count = %', recent_count;
    END second_sub;
END rental_report $$;

-- Task 6.4

CREATE OR REPLACE FUNCTION fee_split(
    p_from_date DATE,
    OUT before_total NUMERIC,
    OUT after_total  NUMERIC)
AS $$
BEGIN
    SELECT COALESCE(SUM(fee) FILTER (WHERE start_date <  p_from_date), 0),
           COALESCE(SUM(fee) FILTER (WHERE start_date >= p_from_date), 0)
    INTO before_total, after_total
    FROM rentals;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM fee_split(DATE '2025-01-01');

SELECT f.before_total + f.after_total AS split_sum,
       (SELECT SUM(fee) FROM rentals) AS table_total
FROM fee_split(DATE '2025-01-01') f;

-- Part 7

-- Task 7.1
CREATE OR REPLACE FUNCTION station_load(
    p_station_id INT,
    OUT bikes_parked INT,
    OUT capacity_pct NUMERIC)
AS $$
DECLARE
    v_cap INT;
BEGIN
    SELECT s.capacity INTO v_cap
    FROM stations s WHERE s.station_id = p_station_id;

    SELECT COUNT(*)::INT INTO bikes_parked
    FROM bikes b WHERE b.station_id = p_station_id;

    IF v_cap IS NULL OR v_cap = 0 THEN
        capacity_pct := NULL;
    ELSE
        capacity_pct := ROUND(100.0 * bikes_parked / v_cap, 1);
    END IF;
END;
$$ LANGUAGE plpgsql;

SELECT s.station_id, s.station_name, l.*
FROM stations s, LATERAL station_load(s.station_id) l;

-- Task 7.2

CREATE OR REPLACE FUNCTION top_members(p_limit INT DEFAULT 3)
RETURNS TABLE (t_name VARCHAR, t_rentals INT, t_spent NUMERIC)
AS $$
BEGIN
    RETURN QUERY
    SELECT m.full_name,
           COUNT(r.rental_id)::INT,
           COALESCE(SUM(r.fee), 0)
    FROM members m
    LEFT JOIN rentals r ON r.member_id = m.member_id
    GROUP BY m.member_id, m.full_name
    ORDER BY COALESCE(SUM(r.fee), 0) DESC, m.full_name
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM top_members();
SELECT * FROM top_members(6);

-- member 1 because the order is by sum

-- Task 7.3

CREATE OR REPLACE FUNCTION rental_invoice(p_rental_id INT)
RETURNS TABLE (i_member VARCHAR, i_model VARCHAR, i_days INT,
               i_amount NUMERIC, i_status VARCHAR)
AS $$
BEGIN
    RETURN QUERY
    SELECT m.full_name,
           b.model,
           d.days,
           ROUND(d.days * b.daily_rate, 2),
           (CASE WHEN r.end_date IS NULL THEN 'OPEN' ELSE 'CLOSED' END)::VARCHAR
    FROM rentals r
    JOIN members m ON m.member_id = r.member_id
    JOIN bikes   b ON b.bike_id   = r.bike_id
    CROSS JOIN LATERAL (
        SELECT COALESCE(r.end_date, CURRENT_DATE) - r.start_date AS days
    ) d
    WHERE r.rental_id = p_rental_id;
END;
$$ LANGUAGE plpgsql STABLE;

SELECT * FROM rental_invoice(11);
SELECT * FROM rental_invoice(19);

-- Yes it does
-- The rent for rent 19 is not closed so the fee is counting by current date
-- It cannot be immutable because with same in data it is different out data

-- Task 7.4

CREATE OR REPLACE FUNCTION city_report(p_city VARCHAR)
RETURNS TABLE (c_members INT, c_rentals INT, c_revenue NUMERIC)
AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(DISTINCT m.member_id)::INT,
           COUNT(r.rental_id)::INT,
           COALESCE(SUM(r.fee), 0)
    FROM members m
    LEFT JOIN rentals r ON r.member_id = m.member_id
    WHERE m.city = p_city;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION city_report(p_city VARCHAR, p_from_date DATE)
RETURNS TABLE (c_members INT, c_rentals INT, c_revenue NUMERIC)
AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(DISTINCT m.member_id)::INT,
           COUNT(r.rental_id)::INT,
           COALESCE(SUM(r.fee), 0)
    FROM members m
    LEFT JOIN rentals r ON r.member_id = m.member_id
                       AND r.start_date >= p_from_date
    WHERE m.city = p_city;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM city_report('Almaty');
SELECT * FROM city_report('Almaty', DATE '2025-01-01');

-- On because member without rent still in result
-- WHERE clause do not add a member without rent in the result


-- Questions

-- 1 Name its just name. Signature it is a name with an in arguments
-- 2 It is using te regard body of function. It is needed to prevent errors, misunderstandings e.t.c
CREATE FUNCTION greet(p_name TEXT) RETURNS TEXT AS $$
BEGIN
    RETURN 'Hello, ' || p_name || '! It''s a nice day';
END;
$$ LANGUAGE plpgsql;

-- 3 When it returns 1 string of several values
-- RETURN TABLE for several strings
-- 4 All arguments in VARIADIC position adds in one array.
-- If there is more parameter after Variadic it is impossible to understand where the array ends
-- 5 RETURN returns one value and finishes the function
-- Return QUERY adds all rows of query but not stops the function
-- 6 For example i have function total_fess(INT) and total_fees(INT, DATE DEFAULT CURRENT DATE),
-- call total_fees(1) fits for both functions, so postgres cannot understand which function to call
-- 7. When a subblock ends, its variable disappears and the outer block cannot see it. To read a shadowed outer variable, use the block label, for example outer_label.variable_name.
-- 8. An advantage is that the rule is stored in one place, so every application uses the same logic.
--A disadvantage is that stored functions are harder to test, version and debug than application code.
-- 9. A trusted language like PL/pgSQL cannot access the server's files or system, so regular users with the right privileges can create functions in it.
-- An untrusted language like PL/Python has full access to the server, so only a superuser can create functions in it.
-- 10. If the argument types change, PostgreSQL creates a new function and the old one stays in the database, so you get an overload instead of a replacement.
-- This can cause confusion, because old calls still use the old logic, and some calls may become ambiguous.