CREATE TRIGGER trigger_main_on_change_hypertable_trigger
AFTER INSERT OR UPDATE OR DELETE ON _timescaledb_catalog.hypertable_trigger
FOR EACH ROW EXECUTE PROCEDURE _timescaledb_internal.on_change_hypertable_trigger();

CREATE TRIGGER trigger_main_on_change_chunk_trigger
AFTER INSERT OR UPDATE OR DELETE ON _timescaledb_catalog.chunk_trigger
FOR EACH ROW EXECUTE PROCEDURE _timescaledb_internal.on_change_chunk_trigger();

CREATE EVENT TRIGGER ddl_drop_trigger
ON sql_drop
EXECUTE PROCEDURE _timescaledb_internal.ddl_process_drop_trigger();
