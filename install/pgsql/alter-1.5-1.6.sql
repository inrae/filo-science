-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2
-- Diff date: 2020-05-25 14:11:33
-- Source model: filo
-- Database: filodemo
-- PostgreSQL version: 10.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 28
-- Changed objects: 206
-- Truncated tables: 0

SET check_function_bodies = false;
-- ddl-end --

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Created objects ] --
-- object: project_code | type: COLUMN --
-- ALTER TABLE filo.project DROP COLUMN IF EXISTS project_code CASCADE;
ALTER TABLE filo.project ADD COLUMN project_code varchar;
-- ddl-end --


-- object: campaign_code | type: COLUMN --
-- ALTER TABLE filo.campaign DROP COLUMN IF EXISTS campaign_code CASCADE;
ALTER TABLE filo.campaign ADD COLUMN campaign_code varchar;
-- ddl-end --


-- object: operation_code | type: COLUMN --
-- ALTER TABLE filo.operation DROP COLUMN IF EXISTS operation_code CASCADE;
ALTER TABLE filo.operation ADD COLUMN operation_code varchar;
-- ddl-end --


-- object: sample_code | type: COLUMN --
-- ALTER TABLE filo.sample DROP COLUMN IF EXISTS sample_code CASCADE;
ALTER TABLE filo.sample ADD COLUMN sample_code varchar;
-- ddl-end --


-- object: individual_code | type: COLUMN --
-- ALTER TABLE filo.individual DROP COLUMN IF EXISTS individual_code CASCADE;
ALTER TABLE filo.individual ADD COLUMN individual_code varchar;
-- ddl-end --


-- object: river_code | type: COLUMN --
-- ALTER TABLE filo.river DROP COLUMN IF EXISTS river_code CASCADE;
ALTER TABLE filo.river ADD COLUMN river_code varchar;
-- ddl-end --


-- object: facies_code | type: COLUMN --
-- ALTER TABLE filo.facies DROP COLUMN IF EXISTS facies_code CASCADE;
ALTER TABLE filo.facies ADD COLUMN facies_code varchar;
-- ddl-end --


-- object: other_measures | type: COLUMN --
-- ALTER TABLE filo.ambience DROP COLUMN IF EXISTS other_measures CASCADE;
ALTER TABLE filo.ambience ADD COLUMN other_measures json;
-- ddl-end --

COMMENT ON COLUMN filo.ambience.other_measures IS E'Other measures attached to an ambience';
-- ddl-end --


-- object: situation_code | type: COLUMN --
-- ALTER TABLE filo.situation DROP COLUMN IF EXISTS situation_code CASCADE;
ALTER TABLE filo.situation ADD COLUMN situation_code varchar;
-- ddl-end --


-- object: localisation_code | type: COLUMN --
-- ALTER TABLE filo.localisation DROP COLUMN IF EXISTS localisation_code CASCADE;
ALTER TABLE filo.localisation ADD COLUMN localisation_code varchar;
-- ddl-end --


-- object: speed_code | type: COLUMN --
-- ALTER TABLE filo.speed DROP COLUMN IF EXISTS speed_code CASCADE;
ALTER TABLE filo.speed ADD COLUMN speed_code varchar;
-- ddl-end --


-- object: shady_code | type: COLUMN --
-- ALTER TABLE filo.shady DROP COLUMN IF EXISTS shady_code CASCADE;
ALTER TABLE filo.shady ADD COLUMN shady_code varchar;
-- ddl-end --


-- object: granulometry_code | type: COLUMN --
-- ALTER TABLE filo.granulometry DROP COLUMN IF EXISTS granulometry_code CASCADE;
ALTER TABLE filo.granulometry ADD COLUMN granulometry_code varchar;
-- ddl-end --


-- object: vegetation_code | type: COLUMN --
-- ALTER TABLE filo.vegetation DROP COLUMN IF EXISTS vegetation_code CASCADE;
ALTER TABLE filo.vegetation ADD COLUMN vegetation_code varchar;
-- ddl-end --


-- object: cache_abundance_code | type: COLUMN --
-- ALTER TABLE filo.cache_abundance DROP COLUMN IF EXISTS cache_abundance_code CASCADE;
ALTER TABLE filo.cache_abundance ADD COLUMN cache_abundance_code varchar;
-- ddl-end --


