DROP TABLE IF EXISTS master_table_users;
CREATE TABLE IF NOT EXISTS master_table_users (
	id int PRIMARY KEY,
	user_name varchar(20),
	user_birth_date int
);

DROP TABLE IF EXISTS first_quarter, second_quarter, third_quarter, fourth_quarter;

CREATE OR REPLACE FUNCTION adding_check() RETURNS TRIGGER AS $$
	BEGIN
		IF (NEW.id >= 1 AND NEW.id <= 250) THEN
			CREATE TABLE IF NOT EXISTS first_quarter (
				quarter_num int
			) INHERITS (master_table_users);
			INSERT INTO first_quarter VALUES (NEW.id, NEW.user_name, NEW.user_birth_date, 1);
		
		ELSIF (NEW.id >= 251 AND NEW.id <= 500) THEN
			CREATE TABLE IF NOT EXISTS second_quarter (
				quarter_num int
			) INHERITS (master_table_users);
			INSERT INTO second_quarter VALUES (NEW.id, NEW.user_name, NEW.user_birth_date, 2);
		
		ELSIF (NEW.id >= 501 AND NEW.id <= 750) THEN
			CREATE TABLE IF NOT EXISTS third_quarter (
				quarter_num int
			) INHERITS (master_table_users);
			INSERT INTO third_quarter VALUES (NEW.id, NEW.user_name, NEW.user_birth_date, 3);
		
		ELSIF (NEW.id >= 751 AND NEW.id <= 1000) THEN
			CREATE TABLE IF NOT EXISTS fourth_quarter (
				quarter_num int
			) INHERITS (master_table_users);
			INSERT INTO fourth_quarter VALUES (NEW.id, NEW.user_name, NEW.user_birth_date, 4);
		END IF;
		RETURN NEW;
	END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER new_table BEFORE INSERT ON master_table_users FOR EACH ROW
	EXECUTE PROCEDURE adding_check(); 
	
INSERT INTO master_table_users (id, user_name, user_birth_date) 
	SELECT number, concat('User', number), 1950 + random() * 64 FROM generate_series(1, 1000) as number;

TRUNCATE master_table_users