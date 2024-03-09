DROP TABLE IF EXISTS test_table_1, test_table_2, test_table_3, test_table_4;

CREATE TABLE IF NOT EXISTS test_table_1 (
	value_id integer,
	value_name varchar(100)
) WITH (fillfactor = 50);
CREATE TABLE IF NOT EXISTS test_table_2 (
	value_id integer,
	value_name varchar(100)
) WITH (fillfactor = 75);
CREATE TABLE IF NOT EXISTS test_table_3 (
	value_id integer,
	value_name varchar(100)
) WITH (fillfactor = 90);
CREATE TABLE IF NOT EXISTS test_table_4 (
	value_id integer,
	value_name varchar(100)
) WITH (fillfactor = 100);

INSERT INTO test_table_1 VALUES (generate_series(1, 10000), repeat('R', 50)); -- 1.63 MB
INSERT INTO test_table_2 VALUES (generate_series(1, 10000), repeat('T', 50)); -- 1.09 MB
INSERT INTO test_table_3 VALUES (generate_series(1, 10000), repeat('S', 50)); -- 920 KB
INSERT INTO test_table_4 VALUES (generate_series(1, 10000), repeat('M', 50)); -- 832 KB

EXPLAIN ANALYZE UPDATE test_table_1 SET value_name = concat(value_name, value_name) where value_id > 0; -- 139.925 ms
EXPLAIN ANALYZE UPDATE test_table_2 SET value_name = concat(value_name, value_name) where value_id > 0; -- 62.437 ms
EXPLAIN ANALYZE UPDATE test_table_3 SET value_name = concat(value_name, value_name) where value_id > 0; -- 62.226 ms
EXPLAIN ANALYZE UPDATE test_table_4 SET value_name = concat(value_name, value_name) where value_id > 0; -- 71.806 ms

