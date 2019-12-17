-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta2
-- Diff date: 2019-12-17 12:06:54
-- Source model: filo
-- Database: filodemo
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 8
-- Changed objects: 236
-- Truncated tables: 0

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Created objects ] --
-- object: operation_geom | type: COLUMN --
-- ALTER TABLE filo.operation DROP COLUMN IF EXISTS operation_geom CASCADE;
ALTER TABLE filo.operation ADD COLUMN operation_geom geometry(MULTIPOINT, 4326);
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
	sequence_point_number smallint NOT NULL,
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



-- [ Changed objects ] --

COMMENT ON COLUMN tracking.antenna.antenna_code IS E'Antenna or receiver code';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.radius IS E'radius, in metres, of the useful reception';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.geom_polygon IS E'Geometry of the reception zone, in polygonal form, wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.detection_date IS E'Date-time of the detection';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.nb_events IS E'Events number recorded';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.duration IS E'Duration of the detection, in seconds with milliseconds';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.validity IS E'Specifiy if the detection is real (true) or false positive (false)';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.signal_force IS E'Force of the signal';
-- ddl-end --
COMMENT ON COLUMN tracking.detection.observation IS E'comment';
-- ddl-end --
COMMENT ON COLUMN tracking.probe.probe_code IS E'Code of the probe';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_measure.probe_measure_date IS E'Date-time of the record';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_measure.probe_measure_value IS E'Value measured';
-- ddl-end --
COMMENT ON COLUMN tracking.transmitter_type.transmitter_type_name IS E'Code or name of the transmitter';
-- ddl-end --
COMMENT ON COLUMN tracking.transmitter_type.characteristics IS E'General characteristics of the transmitter';
-- ddl-end --
COMMENT ON COLUMN tracking.transmitter_type.technology IS E'Technology used by the transmitter';
-- ddl-end --
COMMENT ON COLUMN import.import_description.import_description_name IS E'Name of the description of the import';
-- ddl-end --
COMMENT ON COLUMN import.import_description.separator IS E'separator used between fields (; , tab, space)';
-- ddl-end --
COMMENT ON COLUMN import.import_column.column_order IS E'Place of the column in the file, from 1';
-- ddl-end --
COMMENT ON COLUMN import.import_column.table_column_name IS E'name of the attribute of the column in the database table';
-- ddl-end --
COMMENT ON COLUMN import.function_type.function_name IS E'Name of the function. Must be the same in the application code';
-- ddl-end --
COMMENT ON COLUMN import.function_type.description IS E'Usage of the function';
-- ddl-end --
COMMENT ON COLUMN import.import_function.column_number IS E'Number of the column, from 1 to n. If 0: entire row';
-- ddl-end --
COMMENT ON COLUMN import.import_function.execution_order IS E'Order of execution of the function';
-- ddl-end --
COMMENT ON COLUMN import.import_function.arguments IS E'Values of arguments, separated by a comma. Arguments are described in function_type.description';
-- ddl-end --
COMMENT ON COLUMN import.import_function.column_result IS E'Number of column that gets the result of the function, from 1 to n. Not used for control functions';
-- ddl-end --
COMMENT ON COLUMN import.import_type.tablename IS E'Name of the table to import into';
-- ddl-end --
COMMENT ON COLUMN import.import_type.column_list IS E'List of the columns used in the table to import into, separed by a comma';
-- ddl-end --
COMMENT ON COLUMN tracking.location.detection_date IS E'Date-time of the detection';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_pk IS E'pk of the location';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_long IS E'Longitude of the location, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking.location.location_lat IS E'Latitude of the location, in wgs84';
-- ddl-end --
COMMENT ON COLUMN tracking.location.signal_force IS E'Force of the signal';
-- ddl-end --
COMMENT ON COLUMN tracking.location.observation IS E'comment';
-- ddl-end --
COMMENT ON COLUMN tracking.location.geom IS E'Geographic point of the location';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.date_start IS E'Start datetime of the event';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.date_end IS E'End datetime of the event';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.comment IS E'Event occurred';
-- ddl-end --
COMMENT ON COLUMN tracking.parameter_measure_type.parameter IS E'Normalized measured parameter (O2, TEMP, etc.)';
-- ddl-end --
COMMENT ON COLUMN tracking.parameter_measure_type.unit IS E'Unit of the parameter';
-- ddl-end --
COMMENT ON COLUMN import.export_model.export_model_name IS E'Name of the structure of export';
-- ddl-end --
COMMENT ON COLUMN import.export_model.pattern IS E'Pattern of the export/import.\nStructure:\n[{technicalKey:string,businessKey:string,tableName:string,tableAlias:string,children[table1,table2],parentKey:string,secondaryParentKey:string}]';
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

