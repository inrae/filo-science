-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.3
-- Diff date: 2021-01-04 17:54:37
-- Source model: filo
-- Database: filoeabx
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 2
-- Changed objects: 44
-- Truncated tables: 0

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,filo,gacl,import,tracking;
-- ddl-end --


-- [ Created objects ] --
-- object: daypart | type: COLUMN --
-- ALTER TABLE tracking.detection DROP COLUMN IF EXISTS daypart CASCADE;
ALTER TABLE tracking.detection ADD COLUMN daypart varchar DEFAULT 'u';
-- ddl-end --

COMMENT ON COLUMN tracking.detection.daypart IS E'Specify if the detection occurred during the day or the night\nd: day\nn: night\nu: unknown';
-- ddl-end --


-- object: tablefunc | type: EXTENSION --
-- DROP EXTENSION IF EXISTS tablefunc CASCADE;
CREATE EXTENSION tablefunc
WITH SCHEMA public;
-- ddl-end --

-- [ Changed objects ] --
ALTER ROLE filo
	ENCRYPTED PASSWORD 'filoScience';
-- ddl-end --
COMMENT ON EXTENSION postgis IS '';
-- ddl-end --
ALTER TABLE filo.station ALTER COLUMN station_number TYPE float using station_number::float;
-- ddl-end --
COMMENT ON COLUMN filo.station.station_number IS E'working number of the station';
-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN measure_estimated SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE filo.ambience ALTER COLUMN ambience_geom TYPE geometry(POINT, 4326);
-- ddl-end --
ALTER TABLE filo.operator ALTER COLUMN is_active SET DEFAULT 't';
-- ddl-end --
ALTER TABLE filo.operation_operator ALTER COLUMN is_responsible SET DEFAULT 't';
-- ddl-end --
-- ALTER TABLE tracking.detection ALTER COLUMN validity SET DEFAULT 't';
-- ddl-end --
-- ALTER TABLE tracking.location ALTER COLUMN location_pk TYPE float;
-- ddl-end --
COMMENT ON EXTENSION pgcrypto IS '';
-- ddl-end --
COMMENT ON COLUMN filo.sequence_point.fish_number IS E'Number of fishes detected at this point';
-- ddl-end --

CREATE INDEX detection_date_antenna_individual_idx ON tracking.detection
	USING btree
	(
	  individual_id,
	  antenna_id,
	  detection_date
	);

INSERT INTO filo.dbversion (dbversion_number, dbversion_date) VALUES (E'1.8', E'2021-01-13');
