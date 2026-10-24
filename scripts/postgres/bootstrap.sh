#!/usr/bin/env bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER owui_main WITH PASSWORD 'password';
	CREATE USER owui_vector WITH PASSWORD 'password';
	CREATE USER owui_kb WITH PASSWORD 'password';
	CREATE USER sonarqube WITH PASSWORD 'password';
	CREATE DATABASE owui_main OWNER owui_main;
	CREATE DATABASE owui_vector OWNER owui_vector;
	CREATE DATABASE owui_kb OWNER owui_kb;
	CREATE DATABASE sonarqube OWNER sonarqube;
	GRANT ALL PRIVILEGES ON DATABASE owui_main TO owui_main;
	GRANT ALL PRIVILEGES ON DATABASE owui_vector TO owui_vector;
	GRANT ALL PRIVILEGES ON DATABASE owui_kb TO owui_kb;
	GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;
	ALTER ROLE owui_main SUPERUSER;
	ALTER ROLE owui_vector SUPERUSER;
	ALTER ROLE owui_kb SUPERUSER;
EOSQL
