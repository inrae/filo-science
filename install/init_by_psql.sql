/*
 * filo - 2018-0/-17
 * Script de creation des tables destinees a recevoir les donnees de l'application
 * database creation script
 * 
 * version minimale de Postgresql : 9.4. / Minimal release of postgresql: 9.4
 * 
 * Schemas par defaut : col pour les donnees, et gacl pour les droits. 
 * Default schemas : col for data, gacl for right management
 * Si vous voulez utiliser d'autres schemas, modifiez ce script :
 * If you want use others schemas, change this script:
 * install/pgsql/create_db.sql
 * Execution de ce script en ligne de commande, en etant connecte root :
 * at prompt, you cas execute this script as root:
 * su postgres -c "psql -f init_by_psql.sql"
 * 
 * dans la configuration de postgresql : / postgresql configuration:
 * /etc/postgresql/version/main/pg_hba.conf
 * inserez les lignes suivantes (connexion avec uniquement le compte collec en local) :
 * insert theses lines (connection only with the account collec on local server):
 * host    collec             collec             127.0.0.1/32            md5
 * host    all            collec                  0.0.0.0/0               reject
 */
 
 /*
  * Creation du compte de connexion et de la base de donnees
  * creation of connection account
  */
CREATE USER filo WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
 PASSWORD 'filoPassword'  
;

/*
 * Database creation
 */
create database filo owner filo;
\c "dbname=filo"
create extension postgis schema public;

/*
 * connexion a la base filo, avec l'utilisateur filo, en localhost,
 * depuis psql
 * Connection to collec database with user filo on localhost server
 */
\c "dbname=filo user=filo password=filoPassword host=localhost"


/*
 * Creation des tables dans le schema col
 * Tables creation in schema col
 */
\ir pgsql/create_db.sql
