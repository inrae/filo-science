-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-10-14 17:13:45
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 5
-- Created objects: 2
-- Changed objects: 41
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS location_fk CASCADE;
-- ddl-end --
ALTER TABLE import.column_matching DROP CONSTRAINT IF EXISTS import_column_fk CASCADE;
-- ddl-end --
DROP INDEX IF EXISTS tracking.detection_location_id_idx CASCADE;
-- ddl-end --
DROP TABLE IF EXISTS import.column_matching CASCADE;
-- ddl-end --
DROP SEQUENCE IF EXISTS import.column_matching_column_matching_id_seq CASCADE;
-- ddl-end --
ALTER TABLE tracking.detection DROP COLUMN IF EXISTS location_id CASCADE;
-- ddl-end --
ALTER TABLE import.import_column DROP COLUMN IF EXISTS is_er CASCADE;
-- ddl-end --
ALTER TABLE import.import_column DROP COLUMN IF EXISTS is_value CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP COLUMN IF EXISTS is_table_er CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: individual_id | type: COLUMN --
-- ALTER TABLE tracking.location DROP COLUMN IF EXISTS individual_id CASCADE;
ALTER TABLE tracking.location ADD COLUMN individual_id integer NOT NULL;
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
ALTER VIEW tracking.v_individual_tracking OWNER TO filo;
-- ddl-end --


-- [ Created foreign keys ] --
-- object: individual_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.location DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
ALTER TABLE tracking.location ADD CONSTRAINT individual_tracking_fk FOREIGN KEY (individual_id)
REFERENCES tracking.individual_tracking (individual_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