DELETE
FROM import.export_model
WHERE export_model_id = 1;
INSERT INTO import.export_model
(
  export_model_name,
  pattern
)
VALUES
(
  'Paramètres généraux',
  CAST('[{"tableName":"river","technicalKey":"river_id","businessKey":"river_name","children":[],"items":["1","2"]},{"tableName":"taxon","technicalKey":"taxon_id","businessKey":"scientific_name","children":["measure_template"],"items":[]},{"tableName":"measure_template","technicalKey":"measure_template_id","parentKey":"taxon_id","children":[],"items":[]}]' AS JSON)
);

DELETE
FROM import.export_model
WHERE export_model_id = 2;
INSERT INTO import.export_model
(
  export_model_name,
  pattern
)
VALUES
(
  'import_description',
  CAST('[{"tableName":"import_description","technicalKey":"import_description_id","businessKey":"import_description_name","children":["import_function","import_column"],"keys":[]},{"tableName":"import_function","technicalKey":"import_function_id","parentKey":"import_description_id","children":[],"keys":[]},{"tableName":"import_column","technicalKey":"import_column_id","parentKey":"import_description_id","children":[],"keys":[]}]' AS JSON)
);

DELETE
FROM import.export_model
WHERE export_model_id = 5;
INSERT INTO import.export_model
(
  export_model_name,
  pattern
)
VALUES
(
  'export_model',
  CAST('[{"tableName":"export_model","technicalKey":"export_model_id","isEmpty":false,"businessKey":"export_model_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]' AS JSON)
);

DELETE
FROM import.export_model
WHERE export_model_id = 9;
INSERT INTO import.export_model
(
  export_model_name,
  pattern
)
VALUES
(
  'campaignOnly',
  CAST('[{"tableName":"campaign","technicalKey":"campaign_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[{"aliasName":"protocol_measure","isStrict":true}],"parameters":[{"aliasName":"analysis_template","fieldName":"analysis_template_id"}],"istablenn":false},{"tableName":"analysis_template","technicalKey":"analysis_template_id","isEmpty":true,"businessKey":"analysis_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"measure_template","technicalKey":"measure_template_id","isEmpty":false,"businessKey":"measure_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"protocol_measure","isEmpty":false,"parentKey":"protocol_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"measure_template_id","tableAlias":"measure_template"}},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]' AS JSON)
);

