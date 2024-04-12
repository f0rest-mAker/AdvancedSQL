BEGIN
	DROP TABLE IF EXISTS master_people;

	CREATE TABLE master_people (
		id int,
		person_name varchar,
		person_age int
	);

	DROP TABLE IF EXISTS boomer, zoomer, gen_z;

	CREATE OR REPLACE FUNCTION before_add() RETURNS TRIGGER AS $$
	BEGIN
		IF (NEW.person_age <= 18) THEN
			CREATE TABLE IF NOT EXISTS gen_z (
			) INHERITS (master_people);
			INSERT INTO gen_z VALUES (NEW.id, NEW.person_name, NEW.person_age);

		ELSIF (NEW.person_age > 18 AND NEW.person_age <= 25) THEN
			CREATE TABLE IF NOT EXISTS zoomer (
			) INHERITS (master_people);
			INSERT INTO zoomer VALUES (NEW.id, NEW.person_name, NEW.person_age);

		ELSIF (NEW.person_age > 25) THEN
			CREATE TABLE IF NOT EXISTS boomer (
			) INHERITS (master_people);
			INSERT INTO boomer VALUES (NEW.id, NEW.person_name, NEW.person_age);

		END IF;
		RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;

	CREATE OR REPLACE TRIGGER before_adding_master BEFORE INSERT ON master_people FOR EACH ROW
		EXECUTE PROCEDURE before_add();

	INSERT INTO master_people (id, person_name, person_age) 
		SELECT  number, concat('person', number), 10 + random() * 40 
		FROM generate_series(1, 150) AS number;

	SELECT relname AS table_name, n_live_tup AS tuple_count FROM pg_stat_user_tables
		WHERE relname in ('boomer', 'zoomer', 'gen_z');
END;