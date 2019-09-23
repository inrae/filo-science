-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-09-23 17:44:02
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 9.6

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 1
-- Changed objects: 43
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE tracking.antenna DROP COLUMN IF EXISTS geom_circular CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: metric_srid | type: COLUMN --
-- ALTER TABLE filo.project DROP COLUMN IF EXISTS metric_srid CASCADE;
ALTER TABLE filo.project ADD COLUMN metric_srid smallint DEFAULT 2154;
-- ddl-end --

COMMENT ON COLUMN filo.project.metric_srid IS 'Srid in metric referential, for calculate circles or other geographic objects';
-- ddl-end --

