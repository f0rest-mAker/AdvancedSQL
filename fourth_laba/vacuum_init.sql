DROP TABLE IF EXISTS vacuum_test;

CREATE TABLE vacuum_test (
	id int,
	name varchar
) WITH (autovacuum_enabled = false);

INSERT INTO vacuum_test VALUES 
	(1, 'User #1');

select table_name, pg_size_pretty(pg_relation_size('vacuum_test'))
from information_schema.tables
where table_schema = 'public' and
table_catalog = 'AdvancedSQL' and table_name = 'vacuum_test';
-- Size with 1 tuple = 8 kB