-- object: clogging_code | type: COLUMN --
-- ALTER TABLE filo.clogging DROP COLUMN IF EXISTS clogging_code CASCADE;
ALTER TABLE filo.clogging ADD COLUMN clogging_code varchar;
-- ddl-end --


-- object: sinuosity_code | type: COLUMN --
-- ALTER TABLE filo.sinuosity DROP COLUMN IF EXISTS sinuosity_code CASCADE;
ALTER TABLE filo.sinuosity ADD COLUMN sinuosity_code varchar;
-- ddl-end --


-- object: flow_trend_code | type: COLUMN --
-- ALTER TABLE filo.flow_trend DROP COLUMN IF EXISTS flow_trend_code CASCADE;
ALTER TABLE filo.flow_trend ADD COLUMN flow_trend_code varchar;
-- ddl-end --


-- object: turbidity_code | type: COLUMN --
-- ALTER TABLE filo.turbidity DROP COLUMN IF EXISTS turbidity_code CASCADE;
ALTER TABLE filo.turbidity ADD COLUMN turbidity_code varchar;
-- ddl-end --


-- object: protocol_code | type: COLUMN --
-- ALTER TABLE filo.protocol DROP COLUMN IF EXISTS protocol_code CASCADE;
ALTER TABLE filo.protocol ADD COLUMN protocol_code varchar;
-- ddl-end --


-- object: water_regime_code | type: COLUMN --
-- ALTER TABLE filo.water_regime DROP COLUMN IF EXISTS water_regime_code CASCADE;
ALTER TABLE filo.water_regime ADD COLUMN water_regime_code varchar;
-- ddl-end --


-- object: electric_current_type_code | type: COLUMN --
-- ALTER TABLE filo.electric_current_type DROP COLUMN IF EXISTS electric_current_type_code CASCADE;
ALTER TABLE filo.electric_current_type ADD COLUMN electric_current_type_code varchar;
-- ddl-end --


-- object: fishing_strategy_code | type: COLUMN --
-- ALTER TABLE filo.fishing_strategy DROP COLUMN IF EXISTS fishing_strategy_code CASCADE;
ALTER TABLE filo.fishing_strategy ADD COLUMN fishing_strategy_code varchar;
-- ddl-end --


-- object: scale_code | type: COLUMN --
-- ALTER TABLE filo.scale DROP COLUMN IF EXISTS scale_code CASCADE;
ALTER TABLE filo.scale ADD COLUMN scale_code varchar;
-- ddl-end --


-- object: gear_method_code | type: COLUMN --
-- ALTER TABLE filo.gear_method DROP COLUMN IF EXISTS gear_method_code CASCADE;
ALTER TABLE filo.gear_method ADD COLUMN gear_method_code varchar;
-- ddl-end --


-- object: filo.ambience_template | type: TABLE --
-- DROP TABLE IF EXISTS filo.ambience_template CASCADE;
CREATE TABLE filo.ambience_template (
	ambience_template_id serial NOT NULL,
	ambience_template_name varchar NOT NULL,
	ambience_template_schema json,
	CONSTRAINT ambience_template_pk PRIMARY KEY (ambience_template_id)

);
-- ddl-end --
COMMENT ON TABLE filo.ambience_template IS E'List of other measures that can be attached to an ambience';
-- ddl-end --
COMMENT ON COLUMN filo.ambience_template.ambience_template_name IS E'Name of the template';
-- ddl-end --
COMMENT ON COLUMN filo.ambience_template.ambience_template_schema IS E'List of fields of the template';
-- ddl-end --
ALTER TABLE filo.ambience_template OWNER TO filo;
-- ddl-end --

-- object: ambience_template_id | type: COLUMN --
-- ALTER TABLE filo.protocol DROP COLUMN IF EXISTS ambience_template_id CASCADE;
ALTER TABLE filo.protocol ADD COLUMN ambience_template_id integer;
-- ddl-end --

