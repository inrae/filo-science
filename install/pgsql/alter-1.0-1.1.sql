-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta
-- Diff date: 2019-06-05 16:18:24
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 0
-- Changed objects: 40
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE filo.ambience DROP COLUMN IF EXISTS ambience_depth CASCADE;
-- ddl-end --


-- [ Changed objects ] --
COMMENT ON SCHEMA filo IS 'Fish logging - schema of data';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.length_max IS 'Length maximum, in mm';
-- ddl-end --
COMMENT ON COLUMN filo.sample.sample_size_min IS 'Minimal size of fishes in this sample, in mm';
-- ddl-end --
ALTER TABLE filo.sample ALTER COLUMN sample_size_max TYPE float;
-- ddl-end --
COMMENT ON COLUMN filo.sample.sample_size_max IS 'Maximal size of fishes in this sample, in mm';

-- ddl-end --
COMMENT ON COLUMN filo.individual.sl IS 'Standard length, in mm';

-- ddl-end --
COMMENT ON COLUMN filo.individual.fl IS 'Fork length, in mm';

-- ddl-end --
COMMENT ON COLUMN filo.individual.tl IS 'Total length, in mm';

-- ddl-end --
COMMENT ON COLUMN filo.individual.wd IS 'Width of disk, in mm';

-- ddl-end --
COMMENT ON COLUMN filo.individual.ot IS 'Other length, in mm';

-- ddl-end --
ALTER TABLE filo.individual ALTER COLUMN measure_estimated SET DEFAULT 'f';

-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN analysis_date SET NOT NULL;
-- ddl-end --
COMMENT ON SCHEMA gacl IS 'Rights management';
-- ddl-end --
ALTER TABLE filo.operator ALTER COLUMN is_active SET DEFAULT 't';
-- ddl-end --
ALTER TABLE filo.operation_operator ALTER COLUMN is_responsible SET DEFAULT 't';
-- ddl-end --
ALTER TABLE filo.analysis ALTER COLUMN sequence_id SET NOT NULL;
-- ddl-end --
insert into filo.dbversion (dbversion_number, dbversion_date) values ('1.1', '2019-06-05');