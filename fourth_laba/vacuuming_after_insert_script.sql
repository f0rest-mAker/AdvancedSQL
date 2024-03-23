select table_name, pg_size_pretty(pg_relation_size('vacuum_test'))
from information_schema.tables
where table_schema = 'public' and
table_catalog = 'AdvancedSQL' and table_name = 'vacuum_test';
-- size after 1000000 update = 10056 kB
-- more than 10056 / 8 = 1257 times

VACUUM vacuum_test;

select table_name, pg_size_pretty(pg_relation_size('vacuum_test'))
from information_schema.tables
where table_schema = 'public' and
table_catalog = 'AdvancedSQL' and table_name = 'vacuum_test';
-- after vacuum = 10056 kB

VACUUM FULL vacuum_test;

select table_name, pg_size_pretty(pg_relation_size('vacuum_test'))
from information_schema.tables
where table_schema = 'public' and
table_catalog = 'AdvancedSQL' and table_name = 'vacuum_test';
-- after VACUUM FULL size = 8 kB