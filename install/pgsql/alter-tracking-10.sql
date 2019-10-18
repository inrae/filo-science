-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-10-14 17:25:06
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 3
-- Changed objects: 40
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Created objects ] --
-- object: signal_force | type: COLUMN --
-- ALTER TABLE tracking.location DROP COLUMN IF EXISTS signal_force CASCADE;
ALTER TABLE tracking.location ADD COLUMN signal_force smallint;
-- ddl-end --

COMMENT ON COLUMN tracking.location.signal_force IS 'Force of the signal';
-- ddl-end --


-- object: observation | type: COLUMN --
-- ALTER TABLE tracking.location DROP COLUMN IF EXISTS observation CASCADE;
ALTER TABLE tracking.location ADD COLUMN observation varchar;
-- ddl-end --

COMMENT ON COLUMN tracking.location.observation IS 'comment';
-- ddl-end --


-- object: detection_date | type: COLUMN --
-- ALTER TABLE tracking.location DROP COLUMN IF EXISTS detection_date CASCADE;
ALTER TABLE tracking.location ADD COLUMN detection_date timestamp NOT NULL;
-- ddl-end --

COMMENT ON COLUMN tracking.location.detection_date IS 'Date-time of the detection';
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
ALTER TABLE tracking.technology_type ALTER COLUMN technology_type_id SET DEFAULT nextval('import.technology_technology_type_id_seq'::regclass);
-- ddl-end --
ALTER TABLE tracking.location ALTER COLUMN location_pk TYPE float;
-- ddl-end --
