\c "dbname=filo"
create extension IF NOT EXISTS postgis schema public;
create extension IF NOT EXISTS pgcrypto schema public;
create extension IF NOT EXISTS tablefunc schema public;
\c "dbname=filo user=filo password=filoPassword host=localhost"
\ir pgsql/alter-1.2-1.3.sql
\ir pgsql/alter-1.3-1.4.sql
\ir pgsql/alter-1.4-1.5.sql
\ir pgsql/alter-1.5-1.6.sql
\ir pgsql/alter-1.6-1.7.sql
\ir pgsql/alter-1.7-1.8.sql
\ir pgsql/alter-1.8-1.9.sql
\ir pgsql/alter-1.9-1.10.sql
