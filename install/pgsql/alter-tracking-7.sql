-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-10-04 17:12:13
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 3
-- Created objects: 15
-- Changed objects: 42
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE tracking.manual_detection DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
-- ddl-end --
DROP TABLE IF EXISTS tracking.manual_detection CASCADE;
-- ddl-end --
DROP SEQUENCE IF EXISTS tracking.manual_detection_manual_detection_id_seq CASCADE;
-- ddl-end --


-- [ Created objects ] --
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
	project_id integer NOT NULL,
	river_id integer,
	antenna_type_id integer,
	location_pk float,
	location_long double precision,
	location_lat double precision,
	geom geometry(POINT, 4326),
	CONSTRAINT location_pk PRIMARY KEY (location_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.location IS 'List of locations of manual detections';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_pk IS 'pk of the location';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_long IS 'Longitude of the location, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_lat IS 'Latitude of the location, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking.location.geom IS 'Geographic point of the location';
-- ddl-end --
ALTER TABLE tracking.location OWNER TO filo;
-- ddl-end --

-- object: observation | type: COLUMN --
-- ALTER TABLE tracking.detection DROP COLUMN IF EXISTS observation CASCADE;
ALTER TABLE tracking.detection ADD COLUMN observation varchar;
-- ddl-end --

COMMENT ON COLUMN tracking.detection.observation IS 'comment';
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
COMMENT ON TABLE tracking.antenna_event IS 'Events occured on an antenna';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.date_start IS 'Start datetime of the event';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.date_end IS 'End datetime of the event';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.comment IS 'Event occurred';
-- ddl-end --
ALTER TABLE tracking.antenna_event OWNER TO filo;
-- ddl-end --

-- object: antenna_id | type: COLUMN --
-- ALTER TABLE tracking.detection DROP COLUMN IF EXISTS antenna_id CASCADE;
ALTER TABLE tracking.detection ADD COLUMN antenna_id integer;
-- ddl-end --


-- object: location_id | type: COLUMN --
-- ALTER TABLE tracking.detection DROP COLUMN IF EXISTS location_id CASCADE;
ALTER TABLE tracking.detection ADD COLUMN location_id integer;
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE filo
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
ALTER TABLE tracking.detection ALTER COLUMN validity SET DEFAULT 't';
-- ddl-end --
ALTER TABLE import.import_column ALTER COLUMN is_er SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE import.import_column ALTER COLUMN is_value SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE import.import_type ALTER COLUMN is_table_er SET DEFAULT 'f';
-- ddl-end --
COMMENT ON COLUMN import.import_type.is_table_er IS 'Is the destination table in format entity-relation? (example: probe_measure)';
-- ddl-end --
ALTER TABLE tracking.technology_type ALTER COLUMN technology_type_id SET DEFAULT nextval('import.technology_technology_type_id_seq'::regclass);
-- ddl-end --


-- [ Created foreign keys ] --
-- object: antenna_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS antenna_fk CASCADE;
ALTER TABLE tracking.detection ADD CONSTRAINT antenna_fk FOREIGN KEY (antenna_id)
REFERENCES tracking.antenna (antenna_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: location_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS location_fk CASCADE;
ALTER TABLE tracking.detection ADD CONSTRAINT location_fk FOREIGN KEY (location_id)
REFERENCES tracking.location (location_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.location DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE tracking.location ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES filo.project (project_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: river_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.location DROP CONSTRAINT IF EXISTS river_fk CASCADE;
ALTER TABLE tracking.location ADD CONSTRAINT river_fk FOREIGN KEY (river_id)
REFERENCES filo.river (river_id) MATCH FULL
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

