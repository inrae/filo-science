-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta2
-- Diff date: 2019-11-22 15:14:29
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 9
-- Changed objects: 44
-- Truncated tables: 0

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,filo,gacl,import,tracking;
-- ddl-end --


-- [ Created objects ] --
-- object: tablefunc | type: EXTENSION --
-- DROP EXTENSION IF EXISTS tablefunc CASCADE;
CREATE EXTENSION tablefunc
WITH SCHEMA public;
-- ddl-end --

-- object: filo.sequence_point_sequence_point_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.sequence_point_sequence_point_id_seq CASCADE;
CREATE SEQUENCE filo.sequence_point_sequence_point_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.sequence_point_sequence_point_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.sequence_point | type: TABLE --
-- DROP TABLE IF EXISTS filo.sequence_point CASCADE;
CREATE TABLE filo.sequence_point (
	sequence_point_id integer NOT NULL DEFAULT nextval('filo.sequence_point_sequence_point_id_seq'::regclass),
	sequence_id integer NOT NULL,
	localisation_id integer,
	facies_id integer,
	fish_number smallint,
	CONSTRAINT sequence_point_pk PRIMARY KEY (sequence_point_id)

);
-- ddl-end --
COMMENT ON TABLE filo.sequence_point IS E'Sampling points during the sequence';
-- ddl-end --
COMMENT ON COLUMN filo.sequence_point.fish_number IS E'Sampling points during the sequence';
-- ddl-end --
ALTER TABLE filo.sequence_point OWNER TO filo;
-- ddl-end --

-- object: business_code | type: COLUMN --
-- ALTER TABLE filo.sequence_gear DROP COLUMN IF EXISTS business_code CASCADE;
ALTER TABLE filo.sequence_gear ADD COLUMN business_code varchar;
-- ddl-end --

COMMENT ON COLUMN filo.sequence_gear.business_code IS E'Business code of the gear, especially for traps';
-- ddl-end --


-- object: ambience_geom | type: COLUMN --
-- ALTER TABLE filo.ambience DROP COLUMN IF EXISTS ambience_geom CASCADE;
ALTER TABLE filo.ambience ADD COLUMN ambience_geom geometry(POINT, 4326);
-- ddl-end --


-- object: operation_geom | type: COLUMN --
-- ALTER TABLE filo.operation DROP COLUMN IF EXISTS operation_geom CASCADE;
ALTER TABLE filo.operation ADD COLUMN operation_geom geometry(MULTIPOINT, 4326);
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE filo
	ENCRYPTED PASSWORD 'filoPassword';
-- ddl-end --
ALTER TABLE filo.station ALTER COLUMN geom TYPE geometry(POINT, 4326);
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
ALTER TABLE tracking.antenna ALTER COLUMN geom_polygon TYPE geometry(POLYGON, 4326);
-- ddl-end --
ALTER TABLE tracking.detection ALTER COLUMN validity SET DEFAULT 't';
-- ddl-end --
ALTER TABLE tracking.location ALTER COLUMN location_pk TYPE float;
-- ddl-end --
ALTER TABLE tracking.location ALTER COLUMN geom TYPE geometry(POINT, 4326);
-- ddl-end --
COMMENT ON COLUMN import.export_model.pattern IS E'Pattern of the export/import.\nStructure:\n[{technicalKey:string,businessKey:string,tableName:string,tableAlias:string,children[table1,table2],parentKey:string,secondaryParentKey:string}]';
-- ddl-end --
COMMENT ON EXTENSION pgcrypto IS '';
-- ddl-end --


-- [ Created foreign keys ] --
-- object: sequence_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sequence_point DROP CONSTRAINT IF EXISTS sequence_fk CASCADE;
ALTER TABLE filo.sequence_point ADD CONSTRAINT sequence_fk FOREIGN KEY (sequence_id)
REFERENCES filo.sequence (sequence_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: localisation_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sequence_point DROP CONSTRAINT IF EXISTS localisation_fk CASCADE;
ALTER TABLE filo.sequence_point ADD CONSTRAINT localisation_fk FOREIGN KEY (localisation_id)
REFERENCES filo.localisation (localisation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: facies_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sequence_point DROP CONSTRAINT IF EXISTS facies_fk CASCADE;
ALTER TABLE filo.sequence_point ADD CONSTRAINT facies_fk FOREIGN KEY (facies_id)
REFERENCES filo.facies (facies_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

