ALTER TABLE _timescaledb_catalog.hypertable ADD UNIQUE (id, schema_name);
ALTER TABLE _timescaledb_catalog.hypertable_index DROP CONSTRAINT hypertable_index_hypertable_id_fkey;
ALTER TABLE _timescaledb_catalog.hypertable_index ADD CONSTRAINT hypertable_index_hypertable_id_fkey FOREIGN KEY (hypertable_id, main_schema_name) REFERENCES _timescaledb_catalog.hypertable(id, schema_name) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE _timescaledb_catalog.chunk_index
DROP CONSTRAINT chunk_index_main_schema_name_fkey,
ADD CONSTRAINT chunk_index_main_schema_name_fkey
FOREIGN KEY (main_schema_name, main_index_name) 
REFERENCES _timescaledb_catalog.hypertable_index(main_schema_name, main_index_name) 
ON UPDATE CASCADE 
ON DELETE CASCADE;


CREATE TABLE IF NOT EXISTS _timescaledb_catalog.hypertable_trigger (
    id               SERIAL              NOT NULL PRIMARY KEY,
    hypertable_id    INTEGER             NOT NULL REFERENCES _timescaledb_catalog.hypertable(id) ON DELETE CASCADE,
    trigger_name     NAME                NOT NULL,
    definition       TEXT                NOT NULL, -- def with /*TABLE_NAME*/ placeholders
    UNIQUE(hypertable_id, trigger_name)
);
SELECT pg_catalog.pg_extension_config_dump('_timescaledb_catalog.hypertable_trigger', '');
SELECT pg_catalog.pg_extension_config_dump(pg_get_serial_sequence('_timescaledb_catalog.hypertable_trigger','id'), '');

CREATE TABLE IF NOT EXISTS _timescaledb_catalog.chunk_trigger (
    id                      SERIAL  PRIMARY KEY,
    chunk_id                INTEGER NOT NULL REFERENCES _timescaledb_catalog.chunk(id) ON DELETE CASCADE,
    hypertable_trigger_id   INTEGER NOT NULL REFERENCES _timescaledb_catalog.hypertable_trigger(id) ON DELETE CASCADE,
    trigger_name            NAME    NOT NULL,
    definition              TEXT    NOT NULL
);
SELECT pg_catalog.pg_extension_config_dump('_timescaledb_catalog.chunk_trigger', '');
SELECT pg_catalog.pg_extension_config_dump(pg_get_serial_sequence('_timescaledb_catalog.chunk_trigger','id'), '');