-- [ Created foreign keys ] --
-- object: ambience_template_fk | type: CONSTRAINT --
-- ALTER TABLE filo.protocol DROP CONSTRAINT IF EXISTS ambience_template_fk CASCADE;
ALTER TABLE filo.protocol ADD CONSTRAINT ambience_template_fk FOREIGN KEY (ambience_template_id)
REFERENCES filo.ambience_template (ambience_template_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'16', E'getIndividualFromCode', E'Récupère l''identifiant du poisson à partir de son code');

UPDATE filo.facies
   SET facies_name = 'Chenal lotique (profond courant)',
       facies_code = NULL
WHERE facies_id = 11;

UPDATE filo.facies
   SET facies_name = 'Rapide',
       facies_code = '10'
WHERE facies_id = 1;

UPDATE filo.facies
   SET facies_name = 'Radier',
       facies_code = '9'
WHERE facies_id = 2;

UPDATE filo.facies
   SET facies_name = 'Plat courant',
       facies_code = '8'
WHERE facies_id = 3;

UPDATE filo.facies
   SET facies_name = 'Plat lent',
       facies_code = '6'
WHERE facies_id = 4;

UPDATE filo.facies
   SET facies_name = 'Mouille ou profond',
       facies_code = '7'
WHERE facies_id = 5;

UPDATE filo.facies
   SET facies_name = 'Chenal lotique (profond courant)',
       facies_code = '1'
WHERE facies_id = 6;

UPDATE filo.facies
   SET facies_name = 'Chenal lentique (profond lent)',
       facies_code = '2'
WHERE facies_id = 7;

UPDATE filo.facies
   SET facies_name = 'Remous ou contre-courant',
       facies_code = ''
WHERE facies_id = 8;

UPDATE filo.facies
   SET facies_name = 'Bras mort ou lône',
       facies_code = '4'
WHERE facies_id = 9;

UPDATE filo.facies
   SET facies_name = 'Darse',
       facies_code = '26'
WHERE facies_id = 10;

UPDATE filo.granulometry
   SET granulometry_name = 'Argile (<3,9 µm)',
       granulometry_code = 'A'
WHERE granulometry_id = 1;

UPDATE filo.granulometry
   SET granulometry_name = 'Limons (de 3,9 à 62,5 µm)',
       granulometry_code = 'L'
WHERE granulometry_id = 2;

UPDATE filo.granulometry
   SET granulometry_name = 'Sables fins (de 62,5 à 0,5 µm)',
       granulometry_code = 'SF'
WHERE granulometry_id = 3;

UPDATE filo.granulometry
   SET granulometry_name = 'Sables grossiers (de 0,5 µm à 2 mm)',
       granulometry_code = 'SG'
WHERE granulometry_id = 4;

UPDATE filo.granulometry
   SET granulometry_name = 'Graviers (de 2 à 16 mm)',
       granulometry_code = 'G'
WHERE granulometry_id = 5;

UPDATE filo.granulometry
   SET granulometry_name = 'Cailloux fins (de 16 à 32 mm)',
       granulometry_code = 'CF'
WHERE granulometry_id = 6;

UPDATE filo.granulometry
   SET granulometry_name = 'Cailloux grossiers (de 32 à 64 mm)',
       granulometry_code = 'CG'
WHERE granulometry_id = 7;

UPDATE filo.granulometry
   SET granulometry_name = 'Pierres fines (de 64 à 128 mm)',
       granulometry_code = 'PF'
WHERE granulometry_id = 8;

UPDATE filo.granulometry
   SET granulometry_name = 'Pierres grossières (de 128 à 256 mm)',
       granulometry_code = 'PG'
WHERE granulometry_id = 9;

UPDATE filo.granulometry
   SET granulometry_name = 'Blocs (de 256 à 1024 mm)',
       granulometry_code = 'B'
WHERE granulometry_id = 10;

UPDATE filo.granulometry
   SET granulometry_name = 'Rochers (substra immergé avec protubérance)',
       granulometry_code = 'R'
WHERE granulometry_id = 11;

UPDATE filo.granulometry
   SET granulometry_name = 'Dalle (substrat immergé sans protubérance)',
       granulometry_code = 'D'
WHERE granulometry_id = 12;

INSERT INTO filo.dbversion (dbversion_number, dbversion_date) VALUES (E'1.6', E'2020-05-25');