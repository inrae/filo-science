-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-10-02 15:53:15
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 3
-- Changed objects: 49
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE import.import_column DROP COLUMN IF EXISTS specific_format CASCADE;
-- ddl-end --


-- [ Created objects ] --
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

-- object: tablename | type: COLUMN --
-- ALTER TABLE import.import_type DROP COLUMN IF EXISTS tablename CASCADE;
ALTER TABLE import.import_type ADD COLUMN tablename varchar;
-- ddl-end --

COMMENT ON COLUMN import.import_type.tablename IS 'Name of the table to import into';
-- ddl-end --


-- object: column_list | type: COLUMN --
-- ALTER TABLE import.import_type DROP COLUMN IF EXISTS column_list CASCADE;
ALTER TABLE import.import_type ADD COLUMN column_list varchar;
-- ddl-end --

COMMENT ON COLUMN import.import_type.column_list IS 'List of the columns used in the table to import into, separed by a comma';
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
ALTER TABLE tracking.manual_detection ALTER COLUMN validity SET DEFAULT 't';
-- ddl-end --
ALTER TABLE tracking.detection ALTER COLUMN validity SET DEFAULT 't';
-- ddl-end --
COMMENT ON TABLE import.import_description IS 'Import templates';
-- ddl-end --
COMMENT ON COLUMN import.import_description.separator IS 'separator used between fields (; , tab, space)';
-- ddl-end --
ALTER TABLE import.import_description ALTER COLUMN is_table_er SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE import.import_column ALTER COLUMN table_column_name DROP NOT NULL;
-- ddl-end --
ALTER TABLE import.import_column ALTER COLUMN is_er SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE import.import_column ALTER COLUMN is_value SET DEFAULT 'f';
-- ddl-end --
ALTER TABLE import.import_type ALTER COLUMN import_type_id TYPE integer;
-- ddl-end --
ALTER TABLE import.import_type ALTER COLUMN import_type_id SET DEFAULT nextval('import.import_type_import_type_id_seq'::regclass);
-- ddl-end --
ALTER TABLE tracking.technology_type ALTER COLUMN technology_type_id SET DEFAULT nextval('import.technology_technology_type_id_seq'::regclass);
-- ddl-end --
ALTER TABLE tracking.antenna ALTER COLUMN technology_type_id DROP DEFAULT;
-- ddl-end --
ALTER TABLE import.import_description ALTER COLUMN import_type_id TYPE integer;
-- ddl-end --
