----------------- complex number part -----------------
DROP TYPE IF EXISTS complex_number;
CREATE TYPE complex_number as (real_part int, imaginary_part int);

DROP TABLE IF EXISTS complex_number_table;
CREATE TABLE complex_number_table (
	id int PRIMARY KEY,
	first_number complex_number,
	second_number complex_number
);

INSERT INTO complex_number_table (id, first_number, second_number) 
	SELECT number_id, CAST(ROW(-20 + random() * 40, -20 + random() * 40) as complex_number),
			CAST(ROW(-20 + random() * 40, -20 + random() * 40) as complex_number) FROM generate_series(2, 10) as number_id;

SELECT * FROM complex_number_table;

-- sum function
CREATE OR REPLACE FUNCTION complex_number_sum(first complex_number, second complex_number) RETURNS complex_number AS $$
BEGIN
	RETURN ROW(first.real_part + second.real_part, first.imaginary_part + second.imaginary_part);
END;
$$ LANGUAGE plpgsql;

-- subtraction function
CREATE OR REPLACE FUNCTION complex_number_diff(first complex_number, second complex_number) RETURNS complex_number AS $$
BEGIN
	RETURN ROW(first.real_part - second.real_part, first.imaginary_part - second.imaginary_part);
END;
$$ LANGUAGE plpgsql;

SELECT first_number, second_number, complex_number_sum(first_number, second_number) as sum FROM complex_number_table;

-- division function
CREATE OR REPLACE FUNCTION complex_number_div(first complex_number, second complex_number) RETURNS complex_number AS $$
BEGIN
	RETURN ROW((first.real_part * second.real_part + first.imaginary_part * second.imaginary_part) / 
					(second.real_part * second.real_part + second.imaginary_part * second.imaginary_part),
					(first.imaginary_part * second.real_part - first.real_part * second.imaginary_part) / 
					(second.real_part * second.real_part + second.imaginary_part * second.imaginary_part));
END;
$$ LANGUAGE plpgsql;
-- product function
CREATE OR REPLACE FUNCTION complex_number_mul(first complex_number, second complex_number) RETURNS complex_number AS $$
BEGIN
	RETURN ROW(first.real_part * second.real_part + first.imaginary_part * second.imaginary_part, 
					first.real_part * second.imaginary_part + first.imaginary_part * second.real);
END;
$$ LANGUAGE plpgsql;

----------------- Aggregate fuction part -----------------
DROP AGGREGATE IF EXISTS complex_sum(complex_number);

CREATE OR REPLACE FUNCTION sum_transition(first complex_number, second complex_number) RETURNS complex_number AS $$
BEGIN
	RETURN ROW(first.real_part + second.real_part, first.imaginary_part + second.imaginary_part)::complex_number;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION final_sum(first complex_number) RETURNS complex_number AS $$
BEGIN
	return ROW(first.real_part, first.imaginary_part)::complex_number;
END;
$$ LANGUAGE plpgsql;

CREATE AGGREGATE complex_sum(complex_number) (
	sfunc = sum_transition,
	stype = complex_number,
	finalfunc = final_sum,
	initcond = '(0, 0)'
);

SELECT complex_sum(first_number) FROM complex_number_table;

SELECT first_number FROM complex_number_table;