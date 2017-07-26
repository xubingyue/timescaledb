DROP FUNCTION IF EXISTS _timescaledb_internal.timescale_trigger_names();
DROP FUNCTION IF EXISTS _timescaledb_internal.main_table_insert_trigger() CASCADE;
DROP FUNCTION IF EXISTS _timescaledb_internal.main_table_after_insert_trigger() CASCADE;

DO $BODY$
DECLARE
    r record;
BEGIN 
    FOR r IN SELECT * FROM _timescaledb_catalog.hypertable 
        LOOP
            EXECUTE format(
            $$
                CREATE TRIGGER _timescaledb_main_insert_error_trigger BEFORE INSERT ON %I.%I
                FOR EACH ROW EXECUTE PROCEDURE _timescaledb_internal.on_insert_main_table_error();
            $$, r.schema_name, r.table_name);
        END LOOP;
END
$BODY$;
