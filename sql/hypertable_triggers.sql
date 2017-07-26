CREATE OR REPLACE FUNCTION _timescaledb_internal.on_insert_main_table_error()
    RETURNS TRIGGER LANGUAGE PLPGSQL AS
$BODY$
BEGIN
    RAISE 'Should never be inserting data directly to the main table of hypertable: %.%',
    TG_TABLE_SCHEMA, TG_TABLE_NAME;
END
$BODY$;


-- This file contains triggers that act on the main 'hypertable' table as
-- well as triggers for newly created hypertables.
CREATE OR REPLACE FUNCTION _timescaledb_internal.on_change_hypertable()
    RETURNS TRIGGER LANGUAGE PLPGSQL AS
$BODY$
DECLARE
BEGIN
    IF TG_OP = 'INSERT' THEN
        DECLARE 
            cnt INTEGER;
        BEGIN
            EXECUTE format(
                $$
                    CREATE SCHEMA IF NOT EXISTS %I
                $$, NEW.associated_schema_name);
        EXCEPTION
            WHEN insufficient_privilege THEN
                SELECT COUNT(*) INTO cnt
                FROM pg_namespace 
                WHERE nspname = NEW.associated_schema_name;
                IF cnt = 0 THEN
                    RAISE;
                END IF;

        END;
        EXECUTE format(
            $$
                CREATE TRIGGER _timescaledb_main_insert_error_trigger BEFORE INSERT ON %I.%I
                FOR EACH ROW EXECUTE PROCEDURE _timescaledb_internal.on_insert_main_table_error();
            $$, NEW.schema_name, NEW.table_name);
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
       RETURN NEW;
    END IF;

    PERFORM _timescaledb_internal.on_trigger_error(TG_OP, TG_TABLE_SCHEMA, TG_TABLE_NAME);
END
$BODY$
SET client_min_messages = WARNING; -- suppress NOTICE on IF EXISTS schema
