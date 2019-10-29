-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-10-29 15:44:38
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 2
-- Created objects: 9
-- Changed objects: 42
-- Truncated tables: 0

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,filo,gacl,import,tracking;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE tracking."position" DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
-- ddl-end --
DROP TABLE IF EXISTS tracking."position" CASCADE;
-- ddl-end --

-- object: pgcrypto | type: EXTENSION --
-- DROP EXTENSION IF EXISTS pgcrypto CASCADE;
CREATE EXTENSION pgcrypto
WITH SCHEMA public;
-- ddl-end --

-- ddl-end --

-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.operation DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.operation ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.ambience DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.ambience ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.sequence DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.sequence ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
-- ddl-end --


-- object: uuid | type: COLUMN --
-- ALTER TABLE filo.sample DROP COLUMN IF EXISTS uuid CASCADE;
ALTER TABLE filo.sample ADD COLUMN uuid uuid NOT NULL DEFAULT gen_random_uuid();
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






-- [ Changed objects ] --
ALTER ROLE filo
	ENCRYPTED PASSWORD 'filoPassword';
-- ddl-end --
ALTER DATABASE filo OWNER TO filo;
-- ddl-end --
COMMENT ON DATABASE filo IS 'Recording of measurements taken during scientific fisheries';
-- ddl-end --
COMMENT ON EXTENSION postgis IS '';
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
ALTER TABLE tracking.location ALTER COLUMN location_pk TYPE float;
-- ddl-end --
COMMENT ON COLUMN import.export_model.pattern IS 'Pattern of the export/import.
Structure:
[{technicalKey:string,businessKey:string,tableName:string,children[table1,table2],parentKey:string,functionName:string,keys[1,2,3]}]';
-- ddl-end --