DELETE
FROM import.export_model
WHERE export_model_name = 'campaign';
INSERT INTO import.export_model
(
  export_model_name,
  pattern
)
VALUES
(
  'campaign',
  CAST('[{"tableName":"campaign","technicalKey":"campaign_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":[],"children":[{"aliasName":"operation","isStrict":false}],"parameters":[{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"operation","technicalKey":"operation_id","isEmpty":false,"businessKey":"uuid","parentKey":"campaign_id","istable11":false,"booleanFields":["freshwater"],"children":[{"aliasName":"sequence","isStrict":false},{"aliasName":"operationAmbience","isStrict":false},{"aliasName":"operation_operator","isStrict":false}],"parameters":[{"aliasName":"station","fieldName":"station_id"},{"aliasName":"protocol","fieldName":"protocol_id"},{"aliasName":"water_regime","fieldName":"water_regime_id"},{"aliasName":"fishing_strategy","fieldName":"fishing_strategy_id"},{"aliasName":"scale","fieldName":"scale_id"},{"aliasName":"taxa_template","fieldName":"taxa_template_id"}],"istablenn":false},{"tableName":"sequence","technicalKey":"sequence_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"sequenceAmbience","isStrict":false},{"aliasName":"sequence_gear","isStrict":false},{"aliasName":"analysis","isStrict":false},{"aliasName":"sample","isStrict":false}],"parameters":[],"istablenn":false},{"tableName":"operation_operator","isEmpty":false,"parentKey":"operation_id","istable11":false,"booleanFields":["is_responsible"],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"operator_id","tableAlias":"operator"}},{"tableName":"operator","technicalKey":"operator_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[],"istablenn":false},{"tableName":"ambience","tableAlias":"operationAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"ambience","tableAlias":"sequenceAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"sample","technicalKey":"sample_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"individual","isStrict":false}],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"sequence_gear","technicalKey":"sequence_gear_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"gear","fieldName":"gear_id"},{"aliasName":"gear_method","fieldName":"gear_method_id"},{"aliasName":"electric_current_type","fieldName":"electric_current_type_id"}],"istablenn":false},{"tableName":"analysis","technicalKey":"analysis_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"individual","technicalKey":"individual_id","isEmpty":false,"businessKey":"uuid","parentKey":"sample_id","istable11":false,"booleanFields":["measure_estimated"],"children":[{"aliasName":"individual_tracking","isStrict":false}],"parameters":[{"aliasName":"sexe","fieldName":"sexe_id"},{"aliasName":"pathology","fieldName":"pathology_id"}],"istablenn":false},{"tableName":"individual_tracking","technicalKey":"individual_id","isEmpty":false,"parentKey":"individual_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"transmitter_type","fieldName":"transmitter_type_id"},{"aliasName":"taxon","fieldName":"taxon_id"},{"aliasName":"project","fieldName":"project_id"},{"aliasName":"station","fieldName":"release_station_id"}],"istablenn":false},{"tableName":"station","technicalKey":"station_id","isEmpty":true,"businessKey":"station_name","istable11":false,"booleanFields":[],"children":[{"aliasName":"station_tracking","isStrict":false}],"parameters":[{"aliasName":"river","fieldName":"river_id"},{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"station_tracking","technicalKey":"station_id","isEmpty":false,"parentKey":"station_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"station_type","fieldName":"station_type_id"}],"istablenn":false},{"tableName":"station_type","technicalKey":"station_type_id","isEmpty":true,"businessKey":"station_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[],"parameters":[{"aliasName":"analyse_template","fieldName":"analyse_template_id"}],"istablenn":false},{"tableName":"analyse_template","technicalKey":"analyse_template_id","isEmpty":true,"businessKey":"analyse_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"water_regime","technicalKey":"water_regime_id","isEmpty":true,"businessKey":"water_regime_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"fishing_strategy","technicalKey":"fishing_strategy_id","isEmpty":true,"businessKey":"fishing_strategy_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"scale","technicalKey":"scale_id","isEmpty":true,"businessKey":"scale_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxa_template","technicalKey":"taxa_template_id","isEmpty":true,"businessKey":"taxa_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"facies","technicalKey":"facies_id","isEmpty":true,"businessKey":"facies_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"situation","technicalKey":"situation_id","isEmpty":true,"businessKey":"situation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"speed","technicalKey":"speed_id","isEmpty":true,"businessKey":"speed_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"shady","technicalKey":"shady_id","isEmpty":true,"businessKey":"shady_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"localisation","technicalKey":"localisation_id","isEmpty":true,"businessKey":"localisation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"granulometry","technicalKey":"granulometry_id","isEmpty":true,"businessKey":"granulometry_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"cache_abundance","technicalKey":"cache_abundance_id","isEmpty":true,"businessKey":"cache_abundance_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"clogging","technicalKey":"clogging_id","isEmpty":true,"businessKey":"clogging_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sinuosity","technicalKey":"sinuosity_id","isEmpty":true,"businessKey":"sinuosity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"flow_trend","technicalKey":"flow_trend_id","isEmpty":true,"businessKey":"flow_trend_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"turbidity","technicalKey":"turbidity_id","isEmpty":true,"businessKey":"turbidity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"river","technicalKey":"river_id","isEmpty":true,"businessKey":"river_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear","technicalKey":"gear_id","isEmpty":true,"businessKey":"gear_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear_method","technicalKey":"gear_method_id","isEmpty":true,"businessKey":"gear_method_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"electric_current_type","technicalKey":"electric_current_type_id","isEmpty":true,"businessKey":"electric_current_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sexe","technicalKey":"sexe_id","isEmpty":true,"businessKey":"sexe_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"vegetation","technicalKey":"vegetation_id","isEmpty":true,"businessKey":"vegetation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"pathology","technicalKey":"pathology_id","isEmpty":true,"businessKey":"pathology_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"transmitter_type","technicalKey":"transmitter_type_id","isEmpty":true,"businessKey":"transmitter_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]' AS JSON)
);

