\set ON_ERROR_STOP 1
\set VERBOSITY verbose
\set SHOW_CONTEXT never

\ir include/create_clustered_db.sql

\set ECHO ALL
\c Test1

create schema test_schema;
create table test_schema.test_table(time bigint, temp float8, device_id text);
\dt "test_schema".*
select * from create_hypertable('test_schema.test_table', 'time', 'device_id');

\C test2
\dt "test_schema".*

--test partitioning in only time dimension
create table test_schema.test_1dim(time timestamp, temp float);
select create_hypertable('test_schema.test_1dim', 'time');

\dt "test_schema".*