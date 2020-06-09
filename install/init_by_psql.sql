/*
 * filo-SCIENCE - 2018-07-03
 * Script de creation des tables destinees a recevoir les donnees de l'application
 * database creation script
 *
 * version minimale de Postgresql : 9.4. / Minimal release of postgresql: 9.4
 *
 * Schemas par defaut : col pour les donnees, et gacl pour les droits.
 * Default schemas : col for data, gacl for right management
 * Si vous voulez utiliser d'autres schemas, modifiez les scripts :
 * If you want use others schemas, change these scripts:
 * gacl_create_2.1.sql et col_create_2.1.sql
 * Execution de ce script en ligne de commande, en etant connecte root :
 * at prompt, you cas execute this script as root:
 * su postgres -c "psql -f init_by_psql.sql"
 *
 * dans la configuration de postgresql : / postgresql configuration:
 * /etc/postgresql/version/main/pg_hba.conf
 * inserez les lignes suivantes (connexion avec uniquement le compte filo en local) :
 * insert theses lines (connection only with the account filo on local server):
 * host    filo             filo             127.0.0.1/32            md5
 * host    all            filo                  0.0.0.0/0               reject
 */

 /*
  * Creation du compte de connexion et de la base de donnees
  * creation of connection account
  */
-- object: filo | type: ROLE --
-- DROP ROLE IF EXISTS filo;
CREATE ROLE filo WITH
	LOGIN
	ENCRYPTED PASSWORD 'filoPassword';
-- ddl-end --

/*
 * Database creation
 */
create database filo owner filo;
\c "dbname=filo"
-- object: postgis | type: EXTENSION --
-- DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis
WITH SCHEMA public;
-- ddl-end --
-- object: tablefunc | type: EXTENSION --
-- DROP EXTENSION IF EXISTS tablefunc CASCADE;
CREATE EXTENSION tablefunc
WITH SCHEMA public;
-- ddl-end --
-- object: pgcrypto | type: EXTENSION --
-- DROP EXTENSION IF EXISTS pgcrypto CASCADE;
CREATE EXTENSION pgcrypto
WITH SCHEMA public;
-- ddl-end --

 -- object: grant_95c2183ced | type: PERMISSION --
GRANT CREATE,CONNECT,TEMPORARY
   ON DATABASE filo
   TO filo;
-- ddl-end --

/*
 * Connection at the database filo with login filo localhost server
 * from psql
 */
\c "dbname=filo user=filo password=filoPassword host=localhost"

/**
 * create structure
 */
\ir pgsql/create_db.sql
