begin;

	DROP TABLE IF EXISTS unlog_test;
	
	CREATE UNLOGGED TABLE unlog_test (
		ID bigint PRIMARY KEY
	);
	
	INSERT INTO unlog_test
	SELECT * from generate_series(1, 100000);

end;