begin;
	DROP TABLE IF EXISTS log_test;

	CREATE TABLE log_test (
		ID bigint PRIMARY KEY 
	);

	INSERT INTO log_test 
	SELECT * from generate_series(1, 100000);
end;