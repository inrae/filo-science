\c "dbname=filo"
create extension IF NOT EXISTS postgis schema public;
create extension IF NOT EXISTS pgcrypto schema public;
create extension IF NOT EXISTS tablefunc schema public;
\c "dbname=filo user=filo password=filoPassword host=localhost"
\ir pgsql/alter-1.2-1.3.sql
