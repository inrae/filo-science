-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta2
-- Diff date: 2019-11-18 10:08:09
-- Source model: filo
-- Database: filodemo
-- PostgreSQL version: 9.5

-- [ Diff summary ]
-- Dropped objects: 1
-- Created objects: 111
-- Changed objects: 148
-- Truncated tables: 0

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --

-- object: pgcrypto | type: EXTENSION --
-- DROP EXTENSION IF EXISTS pgcrypto CASCADE;
-- CREATE EXTENSION pgcrypto
-- WITH SCHEMA public;
-- ddl-end --


-- object: postgis | type: EXTENSION --
-- DROP EXTENSION IF EXISTS postgis CASCADE;
-- CREATE EXTENSION postgis
-- WITH SCHEMA public;
-- ddl-end --

-- object: tablefunc | type: EXTENSION --
-- DROP EXTENSION IF EXISTS tablefunc CASCADE;
-- CREATE EXTENSION tablefunc
-- WITH SCHEMA public;
-- ddl-end --

-- [ Dropped objects ] --
ALTER TABLE gacl.passwordlost DROP CONSTRAINT IF EXISTS logingestion_passwordlost_fk CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: metric_srid | type: COLUMN --
-- ALTER TABLE filo.project DROP COLUMN IF EXISTS metric_srid CASCADE;
ALTER TABLE filo.project ADD COLUMN metric_srid smallint DEFAULT 2154;
-- ddl-end --

COMMENT ON COLUMN filo.project.metric_srid IS E'Srid in metric referential, for calculate circles or other geographic objects';
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.campaign DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.campaign ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --

-- object: geom | type: COLUMN --
-- ALTER TABLE filo.station DROP COLUMN IF EXISTS geom CASCADE;
ALTER TABLE filo.station ADD COLUMN geom geometry(POINT, 4326);
-- ddl-end --

COMMENT ON COLUMN filo.station.geom IS E'Geographical representation of the situation of the station';
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.operation DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.operation ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.sequence DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.sequence ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.sample DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.sample ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: transmitter | type: COLUMN --
-- ALTER TABLE filo.individual DROP COLUMN IF EXISTS transmitter CASCADE;
ALTER TABLE filo.individual ADD COLUMN transmitter varchar;
-- ddl-end --

COMMENT ON COLUMN filo.individual.transmitter IS E'Acoustic or radio transmitter identifier';
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.individual DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.individual ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.sequence_gear DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.sequence_gear ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.analysis DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.analysis ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.ambience DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.ambience ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.operator DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.operator ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: tracking | type: SCHEMA --
-- DROP SCHEMA IF EXISTS tracking CASCADE;
CREATE SCHEMA tracking;
-- ddl-end --
ALTER SCHEMA tracking OWNER TO filo;
-- ddl-end --

-- object: tracking.release_place_release_place_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.release_place_release_place_id_seq CASCADE;
CREATE SEQUENCE tracking.release_place_release_place_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.release_place_release_place_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.individual_tracking | type: TABLE --
-- DROP TABLE IF EXISTS tracking.individual_tracking CASCADE;
CREATE TABLE tracking.individual_tracking (
	individual_id integer NOT NULL,
	release_station_id integer,
	taxon_id integer NOT NULL,
	project_id integer NOT NULL,
	transmitter_type_id integer,
	CONSTRAINT individual_tracking_pk PRIMARY KEY (individual_id)

);
-- ddl-end --
ALTER TABLE tracking.individual_tracking OWNER TO filo;
-- ddl-end --

-- object: tracking.station_tracking | type: TABLE --
-- DROP TABLE IF EXISTS tracking.station_tracking CASCADE;
CREATE TABLE tracking.station_tracking (
	station_id integer NOT NULL,
	station_type_id integer NOT NULL,
	CONSTRAINT station_tracking_pk PRIMARY KEY (station_id)

);
-- ddl-end --
ALTER TABLE tracking.station_tracking OWNER TO filo;
-- ddl-end --

-- object: tracking.station_type_station_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.station_type_station_type_id_seq CASCADE;
CREATE SEQUENCE tracking.station_type_station_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.station_type_station_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.station_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.station_type CASCADE;
CREATE TABLE tracking.station_type (
	station_type_id integer NOT NULL DEFAULT nextval('tracking.station_type_station_type_id_seq'::regclass),
	station_type_name varchar NOT NULL,
	CONSTRAINT station_type_pk PRIMARY KEY (station_type_id)

);
-- ddl-end --
ALTER TABLE tracking.station_type OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna_antenna_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.antenna_antenna_id_seq CASCADE;
CREATE SEQUENCE tracking.antenna_antenna_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.antenna_antenna_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna | type: TABLE --
-- DROP TABLE IF EXISTS tracking.antenna CASCADE;
CREATE TABLE tracking.antenna (
	antenna_id integer NOT NULL DEFAULT nextval('tracking.antenna_antenna_id_seq'::regclass),
	station_id integer NOT NULL,
	technology_type_id integer NOT NULL,
	antenna_code varchar NOT NULL,
	radius smallint,
	geom_polygon geometry(POLYGON, 4326),
	CONSTRAINT antenna_pk PRIMARY KEY (antenna_id)

);
-- ddl-end --
ALTER TABLE tracking.antenna OWNER TO filo;
-- ddl-end --

-- object: tracking.detection_detection_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.detection_detection_id_seq CASCADE;
CREATE SEQUENCE tracking.detection_detection_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.detection_detection_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.detection | type: TABLE --
-- DROP TABLE IF EXISTS tracking.detection CASCADE;
CREATE TABLE tracking.detection (
	detection_id integer NOT NULL DEFAULT nextval('tracking.detection_detection_id_seq'::regclass),
	individual_id integer NOT NULL,
	antenna_id integer,
	detection_date timestamp NOT NULL,
	nb_events smallint,
	duration double precision,
	validity boolean NOT NULL DEFAULT 't',
	signal_force smallint,
	observation varchar,
	CONSTRAINT detection_pk PRIMARY KEY (detection_id)

);
-- ddl-end --
ALTER TABLE tracking.detection OWNER TO filo;
-- ddl-end --

-- object: tracking.probe_probe_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.probe_probe_id_seq CASCADE;
CREATE SEQUENCE tracking.probe_probe_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.probe_probe_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.probe | type: TABLE --
-- DROP TABLE IF EXISTS tracking.probe CASCADE;
CREATE TABLE tracking.probe (
	probe_id integer NOT NULL DEFAULT nextval('tracking.probe_probe_id_seq'::regclass),
	station_id integer NOT NULL,
	probe_code varchar NOT NULL,
	CONSTRAINT probe_pk PRIMARY KEY (probe_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.probe IS E'Probe used to record the environmental variables';
-- ddl-end --
COMMENT ON COLUMN tracking.probe.probe_code IS E'Probe used to record the environmental variables';
-- ddl-end --
ALTER TABLE tracking.probe OWNER TO filo;
-- ddl-end --

-- object: tracking.probe_measure_probe_measure_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.probe_measure_probe_measure_id_seq CASCADE;
CREATE SEQUENCE tracking.probe_measure_probe_measure_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.probe_measure_probe_measure_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.probe_measure | type: TABLE --
-- DROP TABLE IF EXISTS tracking.probe_measure CASCADE;
CREATE TABLE tracking.probe_measure (
	probe_measure_id integer NOT NULL DEFAULT nextval('tracking.probe_measure_probe_measure_id_seq'::regclass),
	probe_id integer NOT NULL,
	parameter_measure_type_id integer NOT NULL,
	probe_measure_date timestamp NOT NULL,
	probe_measure_value double precision NOT NULL,
	CONSTRAINT probe_measure_pk PRIMARY KEY (probe_measure_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.probe_measure IS E'List of the measures recorded by a probe';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_measure.probe_measure_date IS E'List of the measures recorded by a probe';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_measure.probe_measure_value IS E'List of the measures recorded by a probe';
-- ddl-end --
ALTER TABLE tracking.probe_measure OWNER TO filo;
-- ddl-end --

-- object: tracking.transmitter_type_transmitter_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.transmitter_type_transmitter_type_id_seq CASCADE;
CREATE SEQUENCE tracking.transmitter_type_transmitter_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.transmitter_type_transmitter_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.transmitter_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.transmitter_type CASCADE;
CREATE TABLE tracking.transmitter_type (
	transmitter_type_id integer NOT NULL DEFAULT nextval('tracking.transmitter_type_transmitter_type_id_seq'::regclass),
	transmitter_type_name varchar NOT NULL,
	characteristics varchar,
	technology varchar,
	CONSTRAINT transmitter_type_pk PRIMARY KEY (transmitter_type_id)

);
-- ddl-end --
ALTER TABLE tracking.transmitter_type OWNER TO filo;
-- ddl-end --

-- object: tracking.position_position_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.position_position_id_seq CASCADE;
CREATE SEQUENCE tracking.position_position_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.position_position_id_seq OWNER TO filo;
-- ddl-end --

-- object: import | type: SCHEMA --
-- DROP SCHEMA IF EXISTS import CASCADE;
CREATE SCHEMA import;
-- ddl-end --
ALTER SCHEMA import OWNER TO filo;
-- ddl-end --

-- object: import.import_description_import_description_id | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.import_description_import_description_id CASCADE;
CREATE SEQUENCE import.import_description_import_description_id
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.import_description_import_description_id OWNER TO filo;
-- ddl-end --

-- object: import.import_description | type: TABLE --
-- DROP TABLE IF EXISTS import.import_description CASCADE;
CREATE TABLE import.import_description (
	import_description_id integer NOT NULL DEFAULT nextval('import.import_description_import_description_id'::regclass),
	import_type_id integer NOT NULL,
	csv_type_id smallint NOT NULL,
	import_description_name varchar NOT NULL,
	separator varchar NOT NULL DEFAULT ';',
	CONSTRAINT import_type_pk PRIMARY KEY (import_description_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_description IS E'Import templates';
-- ddl-end --
COMMENT ON COLUMN import.import_description.import_description_name IS E'Import templates';
-- ddl-end --
COMMENT ON COLUMN import.import_description.separator IS E'Import templates';
-- ddl-end --
ALTER TABLE import.import_description OWNER TO filo;
-- ddl-end --

-- object: import.csv_type | type: TABLE --
-- DROP TABLE IF EXISTS import.csv_type CASCADE;
CREATE TABLE import.csv_type (
	csv_type_id smallint NOT NULL,
	csv_type_name varchar NOT NULL,
	CONSTRAINT csv_type_pk PRIMARY KEY (csv_type_id)

);
-- ddl-end --
ALTER TABLE import.csv_type OWNER TO filo;
-- ddl-end --

INSERT INTO import.csv_type (csv_type_id, csv_type_name) VALUES (E'1', E'Data in columns: classic format for CSV');
-- ddl-end --
INSERT INTO import.csv_type (csv_type_id, csv_type_name) VALUES (E'2', E'Data in lines: format entity-relation');
-- ddl-end --

-- object: import.column_er_column_er_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.column_er_column_er_id_seq CASCADE;
CREATE SEQUENCE import.column_er_column_er_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.column_er_column_er_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.import_column_import_column_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.import_column_import_column_id_seq CASCADE;
CREATE SEQUENCE import.import_column_import_column_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.import_column_import_column_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.import_column | type: TABLE --
-- DROP TABLE IF EXISTS import.import_column CASCADE;
CREATE TABLE import.import_column (
	import_column_id integer NOT NULL DEFAULT nextval('import.import_column_import_column_id_seq'::regclass),
	import_description_id integer NOT NULL,
	column_order smallint NOT NULL DEFAULT 1,
	table_column_name varchar,
	CONSTRAINT column_pk PRIMARY KEY (import_column_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_column IS E'List of all columns of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_column.column_order IS E'List of all columns of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_column.table_column_name IS E'List of all columns of the file';
-- ddl-end --
ALTER TABLE import.import_column OWNER TO filo;
-- ddl-end --

-- object: log_ip_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_ip_idx CASCADE;
CREATE INDEX log_ip_idx ON gacl.log
	USING btree
	(
	  ipaddress
	);
-- ddl-end --


-- object: import.function_type_function_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.function_type_function_type_id_seq CASCADE;
CREATE SEQUENCE import.function_type_function_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.function_type_function_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.function_type | type: TABLE --
-- DROP TABLE IF EXISTS import.function_type CASCADE;
CREATE TABLE import.function_type (
	function_type_id integer NOT NULL DEFAULT nextval('import.function_type_function_type_id_seq'::regclass),
	function_name varchar NOT NULL,
	description varchar NOT NULL,
	CONSTRAINT function_type_pk PRIMARY KEY (function_type_id)

);
-- ddl-end --
COMMENT ON TABLE import.function_type IS E'List of functions writed in the application, and usable to test or transform the data';
-- ddl-end --
COMMENT ON COLUMN import.function_type.function_name IS E'List of functions writed in the application, and usable to test or transform the data';
-- ddl-end --
COMMENT ON COLUMN import.function_type.description IS E'List of functions writed in the application, and usable to test or transform the data';
-- ddl-end --
ALTER TABLE import.function_type OWNER TO filo;
-- ddl-end --

INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'1', E'testValue', E'Teste si un champ contient la valeur indiquée');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'2', E'getSecondsFromTime', E'Transforme un champ de type hh:mm:ss.u en ss.u');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'3', E'extractRightChar', E'Extrait les n caractères à droite du champ');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'4', E'formatDateTime', E'Transforme une datetime dans un format reconnu par la base de données, à partir du format indiqué. Exemple : d/m/Y H:i:s pour une date de type 13/01/2019 08:50:00. La liste des formats autorisés est disponible ici : https://www.php.net/manual/fr/datetime.createfromformat.php');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'5', E'concatenateDateAndTime', E'Concatène un champ date et un champ time. L''argument doit correspondre au numéro de la colonne time');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'6', E'transformJulianToDate', E'Transforme un nombre de jours depuis la date indiquée en référence (au format Y-m-d) en date exploitable au format Y-m-d');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'7', E'verifyTypeNumber', E'Vérifie si une valeur est numérique ou non');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'8', E'testColumnsNumber', E'Vérifie que le nombre de colonnes de la ligne courante correspond bien au nombre attendu');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'9', E'getIndividualFromTag', E'Récupère l''identifiant du poisson à partir du tag (RFID)');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'10', E'getIndividualFromTransmitter', E'Récupère l''identifiant du poisson à partir du transmetteur (radio ou acoustique)');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'11', E'numericToHexa', E'Transforme une valeur numérique en valeur Hexa, si celle-ci ne l''est pas. La valeur Hexa doit comprendre au moins une lettre. L''argument doit préciser le nombre de caractères attendus (multiple de 2) pour formater la chaine dans une zone de zéros');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'12', E'concatenate', E'Associe le contenu de colonnes ou du texte. L''argument doit etre au format JSON, sous la forme : [{"type":"col","val":4},{type:"str","val":":"}]');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'13', E'matchingCode', E'Remplace la valeur courante par une autre valeur, définie dans un argument JSON au format : {"valueSearched":correspondingValue, "2ndvalue":corresp2}. Pour la recherche des paramètres de sonde, valueSearched doit correspondre au libellé utilisé par la sonde, et correspondingValue à la valeur de la clé dans la table des paramètres');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'14', E'decodeAll', E'Transforme un jeu de caractère particulier en UTF-8. L''argument doit comprendre le jeu de caractère à transcoder, par exemple UTF-32');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'15', E'transformDecimalSeparator', E'Transforme la virgule en point, pour les champs décimaux en français');
-- ddl-end --

-- object: import.import_function_import_function_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.import_function_import_function_id_seq CASCADE;
CREATE SEQUENCE import.import_function_import_function_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.import_function_import_function_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.import_function | type: TABLE --
-- DROP TABLE IF EXISTS import.import_function CASCADE;
CREATE TABLE import.import_function (
	import_function_id integer NOT NULL DEFAULT nextval('import.import_function_import_function_id_seq'::regclass),
	import_description_id integer NOT NULL,
	function_type_id integer NOT NULL,
	column_number smallint NOT NULL DEFAULT 1,
	execution_order smallint NOT NULL DEFAULT 1,
	arguments varchar,
	column_result smallint,
	CONSTRAINT import_function_pk PRIMARY KEY (import_function_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_function IS E'List of functions to be performed for each row of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_function.column_number IS E'List of functions to be performed for each row of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_function.execution_order IS E'List of functions to be performed for each row of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_function.arguments IS E'List of functions to be performed for each row of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_function.column_result IS E'List of functions to be performed for each row of the file';
-- ddl-end --
ALTER TABLE import.import_function OWNER TO filo;
-- ddl-end --

-- object: import.import_type_import_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.import_type_import_type_id_seq CASCADE;
CREATE SEQUENCE import.import_type_import_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 3
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.import_type_import_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.import_type | type: TABLE --
-- DROP TABLE IF EXISTS import.import_type CASCADE;
CREATE TABLE import.import_type (
	import_type_id integer NOT NULL DEFAULT nextval('import.import_type_import_type_id_seq'::regclass),
	import_type_name varchar NOT NULL,
	tablename varchar,
	column_list varchar,
	CONSTRAINT import_type_pk_1 PRIMARY KEY (import_type_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_type IS E'List of types of import';
-- ddl-end --
COMMENT ON COLUMN import.import_type.tablename IS E'List of types of import';
-- ddl-end --
COMMENT ON COLUMN import.import_type.column_list IS E'List of types of import';
-- ddl-end --
ALTER TABLE import.import_type OWNER TO filo;
-- ddl-end --

INSERT INTO import.import_type (import_type_id, import_type_name, tablename, column_list) VALUES (E'1', E'Detection', E'detection', E'detection_date,nb_events,duration,signal_force');
-- ddl-end --
INSERT INTO import.import_type (import_type_id, import_type_name, tablename, column_list) VALUES (E'2', E'Probe data/données de sonde', E'probe_measure', E'probe_measure_date,probe_measure_value');
-- ddl-end --
INSERT INTO import.import_type (import_type_id, import_type_name, tablename, column_list) VALUES (E'3', E'Manual detection', E'location', E'individual_id,detection_date,signal_force,observation,location_long,location_lat,antenna_type_id');
-- ddl-end --

-- object: import.technology_technology_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.technology_technology_type_id_seq CASCADE;
CREATE SEQUENCE import.technology_technology_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 4
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.technology_technology_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.technology_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.technology_type CASCADE;
CREATE TABLE tracking.technology_type (
	technology_type_id integer NOT NULL DEFAULT nextval('import.technology_technology_type_id_seq'::regclass),
	technology_type_name varchar NOT NULL,
	CONSTRAINT technology_type_pk PRIMARY KEY (technology_type_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.technology_type IS E'Types of technologies used for detection';
-- ddl-end --
ALTER TABLE tracking.technology_type OWNER TO filo;
-- ddl-end --

INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'1', E'RFID');
-- ddl-end --
INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'2', E'Acoustic');
-- ddl-end --
INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'3', E'Radio');
-- ddl-end --

-- object: tracking.location_location_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.location_location_id_seq CASCADE;
CREATE SEQUENCE tracking.location_location_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.location_location_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.location | type: TABLE --
-- DROP TABLE IF EXISTS tracking.location CASCADE;
CREATE TABLE tracking.location (
	location_id integer NOT NULL DEFAULT nextval('tracking.location_location_id_seq'::regclass),
	antenna_type_id integer,
	individual_id integer NOT NULL,
	detection_date timestamp NOT NULL,
	location_pk float,
	location_long double precision,
	location_lat double precision,
	signal_force smallint,
	observation varchar,
	geom geometry(POINT, 4326),
	CONSTRAINT location_pk PRIMARY KEY (location_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.location IS E'List of locations of manual detections';
-- ddl-end --
COMMENT ON COLUMN tracking.location.detection_date IS E'List of locations of manual detections';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_pk IS E'List of locations of manual detections';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_long IS E'List of locations of manual detections';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_lat IS E'List of locations of manual detections';
-- ddl-end --
COMMENT ON COLUMN tracking.location.signal_force IS E'List of locations of manual detections';
-- ddl-end --
COMMENT ON COLUMN tracking.location.observation IS E'List of locations of manual detections';
-- ddl-end --
COMMENT ON COLUMN tracking.location.geom IS E'List of locations of manual detections';
-- ddl-end --
ALTER TABLE tracking.location OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna_type_antenna_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.antenna_type_antenna_type_id_seq CASCADE;
CREATE SEQUENCE tracking.antenna_type_antenna_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.antenna_type_antenna_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.antenna_type CASCADE;
CREATE TABLE tracking.antenna_type (
	antenna_type_id integer NOT NULL DEFAULT nextval('tracking.antenna_type_antenna_type_id_seq'::regclass),
	antenna_type_name varchar NOT NULL,
	CONSTRAINT antenna_type_pk PRIMARY KEY (antenna_type_id)

);
-- ddl-end --
ALTER TABLE tracking.antenna_type OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna_event_antenna_event_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.antenna_event_antenna_event_id_seq CASCADE;
CREATE SEQUENCE tracking.antenna_event_antenna_event_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.antenna_event_antenna_event_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna_event | type: TABLE --
-- DROP TABLE IF EXISTS tracking.antenna_event CASCADE;
CREATE TABLE tracking.antenna_event (
	antenna_event_id integer NOT NULL DEFAULT nextval('tracking.antenna_event_antenna_event_id_seq'::regclass),
	antenna_id integer NOT NULL,
	date_start timestamp,
	date_end timestamp,
	comment varchar,
	CONSTRAINT antenna_event_pk PRIMARY KEY (antenna_event_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.antenna_event IS E'Events occured on an antenna';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.date_start IS E'Events occured on an antenna';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.date_end IS E'Events occured on an antenna';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.comment IS E'Events occured on an antenna';
-- ddl-end --
ALTER TABLE tracking.antenna_event OWNER TO filo;
-- ddl-end --

-- object: individual_tag_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.individual_tag_idx CASCADE;
CREATE INDEX individual_tag_idx ON filo.individual
	USING btree
	(
	  tag
	);
-- ddl-end --

-- object: individual_transmitter_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.individual_transmitter_idx CASCADE;
CREATE INDEX individual_transmitter_idx ON filo.individual
	USING btree
	(
	  transmitter
	);
-- ddl-end --

-- object: individual_tracking_project_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS tracking.individual_tracking_project_id_idx CASCADE;
CREATE INDEX individual_tracking_project_id_idx ON tracking.individual_tracking
	USING btree
	(
	  project_id
	);
-- ddl-end --

-- object: probe_measure_probe_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS tracking.probe_measure_probe_id_idx CASCADE;
CREATE INDEX probe_measure_probe_id_idx ON tracking.probe_measure
	USING btree
	(
	  probe_id
	);
-- ddl-end --

-- object: probe_measure_probe_measure_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS tracking.probe_measure_probe_measure_date_idx CASCADE;
CREATE INDEX probe_measure_probe_measure_date_idx ON tracking.probe_measure
	USING btree
	(
	  probe_measure_date
	);
-- ddl-end --

-- object: detection_individual_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS tracking.detection_individual_id_idx CASCADE;
CREATE INDEX detection_individual_id_idx ON tracking.detection
	USING btree
	(
	  individual_id
	);
-- ddl-end --

-- object: detection_detection_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS tracking.detection_detection_date_idx CASCADE;
CREATE INDEX detection_detection_date_idx ON tracking.detection
	USING btree
	(
	  detection_date
	);
-- ddl-end --

-- object: detection_antenna_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS tracking.detection_antenna_id_idx CASCADE;
CREATE INDEX detection_antenna_id_idx ON tracking.detection
	USING btree
	(
	  antenna_id
	);
-- ddl-end --

-- object: individual_sample_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.individual_sample_id_idx CASCADE;
CREATE INDEX individual_sample_id_idx ON filo.individual
	USING btree
	(
	  sample_id
	);
-- ddl-end --

-- object: operation_campaign_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.operation_campaign_id_idx CASCADE;
CREATE INDEX operation_campaign_id_idx ON filo.operation
	USING btree
	(
	  campaign_id
	);
-- ddl-end --

-- object: operation_station_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.operation_station_id_idx CASCADE;
CREATE INDEX operation_station_id_idx ON filo.operation
	USING btree
	(
	  station_id
	);
-- ddl-end --

-- object: station_project_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.station_project_id_idx CASCADE;
CREATE INDEX station_project_id_idx ON filo.station
	USING btree
	(
	  project_id
	);
-- ddl-end --

-- object: station_river_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.station_river_id_idx CASCADE;
CREATE INDEX station_river_id_idx ON filo.station
	USING btree
	(
	  river_id
	);
-- ddl-end --

-- object: sample_sequence_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.sample_sequence_id_idx CASCADE;
CREATE INDEX sample_sequence_id_idx ON filo.sample
	USING btree
	(
	  sequence_id
	);
-- ddl-end --

-- object: sample_taxon_name_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.sample_taxon_name_idx CASCADE;
CREATE INDEX sample_taxon_name_idx ON filo.sample
	USING btree
	(
	  taxon_name
	);
-- ddl-end --

-- object: sequence_operation_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.sequence_operation_id_idx CASCADE;
CREATE INDEX sequence_operation_id_idx ON filo.sequence
	USING btree
	(
	  operation_id
	);
-- ddl-end --

-- object: operation_date_start_idx | type: INDEX --
-- DROP INDEX IF EXISTS filo.operation_date_start_idx CASCADE;
CREATE INDEX operation_date_start_idx ON filo.operation
	USING btree
	(
	  date_start
	);
-- ddl-end --

-- object: tracking.parameter_measure_type_parameter_measure_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.parameter_measure_type_parameter_measure_type_id_seq CASCADE;
CREATE SEQUENCE tracking.parameter_measure_type_parameter_measure_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.parameter_measure_type_parameter_measure_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.parameter_measure_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.parameter_measure_type CASCADE;
CREATE TABLE tracking.parameter_measure_type (
	parameter_measure_type_id integer NOT NULL DEFAULT nextval('tracking.parameter_measure_type_parameter_measure_type_id_seq'::regclass),
	parameter varchar NOT NULL,
	unit varchar,
	CONSTRAINT parameter_measure_type_pk PRIMARY KEY (parameter_measure_type_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.parameter_measure_type IS E'Types of parameters used with probes';
-- ddl-end --
COMMENT ON COLUMN tracking.parameter_measure_type.parameter IS E'Types of parameters used with probes';
-- ddl-end --
COMMENT ON COLUMN tracking.parameter_measure_type.unit IS E'Types of parameters used with probes';
-- ddl-end --
ALTER TABLE tracking.parameter_measure_type OWNER TO filo;
-- ddl-end --

-- object: tracking.v_station_tracking | type: VIEW --
-- DROP VIEW IF EXISTS tracking.v_station_tracking CASCADE;
CREATE VIEW tracking.v_station_tracking
AS

SELECT
   station_id, station_name, station_long, station_lat, station_pk, geom
,station_type_id, station_type_name
,project_id, project_name

FROM
   tracking.station_tracking
join filo.station using (station_id)
join tracking.station_type using (station_type_id)
join filo.project using (project_id);
-- ddl-end --
COMMENT ON VIEW tracking.v_station_tracking IS E'List of stations used for tracking, with geom object';
-- ddl-end --
ALTER VIEW tracking.v_station_tracking OWNER TO filo;
-- ddl-end --

-- object: tracking.v_individual_tracking | type: VIEW --
-- DROP VIEW IF EXISTS tracking.v_individual_tracking CASCADE;
CREATE VIEW tracking.v_individual_tracking
AS

SELECT
   individual_id, scientific_name, taxon_id
,tag, transmitter
,project.project_id, project_name
,transmitter_type_name, transmitter_type_id
,station_name as release_station_name, release_station_id
FROM
   filo.individual
join tracking.individual_tracking using (individual_id)
join filo.taxon using (taxon_id)
join filo.project using (project_id)
left outer join tracking.transmitter_type using (transmitter_type_id)
left outer join tracking.station_tracking st on (st.station_id = release_station_id)
left outer join filo.station on (st.station_id = station.station_id);
-- ddl-end --
COMMENT ON VIEW tracking.v_individual_tracking IS E'View of the fishes tracked';
-- ddl-end --
ALTER VIEW tracking.v_individual_tracking OWNER TO filo;
-- ddl-end --

-- object: tracking.v_station_tracking_update | type: FUNCTION --
-- DROP FUNCTION IF EXISTS tracking.v_station_tracking_update() CASCADE;
CREATE FUNCTION tracking.v_station_tracking_update ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
update filo.station set geom = NEW.geom,
station_long = NEW.station_long,
station_lat = NEW.station_lat,
station_pk = NEW.station_pk,
station_name = NEW.station_name
where station_id = NEW.station_id ;
return null;
END;
$$;
-- ddl-end --
ALTER FUNCTION tracking.v_station_tracking_update() OWNER TO filo;
-- ddl-end --

-- object: v_station_tracking_update | type: TRIGGER --
-- DROP TRIGGER IF EXISTS v_station_tracking_update ON tracking.v_station_tracking CASCADE;
CREATE TRIGGER v_station_tracking_update
	INSTEAD OF UPDATE
	ON tracking.v_station_tracking
	FOR EACH ROW
	EXECUTE PROCEDURE tracking.v_station_tracking_update();
-- ddl-end --

-- object: tracking.v_station_tracking_insert | type: FUNCTION --
-- DROP FUNCTION IF EXISTS tracking.v_station_tracking_insert() CASCADE;
CREATE FUNCTION tracking.v_station_tracking_insert ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
insert into filo.station (station_name, project_id, station_long, station_lat, station_pk, geom)
values (NEW.station_name, NEW.project_id, NEW.station_long, NEW.station_lat, NEW.station_pk,NEW.geom);
insert into tracking.station_tracking (station_id, station_type_id) values (lastval(), NEW.station_type_id);
return null;
END;
$$;
-- ddl-end --
ALTER FUNCTION tracking.v_station_tracking_insert() OWNER TO filo;
-- ddl-end --

-- object: v_station_tracking_insert | type: TRIGGER --
-- DROP TRIGGER IF EXISTS v_station_tracking_insert ON tracking.v_station_tracking CASCADE;
CREATE TRIGGER v_station_tracking_insert
	INSTEAD OF INSERT
	ON tracking.v_station_tracking
	FOR EACH ROW
	EXECUTE PROCEDURE tracking.v_station_tracking_insert();
-- ddl-end --

-- object: tracking.v_antenna | type: VIEW --
-- DROP VIEW IF EXISTS tracking.v_antenna CASCADE;
CREATE VIEW tracking.v_antenna
AS

SELECT
   antenna_id, station_id, technology_type_id
,antenna_code, radius, geom_polygon
,technology_type_name
,station_type_id, station_type_name
,project_id, project_name, metric_srid
,station_name,station_long, station_lat, station_pk
,geom
FROM
   tracking.antenna
join tracking.technology_type using (technology_type_id)
join tracking.station_tracking using (station_id)
join filo.station using (station_id)
join filo.project using(project_id)
join tracking.station_type using (station_type_id);
-- ddl-end --
ALTER VIEW tracking.v_antenna OWNER TO filo;
-- ddl-end --

-- object: tracking.v_antenna_update | type: FUNCTION --
-- DROP FUNCTION IF EXISTS tracking.v_antenna_update() CASCADE;
CREATE FUNCTION tracking.v_antenna_update ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
if NEW.radius > 0 then
update tracking.antenna set geom_polygon =
st_transform (
	st_buffer (
		st_transform (
		  st_setsrid(st_point(new.station_long, new.station_lat),4326)
		,new.metric_srid)
      , new.radius)
,4326),
radius = new.radius,
station_id = new.station_id,
technology_type_id = new.technology_type_id
where antenna_id = new.antenna_id;
END IF;
return null;
END;
$$;
-- ddl-end --
ALTER FUNCTION tracking.v_antenna_update() OWNER TO filo;
-- ddl-end --

-- object: v_antenna_update | type: TRIGGER --
-- DROP TRIGGER IF EXISTS v_antenna_update ON tracking.v_antenna CASCADE;
CREATE TRIGGER v_antenna_update
	INSTEAD OF UPDATE
	ON tracking.v_antenna
	FOR EACH ROW
	EXECUTE PROCEDURE tracking.v_antenna_update();
-- ddl-end --

-- object: tracking.v_detection_location | type: VIEW --
-- DROP VIEW IF EXISTS tracking.v_detection_location CASCADE;
CREATE VIEW tracking.v_detection_location
AS

SELECT
   detection_id as id, individual_id, detection_date
	, nb_events, duration, validity, signal_force, observation
	,station_long long, station_lat lat, station_name, station_pk as pk
	,antenna_code, technology_type_name as antenna_type
	,geom
	,'stationary' as detection_type
from tracking.detection
	join tracking.antenna using (antenna_id)
	join filo.station using (station_id)
	left outer join tracking.technology_type using (technology_type_id)
union
select location_id as id, individual_id, detection_date
	, null nb_events, null duration, true validity, signal_force, observation
	, location_long, location_lat, null station_name, location_pk as pk
	,null as antenna_code, antenna_type_name as antenna_type
	,geom
	,'mobile' as detection_type
from tracking.location
	left outer join tracking.antenna_type using (antenna_type_id);
-- ddl-end --
COMMENT ON VIEW tracking.v_detection_location IS E'List of all detections and locations for a fish';
-- ddl-end --
ALTER VIEW tracking.v_detection_location OWNER TO filo;
-- ddl-end --

-- object: import.export_model_export_model_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.export_model_export_model_id_seq CASCADE;
CREATE SEQUENCE import.export_model_export_model_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.export_model_export_model_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.export_model | type: TABLE --
-- DROP TABLE IF EXISTS import.export_model CASCADE;
CREATE TABLE import.export_model (
	export_model_id integer NOT NULL DEFAULT nextval('import.export_model_export_model_id_seq'::regclass),
	export_model_name varchar NOT NULL,
	pattern json,
	CONSTRAINT export_model_pk PRIMARY KEY (export_model_id)

);
-- ddl-end --
COMMENT ON TABLE import.export_model IS E'Structure of an export/import of table data';
-- ddl-end --
COMMENT ON COLUMN import.export_model.export_model_name IS E'Structure of an export/import of table data';
-- ddl-end --
COMMENT ON COLUMN import.export_model.pattern IS E'Structure of an export/import of table data';
-- ddl-end --
ALTER TABLE import.export_model OWNER TO filo;
-- ddl-end --

INSERT INTO import.export_model (export_model_name, pattern) VALUES (E'operation', E'[{"tableName":"operation","technicalKey":"operation_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["freshwater"],"children":[{"aliasName":"sequence","isStrict":false},{"aliasName":"operationAmbience","isStrict":false},{"aliasName":"operation_operator","isStrict":false}],"parameters":[{"aliasName":"station","fieldName":"station_id"},{"aliasName":"protocol","fieldName":"protocol_id"},{"aliasName":"water_regime","fieldName":"water_regime_id"},{"aliasName":"fishing_strategy","fieldName":"fishing_strategy_id"},{"aliasName":"scale","fieldName":"scale_id"},{"aliasName":"taxa_template","fieldName":"taxa_template_id"}],"istablenn":false},{"tableName":"sequence","technicalKey":"sequence_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"sequenceAmbience","isStrict":false},{"aliasName":"sequence_gear","isStrict":false},{"aliasName":"analysis","isStrict":false},{"aliasName":"sample","isStrict":false}],"parameters":[],"istablenn":false},{"tableName":"operation_operator","isEmpty":false,"parentKey":"operation_id","istable11":false,"booleanFields":["is_responsible"],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"operator_id","tableAlias":"operator"}},{"tableName":"operator","technicalKey":"operator_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[],"istablenn":false},{"tableName":"ambience","tableAlias":"operationAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"ambience","tableAlias":"sequenceAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"sample","technicalKey":"sample_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"individual","isStrict":false}],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"sequence_gear","technicalKey":"sequence_gear_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"gear","fieldName":"gear_id"},{"aliasName":"gear_method","fieldName":"gear_method_id"},{"aliasName":"electric_current_type","fieldName":"electric_current_type_id"}],"istablenn":false},{"tableName":"analysis","technicalKey":"analysis_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"individual","technicalKey":"individual_id","isEmpty":false,"businessKey":"uuid","parentKey":"sample_id","istable11":false,"booleanFields":["measure_estimated"],"children":[{"aliasName":"individual_tracking","isStrict":false}],"parameters":[{"aliasName":"sexe","fieldName":"sexe_id"},{"aliasName":"pathology","fieldName":"pathology_id"}],"istablenn":false},{"tableName":"individual_tracking","technicalKey":"individual_id","isEmpty":false,"parentKey":"individual_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"transmitter_type","fieldName":"transmitter_type_id"},{"aliasName":"taxon","fieldName":"taxon_id"},{"aliasName":"project","fieldName":"project_id"},{"aliasName":"station","fieldName":"release_station_id"}],"istablenn":false},{"tableName":"station","technicalKey":"station_id","isEmpty":true,"businessKey":"station_name","istable11":false,"booleanFields":[],"children":[{"aliasName":"station_tracking","isStrict":false}],"parameters":[{"aliasName":"river","fieldName":"river_id"},{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"station_tracking","technicalKey":"station_id","isEmpty":false,"parentKey":"station_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"station_type","fieldName":"station_type_id"}],"istablenn":false},{"tableName":"station_type","technicalKey":"station_type_id","isEmpty":true,"businessKey":"station_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[],"parameters":[{"aliasName":"analyse_template","fieldName":"analyse_template_id"}],"istablenn":false},{"tableName":"analyse_template","technicalKey":"analyse_template_id","isEmpty":true,"businessKey":"analyse_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"water_regime","technicalKey":"water_regime_id","isEmpty":true,"businessKey":"water_regime_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"fishing_strategy","technicalKey":"fishing_strategy_id","isEmpty":true,"businessKey":"fishing_strategy_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"scale","technicalKey":"scale_id","isEmpty":true,"businessKey":"scale_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxa_template","technicalKey":"taxa_template_id","isEmpty":true,"businessKey":"taxa_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"facies","technicalKey":"facies_id","isEmpty":true,"businessKey":"facies_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"situation","technicalKey":"situation_id","isEmpty":true,"businessKey":"situation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"speed","technicalKey":"speed_id","isEmpty":true,"businessKey":"speed_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"shady","technicalKey":"shady_id","isEmpty":true,"businessKey":"shady_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"localisation","technicalKey":"localisation_id","isEmpty":true,"businessKey":"localisation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"granulometry","technicalKey":"granulometry_id","isEmpty":true,"businessKey":"granulometry_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"cache_abundance","technicalKey":"cache_abundance_id","isEmpty":true,"businessKey":"cache_abundance_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"clogging","technicalKey":"clogging_id","isEmpty":true,"businessKey":"clogging_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sinuosity","technicalKey":"sinuosity_id","isEmpty":true,"businessKey":"sinuosity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"flow_trend","technicalKey":"flow_trend_id","isEmpty":true,"businessKey":"flow_trend_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"turbidity","technicalKey":"turbidity_id","isEmpty":true,"businessKey":"turbidity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"river","technicalKey":"river_id","isEmpty":true,"businessKey":"river_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear","technicalKey":"gear_id","isEmpty":true,"businessKey":"gear_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear_method","technicalKey":"gear_method_id","isEmpty":true,"businessKey":"gear_method_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"electric_current_type","technicalKey":"electric_current_type_id","isEmpty":true,"businessKey":"electric_current_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sexe","technicalKey":"sexe_id","isEmpty":true,"businessKey":"sexe_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"vegetation","technicalKey":"vegetation_id","isEmpty":true,"businessKey":"vegetation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"pathology","technicalKey":"pathology_id","isEmpty":true,"businessKey":"pathology_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"transmitter_type","technicalKey":"transmitter_type_id","isEmpty":true,"businessKey":"transmitter_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]');
-- ddl-end --
INSERT INTO import.export_model (export_model_name, pattern) VALUES (E'campaign', E'[{"tableName":"campaign","technicalKey":"campaign_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":[],"children":[{"aliasName":"operation","isStrict":false}],"parameters":[{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"operation","technicalKey":"operation_id","isEmpty":false,"businessKey":"uuid","parentKey":"campaign_id","istable11":false,"booleanFields":["freshwater"],"children":[{"aliasName":"sequence","isStrict":false},{"aliasName":"operationAmbience","isStrict":false},{"aliasName":"operation_operator","isStrict":false}],"parameters":[{"aliasName":"station","fieldName":"station_id"},{"aliasName":"protocol","fieldName":"protocol_id"},{"aliasName":"water_regime","fieldName":"water_regime_id"},{"aliasName":"fishing_strategy","fieldName":"fishing_strategy_id"},{"aliasName":"scale","fieldName":"scale_id"},{"aliasName":"taxa_template","fieldName":"taxa_template_id"}],"istablenn":false},{"tableName":"sequence","technicalKey":"sequence_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"sequenceAmbience","isStrict":false},{"aliasName":"sequence_gear","isStrict":false},{"aliasName":"analysis","isStrict":false},{"aliasName":"sample","isStrict":false}],"parameters":[],"istablenn":false},{"tableName":"operation_operator","isEmpty":false,"parentKey":"operation_id","istable11":false,"booleanFields":["is_responsible"],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"operator_id","tableAlias":"operator"}},{"tableName":"operator","technicalKey":"operator_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[],"istablenn":false},{"tableName":"ambience","tableAlias":"operationAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"ambience","tableAlias":"sequenceAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"sample","technicalKey":"sample_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"individual","isStrict":false}],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"sequence_gear","technicalKey":"sequence_gear_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"gear","fieldName":"gear_id"},{"aliasName":"gear_method","fieldName":"gear_method_id"},{"aliasName":"electric_current_type","fieldName":"electric_current_type_id"}],"istablenn":false},{"tableName":"analysis","technicalKey":"analysis_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"individual","technicalKey":"individual_id","isEmpty":false,"businessKey":"uuid","parentKey":"sample_id","istable11":false,"booleanFields":["measure_estimated"],"children":[{"aliasName":"individual_tracking","isStrict":false}],"parameters":[{"aliasName":"sexe","fieldName":"sexe_id"},{"aliasName":"pathology","fieldName":"pathology_id"}],"istablenn":false},{"tableName":"individual_tracking","technicalKey":"individual_id","isEmpty":false,"parentKey":"individual_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"transmitter_type","fieldName":"transmitter_type_id"},{"aliasName":"taxon","fieldName":"taxon_id"},{"aliasName":"project","fieldName":"project_id"},{"aliasName":"station","fieldName":"release_station_id"}],"istablenn":false},{"tableName":"station","technicalKey":"station_id","isEmpty":true,"businessKey":"station_name","istable11":false,"booleanFields":[],"children":[{"aliasName":"station_tracking","isStrict":false}],"parameters":[{"aliasName":"river","fieldName":"river_id"},{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"station_tracking","technicalKey":"station_id","isEmpty":false,"parentKey":"station_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"station_type","fieldName":"station_type_id"}],"istablenn":false},{"tableName":"station_type","technicalKey":"station_type_id","isEmpty":true,"businessKey":"station_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[],"parameters":[{"aliasName":"analyse_template","fieldName":"analyse_template_id"}],"istablenn":false},{"tableName":"analyse_template","technicalKey":"analyse_template_id","isEmpty":true,"businessKey":"analyse_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"water_regime","technicalKey":"water_regime_id","isEmpty":true,"businessKey":"water_regime_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"fishing_strategy","technicalKey":"fishing_strategy_id","isEmpty":true,"businessKey":"fishing_strategy_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"scale","technicalKey":"scale_id","isEmpty":true,"businessKey":"scale_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxa_template","technicalKey":"taxa_template_id","isEmpty":true,"businessKey":"taxa_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"facies","technicalKey":"facies_id","isEmpty":true,"businessKey":"facies_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"situation","technicalKey":"situation_id","isEmpty":true,"businessKey":"situation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"speed","technicalKey":"speed_id","isEmpty":true,"businessKey":"speed_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"shady","technicalKey":"shady_id","isEmpty":true,"businessKey":"shady_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"localisation","technicalKey":"localisation_id","isEmpty":true,"businessKey":"localisation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"granulometry","technicalKey":"granulometry_id","isEmpty":true,"businessKey":"granulometry_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"cache_abundance","technicalKey":"cache_abundance_id","isEmpty":true,"businessKey":"cache_abundance_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"clogging","technicalKey":"clogging_id","isEmpty":true,"businessKey":"clogging_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sinuosity","technicalKey":"sinuosity_id","isEmpty":true,"businessKey":"sinuosity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"flow_trend","technicalKey":"flow_trend_id","isEmpty":true,"businessKey":"flow_trend_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"turbidity","technicalKey":"turbidity_id","isEmpty":true,"businessKey":"turbidity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"river","technicalKey":"river_id","isEmpty":true,"businessKey":"river_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear","technicalKey":"gear_id","isEmpty":true,"businessKey":"gear_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear_method","technicalKey":"gear_method_id","isEmpty":true,"businessKey":"gear_method_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"electric_current_type","technicalKey":"electric_current_type_id","isEmpty":true,"businessKey":"electric_current_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sexe","technicalKey":"sexe_id","isEmpty":true,"businessKey":"sexe_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"vegetation","technicalKey":"vegetation_id","isEmpty":true,"businessKey":"vegetation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"pathology","technicalKey":"pathology_id","isEmpty":true,"businessKey":"pathology_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"transmitter_type","technicalKey":"transmitter_type_id","isEmpty":true,"businessKey":"transmitter_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]');
-- ddl-end --
INSERT INTO import.export_model (export_model_name, pattern) VALUES (E'export_model', E'[{"tableName":"export_model","businessKey":"export_model_name","istable11":false,"children":[],"booleanFields":[],"istablenn":false}]');
-- ddl-end --
INSERT INTO import.export_model (export_model_name, pattern) VALUES (E'campaignOnly', E'[{"tableName":"campaign","technicalKey":"campaign_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[{"aliasName":"protocol_measure","isStrict":true}],"parameters":[{"aliasName":"analysis_template","fieldName":"analysis_template_id"}],"istablenn":false},{"tableName":"analysis_template","technicalKey":"analysis_template_id","isEmpty":true,"businessKey":"analysis_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"measure_template","technicalKey":"measure_template_id","isEmpty":false,"businessKey":"measure_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"protocol_measure","isEmpty":false,"parentKey":"protocol_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"measure_template_id","tableAlias":"measure_template"}},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]');
-- ddl-end --


-- object: protocol_default_id | type: COLUMN --
-- ALTER TABLE filo.project DROP COLUMN IF EXISTS protocol_default_id CASCADE;
ALTER TABLE filo.project ADD COLUMN protocol_default_id integer;
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE filo
	NOINHERIT
	ENCRYPTED PASSWORD 'filoPassword';
-- ddl-end --
ALTER SCHEMA filo OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.project_project_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.campaign_campaign_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.project OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.campaign OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.station_station_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.operation_operation_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.place_place_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.station OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.taxon_taxon_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.sample_sample_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.taxon OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.taxon ALTER COLUMN length_max TYPE float;
-- ddl-end --
ALTER TABLE filo.taxon ALTER COLUMN weight_max TYPE float;
-- ddl-end --
ALTER TABLE filo.operation OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.operation ALTER COLUMN length TYPE float;
-- ddl-end --
ALTER TABLE filo.operation ALTER COLUMN altitude TYPE float;
-- ddl-end --
ALTER TABLE filo.operation ALTER COLUMN tidal_coef TYPE float;
-- ddl-end --
ALTER TABLE filo.operation ALTER COLUMN debit TYPE float;
-- ddl-end --
ALTER TABLE filo.operation ALTER COLUMN surface TYPE float;
-- ddl-end --
ALTER TABLE filo.sequence OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.sequence ALTER COLUMN fishing_duration TYPE float;
-- ddl-end --
ALTER TABLE filo.sample OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.sample ALTER COLUMN sample_size_min TYPE float;
-- ddl-end --
ALTER TABLE filo.sample ALTER COLUMN sample_size_max TYPE float;
-- ddl-end --
ALTER SEQUENCE filo.item_item_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.individual OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN sl TYPE float;
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN fl TYPE float;
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN tl TYPE float;
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN wd TYPE float;
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN ot TYPE float;
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN weight TYPE float;
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN measure_estimated SET DEFAULT 'f';
-- ddl-end --
COMMENT ON COLUMN filo.individual.tag IS E'RFID tag';
-- ddl-end --
COMMENT ON COLUMN filo.individual.tag_posed IS E'RFID tag posed on the fish';
-- ddl-end --
ALTER SEQUENCE filo.measure_template_measure_template_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.measure_template OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.operation_template_operation_template_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.item_generated_item_generated_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.gear_gear_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.sequence_gear_sequence_gear_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.gear OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.gear ALTER COLUMN gear_length TYPE float;
-- ddl-end --
ALTER TABLE filo.gear ALTER COLUMN gear_height TYPE float;
-- ddl-end --
ALTER TABLE filo.sequence_gear OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.sequence_gear ALTER COLUMN voltage TYPE float;
-- ddl-end --
ALTER TABLE filo.sequence_gear ALTER COLUMN amperage TYPE float;
-- ddl-end --
ALTER TABLE filo.sequence_gear ALTER COLUMN depth TYPE float;
-- ddl-end --
ALTER SEQUENCE filo.engine_engine_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.river_river_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.river OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.analysis_analysis_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.analysis OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN ph TYPE float;
-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN temperature TYPE float;
-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN o2_pc TYPE float;
-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN o2_mg TYPE float;
-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN salinity TYPE float;
-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN conductivity TYPE float;
-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN secchi TYPE float;
-- ddl-end --
ALTER TABLE filo.sexe OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.pathology_pathology_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.pathology OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.facies_facies_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.ambience_ambience_id_seq OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.situation_situation_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.facies OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.ambience OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.ambience ALTER COLUMN ambience_length TYPE float;
-- ddl-end --
ALTER TABLE filo.ambience ALTER COLUMN ambience_width TYPE float;
-- ddl-end --
ALTER TABLE filo.ambience ALTER COLUMN current_speed TYPE float;
-- ddl-end --
ALTER TABLE filo.ambience ALTER COLUMN current_speed_max TYPE float;
-- ddl-end --
ALTER TABLE filo.ambience ALTER COLUMN current_speed_min TYPE float;
-- ddl-end --
ALTER TABLE filo.situation OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.localisation_localisation_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.localisation OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.speed OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.shady OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.granulometry_granulometry_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.granulometry OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.vegetation_vegetation_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.vegetation OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.cache_abundance_cache_abundance_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.cache_abundance OWNER TO filo;
-- ddl-end --
ALTER SCHEMA gacl OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE gacl.aclacl OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE gacl.aclaco_aclaco_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE gacl.aclaco OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE gacl.aclappli_aclappli_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE gacl.aclappli OWNER TO filo;
-- ddl-end --
ALTER TABLE gacl.aclgroup OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE gacl.acllogin_acllogin_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE gacl.acllogin OWNER TO filo;
-- ddl-end --
ALTER TABLE gacl.acllogingroup OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE gacl.log_log_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE gacl.log OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE gacl.seq_logingestion_id OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE gacl.login_oldpassword_login_oldpassword_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE gacl.logingestion OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.project_group OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.operator_operator_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.operator OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.operator ALTER COLUMN is_active SET DEFAULT 't';
-- ddl-end --
ALTER TABLE filo.operation_operator OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.operation_operator ALTER COLUMN is_responsible SET DEFAULT 't';
-- ddl-end --
ALTER SEQUENCE filo.analysis_template_analysis_template_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.analysis_template OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.cloggging_clogging_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.clogging OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.sinuosity_sinuosity_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.sinuosity OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.flow_trend_flow_trend_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.flow_trend OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.turbidity_id OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.turbidity OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.protocol_protocol_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.protocol OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.protocol_measure OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.water_regime_water_regime_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.water_regime OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.electric_current_type OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.fishing_strategy_fishing_strategy_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.fishing_strategy OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.scale_scale_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.scale OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.gear_method_gear_method_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.gear_method OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.dbparam OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.dbversion_dbversion_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.dbversion OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.taxa_template_taxa_template_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.taxa_template OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE filo.document_document_id_seq OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.document OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.mime_type OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.project_document OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.protocol_document OWNER TO filo;
-- ddl-end --
ALTER SEQUENCE gacl.passwordlost_passwordlost_id_seq
	MINVALUE 0
	MAXVALUE 2147483647
;
-- ddl-end --
ALTER TABLE gacl.passwordlost OWNER TO filo;
-- ddl-end --
COMMENT ON TABLE gacl.passwordlost IS '';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.token IS E'Token used to reinit the password';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.expiration IS E'Date of expiration of the token';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.usedate IS E'Date of use of the token';
-- ddl-end --
ALTER TABLE filo.operation_document OWNER TO filo;
-- ddl-end --
ALTER VIEW filo.v_individual_other_measures OWNER TO filo;
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN sample_id DROP NOT NULL;
-- ddl-end --


-- [ Created constraints ] --
-- object: individual_tracking_uq | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS individual_tracking_uq CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT individual_tracking_uq UNIQUE (individual_id);
-- ddl-end --



-- [ Created foreign keys ] --
-- object: logingestion_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.passwordlost DROP CONSTRAINT IF EXISTS logingestion_fk CASCADE;
ALTER TABLE gacl.passwordlost ADD CONSTRAINT logingestion_fk FOREIGN KEY (id)
REFERENCES gacl.logingestion (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: individual_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS individual_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT individual_fk FOREIGN KEY (individual_id)
REFERENCES filo.individual (individual_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: station_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.station_tracking DROP CONSTRAINT IF EXISTS station_fk CASCADE;
ALTER TABLE tracking.station_tracking ADD CONSTRAINT station_fk FOREIGN KEY (station_id)
REFERENCES filo.station (station_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: station_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.station_tracking DROP CONSTRAINT IF EXISTS station_type_fk CASCADE;
ALTER TABLE tracking.station_tracking ADD CONSTRAINT station_type_fk FOREIGN KEY (station_type_id)
REFERENCES tracking.station_type (station_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: station_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.antenna DROP CONSTRAINT IF EXISTS station_tracking_fk CASCADE;
ALTER TABLE tracking.antenna ADD CONSTRAINT station_tracking_fk FOREIGN KEY (station_id)
REFERENCES tracking.station_tracking (station_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: individual_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
ALTER TABLE tracking.detection ADD CONSTRAINT individual_tracking_fk FOREIGN KEY (individual_id)
REFERENCES tracking.individual_tracking (individual_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: station_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS station_tracking_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT station_tracking_fk FOREIGN KEY (release_station_id)
REFERENCES tracking.station_tracking (station_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: station_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe DROP CONSTRAINT IF EXISTS station_tracking_fk CASCADE;
ALTER TABLE tracking.probe ADD CONSTRAINT station_tracking_fk FOREIGN KEY (station_id)
REFERENCES tracking.station_tracking (station_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: probe_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe_measure DROP CONSTRAINT IF EXISTS probe_fk CASCADE;
ALTER TABLE tracking.probe_measure ADD CONSTRAINT probe_fk FOREIGN KEY (probe_id)
REFERENCES tracking.probe (probe_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: transmitter_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS transmitter_type_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT transmitter_type_fk FOREIGN KEY (transmitter_type_id)
REFERENCES tracking.transmitter_type (transmitter_type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES filo.project (project_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: csv_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_description DROP CONSTRAINT IF EXISTS csv_type_fk CASCADE;
ALTER TABLE import.import_description ADD CONSTRAINT csv_type_fk FOREIGN KEY (csv_type_id)
REFERENCES import.csv_type (csv_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: import_description_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_column DROP CONSTRAINT IF EXISTS import_description_fk CASCADE;
ALTER TABLE import.import_column ADD CONSTRAINT import_description_fk FOREIGN KEY (import_description_id)
REFERENCES import.import_description (import_description_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: taxon_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS taxon_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT taxon_fk FOREIGN KEY (taxon_id)
REFERENCES filo.taxon (taxon_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: protocol_fk | type: CONSTRAINT --
-- ALTER TABLE filo.project DROP CONSTRAINT IF EXISTS protocol_fk CASCADE;
ALTER TABLE filo.project ADD CONSTRAINT protocol_fk FOREIGN KEY (protocol_default_id)
REFERENCES filo.protocol (protocol_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: import_description_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_function DROP CONSTRAINT IF EXISTS import_description_fk CASCADE;
ALTER TABLE import.import_function ADD CONSTRAINT import_description_fk FOREIGN KEY (import_description_id)
REFERENCES import.import_description (import_description_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: function_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_function DROP CONSTRAINT IF EXISTS function_type_fk CASCADE;
ALTER TABLE import.import_function ADD CONSTRAINT function_type_fk FOREIGN KEY (function_type_id)
REFERENCES import.function_type (function_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: technology_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.antenna DROP CONSTRAINT IF EXISTS technology_type_fk CASCADE;
ALTER TABLE tracking.antenna ADD CONSTRAINT technology_type_fk FOREIGN KEY (technology_type_id)
REFERENCES tracking.technology_type (technology_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: import_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_description DROP CONSTRAINT IF EXISTS import_type_fk CASCADE;
ALTER TABLE import.import_description ADD CONSTRAINT import_type_fk FOREIGN KEY (import_type_id)
REFERENCES import.import_type (import_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: antenna_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS antenna_fk CASCADE;
ALTER TABLE tracking.detection ADD CONSTRAINT antenna_fk FOREIGN KEY (antenna_id)
REFERENCES tracking.antenna (antenna_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: antenna_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.location DROP CONSTRAINT IF EXISTS antenna_type_fk CASCADE;
ALTER TABLE tracking.location ADD CONSTRAINT antenna_type_fk FOREIGN KEY (antenna_type_id)
REFERENCES tracking.antenna_type (antenna_type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: antenna_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.antenna_event DROP CONSTRAINT IF EXISTS antenna_fk CASCADE;
ALTER TABLE tracking.antenna_event ADD CONSTRAINT antenna_fk FOREIGN KEY (antenna_id)
REFERENCES tracking.antenna (antenna_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: parameter_measure_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe_measure DROP CONSTRAINT IF EXISTS parameter_measure_type_fk CASCADE;
ALTER TABLE tracking.probe_measure ADD CONSTRAINT parameter_measure_type_fk FOREIGN KEY (parameter_measure_type_id)
REFERENCES tracking.parameter_measure_type (parameter_measure_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: individual_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.location DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
ALTER TABLE tracking.location ADD CONSTRAINT individual_tracking_fk FOREIGN KEY (individual_id)
REFERENCES tracking.individual_tracking (individual_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

INSERT INTO tracking.station_type (station_type_name) VALUES (E'Station de mesure physico-chimique');
-- ddl-end --
INSERT INTO tracking.station_type (station_type_name) VALUES (E'Station d''enregistrement');
-- ddl-end --
INSERT INTO tracking.station_type (station_type_name) VALUES (E'Station de lacher');
-- ddl-end --

insert into filo.dbversion (dbversion_number, dbversion_date) values ('1.3', '2019-11-18');
