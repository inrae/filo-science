-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-10-09 10:59:21
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 4
-- Created objects: 22
-- Changed objects: 43
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE tracking.probe_measure DROP CONSTRAINT IF EXISTS probe_parameter_fk CASCADE;
-- ddl-end --
ALTER TABLE tracking.probe_parameter DROP CONSTRAINT IF EXISTS probe_fk CASCADE;
-- ddl-end --
DROP TABLE IF EXISTS tracking.probe_parameter CASCADE;
-- ddl-end --
DROP SEQUENCE IF EXISTS tracking.probe_parameter_probe_parameter_id_seq CASCADE;
-- ddl-end --
ALTER TABLE tracking.probe_measure DROP COLUMN IF EXISTS probe_parameter_id CASCADE;
-- ddl-end --


-- [ Created objects ] --
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

-- object: detection_location_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS tracking.detection_location_id_idx CASCADE;
CREATE INDEX detection_location_id_idx ON tracking.detection
	USING btree
	(
	  location_id
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
COMMENT ON TABLE tracking.parameter_measure_type IS 'Types of parameters used with probes';
-- ddl-end --
COMMENT ON COLUMN tracking.parameter_measure_type.parameter IS 'Normalized measured parameter (O2, TEMP, etc.)';
-- ddl-end --
COMMENT ON COLUMN tracking.parameter_measure_type.unit IS 'Unit of the parameter';
-- ddl-end --
ALTER TABLE tracking.parameter_measure_type OWNER TO filo;
-- ddl-end --

-- object: parameter_measure_type_id | type: COLUMN --
-- ALTER TABLE tracking.probe_measure DROP COLUMN IF EXISTS parameter_measure_type_id CASCADE;
ALTER TABLE tracking.probe_measure ADD COLUMN parameter_measure_type_id integer NOT NULL;
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
ALTER TABLE tracking.technology_type ALTER COLUMN technology_type_id SET DEFAULT nextval('import.technology_technology_type_id_seq'::regclass);
-- ddl-end --
ALTER TABLE tracking.location ALTER COLUMN location_pk TYPE float;
-- ddl-end --


-- [ Created foreign keys ] --
-- object: parameter_measure_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe_measure DROP CONSTRAINT IF EXISTS parameter_measure_type_fk CASCADE;
ALTER TABLE tracking.probe_measure ADD CONSTRAINT parameter_measure_type_fk FOREIGN KEY (parameter_measure_type_id)
REFERENCES tracking.parameter_measure_type (parameter_measure_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