DELETE
FROM import.export_model
WHERE export_model_name = 'station';
INSERT INTO import.export_model
(
  export_model_name,
  pattern
)
VALUES
(
  'station',
  CAST('[{"tableName":"station","technicalKey":"station_id","businessKey":"station_name","istable11":false,"children":[],"booleanFields":[],"istablenn":false}]' AS JSON)
);

DELETE
FROM import.export_model
WHERE export_model_name = 'operation';
INSERT INTO import.export_model
(
  export_model_name,
  pattern
)
VALUES
(
  'operation',
  CAST('[{"tableName":"operation","technicalKey":"operation_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["freshwater"],"children":[{"aliasName":"sequence","isStrict":false},{"aliasName":"operationAmbience","isStrict":false},{"aliasName":"operation_operator","isStrict":false}],"parameters":[{"aliasName":"station","fieldName":"station_id"},{"aliasName":"protocol","fieldName":"protocol_id"},{"aliasName":"water_regime","fieldName":"water_regime_id"},{"aliasName":"fishing_strategy","fieldName":"fishing_strategy_id"},{"aliasName":"scale","fieldName":"scale_id"},{"aliasName":"taxa_template","fieldName":"taxa_template_id"}],"istablenn":false},{"tableName":"sequence","technicalKey":"sequence_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"sequenceAmbience","isStrict":false},{"aliasName":"sequence_gear","isStrict":false},{"aliasName":"analysis","isStrict":false},{"aliasName":"sample","isStrict":false}],"parameters":[],"istablenn":false},{"tableName":"operation_operator","isEmpty":false,"parentKey":"operation_id","istable11":false,"booleanFields":["is_responsible"],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"operator_id","tableAlias":"operator"}},{"tableName":"operator","technicalKey":"operator_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[],"istablenn":false},{"tableName":"ambience","tableAlias":"operationAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"ambience","tableAlias":"sequenceAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"sample","technicalKey":"sample_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"individual","isStrict":false}],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"sequence_gear","technicalKey":"sequence_gear_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"gear_method","fieldName":"gear_method_id"},{"aliasName":"electric_current_type","fieldName":"electric_current_type_id"}],"istablenn":true,"tablenn":{"secondaryParentKey":"gear_id","tableAlias":"gear"}},{"tableName":"analysis","technicalKey":"analysis_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"individual","technicalKey":"individual_id","isEmpty":false,"businessKey":"uuid","parentKey":"sample_id","istable11":false,"booleanFields":["measure_estimated"],"children":[{"aliasName":"individual_tracking","isStrict":false}],"parameters":[{"aliasName":"sexe","fieldName":"sexe_id"},{"aliasName":"pathology","fieldName":"pathology_id"}],"istablenn":false},{"tableName":"individual_tracking","technicalKey":"individual_id","isEmpty":false,"parentKey":"individual_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"transmitter_type","fieldName":"transmitter_type_id"},{"aliasName":"taxon","fieldName":"taxon_id"},{"aliasName":"project","fieldName":"project_id"},{"aliasName":"station","fieldName":"release_station_id"}],"istablenn":false},{"tableName":"station","technicalKey":"station_id","isEmpty":true,"businessKey":"station_name","istable11":false,"booleanFields":[],"children":[{"aliasName":"station_tracking","isStrict":false}],"parameters":[{"aliasName":"river","fieldName":"river_id"},{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"station_tracking","technicalKey":"station_id","isEmpty":false,"parentKey":"station_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"station_type","fieldName":"station_type_id"}],"istablenn":false},{"tableName":"station_type","technicalKey":"station_type_id","isEmpty":true,"businessKey":"station_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[],"parameters":[{"aliasName":"analyse_template","fieldName":"analyse_template_id"}],"istablenn":false},{"tableName":"analyse_template","technicalKey":"analyse_template_id","isEmpty":true,"businessKey":"analyse_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"water_regime","technicalKey":"water_regime_id","isEmpty":true,"businessKey":"water_regime_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"fishing_strategy","technicalKey":"fishing_strategy_id","isEmpty":true,"businessKey":"fishing_strategy_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"scale","technicalKey":"scale_id","isEmpty":true,"businessKey":"scale_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxa_template","technicalKey":"taxa_template_id","isEmpty":true,"businessKey":"taxa_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"facies","technicalKey":"facies_id","isEmpty":true,"businessKey":"facies_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"situation","technicalKey":"situation_id","isEmpty":true,"businessKey":"situation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"speed","technicalKey":"speed_id","isEmpty":true,"businessKey":"speed_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"shady","technicalKey":"shady_id","isEmpty":true,"businessKey":"shady_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"localisation","technicalKey":"localisation_id","isEmpty":true,"businessKey":"localisation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"granulometry","technicalKey":"granulometry_id","isEmpty":true,"businessKey":"granulometry_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"cache_abundance","technicalKey":"cache_abundance_id","isEmpty":true,"businessKey":"cache_abundance_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"clogging","technicalKey":"clogging_id","isEmpty":true,"businessKey":"clogging_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sinuosity","technicalKey":"sinuosity_id","isEmpty":true,"businessKey":"sinuosity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"flow_trend","technicalKey":"flow_trend_id","isEmpty":true,"businessKey":"flow_trend_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"turbidity","technicalKey":"turbidity_id","isEmpty":true,"businessKey":"turbidity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"river","technicalKey":"river_id","isEmpty":true,"businessKey":"river_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear","technicalKey":"gear_id","isEmpty":true,"businessKey":"gear_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear_method","technicalKey":"gear_method_id","isEmpty":true,"businessKey":"gear_method_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"electric_current_type","technicalKey":"electric_current_type_id","isEmpty":true,"businessKey":"electric_current_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sexe","technicalKey":"sexe_id","isEmpty":true,"businessKey":"sexe_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"vegetation","technicalKey":"vegetation_id","isEmpty":true,"businessKey":"vegetation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"pathology","technicalKey":"pathology_id","isEmpty":true,"businessKey":"pathology_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"transmitter_type","technicalKey":"transmitter_type_id","isEmpty":true,"businessKey":"transmitter_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]' AS JSON)
);

insert into filo.dbversion (dbversion_number, dbversion_date) values (E'1.4', E'2019-12-17');