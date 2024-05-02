DROP TABLE IF EXISTS test_table_8;
CREATE TABLE test_table_8 (
	A int,
	B int,
	C int
);

TRUNCATE test_table_8;
INSERT INTO test_table_8 (A, B, C) SELECT random() * 200, random() * 200, random() * 200 FROM generate_series(1, 100000);

CREATE INDEX test_8_A ON test_table_8 (A);
CREATE INDEX test_8_B ON test_table_8 (B);
CREATE INDEX test_8_C ON test_table_8 (C);

CREATE INDEX test_8_AB ON test_table_8 (A, B);
CREATE INDEX test_8_AC ON test_table_8 (A, C);
CREATE INDEX test_8_BC ON test_table_8 (B, C);

CREATE INDEX test_8_ABC ON test_table_8 (A, B, C);
CREATE INDEX test_8_ACB ON test_table_8 (A, C, B);
CREATE INDEX test_8_BAC ON test_table_8 (B, A, C);
CREATE INDEX test_8_BCA ON test_table_8 (B, C, A);
CREATE INDEX test_8_CAB ON test_table_8 (C, A, B);
CREATE INDEX test_8_CBA ON test_table_8 (C, B, A);

VACUUM ANALYZE test_table_8;

EXPLAIN ANALYZE SELECT A, B, C FROM test_table_8
WHERE C = 45 AND B = 12 AND A = 10;


EXPLAIN ANALYZE SELECT min(A) OVER(PARTITION BY B,C ORDER BY B,C) FROM test_table_8
WHERE A = A
ORDER BY C, B

SELECT * FROM pg_stat_user_indexes