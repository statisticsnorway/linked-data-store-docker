CREATE EXTENSION dblink;

CREATE OR REPLACE FUNCTION create_user_if_not_exists(username NAME, password NAME) RETURNS TEXT LANGUAGE plpgsql AS
$$
BEGIN
    IF (SELECT EXISTS (SELECT 1 FROM pg_roles WHERE rolname=username)) THEN
        RETURN format('USER %L ALREADY EXISTS', username);
    ELSE
        EXECUTE format('CREATE USER %I WITH PASSWORD %L', username, password);
        RETURN format('USER %L CREATED', username);
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION create_database_if_not_exists(dbname text)
    RETURNS integer AS
$$
BEGIN

    IF EXISTS (SELECT 1 FROM pg_database WHERE datname = dbname) THEN
        RAISE NOTICE 'Database already exists';
    ELSE
        PERFORM dblink_exec('dbname=' || current_database()   -- current db
                    , 'CREATE DATABASE ' || quote_ident(dbname));
    END IF;
    RETURN 1;
END
$$ LANGUAGE plpgsql;

SELECT create_user_if_not_exists('lds', 'lds');

SELECT create_database_if_not_exists('txlog');
SELECT create_database_if_not_exists('sagalog');

GRANT ALL PRIVILEGES ON DATABASE txlog TO lds;
GRANT ALL PRIVILEGES ON DATABASE sagalog TO lds;
