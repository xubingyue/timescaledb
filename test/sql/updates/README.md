Testing using multiple versions

0) build current container
IMAGE_NAME=update_test TAG_NAME=latest bash scripts/docker-build.sh

Build updated container: 
1) Setup a 0.1.0 docker.
docker run -d --name timescaledb-orig -v /tmp/pg_data:/var/lib/postgresql/data -p 5432:5432 timescale/timescaledb
2) Run a test setup script:
psql -h localhost -U postgres -f test/sql/updates/setup.sql
3) Stop 0.1.0 docker.
docker rm -vf timescaledb-orig
5) run built container
docker run -d --name timescaledb-updated -v /tmp/pg_data:/var/lib/postgresql/data -p 6432:5432 update_test:latest
6) update extension
psql -h localhost -U postgres -d single -p 6432 -c "ALTER EXTENSION timescaledb UPDATE"

Build a clean-slate container:
1) Run container 
docker run -d --name timescaledb-clean -v /tmp/pg_data_clean:/var/lib/postgresql/data -p 6433:5432 update_test:latest
2) Run setup script:
psql -h localhost -U postgres -f test/sql/updates/setup.sql


Compare:

