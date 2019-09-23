-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-09-23 12:30:45
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 2
-- Created objects: 55
-- Changed objects: 50
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE gacl.passwordlost DROP CONSTRAINT IF EXISTS logingestion_passwordlost_fk CASCADE;
-- ddl-end --

-- [ Created objects ] --
-- object: postgis | type: EXTENSION --
-- DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis
;
-- ddl-end --

-- object: geom | type: COLUMN --
-- ALTER TABLE filo.station DROP COLUMN IF EXISTS geom CASCADE;
ALTER TABLE filo.station ADD COLUMN geom geometry(POINT, 4326);
-- ddl-end --

COMMENT ON COLUMN filo.station.geom IS 'Geographical representation of the situation of the station';
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
	transmitter_type_id integer,
	project_id integer NOT NULL,
	CONSTRAINT individual_tracking_pk PRIMARY KEY (individual_id)

);
-- ddl-end --
ALTER TABLE tracking.individual_tracking OWNER TO filo;
-- ddl-end --

-- object: tracking.manual_detection_manual_detection_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.manual_detection_manual_detection_id_seq CASCADE;
CREATE SEQUENCE tracking.manual_detection_manual_detection_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.manual_detection_manual_detection_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.manual_detection | type: TABLE --
-- DROP TABLE IF EXISTS tracking.manual_detection CASCADE;
CREATE TABLE tracking.manual_detection (
	manual_detection_id integer NOT NULL DEFAULT nextval('tracking.manual_detection_manual_detection_id_seq'::regclass),
	individual_id integer NOT NULL,
	long double precision,
	lat double precision,
	geom geometry(POINT, 4326),
	signal_force smallint,
	observation varchar,
	validity boolean NOT NULL DEFAULT 't',
	CONSTRAINT manual_detection_pk PRIMARY KEY (manual_detection_id)

);
-- ddl-end --
COMMENT ON COLUMN tracking.manual_detection.long IS 'Longitude, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking.manual_detection.lat IS 'Latitude, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking.manual_detection.geom IS 'Geographic representation of the point';
-- ddl-end --
COMMENT ON COLUMN tracking.manual_detection.signal_force IS 'Force of the signal';
-- ddl-end --
COMMENT ON COLUMN tracking.manual_detection.observation IS 'comment';
-- ddl-end --
COMMENT ON COLUMN tracking.manual_detection.validity IS 'Specifiy if the detection is real (true) or false positive (false)';
-- ddl-end --
ALTER TABLE tracking.manual_detection OWNER TO filo;
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
	antenna_code varchar,
	diameter smallint,
	geom_circular geometry(CIRCULARSTRING, 4328),
	geom_polygon geometry(POLYGON, 4328),
	CONSTRAINT antenna_pk PRIMARY KEY (antenna_id)

);
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.antenna_code IS 'Antenna or receiver code';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.diameter IS 'Diameter, in metres, of the useful reception';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.geom_circular IS 'Geometry of the reception, with a circular representation, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.geom_polygon IS 'Geometry of the reception zone, in polygonal form, wgs84';
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
	antenna_id integer NOT NULL,
	detection_date timestamp NOT NULL,
	nb_events smallint,
	duration integer,
	validity boolean NOT NULL DEFAULT 't',
	signal_force smallint,
	CONSTRAINT detection_pk PRIMARY KEY (detection_id)

);
-- ddl-end --
COMMENT ON COLUMN tracking.detection.detection_date IS 'Date-time of the detection';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.nb_events IS 'Events number recorded';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.duration IS 'Duration of the detection, in 1/00 of second';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.validity IS 'Specifiy if the detection is real (true) or false positive (false)';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.signal_force IS 'Force of the signal';
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
	CONSTRAINT probe_pk PRIMARY KEY (probe_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.probe IS 'Probe used to record the environmental variables';
-- ddl-end --
ALTER TABLE tracking.probe OWNER TO filo;
-- ddl-end --

-- object: tracking.probe_parameter_probe_parameter_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.probe_parameter_probe_parameter_id_seq CASCADE;
CREATE SEQUENCE tracking.probe_parameter_probe_parameter_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.probe_parameter_probe_parameter_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.probe_parameter | type: TABLE --
-- DROP TABLE IF EXISTS tracking.probe_parameter CASCADE;
CREATE TABLE tracking.probe_parameter (
	probe_parameter_id integer NOT NULL DEFAULT nextval('tracking.probe_parameter_probe_parameter_id_seq'::regclass),
	probe_id integer NOT NULL,
	probe_code varchar NOT NULL,
	parameter varchar NOT NULL,
	unit varchar,
	CONSTRAINT probe_parameter_pk PRIMARY KEY (probe_parameter_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.probe_parameter IS 'List of parameters managed by a probe';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_parameter.probe_code IS 'Code of the parameter assigned by the probe';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_parameter.parameter IS 'Normalized measured parameter (O2, TEMP, etc.)';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_parameter.unit IS 'Unit of the parameter';
-- ddl-end --
ALTER TABLE tracking.probe_parameter OWNER TO filo;
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
	probe_parameter_id integer NOT NULL,
	probe_measure_date timestamp NOT NULL,
	probe_measure_value double precision NOT NULL,
	CONSTRAINT probe_measure_pk PRIMARY KEY (probe_measure_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.probe_measure IS 'List of the measures recorded by a probe';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_measure.probe_measure_date IS 'Date-time of the record';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_measure.probe_measure_value IS 'Value measured';
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
COMMENT ON COLUMN tracking.transmitter_type.transmitter_type_name IS 'Code or name of the transmitter';
-- ddl-end --
COMMENT ON COLUMN tracking.transmitter_type.characteristics IS 'General characteristics of the transmitter';
-- ddl-end --
COMMENT ON COLUMN tracking.transmitter_type.technology IS 'Technology used by the transmitter';
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

-- object: tracking."position" | type: TABLE --
-- DROP TABLE IF EXISTS tracking."position" CASCADE;
CREATE TABLE tracking."position" (
	position_id integer DEFAULT nextval('tracking.position_position_id_seq'::regclass),
	individual_id integer NOT NULL,
	position_date timestamp NOT NULL,
	long double precision NOT NULL,
	lat double precision NOT NULL,
	geom geometry(POINT, 4326)
);
-- ddl-end --
COMMENT ON TABLE tracking."position" IS 'Calculated position';
-- ddl-end --
COMMENT ON COLUMN tracking."position".position_date IS 'Date-time of the position calculate';
-- ddl-end --
COMMENT ON COLUMN tracking."position".long IS 'Longitude, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking."position".lat IS 'Latitude, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking."position".geom IS 'Geometric representation';
-- ddl-end --
ALTER TABLE tracking."position" OWNER TO filo;
-- ddl-end --

-- object: import | type: SCHEMA --
-- DROP SCHEMA IF EXISTS import CASCADE;
CREATE SCHEMA import;
-- ddl-end --
ALTER SCHEMA import OWNER TO filo;
-- ddl-end --

-- object: import.import_type_import_type_id | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.import_type_import_type_id CASCADE;
CREATE SEQUENCE import.import_type_import_type_id
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.import_type_import_type_id OWNER TO filo;
-- ddl-end --

-- object: import.import_type | type: TABLE --
-- DROP TABLE IF EXISTS import.import_type CASCADE;
CREATE TABLE import.import_type (
	import_type_id integer NOT NULL DEFAULT nextval('import.import_type_import_type_id'::regclass),
	csv_type_id smallint NOT NULL,
	import_type_name varchar NOT NULL,
	schema_name varchar NOT NULL DEFAULT 'public',
	table_name varchar NOT NULL,
	separator varchar NOT NULL DEFAULT ';',
	header_size smallint NOT NULL DEFAULT 1,
	is_table_er boolean NOT NULL DEFAULT 'f',
	repeat_header_number smallint NOT NULL DEFAULT 0,
	CONSTRAINT import_type_pk PRIMARY KEY (import_type_id)

);
-- ddl-end --
COMMENT ON COLUMN import.import_type.import_type_name IS 'Name of the type of import';
-- ddl-end --
COMMENT ON COLUMN import.import_type.schema_name IS 'Name of the schema where the table is';
-- ddl-end --
COMMENT ON COLUMN import.import_type.table_name IS 'Table populate by the import';
-- ddl-end --
COMMENT ON COLUMN import.import_type.separator IS 'separator used between fields (; , tab)';
-- ddl-end --
COMMENT ON COLUMN import.import_type.header_size IS 'Size, in number of lines, of the header of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_type.is_table_er IS 'Is the destination table in format entity-relation? (example: probe_measure)';
-- ddl-end --
COMMENT ON COLUMN import.import_type.repeat_header_number IS 'Number of lines between 2 repetitions of the header line. 0: none';
-- ddl-end --
ALTER TABLE import.import_type OWNER TO filo;
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

-- object: import.column_column_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.column_column_id_seq CASCADE;
CREATE SEQUENCE import.column_column_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.column_column_id_seq OWNER TO filo;
-- ddl-end --

-- object: import."column" | type: TABLE --
-- DROP TABLE IF EXISTS import."column" CASCADE;
CREATE TABLE import."column" (
	column_id integer NOT NULL DEFAULT nextval('import.column_column_id_seq'::regclass),
	import_type_id integer NOT NULL,
	format_type_id smallint NOT NULL,
	column_order smallint NOT NULL DEFAULT 1,
	table_column_name varchar NOT NULL,
	specific_format varchar,
	is_er boolean NOT NULL DEFAULT 'f',
	is_value boolean NOT NULL DEFAULT 'f',
	sql_matching varchar,
	CONSTRAINT column_pk PRIMARY KEY (column_id)

);
-- ddl-end --
COMMENT ON TABLE import."column" IS 'List of all columns of the file';
-- ddl-end --
COMMENT ON COLUMN import."column".column_order IS 'Place of the column in the file, from 1';
-- ddl-end --
COMMENT ON COLUMN import."column".table_column_name IS 'name of the attribute of the column in the database table';
-- ddl-end --
COMMENT ON COLUMN import."column".specific_format IS 'Specific format, as datetime format. Example: YYYY-MM-DDThh:mm:ss';
-- ddl-end --
COMMENT ON COLUMN import."column".is_er IS 'Specify if the column is an entity-relation identifier';
-- ddl-end --
COMMENT ON COLUMN import."column".is_value IS 'Specifiy if the column contain the value of an entity-relation row';
-- ddl-end --
COMMENT ON COLUMN import."column".sql_matching IS 'SQL request for obtain the real value of the field. Example: select individu_id as id from filo.individu where tag =  :value';
-- ddl-end --
ALTER TABLE import."column" OWNER TO filo;
-- ddl-end --

-- object: import.format_type | type: TABLE --
-- DROP TABLE IF EXISTS import.format_type CASCADE;
CREATE TABLE import.format_type (
	format_type_id smallint NOT NULL,
	format_type_name varchar NOT NULL,
	CONSTRAINT format_type_pk PRIMARY KEY (format_type_id)

);
-- ddl-end --
COMMENT ON TABLE import.format_type IS 'Types of formats of the columns';
-- ddl-end --
ALTER TABLE import.format_type OWNER TO filo;
-- ddl-end --

INSERT INTO import.format_type (format_type_id, format_type_name) VALUES (E'1', E'String');
-- ddl-end --
INSERT INTO import.format_type (format_type_id, format_type_name) VALUES (E'2', E'Numeric');
-- ddl-end --
INSERT INTO import.format_type (format_type_id, format_type_name) VALUES (E'3', E'Date or datetime');
-- ddl-end --

-- object: import.column_matching_column_matching_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.column_matching_column_matching_id_seq CASCADE;
CREATE SEQUENCE import.column_matching_column_matching_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.column_matching_column_matching_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.column_matching | type: TABLE --
-- DROP TABLE IF EXISTS import.column_matching CASCADE;
CREATE TABLE import.column_matching (
	column_matching_id integer NOT NULL DEFAULT nextval('import.column_matching_column_matching_id_seq'::regclass),
	value varchar NOT NULL,
	column_name varchar NOT NULL,
	column_id integer NOT NULL,
	CONSTRAINT column_matching_pk PRIMARY KEY (column_matching_id)

);
-- ddl-end --
COMMENT ON COLUMN import.column_matching.value IS 'Value used in the field';
-- ddl-end --
COMMENT ON COLUMN import.column_matching.column_name IS 'Name of the column corresponding to the value';
-- ddl-end --
ALTER TABLE import.column_matching OWNER TO filo;
-- ddl-end --



-- [ Changed objects ] --
ALTER ROLE filo
	NOINHERIT
	ENCRYPTED PASSWORD 'filoPassword';
-- ddl-end --
ALTER TABLE filo.taxon ALTER COLUMN length_max TYPE float;
-- ddl-end --
ALTER TABLE filo.taxon ALTER COLUMN weight_max TYPE float;
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
ALTER TABLE filo.sequence ALTER COLUMN fishing_duration TYPE float;
-- ddl-end --
ALTER TABLE filo.sample ALTER COLUMN sample_size_min TYPE float;
-- ddl-end --
ALTER TABLE filo.sample ALTER COLUMN sample_size_max TYPE float;
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
ALTER TABLE filo.gear ALTER COLUMN gear_length TYPE float;
-- ddl-end --
ALTER TABLE filo.gear ALTER COLUMN gear_height TYPE float;
-- ddl-end --
ALTER TABLE filo.sequence_gear ALTER COLUMN voltage TYPE float;
-- ddl-end --
ALTER TABLE filo.sequence_gear ALTER COLUMN amperage TYPE float;
-- ddl-end --
ALTER TABLE filo.sequence_gear ALTER COLUMN depth TYPE float;
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
ALTER TABLE filo.operator ALTER COLUMN is_active SET DEFAULT 't';
-- ddl-end --
ALTER TABLE filo.operation_operator ALTER COLUMN is_responsible SET DEFAULT 't';
-- ddl-end --
ALTER SEQUENCE filo.turbidity_id OWNER TO filo;
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
ALTER SEQUENCE gacl.passwordlost_passwordlost_id_seq OWNER TO filo;
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
COMMENT ON COLUMN gacl.passwordlost.token IS 'Token used to reinit the password';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.expiration IS 'Date of expiration of the token';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.usedate IS 'Date of use of the token';
-- ddl-end --
ALTER TABLE filo.operation_document OWNER TO filo;
-- ddl-end --
ALTER VIEW filo.v_individual_other_measures OWNER TO filo;
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

-- object: individual_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.manual_detection DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
ALTER TABLE tracking.manual_detection ADD CONSTRAINT individual_tracking_fk FOREIGN KEY (individual_id)
REFERENCES tracking.individual_tracking (individual_id) MATCH FULL
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

-- object: antenna_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS antenna_fk CASCADE;
ALTER TABLE tracking.detection ADD CONSTRAINT antenna_fk FOREIGN KEY (antenna_id)
REFERENCES tracking.antenna (antenna_id) MATCH FULL
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
-- ALTER TABLE tracking.probe_parameter DROP CONSTRAINT IF EXISTS probe_fk CASCADE;
ALTER TABLE tracking.probe_parameter ADD CONSTRAINT probe_fk FOREIGN KEY (probe_id)
REFERENCES tracking.probe (probe_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: probe_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe_measure DROP CONSTRAINT IF EXISTS probe_fk CASCADE;
ALTER TABLE tracking.probe_measure ADD CONSTRAINT probe_fk FOREIGN KEY (probe_id)
REFERENCES tracking.probe (probe_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: probe_parameter_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe_measure DROP CONSTRAINT IF EXISTS probe_parameter_fk CASCADE;
ALTER TABLE tracking.probe_measure ADD CONSTRAINT probe_parameter_fk FOREIGN KEY (probe_parameter_id)
REFERENCES tracking.probe_parameter (probe_parameter_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: transmitter_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS transmitter_type_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT transmitter_type_fk FOREIGN KEY (transmitter_type_id)
REFERENCES tracking.transmitter_type (transmitter_type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: individual_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking."position" DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
ALTER TABLE tracking."position" ADD CONSTRAINT individual_tracking_fk FOREIGN KEY (individual_id)
REFERENCES tracking.individual_tracking (individual_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES filo.project (project_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: csv_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_type DROP CONSTRAINT IF EXISTS csv_type_fk CASCADE;
ALTER TABLE import.import_type ADD CONSTRAINT csv_type_fk FOREIGN KEY (csv_type_id)
REFERENCES import.csv_type (csv_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: format_type_fk | type: CONSTRAINT --
-- ALTER TABLE import."column" DROP CONSTRAINT IF EXISTS format_type_fk CASCADE;
ALTER TABLE import."column" ADD CONSTRAINT format_type_fk FOREIGN KEY (format_type_id)
REFERENCES import.format_type (format_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: import_type_fk | type: CONSTRAINT --
-- ALTER TABLE import."column" DROP CONSTRAINT IF EXISTS import_type_fk CASCADE;
ALTER TABLE import."column" ADD CONSTRAINT import_type_fk FOREIGN KEY (import_type_id)
REFERENCES import.import_type (import_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: column_fk | type: CONSTRAINT --
-- ALTER TABLE import.column_matching DROP CONSTRAINT IF EXISTS column_fk CASCADE;
ALTER TABLE import.column_matching ADD CONSTRAINT column_fk FOREIGN KEY (column_id)
REFERENCES import."column" (column_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

