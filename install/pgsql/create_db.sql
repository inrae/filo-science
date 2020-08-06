-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2
-- PostgreSQL version: 9.6
-- Project Site: pgmodeler.io
-- Model Author: Eric Quinton

SET check_function_bodies = false;
-- ddl-end --

-- object: filo | type: ROLE --
-- DROP ROLE IF EXISTS filo;


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: filo | type: DATABASE --
-- -- DROP DATABASE IF EXISTS filo;
-- CREATE DATABASE filo
-- 	OWNER = filo;
-- -- ddl-end --
-- COMMENT ON DATABASE filo IS E'Recording of measurements taken during scientific fisheries';
-- -- ddl-end --
-- 

-- object: filo | type: SCHEMA --
-- DROP SCHEMA IF EXISTS filo CASCADE;
CREATE SCHEMA filo;
-- ddl-end --
ALTER SCHEMA filo OWNER TO filo;
-- ddl-end --
COMMENT ON SCHEMA filo IS E'Fish logging - schema of data';
-- ddl-end --

-- object: gacl | type: SCHEMA --
-- DROP SCHEMA IF EXISTS gacl CASCADE;
CREATE SCHEMA gacl;
-- ddl-end --
ALTER SCHEMA gacl OWNER TO filo;
-- ddl-end --
COMMENT ON SCHEMA gacl IS E'Rights management';
-- ddl-end --

-- object: tracking | type: SCHEMA --
-- DROP SCHEMA IF EXISTS tracking CASCADE;
CREATE SCHEMA tracking;
-- ddl-end --
ALTER SCHEMA tracking OWNER TO filo;
-- ddl-end --

-- object: import | type: SCHEMA --
-- DROP SCHEMA IF EXISTS import CASCADE;
CREATE SCHEMA import;
-- ddl-end --
ALTER SCHEMA import OWNER TO filo;
-- ddl-end --

SET search_path TO pg_catalog,public,filo,gacl,tracking,import;
-- ddl-end --

-- object: filo.project_project_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.project_project_id_seq CASCADE;
CREATE SEQUENCE filo.project_project_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.project_project_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.campaign_campaign_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.campaign_campaign_id_seq CASCADE;
CREATE SEQUENCE filo.campaign_campaign_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.campaign_campaign_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.project | type: TABLE --
-- DROP TABLE IF EXISTS filo.project CASCADE;
CREATE TABLE filo.project (
	project_id integer NOT NULL DEFAULT nextval('filo.project_project_id_seq'::regclass),
	project_name varchar NOT NULL,
	is_active boolean DEFAULT true,
	metric_srid smallint DEFAULT 2154,
	protocol_default_id integer,
	project_code varchar,
	CONSTRAINT project_id_pk PRIMARY KEY (project_id)

);
-- ddl-end --
COMMENT ON TABLE filo.project IS E'List of projects. This table is used for grant rights';
-- ddl-end --
COMMENT ON COLUMN filo.project.project_name IS E'Name of the project';
-- ddl-end --
COMMENT ON COLUMN filo.project.is_active IS E'Specify if the project is currently active';
-- ddl-end --
COMMENT ON COLUMN filo.project.metric_srid IS E'Srid in metric referential, for calculate circles or other geographic objects';
-- ddl-end --
ALTER TABLE filo.project OWNER TO filo;
-- ddl-end --

-- object: filo.campaign | type: TABLE --
-- DROP TABLE IF EXISTS filo.campaign CASCADE;
CREATE TABLE filo.campaign (
	campaign_id integer NOT NULL DEFAULT nextval('filo.campaign_campaign_id_seq'::regclass),
	project_id integer NOT NULL,
	campaign_name varchar NOT NULL,
	campaign_code varchar,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	CONSTRAINT campaign_id_pk PRIMARY KEY (campaign_id)

);
-- ddl-end --
COMMENT ON TABLE filo.campaign IS E'List of campaigns rattached to a project';
-- ddl-end --
COMMENT ON COLUMN filo.campaign.campaign_name IS E'Name of the campaign';
-- ddl-end --
ALTER TABLE filo.campaign OWNER TO filo;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE filo.campaign DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE filo.campaign ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES filo.project (project_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.station_station_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.station_station_id_seq CASCADE;
CREATE SEQUENCE filo.station_station_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.station_station_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.operation_operation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.operation_operation_id_seq CASCADE;
CREATE SEQUENCE filo.operation_operation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.operation_operation_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.place_place_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.place_place_id_seq CASCADE;
CREATE SEQUENCE filo.place_place_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.place_place_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.station | type: TABLE --
-- DROP TABLE IF EXISTS filo.station CASCADE;
CREATE TABLE filo.station (
	station_id integer NOT NULL DEFAULT nextval('filo.station_station_id_seq'::regclass),
	station_name varchar NOT NULL,
	project_id integer,
	station_long double precision,
	station_lat double precision,
	station_pk smallint,
	station_code varchar,
	river_id integer,
	geom geometry(POINT, 4326),
	station_number integer,
	CONSTRAINT station_id_pk PRIMARY KEY (station_id)

);
-- ddl-end --
COMMENT ON TABLE filo.station IS E'List of the stations used for a project';
-- ddl-end --
COMMENT ON COLUMN filo.station.station_name IS E'Name of the station';
-- ddl-end --
COMMENT ON COLUMN filo.station.station_long IS E'Longitude of the station, in WGS84, numeric value';
-- ddl-end --
COMMENT ON COLUMN filo.station.station_lat IS E'Latitude of the station, in WGS84, numeric value';
-- ddl-end --
COMMENT ON COLUMN filo.station.station_pk IS E'Kilometer point from source, in meters';
-- ddl-end --
COMMENT ON COLUMN filo.station.station_code IS E'Code of the station, according to the nomenclature sandre.eaufrance.fr';
-- ddl-end --
COMMENT ON COLUMN filo.station.geom IS E'Geographical representation of the situation of the station';
-- ddl-end --
COMMENT ON COLUMN filo.station.station_number IS E'working number of the station';
-- ddl-end --
ALTER TABLE filo.station OWNER TO filo;
-- ddl-end --

-- object: filo.taxon_taxon_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.taxon_taxon_id_seq CASCADE;
CREATE SEQUENCE filo.taxon_taxon_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.taxon_taxon_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.sample_sample_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.sample_sample_id_seq CASCADE;
CREATE SEQUENCE filo.sample_sample_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.sample_sample_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.taxon | type: TABLE --
-- DROP TABLE IF EXISTS filo.taxon CASCADE;
CREATE TABLE filo.taxon (
	taxon_id integer NOT NULL DEFAULT nextval('filo.taxon_taxon_id_seq'::regclass),
	scientific_name varchar NOT NULL,
	author varchar,
	common_name varchar,
	taxon_code varchar,
	fresh_code varchar,
	sea_code varchar,
	ecotype varchar,
	length_max float,
	weight_max float,
	CONSTRAINT taxon_id_pk PRIMARY KEY (taxon_id)

);
-- ddl-end --
COMMENT ON TABLE filo.taxon IS E'List of taxons';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.scientific_name IS E'Scientific name of the taxon';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.author IS E'Author of the description of the taxon';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.common_name IS E'Common name of the taxon';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.taxon_code IS E'Code used for reference the taxon in national nomenclature';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.fresh_code IS E'code mnemotechnic used for fishing operations in fresh water';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.sea_code IS E'Code mnemotechnic used for fishing operations in sea water';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.ecotype IS E'Specific ecotype used for this taxon';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.length_max IS E'Length maximum, in mm';
-- ddl-end --
COMMENT ON COLUMN filo.taxon.weight_max IS E'weight maximum, in g';
-- ddl-end --
ALTER TABLE filo.taxon OWNER TO filo;
-- ddl-end --

INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leucaspius delineatus', E'Heckel 1843', E'Able de Heckel', E'2117', E'ABH', E'ABH', E'100', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alburnus alburnus', E'Linnaeus, 1758', E'Ablette', E'2090', E'ABL', E'ABL', E'250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa alosa', E'Linnaeus, 1758', E'Alose (Grande Alose)', E'2056', E'ALA', E'ALA', E'830', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa fallax fallax', DEFAULT, E'Alose feinte', DEFAULT, DEFAULT, DEFAULT, E'500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa fallax rhodanensis', DEFAULT, E'Alose du Rhône', E'2058', E'ALR', DEFAULT, E'700', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Anguilla anguilla', E'Linnaeus, 1758', E'Anguille', E'2038', E'ANG', E'ANG', E'1330', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aphanius fasciatus', E'(Valenciennes), 1821', E'Aphanius de Corse', E'2142', E'APC', DEFAULT, E'60', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aphanius iberus', E'Valenciennes, 1846', E'Aphanius d''Espagne', E'2143', E'APE', DEFAULT, E'50', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Austropotamobius pallipes', DEFAULT, E'Ecrevisse à pieds blancs', E'868', E'APP', DEFAULT, E'120', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zingel asper', DEFAULT, E'Apron', E'2197', E'APR', DEFAULT, E'220', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Astacus astacus', DEFAULT, E'Ecrevisse à pieds rouges', E'866', E'ASA', DEFAULT, E'180', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Astacus leptodactylus', DEFAULT, E'Ecrevisse à pieds grêles', E'2963', E'ASL', DEFAULT, E'200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aspius aspius', DEFAULT, E'Aspe', E'2094', E'ASP', DEFAULT, E'1000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina boyeri', E'Risso 1810', E'Joël', E'2041', DEFAULT, E'ATB', E'120', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Barbus barbus', E'Linnaeus, 1758', E'Barbeau fluviatile', E'2096', E'BAF', DEFAULT, E'1200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Barbus meridionalis', DEFAULT, E'Barbeau méridional', E'2097', E'BAM', DEFAULT, E'300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dicentrarchus labrax', E'Linnaeus, 1758', E'Loup', E'2234', E'LOU', E'LOU', E'1030', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Micropterus salmoides', E'Lacepède 1802', E'Achigan à grande bouche', E'2053', E'BBG', DEFAULT, E'970', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Micropterus dolomieu', DEFAULT, E'Achigan à petite bouche', DEFAULT, DEFAULT, DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salaria fluviatilis', E'Asso, 1801', E'Blennie fluviatile', E'2045', E'BLE', DEFAULT, E'250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Telestes souffia', DEFAULT, E'Blageon', E'25609', E'BLN', DEFAULT, E'360', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rhodeus amarus', E'Bloch 1782', E'Bouvière', E'2131', E'BOU', DEFAULT, E'110', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Blicca bjoerkna', E'Linnaeus, 1758', E'Brème bordelière', E'2099', E'BRB', E'BRB', E'360', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Abramis brama', E'Linnaeus, 1758', E'Brème commune', E'2086', E'BRE', E'BRE', E'820', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Abramis sp.', DEFAULT, E'Brème (non identifiée)', DEFAULT, DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Esox lucius', E'Linnaeus, 1758', E'Brochet', E'2151', E'BRO', E'BRO', E'1500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius auratus', DEFAULT, E'Carassin doré', E'20597', E'CAD', DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius gibelio', DEFAULT, E'Carassin argenté', E'20550', E'CAG', DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hypophthalmichthys molitrix', DEFAULT, E'Carpe argentée', E'2115', E'CAR', DEFAULT, E'1050', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius carassius', E'Linnaeus, 1758', E'Carassin commun', E'2102', E'CAS', E'CAR', E'640', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyprinus carpio', E'Linnaeus, 1758', E'Carpe commune', E'2109', E'CMI', E'CCO', E'1340', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ambloplites rupestris', DEFAULT, E'Crapet de roche', E'2048', E'CDR', DEFAULT, E'430', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cottus gobio', E'Linnaeus, 1758', E'Chabot', E'2080', E'CHA', DEFAULT, E'180', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Squalius cephalus', DEFAULT, E'Chevaine', E'31041', E'CHE', DEFAULT, E'720', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cottus petiti', DEFAULT, E'Chabot du Lez', E'2354', E'CHP', DEFAULT, E'40', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chondrostoma sp.', DEFAULT, E'Chondrostome', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Coregonus lavaretus', DEFAULT, E'Lavaret', DEFAULT, DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Valencia hispanica', DEFAULT, E'Cyprinodonte de Valence', E'2145', E'CPV', DEFAULT, E'80', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salvelinus namaycush', DEFAULT, E'Cristivomer', E'2228', E'CRI', DEFAULT, E'1500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ctenopharyngodon idella', DEFAULT, E'Carpe amour', E'31039', E'CTI', DEFAULT, E'1500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyprinidae', DEFAULT, E'Cyprinidae indeterminé', DEFAULT, DEFAULT, DEFAULT, E'50', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus eperlanus', E'Linnaeus, 1758', E'Eperlan', E'2188', E'EPE', E'EPE', E'450', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gasterosteus gymnurus', DEFAULT, E'Epinoche', DEFAULT, DEFAULT, DEFAULT, E'80', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pungitius pungitius', E'Linnaeus, 1758', E'Epinochette', E'2167', E'EPT', E'EPT', E'90', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenser sturio', E'Linnaeus, 1758', E'Esturgeon', E'2032', E'EST', E'EST', E'6000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys flesus', E'Linnaeus, 1758', E'Flet', E'2203', E'FLE', E'FLE', E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gambusia holbrooki', DEFAULT, E'Gambusie', DEFAULT, DEFAULT, DEFAULT, E'70', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rutilus rutilus', E'Linnaeus, 1758', E'Gardon', E'2133', E'GAR', E'GAR', E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobio gobio', E'Linnaeus, 1758', E'Goujon', E'2113', E'GOU', E'GOU', E'200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gymnocephalus cernuus', E'Linnaeus, 1758', E'Grémille', E'2191', E'GRE', E'GRE', E'250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chondrostoma nasus', E'Linnaeus, 1758', E'Hotu', E'2104', E'HOT', DEFAULT, E'500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hucho hucho', DEFAULT, E'Huchon', E'2214', E'HUC', DEFAULT, E'1500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leuciscus idus', E'Linnaeus, 1758', E'Ide mélanote', E'2121', E'IDE', DEFAULT, E'1040', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cobitis bilineata', DEFAULT, E'Loche transalpine', E'34369', E'LOB', DEFAULT, E'120', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Misgurnus fossilis', E'Linnaeus, 1758', E'Loche d''étang', E'2069', E'LOE', DEFAULT, E'300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Barbatula barbatula', E'Linnaeus, 1758', E'Loche franche', E'2071', E'LOF', E'LOF', E'210', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cobitis taenia', E'Ikeda 1936', E'Loche épineuse', E'2067', E'LOR', DEFAULT, E'130', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lota lota', DEFAULT, E'Lote de rivière', E'2156', E'LOT', DEFAULT, E'1520', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'non identifiee', DEFAULT, E'Lamproie (ammocoete)', DEFAULT, DEFAULT, DEFAULT, E'200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzon marinus', E'Linnaeus, 1758', E'Lamproie marine', E'2014', E'LPM', E'LPM', E'1200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lampetra planeri', E'Bloch 1784', E'Lamproie de Planer', E'2012', E'LPP', E'LPP', E'200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lampetra fluviatilis', E'Linnaeus, 1758', E'Lamproie de rivière', E'2011', E'LPR', E'LPR', E'500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chelon labrosus', E'Risso 1827', E'Mulet à grosses lèvres', E'2180', E'MGL', E'MGL', E'840', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mugil cephalus', E'Linnaeus, 1758', E'Mulet cabot', E'2185', E'MUC', DEFAULT, E'1140', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liza aurata', E'Risso 1810', E'Mulet doré', E'2182', E'MUD', E'MUD', E'590', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liza ramada', E'Risso 1810', E'Mulet porc', E'2183', E'MUP', E'MUP', E'700', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Poissons non identifés', DEFAULT, E'Poissons non identifés', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pas de poisson', DEFAULT, E'Pas de poisson', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salvelinus alpinus', DEFAULT, E'Omble chevalier', DEFAULT, DEFAULT, DEFAULT, E'800', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Thymallus thymallus', E'Linnaeus, 1758', E'Ombre commun', E'2247', E'OBR', DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Orconectes limosus', E'Rafinesque 1817', E'Ecrevisse américaine', E'871', E'OCL', E'ORL', E'120', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Procambarus clarkii', E'Girard 1852', E'Ecrevisse de Louisiane', E'2028', E'PCC', E'ECL', E'150', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ameiurus melas', E'Rafinesque 1820', E'Poisson chat', E'2177', E'PCH', DEFAULT, E'660', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Perca fluviatilis', E'Linnaeus, 1758', E'Perche commune', E'2193', E'PER', E'PER', E'670', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepomis gibbosus', E'Linnaeus, 1758', E'Perche soleil', E'2050', E'PES', E'PES', E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pacifastacus leniusculus', DEFAULT, E'Ecrevisse signal', E'873', E'PFL', DEFAULT, E'180', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pimephales promelas', DEFAULT, E'Tête de boule', E'2127', E'PIM', DEFAULT, E'100', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pleuronectes platessa', E'Linnaeus, 1758', E'Plie', E'2205', E'PLI', E'PLI', E'1260', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pseudorasbora parva', E'Temminck & Schlegel, 1846', E'Pseudorasbora', E'2129', E'PSR', E'PSE', E'110', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scardinius erythrophthalmus', E'Linnaeus, 1758', E'Rotengle', E'2135', E'ROT', E'ROT', E'510', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sander lucioperca', E'Linnaeus, 1758', E'Sandre', E'2195', E'SAN', DEFAULT, E'1270', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo salar', E'Linnaeus, 1758', E'Saumon Atlantique', E'2220', E'SAT', E'SAT', E'1500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salvelinus fontinalis', DEFAULT, E'Omble de fontaine', E'2227', E'SDF', DEFAULT, E'940', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Silurus glanis', E'Linnaeus, 1758', E'Silure', E'2238', E'SIL', E'SIL', E'5000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alburnoides bipunctatus', E'Bloch 1782', E'Spirlin', E'2088', E'SPI', DEFAULT, E'160', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenser ruthenus', DEFAULT, E'Sterlet', E'3217', E'STL', DEFAULT, E'1250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Oncorhynchus mykiss', E'Walbaum 1792', E'Truite arc en ciel', E'2216', E'TAC', DEFAULT, E'1200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Tinca tinca', E'Linnaeus, 1758', E'Tanche', E'2137', E'TAN', E'TAN', E'820', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parachondrostoma toxostoma', DEFAULT, E'Toxostome', E'31135', E'TOX', DEFAULT, E'300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo trutta', E'Berg 1908', E'Truite commune', DEFAULT, DEFAULT, E'TRM', E'1000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbra pygmea', DEFAULT, E'Umbre pygmée', DEFAULT, DEFAULT, DEFAULT, E'100', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Phoxinus phoxinus', E'Linnaeus, 1758', E'Vairon', E'2125', E'VAI', E'VAI', E'140', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leuciscus leuciscus', E'Linnaeus, 1758', E'Vandoise', E'2122', E'VAN', DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Vimba vimba', DEFAULT, E'Vimbe', E'2139', E'VIM', DEFAULT, E'500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Abramis', E'Cuvier 1817', E'Brèmes d''eau douce nca', E'2085', E'BRX', DEFAULT, E'360', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Abramis brama, Blicca bjoerkna', DEFAULT, E'Brèmes', E'19511', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenser', E'Linnaeus, 1758', E'Esturgeons', E'2031', E'ES?', DEFAULT, E'6000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenser baerii', E'Brandt, 1869', E'Esturgeon de Sibérie', E'3218', E'BAE', DEFAULT, E'2000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenseridae', DEFAULT, E'Esturgeons nca', E'2030', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenseriformes', DEFAULT, E'Acipenseriformes', E'3347', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Agonus cataphractus', E'Linnaeus, 1758', E'Souris de mer', E'3544', DEFAULT, DEFAULT, E'210', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alloteuthis', DEFAULT, E'calmars nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alloteuthis subulata', E'Lamarck 1798', E'calmar commun', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa alosa x fallax', DEFAULT, E'Aloses vraie et feinte', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa fallax', E'Lacepède 1803', E'Alose feinte', E'2057', E'ALF', E'ALF', E'700', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa sp.', E'Linck 1790', E'Aloses nca', E'2055', DEFAULT, E'ALS', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ammodytes marinus', E'Raitt 1934', E'Lançon équille', E'3422', DEFAULT, DEFAULT, E'250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ammodytes tobianus', E'Linnaeus, 1758', E'Equille', E'2035', E'LAN', DEFAULT, E'300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Anguilla', E'Schrank 1798', E'Anguilles nca', E'2037', E'AN?', DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Anguillidae', DEFAULT, E'Anguilles', E'2036', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aphia minuta', E'Risso 1810', E'Nonnat', E'2170', E'APH', DEFAULT, E'70', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aplysia', E'Linnaeus, 1767', E'Aplysie nca', E'2143', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aplysia punctata', E'Cuvier, 1803', E'Lièvre de mer', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Apogon imberbis', E'Linnaeus, 1758', E'Castagnole rouge', E'20736', DEFAULT, DEFAULT, E'150', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Argyrosomus regius', E'Asso 1801', E'Maigre commun', E'2231', E'MAI', E'MAI', E'2300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Argyrosomus sp.', E'De La Pylaie 1835', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Arnoglossus imperialis', E'Rafinesque, 1810', E'Arnoglosse impérial', E'3505', DEFAULT, DEFAULT, E'250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Arnoglossus laterna', E'Walbaum 1792', E'Arnoglosse de Méditerranée', E'3506', DEFAULT, DEFAULT, E'190', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Arnoglossus thori', E'Kyle 1913', E'Arnoglosse tacheté', E'3507', DEFAULT, DEFAULT, E'205', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aspitrigla cuculus', E'Linnaeus, 1758', E'Grondin rouge', E'19453', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atelecyclus rotundatus', E'Olivi 1792', E'Petit crabe circulaire', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atelecyclus undecimdentatus', E'(Herbst, 1783)', E'Crabe circulaire', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Athanas nitescens', E'(Leach, 1814)', E'crevette athanas', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina', E'Linnaeus, 1758', E'Athérines nca', E'2040', E'AT?', DEFAULT, E'200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina hepsetus', E'Linnaeus, 1758', E'Athèrine sauclet', E'3264', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina presbyter', E'Cuvier 1829', E'Prêtre', E'2042', DEFAULT, E'ATP', E'200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina sp.', DEFAULT, E'Atherine sp', DEFAULT, DEFAULT, E'SILP', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherinidae', DEFAULT, E'Athérinidés', E'2039', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atyaephyra desmaresti,Palemon varians', DEFAULT, E'crevettes divers', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Balistes carolinensis', E'Gmelin, 1789', E'Baliste', E'19460', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Barbus', E'Cuvier 1817', E'Barbeaux nca', E'2095', E'BAX', DEFAULT, E'1200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Belone belone', E'Linnaeus 1761', E'Orphie', E'3378', DEFAULT, E'ORF', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Belone sp.', E'Cuvier 1817', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Bivalvia', E'Linnaeus, 1758', E'bivalves', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Blennius ocellaris', E'Linnaeus, 1758', E'Blennie papillon', E'3430', DEFAULT, DEFAULT, E'200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Boops boops', E'Linnaeus, 1758', E'Bogue', E'3482', DEFAULT, E'BOG', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Bothus podas', E'Delaroche, 1809', E'Rombou commun', E'25283', DEFAULT, DEFAULT, E'450', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Brachyura', DEFAULT, E'Crabes nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Buglossidium luteum', E'Risso 1810', E'Petite sole jaune', E'3535', DEFAULT, DEFAULT, E'150', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus', E'Linnaeus, 1758', E'Callionymes', E'3369', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus lyra', E'Linnaeus, 1758', E'Callionyme lyre', E'3370', DEFAULT, E'CAL', E'300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus pusillus', E'Delaroche, 1809', E'Dragonnet élégant', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus reticulatus', E'Valenciennes 1837', E'Callionyme réticulé', E'3372', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus risso', E'Lesueur 1814', E'Callionyme bélène', E'19458', DEFAULT, DEFAULT, E'110', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cancer pagurus', E'Linnaeus, 1758', E'Tourteau', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius', E'Nilsson 1832', E'Carassins nca', E'2100', E'CAX', DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius auratus auratus', E'Linnaeus, 1758', E'Carassin doré', E'5208', E'CAA', DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius auratus gibelio', E'Bloch, 1782', E'Carassin argenté', E'5207', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carcinus aestuarii', E'Nardo 1847', E'Crabe vert de la Méditerranée', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carcinus maenas', E'Linnaeus, 1758', E'Crabe vert', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Centrolabrus exoletus', E'Linnaeus, 1758', E'Petite vieille', E'3459', DEFAULT, DEFAULT, E'180', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chelidonichthys lucernus', E'Linnaeus, 1758', E'Grondin perlon', E'3563', DEFAULT, DEFAULT, E'750', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chelon', E'Artedi, 1793', E'Mulets nca', E'2179', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chlamys opercularis', DEFAULT, E'Coquille Saint Jacques', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chlamys varia', E'(Linnaeus, 1758)', E'Pétoncle', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chromis chromis', E'Linnaeus, 1758', E'Castagnole', E'20738', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ciliata', E'Couch 1832', E'Motelle', E'2153', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ciliata mustela', E'Linnaeus, 1758', E'Motelle à cinq barbillons', E'2154', E'MOT', E'MOT', E'250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ciliata septentrionalis', E'Collett 1875', E'Motelle à moustaches', E'3384', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Clupea harengus', E'Linnaeus, 1758', E'Hareng de l''Atlantique', E'2060', E'HAR', E'HER', E'450', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Clupea sp.', E'Linnaeus 1758', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Clupeidae', DEFAULT, E'Harengs, sardines nca', E'2054', E'CLU', DEFAULT, E'4176', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Conger conger', E'Linnaeus, 1758', E'Congre d''Europe', E'2074', E'CGR', E'CON', E'3000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Coris julis', E'Linnaeus, 1758', E'Girelle', E'19451', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cottus', E'Linnaeus, 1758', E'Chabot nca', E'2079', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crangon', DEFAULT, E'Crevettes crangon nca', E'3281', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crangon crangon', E'Linnaeus, 1758', E'Crevette grise', E'3282', E'CRG', E'CRG', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crangonidae', DEFAULT, E'Crevettes crangonidés', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crassostrea gigas', E'Thunberg 1793', E'Huître creuse du Pacifique', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crystallogobius linearis', E'Düben 1845', E'Gobie cristal', E'3445', DEFAULT, DEFAULT, E'47', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ctenolabrus rupestris', E'Linnaeus, 1758', E'Rouquié', E'3461', DEFAULT, E'ROU', E'180', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyclopterus lumpus', E'Linnaeus, 1758', E'Lompe', E'3551', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyprinidae', DEFAULT, E'Cyprinidés', E'2084', E'CYP', E'CYP', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cypriniformes', DEFAULT, E'Cypriniformes', E'3362', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyprinus', E'Linnaeus, 1758', E'Carpes nca', E'2108', E'CCX', DEFAULT, E'1340', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dasyatis', E'Rafinesque 1810', E'Pastenagues nca', E'3588', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dasyatis pastinaca', E'Linnaeus, 1758', E'Pastenague', E'3589', DEFAULT, E'WSX', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dentex dentex', E'Linnaeus, 1758', E'Denté commun', E'20740', DEFAULT, DEFAULT, E'1000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dicentrarchus', E'Gill 1860', E'Bars nca', E'2233', DEFAULT, DEFAULT, E'865', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dicentrarchus punctatus', E'Bloch 1792', E'Bar tacheté', E'2235', E'LOM', E'SPU', E'700', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dicologlossa cuneata', E'Moreau 1881', E'Cèteau', E'3537', DEFAULT, DEFAULT, E'300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplecogaster bimaculata bimaculata', E'Bonnaterre, 1788', E'Gluette rougeoleuse', E'3415', DEFAULT, DEFAULT, E'60', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus annularis', E'Linnaeus, 1758', E'Sparaillon commun', E'19481', DEFAULT, DEFAULT, E'240', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus cervinus', E'Lowe 1838', E'Sar à grosses lèvres', E'19482', DEFAULT, DEFAULT, E'610', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus puntazzo', E'Cetti, 1777', E'Sar à museau pointu', E'20741', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus sargus', E'Linnaeus, 1758', E'Sar commun', E'19483', DEFAULT, DEFAULT, E'450', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus vulgaris', E'Geoffroy St. Hilaire 1817', E'Sar à tête noire', E'19484', DEFAULT, E'SRG', E'450', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dromia', E'Weber, 1795', E'Dromie nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dromia personata', E'Linnaeus, 1758', E'Crabe dormeur', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Echiichthys vipera', E'Cuvier 1829', E'Petite vive', E'19480', DEFAULT, DEFAULT, E'160', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Enchelyopus cimbrius', E'Linnaeus 1766', E'Motelle à quatre barbillons', E'3402', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Engraulis', E'Cuvier 1817', E'Anchois nca', E'2147', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Engraulis encrasicolus', E'Linnaeus, 1758', E'Anchois', E'2148', E'ANC', E'ANC', E'200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Enophrys bubalis', E'Euphrasen, 1786', E'chabot buffle', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Entelurus aequoreus', E'Linnaeus, 1758', E'Entélure', E'3567', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eriocheir sinensis', E'H. Milne Edwards 1853', E'Crabe chinois', E'879', E'CRC', DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eupagurus bernhardus', E'Linnaeus, 1758', E'Bernard l’ermite commun', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eurynome', E'Leach, 1814', E'Majidé eurynome', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eurynome aspera', E'(Pennant, 1777)', E'Eurynome rugeuse', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eutrigla gurnardus', E'Linnaeus, 1758', E'Grondin gris', E'19478', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gadidae', DEFAULT, E'Gadidés', E'2152', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gadus morhua', E'Linnaeus, 1758', E'Morue de l''Atlantique', E'3386', DEFAULT, E'COD', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gaidropsarus mediterraneus', E'Linnaeus, 1758', E'Motelle de Méditerranée', E'3388', DEFAULT, DEFAULT, E'500', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gaidropsarus vulgaris', E'Cloquet 1824', E'Motelle commune', E'3389', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galathea rugosa', E'Fabricius, 1775', E'Galathée rose', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galathea squamifera', E'Leach, 1814', E'Galathée écailleuse', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galathea strigosa', DEFAULT, E'Galathée striée', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galeorhinus galeus', E'Linnaeus, 1758', E'Requin-hâ', E'3581', DEFAULT, E'LSK', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galeus melastomus', E'Rafinesque 1810', E'Chien espagnol', E'19487', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gambusia', E'Poey 1854', E'Gambusie nca', E'2207', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gambusia affinis', E'Baird & Girard 1853', E'Gambusie', E'2208', E'GAM', E'GAM', E'40', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gammaridae', DEFAULT, E'Gammares', E'887', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gasterosteus', E'Linnaeus, 1758', E'Epinoches', E'2164', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gasterosteus aculeatus', E'Linnaeus, 1758', E'Epinoche à trois épines', E'2165', DEFAULT, E'EPI', E'110', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Glyptocephalus cynoglossus', E'Linnaeus, 1758', E'Plie cynoglosse', E'3512', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobiidae', DEFAULT, E'Gobidés', E'2168', DEFAULT, DEFAULT, E'825', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius cobitis', E'Pallas 1814', E'Gobie céphalote', E'19490', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius cruentatus', E'Gmelin 1789', E'Gobie ensanglanté', E'19491', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobiusculus flavescens', E'Fabricius 1779', E'Gobie nageur', E'3451', DEFAULT, DEFAULT, E'63', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius geniporus', E'Valenciennes 1837', E'Gobie à joues poreuses', E'19492', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius niger', E'Linnaeus, 1758', E'Gobie noir', E'2172', E'GBN', DEFAULT, E'180', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius paganellus', E'Linnaeus, 1758', E'Gobie paganel', E'19493', DEFAULT, DEFAULT, E'120', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius roulei', E'De Buen 1928', E'Gobie paganel gros oeil', E'19494', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Goneplax rhomboides', E'Linnaeus, 1758', E'crabe', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gymnammodytes semisquamatus', E'Jourdain 1879', E'Lançon aiguille', E'3424', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hemigrapsus', DEFAULT, E'crabe japonais', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hemigrapsus penicillatus', E'De Haan, 1835', E'crabe japonais', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus', E'Rafinesque 1810', E'Hippocampes nca', E'3568', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus erectus', E'Perry', E'Hippocampe rayé', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus guttulatus', E'Cuvier, 1829', E'Hippocampe moucheté', E'3569', DEFAULT, DEFAULT, E'210', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus hippocampus', E'Linnaeus, 1758', E'Hippocampe à museau court', E'19485', DEFAULT, E'HIP', E'150', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus ingens', E'Girard', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus ramulosus', E'Leach 1814', E'Hippocampe moucheté', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus reidi', E'Ginsburg', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus zosterae', E'Jordan&Gilbert', E'Hippocampe Atlantique ouest', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippoglossoides platessoides', E'Fabricius 1780', E'Balai de l''Atlantique', E'3514', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippolyte varians', E'Leach, 1814', E'Crevette hippolyte', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hyperoplus', E'Linné, 1758', E'lançon ind', E'3426', DEFAULT, DEFAULT, E'370', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hyperoplus immaculatus', E'Corbin, 1950', E'Lançon jolivet', E'3427', DEFAULT, DEFAULT, E'350', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hyperoplus lanceolatus', E'Le Sauvage 1824', E'Lançon commun', E'3428', DEFAULT, DEFAULT, E'390', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ictalurus', E'Rafinesque 1820', E'Barbottes nca', E'2176', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ictalurus melas', DEFAULT, E'Poisson chat', DEFAULT, DEFAULT, E'PCH', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ictalurus punctatus', E'Rafinesque 1818', E'Barbue d''Amérique', E'19486', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Idotea baltica', DEFAULT, E'isopode', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Inachus', E'Weber, 1795', E'Crabe inachus', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Inachus dorsettensis', E'Pennant, 1777', E'Crabe des anémones', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Labrus bergylta', E'Ascanius 1767', E'Vieille commune', E'3463', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Labrus merula', E'Linnaeus, 1758', E'Merle', E'19474', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Labrus mixtus', E'Linnaeus,1758', E'Coquette', E'19489', DEFAULT, DEFAULT, E'350', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Labrus viridis', E'Linnaeus,1758', E'Labre vert', E'19479', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lampetra', E'Gray 1851', E'Lamproie Lampetra', E'2010', E'LPX', DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepadogaster candolii', E'Risso, 1810', E'Gluette petite queue', E'3417', DEFAULT, DEFAULT, E'75', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepadogaster lepadogaster', E'Walbaum 1792', E'Gluette barbier', E'3418', DEFAULT, DEFAULT, E'65', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepidorhombus whiffiagonis', E'Walbaum 1792', E'Cardine franche', E'3523', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepomis sp.', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lesueurigobius friesii', E'Malm 1874', E'Gobie raôlet', E'19469', DEFAULT, DEFAULT, E'130', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leuciscus cephalus', E'Linnaeus, 1758', E'Chevaine', E'2120', DEFAULT, E'CHE', E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leuciscus souffia', E'Risso 1827', E'Blageon', E'2119', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leucoraja naevus', E'Müller & Henle, 1841', E'Raie fleurie', E'3599', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lichia amia', E'Linnaeus, 1758', E'Liche', E'25286', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Limanda limanda', E'Linnaeus, 1758', E'Limande', E'3518', DEFAULT, DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus', E'Stimpson, 1870', E'Etrille nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus arcuatus', E'Leach, 1814', E'Etrille arcuatus', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus depurator', E'Linnaeus, 1758', E'Etrille pattes bleues', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus holsatus', E'Fabricius, 1798', E'Etrille nageuse', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus navigator', E'(Hebst, 1794)', E'Etrille pattes bleues', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liparis liparis', E'Linnaeus 1766', E'Limace de mer', E'3553', DEFAULT, DEFAULT, E'150', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liparis montagui', E'Donovan 1804', E'Limace anicotte', E'2083', E'LIP', DEFAULT, E'120', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lipophrys dalmatinus', E'Steindachner & Kolombatovic, 1884', E'Blennie dalmate', E'20742', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lipophrys pholis', E'Linnaeus, 1758', E'Blennie mordocet', E'3431', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lithognathus mormyrus', E'Linnaeus, 1758', E'Marbré', E'19465', DEFAULT, DEFAULT, E'376', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liza', E'Jordan&Swain 1884', E'Mulets nca', E'2181', DEFAULT, DEFAULT, E'5915', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liza saliens', E'Risso 1810', E'Mulet sauteur', E'3267', E'MUS', DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Loliginidae', E'D''Orbigny, 1848', E'Calmars côtiers nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Loligo', DEFAULT, E'Calmars nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Loligo vulgaris', E'Lamarck 1798', E'Encornet', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lophius piscatorius', E'Linnaeus, 1758', E'Baudroie commune', E'3421', DEFAULT, E'ANF', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Macoma balthica', E'Linnaeus, 1758', E'Telline de la Baltique', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Macropodia', DEFAULT, E'Macropode nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Macropodia longirostris', E'Fabricius, 1775', E'Macropode longirostris', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Macropodia rostrata', E'Linnaeus, 1761', E'Macropode commun', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Maja brachydactyla', DEFAULT, E'Araignée de mer', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Maja squinado', E'Herbst, 1788', E'Araignée de mer', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Maurolicus muelleri', E'Gmelin 1789', E'Brossé améthyste', E'19466', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Medorippe lanata', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Melanogrammus aeglefinus', E'Linnaeus, 1758', E'Eglefin', E'19467', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Merlangius merlangus', E'Linnaeus, 1758', E'Merlan', E'2158', E'MER', E'WHG', E'70', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Merluccius merluccius', E'Linnaeus, 1758', E'Merlu européen', E'3410', DEFAULT, E'HKE', E'1400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Micrenophrys lilljeborgii', E'Collett 1875', E'Chabot têtu', E'3549', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Microchirus variegatus', E'Donovan, 1808', E'Sole perdrix', E'3539', DEFAULT, DEFAULT, E'350', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Micromesistius poutassou', E'Risso 1827', E'Merlan bleu', E'3391', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Microstomus kitt', E'Walbaum 1792', E'Limande sole', E'3520', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Molva molva', E'Linnaeus, 1758', E'Lingue', E'3393', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mugil', E'Linnaeus, 1758', E'Mulets nca', E'2184', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mugilidae', DEFAULT, E'Mugilidés', E'2178', DEFAULT, DEFAULT, E'7833', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mugil liza', E'Valenciennes 1836', E'Mulet lebranche', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mullus', E'Linnaeus, 1758', E'Rougets nca', E'3471', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mullus barbatus', E'Linnaeus, 1758', E'Rouget de vase', E'3472', DEFAULT, DEFAULT, E'332', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mullus sp.', DEFAULT, E'Mullus sp.', DEFAULT, DEFAULT, E'MUL', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mullus surmuletus', E'Linnaeus, 1758', E'Rouget de roche', E'3473', DEFAULT, E'MUS', E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mustelus asterias', E'Cloquet 1821', E'Emissole tachetée', E'3584', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mustelus mustelus', E'Linnaeus, 1758', E'Emissole lisse', E'3585', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Myoxocephalus scorpius', E'Linnaeus, 1758', E'Chaboisseau à épines courtes', E'3546', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Myxine glutinosa', E'Linnaeus, 1758', E'Myxine', E'19470', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Necora puber', E'Linnaeus 1767', E'Etrille commune', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Nerophis lumbriciformis', E'Jenyns 1835', E'Nérophis petit nez', E'19471', DEFAULT, DEFAULT, E'160', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Nerophis maculatus', E'Rafinesque, 1810', E'Nérophis tacheté', DEFAULT, DEFAULT, DEFAULT, E'300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Nerophis ophidion', E'Linnaeus, 1758', E'Nérophis tête bleue', E'19472', DEFAULT, DEFAULT, E'290', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'NoName', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Oblada melanura', E'Linnaeus, 1758', E'Oblade', E'3485', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Octopus vulgaris', DEFAULT, E'poulpe commun', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus mordax', E'Steindachner & Kner 1870', E'Eperlan arc-en-ciel', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus mordax dentex', E'Steind. 1870', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus mordax mordax', E'Mitchill 1814', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus sp.', E'Linnaeus 1758', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus sp., Hypomesus sp.', DEFAULT, E'Eperlans nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pachygrapsus', DEFAULT, E'Crabes Pachygrapsus', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pachygrapsus marmoratus', E'Fabricius 1787', E'Grapse marbré', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pachygrapsus transversus', E'Gibbes 1850', E'Anglette africaine', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pagellus bogaraveo', E'Linnaeus, 1758', E'Pageot rose', DEFAULT, DEFAULT, DEFAULT, E'700', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pagellus erythrinus', E'Linnaeus, 1758', E'Pageot commun', E'23613', DEFAULT, DEFAULT, E'517', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pagurus prideauxi', E'Leach, 1814', E'Gonfaron', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon', E'Weber, 1795', E'Crevettes Palaemon nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon adspersus', E'Rathke, 1837', E'Bouquet balte', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon elegans', E'Rathke 1837', E'Bouquet flaque', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemonetes varians', E'Leach 1814', E'Bouquet atlantique des canaux', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemonidae', E'Rafinesque, 1815', E'Palaemonidés', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon longirostris', E'H. Milne Edwards 1837', E'Crevette blanche', E'3280', E'CRB', E'CRB', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon longirostris, P. serratus', DEFAULT, E'crevettes blanche et rose', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon macrodactylus', E'M.J. Rathbun 1902', E'Bouquet migrateur', DEFAULT, DEFAULT, E'CRM', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon serratus', E'Pennant 1777', E'Bouquet commun', DEFAULT, DEFAULT, E'CRR', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon sp.', DEFAULT, E'Palaemon sp.', DEFAULT, DEFAULT, E'PAL', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Panopeus africanus', E'A. Milne Edwards 1867', E'Crabe caillou africain', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parablennius gattorugine', E'Linnaeus, 1758', E'Blennie cabot', E'3429', DEFAULT, DEFAULT, E'300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parablennius pilicornis', E'Cuvier, 1829', E'Blennie pilicorne', E'20743', DEFAULT, DEFAULT, E'127', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parablennius sanguinolentus', E'Pallas 1814', E'Baveuse', E'19473', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parthenope angulifrons', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pecten maximus', E'(Linnaeus, 1758)', E'Coquille St Jacques', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pegusa impar', E'Bennett, 1831', E'Sole adriatique', E'20746', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pegusa lascaris', E'Ben-Tuvia 1990', E'Sole-pole', E'3540', DEFAULT, DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Penaeus japonicus', E'Bate 1888', E'Crevette kuruma', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Penaeus kerathurus', E'Forskal 1775', E'Caramote', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzon marinus, Lampetra fluviatilis', DEFAULT, E'lamproie marine et lamproie de rivière', E'19512', DEFAULT, E'LPS', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzon sp.', E'Linnaeus 1758', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzontidae', DEFAULT, E'Lamproies nca', E'2009', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzontiformes', DEFAULT, E'Petromyzontiformes', E'5070', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Philocheras trispinosus', E'(Hailstone, 1835)', E'crevette philocheras', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pholis gunnellus', E'Linnaeus, 1758', E'Gonelle', E'2200', E'GON', DEFAULT, E'250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Phoxinus', E'Rafinesque 1820', E'Vairons nca', E'2124', E'PHX', DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pilumnus hirtellus', E'Linnaeus, 1758', E'Crabe rouge poilu', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pirimela denticulata', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pisa tetraodon', E'(Pennant, 1777)', E'Araignée cornue', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pisidia longicornis', E'Linnaeus 1767', E'Porcellane noire', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Planes minutus', E'Linnaeus, 1758', E'Grapse des tortues', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys flesus flesus', E'L. 1758', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys flesus italicus', E'Gsnt. 1862', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys flesus luscus', E'Pallas 1811', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys sp.', E'Girard 1856', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pleuronectes', E'Linnaeus, 1758', E'Plies nca', E'2204', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pleuronectidae', DEFAULT, E'Pleuronectidés', E'2201', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pollachius pollachius', E'Linnaeus, 1758', E'Lieu jaune', E'2160', E'LIJ', E'POL', E'1300', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pollachius virens', E'Linnaeus, 1758', E'Lieu noir', E'3398', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Polybius holsatus', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatomus saltatrix', E'Linnaeus, 1766', E'Tassergal', E'20744', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus', E'Gill 1864', E'Gobies Pomatoschistus', E'2173', DEFAULT, DEFAULT, E'766', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus lozanoi', E'De Buen, 1923', E'Gobie rouillé', E'19464', DEFAULT, DEFAULT, E'80', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus marmoratus', E'Risso, 1810', E'Gobie marbré', E'19463', DEFAULT, DEFAULT, E'80', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus microps', E'Kroeyer 1838', E'Gobie tacheté', E'3455', DEFAULT, DEFAULT, E'68', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus minutus', E'Pallas 1770', E'Gobie buhotte', E'2174', E'GOB', E'GOB', E'110', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus pictus', E'Malm 1865', E'Gobie varié', E'3456', DEFAULT, DEFAULT, E'80', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus quagga', E'Gil, 1863', E'Gobie quagga', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Porcellana platycheles', E'Pennant 1777', E'Crabe porcelaine', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Portumnus latipes', E'Pennant 1777', E'Etrille elegante', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Portunidae', E'Rafinesque, 1815', E'crabes portunidés nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Procambarus', DEFAULT, E'Ecrevisses nca', E'2027', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Processa edulis', E'Risso 1816', E'Guernade nica', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Processa nouveli', E'Al Adhub & Williamson, 1975', E'Guernade nouveli', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Processa parva', DEFAULT, E'crevette ind', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Psetta maxima', E'Linnaeus, 1758', E'Turbot', E'19468', DEFAULT, E'TUR', E'1000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Psetta sp.', E'Swainson 1839', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pycnogonidae', DEFAULT, E'Pycnogonide nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja', E'Linnaeus, 1758', E'Raie nca', E'2210', DEFAULT, DEFAULT, E'1122', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja brachyura', E'Lafont 1873', E'Raie lisse', E'3591', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja clavata', E'Linnaeus, 1758', E'Raie bouclée', E'2211', E'RBC', E'RJC', E'1050', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja microocellata', E'Montagu 1818', E'Raie mélée', E'3592', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja montagui', E'Fowler, 1910', E'Raie étoilée', E'3593', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja naevus', E'Müller & Henle 1841', E'Raie fleurie', DEFAULT, DEFAULT, E'RJN', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja undulata', E'Lacepède 1802', E'Raie brunette', E'3594', DEFAULT, E'SKA', E'1200', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rajella fyllae', E'Lütken, 1887', E'Raie ronde', E'3602', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raniceps raninus', E'Linnaeus, 1758', E'Trident', E'3400', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rhithropanopeus', E'Gould 1832', E'Crabe', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rhithropanopeus harrisii', E'Gould, 1841', E'Crabe de vase', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rhodeus sericeus', E'Pallas 1776', E'Bouvière', DEFAULT, DEFAULT, E'BOU', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rutilus', E'Rafinesque 1820', E'Gardons nca', E'2132', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salaria basilisca', E'Valenciennes, 1836', E'Blennie basilic', E'25285', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salaria pavo', E'Risso 1810', E'Blennie paon', E'19488', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo', E'Linnaeus, 1758', E'Truites nca', E'2219', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmonidae', DEFAULT, E'Salmonidés', E'2212', E'SAL', DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo trutta fario', E'Linnaeus, 1758', E'Truite fario', E'2221', E'TRF', DEFAULT, E'1000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo trutta trutta', E'Linnaeus, 1758', E'Truite de mer brune', E'2224', E'TRM', DEFAULT, E'1000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sander', DEFAULT, E'Sandres nca', E'5074', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sardina pilchardus', E'Walbaum 1792', E'Sardine commune', E'2062', E'SAR', E'SAR', E'270', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sardinella aurita', E'Valenciennes 1847', E'Allache', E'19476', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sarpa salpa', E'Linnaeus, 1758', E'Saupe', E'19475', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sciaena umbra', E'Linnaeus, 1758', E'Corb commun', E'19477', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scomber scombrus', E'Linnaeus, 1758', E'Maquereau commun', E'3475', DEFAULT, E'MAC', E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scophthalmus maximus', E'Linnaeus, 1758', E'Turbot', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scophthalmus rhombus', E'Linnaeus, 1758', E'Barbue', E'3531', DEFAULT, E'BLL', E'750', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scophthalmus sp.', E'Rafinesque 1810', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scorpaena porcus', E'Linnaeus, 1758', E'Rascasse brune', E'20745', DEFAULT, DEFAULT, E'370', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scyliorhinus canicula', E'Linnaeus, 1758', E'Petite roussette', E'3609', DEFAULT, DEFAULT, E'1000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scyliorhinus stellaris', E'Linnaeus, 1758', E'Grande roussette', E'3610', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepia', E'Linnaeus, 1758', E'Seiches', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepia officinalis', E'Linnaeus, 1758', E'Seiche commune', DEFAULT, DEFAULT, E'SEI', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepiola', E'Leach, 1817', E'Sépioles', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepiola atlantica', E'Orbigny 1840', E'Sépiole grandes oreilles', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepiola rondeleti', E'Leach, 1817', E'Sepiole rondeleti', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Serranus hepatus', E'Linné, 1758', E'Serran tambour', E'3479', DEFAULT, DEFAULT, E'250', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sicyonia carinata', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Silurus', E'Linnaeus, 1758', E'Silures nca', E'2237', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea', E'Quensel 1806', E'Soles', E'2240', DEFAULT, E'SOL', E'650', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea aegyptiaca', E'Chabanaud, 1927', E'Sole egyptienne', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea lascaris', DEFAULT, E'Sole pole', DEFAULT, DEFAULT, E'SOS', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea senegalensis', E'Kaup 1858', E'Sole sénégalaise', E'3541', DEFAULT, E'SOX', E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea solea', E'Linnaeus, 1758', E'Sole', E'2241', E'SOL', DEFAULT, E'700', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea vulgaris', E'Quensel 1806', E'Sole commune', DEFAULT, DEFAULT, E'SOL', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sparidae', DEFAULT, E'sparidés nca', E'3481', DEFAULT, DEFAULT, E'4807', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sparus aurata', E'Linnaeus, 1758', E'Dorade royale', E'3490', DEFAULT, E'DRO', E'700', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Spicara smaris', E'Linnaeus, 1758', E'Picarel', E'3449', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Spinachia spinachia', E'Linnaeus, 1758', E'Epinoche de mer', E'19452', DEFAULT, DEFAULT, E'191', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Spondyliosoma cantharus', E'Linnaeus, 1758', E'Griset', E'3492', DEFAULT, E'BRD', E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sprattus sp.', E'Girgensohn 1846', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sprattus sprattus', E'Linnaeus, 1758', E'Sprat', E'2064', E'SPT', E'SPT', E'160', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Squalus acanthias', E'Linnaeus, 1758', E'Aiguillat commun', E'3614', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Stizostedion lucioperca', DEFAULT, E'Sandre', DEFAULT, DEFAULT, E'SAN', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus bailloni', E'Valenciennes in Cuv. & Val., 1839', E'Crénilabre grelue', E'19443', DEFAULT, DEFAULT, E'210', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus cinereus', E'(Bonnaterre), 1788', E'Crénilabre balafré', E'19449', DEFAULT, DEFAULT, E'160', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus melops', E'Linnaeus, 1758', E'Crénilabre melops', E'3466', DEFAULT, DEFAULT, E'240', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus ocellatus', E'(Forsskål, 1775)', E'Crénilabre ocellé', E'19448', DEFAULT, DEFAULT, E'120', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus roissali', E'Risso 1810', E'Crénilabre langaneu', E'19447', DEFAULT, DEFAULT, E'170', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus tinca', E'Linnaeus, 1758', E'Crénilabre paon', E'19450', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Synapturichthys kleinii', E'Risso, 1827', E'Sole tachetée', E'25284', DEFAULT, DEFAULT, E'420', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Synchiropus phaeton', E'(Günther 1861)', E'Callionyme paille-en-queue', E'19445', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathidae', DEFAULT, E'Syngnathes', E'2242', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus', E'Linnaeus, 1758', E'Syngnathes', E'2243', DEFAULT, DEFAULT, E'2975', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus abaster', E'Risso 1827', E'Syngnathe gorge claire', E'19444', DEFAULT, DEFAULT, E'210', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus acus', E'Linnaeus, 1758', E'Syngnathe aiguille', E'2244', E'SYN', DEFAULT, E'20', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus rostellatus', E'Nilsson 1855', E'Syngnathe de Duméril', E'3570', DEFAULT, E'SYN', E'205', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus taenionotus', E'Canestrini 1871', E'Syngnathe taenionotus', E'19459', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus typhle', E'Linnaeus, 1758', E'Siphonostome', E'3571', DEFAULT, DEFAULT, E'360', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus typhle typhle', E'Linnaeus, 1758', E'Siphonostome atlantique', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Taurulus bubalis', E'Euphrasen 1786', E'Chabot buffle', E'3548', DEFAULT, DEFAULT, E'175', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Thorogobius ephippiatus', DEFAULT, E'gobie léopard', DEFAULT, DEFAULT, DEFAULT, E'129', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Tinca sp.', E'Cuvier 1817', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Torpedo marmorata', E'Risso 1810', E'Torpille marbrée', E'19461', DEFAULT, E'TOE', E'612', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Torpedo torpedo', E'Linné, 1758', E'Torpille ocelée', E'25287', DEFAULT, DEFAULT, E'550', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trachinotus ovatus', E'Linnaeus, 1758', E'Liche glauque', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trachinus draco', E'Linnaeus, 1758', E'Grande vive', E'3498', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trachurus trachurus', E'Linnaeus, 1758', E'Chinchard d''Europe', E'3375', DEFAULT, E'HOM', E'700', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trigla', E'Linnaeus, 1758', E'Grondins nca', E'3562', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trigla lucerna', DEFAULT, E'Grondin perlon', DEFAULT, DEFAULT, E'GUP', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trigla lyra', E'Linnaeus, 1758', E'Grondin lyre', E'19455', DEFAULT, DEFAULT, E'600', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Triglidae', DEFAULT, E'Grondins, cavillones nca', E'3557', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Tripterygion delaisi', E'Cadenat & Blache, 1970', E'Triptérygion commun', E'19454', DEFAULT, DEFAULT, E'89', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trisopterus', E'Rafinesque, 1814', E'Tacaud nca', E'2161', DEFAULT, DEFAULT, E'430', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trisopterus esmarkii', E'Nilsson 1855', E'Tacaud norvégien', E'3404', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trisopterus luscus', E'Linnaeus, 1758', E'Tacaud commun', E'2162', E'TAD', E'BIB', E'460', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trisopterus minutus', E'Linnaeus, 1758', E'Capelan', E'3406', DEFAULT, DEFAULT, E'400', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbrina', E'Cuvier, 1816', E'Ombrine nca', E'19435', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbrina canariensis', E'Valenciennes 1843', E'Ombrine bronze', E'19456', DEFAULT, E'UMBB', E'800', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbrina cirrosa', E'Linnaeus, 1758', E'Ombrine côtière', E'19457', DEFAULT, E'UMBC', E'1000', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbrina sp.', DEFAULT, E'Ombrine sp.', DEFAULT, DEFAULT, E'UMB', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Upogebia pusilla', E'Petagna, 1792', E'Crevette fouisseuse', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Xantho incisus', E'Herbst, 1790', E'Crabe de pierre', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zebrus zebrus', E'Risso, 1827', E'Gobie zébré', E'19446', DEFAULT, DEFAULT, E'55', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zeugopterus punctatus', E'Bloch 1787', E'Targeur', E'3533', DEFAULT, DEFAULT, E'270', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zeus faber', E'Linnaeus, 1758', E'Saint Pierre', E'3577', DEFAULT, DEFAULT, E'590', DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zoarces viviparus', E'Linnaeus, 1758', E'Loquette d''Europe', E'3501', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO filo.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zosterisessor ophiocephalus', E'Pallas 1814', E'Gobie lotte', E'19462', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --

-- object: filo.operation | type: TABLE --
-- DROP TABLE IF EXISTS filo.operation CASCADE;
CREATE TABLE filo.operation (
	operation_id integer NOT NULL DEFAULT nextval('filo.operation_operation_id_seq'::regclass),
	campaign_id integer NOT NULL,
	operation_name varchar,
	date_start timestamp NOT NULL,
	date_end timestamp,
	freshwater boolean NOT NULL DEFAULT true,
	long_start double precision,
	lat_start double precision,
	long_end double precision,
	lat_end double precision,
	pk_source smallint,
	pk_mouth smallint,
	length float,
	side varchar,
	altitude float,
	tidal_coef float,
	debit float,
	surface float,
	station_id integer,
	protocol_id integer,
	water_regime_id integer,
	fishing_strategy_id integer,
	scale_id integer,
	taxa_template_id integer,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	operation_geom geometry(MULTIPOINT, 4326),
	operation_code varchar,
	CONSTRAINT operation_id_pk PRIMARY KEY (operation_id)

);
-- ddl-end --
COMMENT ON TABLE filo.operation IS E'Description of operation';
-- ddl-end --
COMMENT ON COLUMN filo.operation.operation_id IS E'Operations rattached at a campaign';
-- ddl-end --
COMMENT ON COLUMN filo.operation.operation_name IS E'Name of operation';
-- ddl-end --
COMMENT ON COLUMN filo.operation.date_start IS E'Start date of operation';
-- ddl-end --
COMMENT ON COLUMN filo.operation.date_end IS E'Date of end of operation';
-- ddl-end --
COMMENT ON COLUMN filo.operation.freshwater IS E'Is the operation in fresh water ?';
-- ddl-end --
COMMENT ON COLUMN filo.operation.long_start IS E'Longitude of the first point, in wgs84 (decimal)';
-- ddl-end --
COMMENT ON COLUMN filo.operation.lat_start IS E'Latitude of the first point, in WGS84 (decimal)';
-- ddl-end --
COMMENT ON COLUMN filo.operation.long_end IS E'Longitude of the last point, in WGS84 (decimal)';
-- ddl-end --
COMMENT ON COLUMN filo.operation.lat_end IS E'Latitude of the last point, in WGS84 (decimal)';
-- ddl-end --
COMMENT ON COLUMN filo.operation.pk_source IS E'Distance from the source, in meter';
-- ddl-end --
COMMENT ON COLUMN filo.operation.pk_mouth IS E'Distance from the mouth, in meter';
-- ddl-end --
COMMENT ON COLUMN filo.operation.length IS E'Length of the sampled zone, in meter';
-- ddl-end --
COMMENT ON COLUMN filo.operation.side IS E'Position in the river (left side, central, right side, etc.)';
-- ddl-end --
COMMENT ON COLUMN filo.operation.altitude IS E'Altitude, in meter';
-- ddl-end --
COMMENT ON COLUMN filo.operation.tidal_coef IS E'Tidal coefficient or water high of the tidal';
-- ddl-end --
COMMENT ON COLUMN filo.operation.debit IS E'Debit of the river, in m³/s';
-- ddl-end --
COMMENT ON COLUMN filo.operation.surface IS E'Surface parsed, in square meters';
-- ddl-end --
ALTER TABLE filo.operation OWNER TO filo;
-- ddl-end --

-- object: campaign_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation DROP CONSTRAINT IF EXISTS campaign_fk CASCADE;
ALTER TABLE filo.operation ADD CONSTRAINT campaign_fk FOREIGN KEY (campaign_id)
REFERENCES filo.campaign (campaign_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.sequence | type: TABLE --
-- DROP TABLE IF EXISTS filo.sequence CASCADE;
CREATE TABLE filo.sequence (
	sequence_id integer NOT NULL DEFAULT nextval('filo.place_place_id_seq'::regclass),
	operation_id integer NOT NULL,
	sequence_number smallint,
	date_start timestamp NOT NULL,
	date_end timestamp,
	fishing_duration float,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	sequence_name varchar,
	CONSTRAINT place_id_pk PRIMARY KEY (sequence_id)

);
-- ddl-end --
COMMENT ON TABLE filo.sequence IS E'Catching sequence';
-- ddl-end --
COMMENT ON COLUMN filo.sequence.sequence_number IS E'Number of sequence in the operation';
-- ddl-end --
COMMENT ON COLUMN filo.sequence.date_start IS E'Start time of fishing at this place';
-- ddl-end --
COMMENT ON COLUMN filo.sequence.date_end IS E'End time of fishing at this place';
-- ddl-end --
COMMENT ON COLUMN filo.sequence.fishing_duration IS E'Fishing duration, in mn';
-- ddl-end --
COMMENT ON COLUMN filo.sequence.sequence_name IS E'Name of the sequence';
-- ddl-end --
ALTER TABLE filo.sequence OWNER TO filo;
-- ddl-end --

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sequence DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE filo.sequence ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES filo.operation (operation_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.sample | type: TABLE --
-- DROP TABLE IF EXISTS filo.sample CASCADE;
CREATE TABLE filo.sample (
	sample_id integer NOT NULL DEFAULT nextval('filo.sample_sample_id_seq'::regclass),
	sequence_id integer NOT NULL,
	taxon_name varchar NOT NULL,
	total_number smallint NOT NULL DEFAULT 1,
	total_measured smallint,
	total_weight double precision,
	sample_size_min float,
	sample_size_max float,
	sample_comment varchar,
	taxon_id integer,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	sample_code varchar,
	CONSTRAINT sample_id_pk PRIMARY KEY (sample_id)

);
-- ddl-end --
COMMENT ON TABLE filo.sample IS E'List of samplings. One or many for a taxon';
-- ddl-end --
COMMENT ON COLUMN filo.sample.taxon_name IS E'Name of the taxon, issued from the table of taxa or created if a new taxon discovered';
-- ddl-end --
COMMENT ON COLUMN filo.sample.total_number IS E'Total number of catched elements\n0 : presence of the taxon, but number not estimated';
-- ddl-end --
COMMENT ON COLUMN filo.sample.total_measured IS E'Number of elements measured';
-- ddl-end --
COMMENT ON COLUMN filo.sample.total_weight IS E'Total weight, in g';
-- ddl-end --
COMMENT ON COLUMN filo.sample.sample_size_min IS E'Minimal size of fishes in this sample, in mm';
-- ddl-end --
COMMENT ON COLUMN filo.sample.sample_size_max IS E'Maximal size of fishes in this sample, in mm';
-- ddl-end --
ALTER TABLE filo.sample OWNER TO filo;
-- ddl-end --

-- object: sequence_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sample DROP CONSTRAINT IF EXISTS sequence_fk CASCADE;
ALTER TABLE filo.sample ADD CONSTRAINT sequence_fk FOREIGN KEY (sequence_id)
REFERENCES filo.sequence (sequence_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: taxon_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sample DROP CONSTRAINT IF EXISTS taxon_fk CASCADE;
ALTER TABLE filo.sample ADD CONSTRAINT taxon_fk FOREIGN KEY (taxon_id)
REFERENCES filo.taxon (taxon_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.item_item_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.item_item_id_seq CASCADE;
CREATE SEQUENCE filo.item_item_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.item_item_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.individual | type: TABLE --
-- DROP TABLE IF EXISTS filo.individual CASCADE;
CREATE TABLE filo.individual (
	individual_id integer NOT NULL DEFAULT nextval('filo.item_item_id_seq'::regclass),
	sample_id integer,
	sexe_id integer,
	pathology_id integer,
	other_measure json,
	sl float,
	fl float,
	tl float,
	wd float,
	ot float,
	weight float,
	individual_comment varchar,
	age smallint,
	measure_estimated boolean NOT NULL DEFAULT 'f',
	pathology_codes varchar,
	tag varchar,
	tag_posed varchar,
	transmitter varchar,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	individual_code varchar,
	spaghetti_brand varchar,
	catching_time time,
	release_time time,
	anesthesia_duration time,
	marking_duration smallint,
	anesthesia_product varchar,
	product_concentration varchar,
	CONSTRAINT individual_id_pk PRIMARY KEY (individual_id)

);
-- ddl-end --
COMMENT ON TABLE filo.individual IS E'List of individuals measured';
-- ddl-end --
COMMENT ON COLUMN filo.individual.other_measure IS E'List of others measures realized on an item';
-- ddl-end --
COMMENT ON COLUMN filo.individual.sl IS E'Standard length, in mm';
-- ddl-end --
COMMENT ON COLUMN filo.individual.fl IS E'Fork length, in mm';
-- ddl-end --
COMMENT ON COLUMN filo.individual.tl IS E'Total length, in mm';
-- ddl-end --
COMMENT ON COLUMN filo.individual.wd IS E'Width of disk, in mm';
-- ddl-end --
COMMENT ON COLUMN filo.individual.ot IS E'Other length, in mm';
-- ddl-end --
COMMENT ON COLUMN filo.individual.weight IS E'Weight, in g';
-- ddl-end --
COMMENT ON COLUMN filo.individual.age IS E'Age of fish, in year';
-- ddl-end --
COMMENT ON COLUMN filo.individual.measure_estimated IS E'Is the measure estimated ?';
-- ddl-end --
COMMENT ON COLUMN filo.individual.pathology_codes IS E'List of codes of pathologies or remarks';
-- ddl-end --
COMMENT ON COLUMN filo.individual.tag IS E'RFID tag';
-- ddl-end --
COMMENT ON COLUMN filo.individual.tag_posed IS E'RFID tag posed on the fish';
-- ddl-end --
COMMENT ON COLUMN filo.individual.transmitter IS E'Acoustic or radio transmitter identifier';
-- ddl-end --
COMMENT ON COLUMN filo.individual.spaghetti_brand IS E'Number or others informations on the spaghetti brand';
-- ddl-end --
COMMENT ON COLUMN filo.individual.catching_time IS E'Time of catching';
-- ddl-end --
COMMENT ON COLUMN filo.individual.release_time IS E'Time of release';
-- ddl-end --
COMMENT ON COLUMN filo.individual.anesthesia_duration IS E'Duration of anesthesia';
-- ddl-end --
COMMENT ON COLUMN filo.individual.marking_duration IS E'Duration of marking, in seconds';
-- ddl-end --
COMMENT ON COLUMN filo.individual.anesthesia_product IS E'Product used for the anesthesia';
-- ddl-end --
COMMENT ON COLUMN filo.individual.product_concentration IS E'Concentration of the product used for anesthesia';
-- ddl-end --
ALTER TABLE filo.individual OWNER TO filo;
-- ddl-end --

-- object: sample_fk | type: CONSTRAINT --
-- ALTER TABLE filo.individual DROP CONSTRAINT IF EXISTS sample_fk CASCADE;
ALTER TABLE filo.individual ADD CONSTRAINT sample_fk FOREIGN KEY (sample_id)
REFERENCES filo.sample (sample_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.measure_template_measure_template_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.measure_template_measure_template_id_seq CASCADE;
CREATE SEQUENCE filo.measure_template_measure_template_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.measure_template_measure_template_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.measure_template | type: TABLE --
-- DROP TABLE IF EXISTS filo.measure_template CASCADE;
CREATE TABLE filo.measure_template (
	measure_template_id integer NOT NULL DEFAULT nextval('filo.measure_template_measure_template_id_seq'::regclass),
	measure_template_name varchar NOT NULL,
	measure_template_schema json,
	taxon_id integer NOT NULL,
	CONSTRAINT measure_template_pk PRIMARY KEY (measure_template_id)

);
-- ddl-end --
COMMENT ON COLUMN filo.measure_template.measure_template_schema IS E'List of all measures usable by a taxon.\nFor each type : name, extended.\nBy default : total_length and weight';
-- ddl-end --
ALTER TABLE filo.measure_template OWNER TO filo;
-- ddl-end --

-- object: filo.operation_template_operation_template_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.operation_template_operation_template_id_seq CASCADE;
CREATE SEQUENCE filo.operation_template_operation_template_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.operation_template_operation_template_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.item_generated_item_generated_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.item_generated_item_generated_id_seq CASCADE;
CREATE SEQUENCE filo.item_generated_item_generated_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.item_generated_item_generated_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.gear_gear_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.gear_gear_id_seq CASCADE;
CREATE SEQUENCE filo.gear_gear_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.gear_gear_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.sequence_gear_sequence_gear_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.sequence_gear_sequence_gear_id_seq CASCADE;
CREATE SEQUENCE filo.sequence_gear_sequence_gear_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.sequence_gear_sequence_gear_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.gear | type: TABLE --
-- DROP TABLE IF EXISTS filo.gear CASCADE;
CREATE TABLE filo.gear (
	gear_id integer NOT NULL DEFAULT nextval('filo.gear_gear_id_seq'::regclass),
	gear_name varchar NOT NULL,
	gear_length float,
	gear_height float,
	mesh_size varchar,
	CONSTRAINT fishing_gear_pk PRIMARY KEY (gear_id)

);
-- ddl-end --
COMMENT ON TABLE filo.gear IS E'Gear used for fishery';
-- ddl-end --
COMMENT ON COLUMN filo.gear.gear_length IS E'Length of the net or other gear, in metter';
-- ddl-end --
COMMENT ON COLUMN filo.gear.gear_height IS E'Height of the net or other gear, in metter';
-- ddl-end --
COMMENT ON COLUMN filo.gear.mesh_size IS E'Size of the mesh, in textual form';
-- ddl-end --
ALTER TABLE filo.gear OWNER TO filo;
-- ddl-end --

-- object: filo.sequence_gear | type: TABLE --
-- DROP TABLE IF EXISTS filo.sequence_gear CASCADE;
CREATE TABLE filo.sequence_gear (
	sequence_gear_id integer NOT NULL DEFAULT nextval('filo.sequence_gear_sequence_gear_id_seq'::regclass),
	voltage float,
	amperage float,
	gear_nb smallint NOT NULL DEFAULT 1,
	depth float,
	sequence_id integer NOT NULL,
	gear_id integer NOT NULL,
	gear_method_id integer,
	electric_current_type_id smallint,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	business_code varchar,
	CONSTRAINT sequence_gear_pk PRIMARY KEY (sequence_gear_id)

);
-- ddl-end --
COMMENT ON TABLE filo.sequence_gear IS E'List of gear used during operation';
-- ddl-end --
COMMENT ON COLUMN filo.sequence_gear.voltage IS E'Voltage used during electric fishing, in volt';
-- ddl-end --
COMMENT ON COLUMN filo.sequence_gear.amperage IS E'Amperage used during electric fishing, in ampere';
-- ddl-end --
COMMENT ON COLUMN filo.sequence_gear.gear_nb IS E'Nb of gears';
-- ddl-end --
COMMENT ON COLUMN filo.sequence_gear.depth IS E'Depth of the gear';
-- ddl-end --
COMMENT ON COLUMN filo.sequence_gear.business_code IS E'Business code of the gear, especially for traps';
-- ddl-end --
ALTER TABLE filo.sequence_gear OWNER TO filo;
-- ddl-end --

-- object: filo.engine_engine_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.engine_engine_id_seq CASCADE;
CREATE SEQUENCE filo.engine_engine_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.engine_engine_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.river_river_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.river_river_id_seq CASCADE;
CREATE SEQUENCE filo.river_river_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.river_river_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.river | type: TABLE --
-- DROP TABLE IF EXISTS filo.river CASCADE;
CREATE TABLE filo.river (
	river_id integer NOT NULL DEFAULT nextval('filo.river_river_id_seq'::regclass),
	river_name varchar NOT NULL,
	river_code varchar,
	CONSTRAINT river_pk PRIMARY KEY (river_id)

);
-- ddl-end --
COMMENT ON TABLE filo.river IS E'River, estuary, sea...';
-- ddl-end --
ALTER TABLE filo.river OWNER TO filo;
-- ddl-end --

-- object: river_fk | type: CONSTRAINT --
-- ALTER TABLE filo.station DROP CONSTRAINT IF EXISTS river_fk CASCADE;
ALTER TABLE filo.station ADD CONSTRAINT river_fk FOREIGN KEY (river_id)
REFERENCES filo.river (river_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: sequence_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sequence_gear DROP CONSTRAINT IF EXISTS sequence_fk CASCADE;
ALTER TABLE filo.sequence_gear ADD CONSTRAINT sequence_fk FOREIGN KEY (sequence_id)
REFERENCES filo.sequence (sequence_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: gear_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sequence_gear DROP CONSTRAINT IF EXISTS gear_fk CASCADE;
ALTER TABLE filo.sequence_gear ADD CONSTRAINT gear_fk FOREIGN KEY (gear_id)
REFERENCES filo.gear (gear_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.analysis_analysis_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.analysis_analysis_id_seq CASCADE;
CREATE SEQUENCE filo.analysis_analysis_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.analysis_analysis_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.analysis | type: TABLE --
-- DROP TABLE IF EXISTS filo.analysis CASCADE;
CREATE TABLE filo.analysis (
	analysis_id integer NOT NULL DEFAULT nextval('filo.analysis_analysis_id_seq'::regclass),
	sequence_id integer NOT NULL,
	analysis_date timestamp NOT NULL,
	ph float,
	temperature float,
	o2_pc float,
	o2_mg float,
	salinity float,
	conductivity float,
	secchi float,
	other_analysis json,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	CONSTRAINT analysis_pk PRIMARY KEY (analysis_id)

);
-- ddl-end --
COMMENT ON TABLE filo.analysis IS E'Water analysis';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.analysis_date IS E'Date/time of the sampling';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.ph IS E'pH';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.temperature IS E'Temperature, in °C';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.o2_pc IS E'Percentage of oxygen saturation';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.o2_mg IS E'Oxygen level, in mg/l';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.salinity IS E'Salinity';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.conductivity IS E'Conductivity, in µS/cm';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.secchi IS E'Secchi depth, in meter';
-- ddl-end --
COMMENT ON COLUMN filo.analysis.other_analysis IS E'Others analysis performed (cf. analysis_template)';
-- ddl-end --
ALTER TABLE filo.analysis OWNER TO filo;
-- ddl-end --

-- object: sequence_fk | type: CONSTRAINT --
-- ALTER TABLE filo.analysis DROP CONSTRAINT IF EXISTS sequence_fk CASCADE;
ALTER TABLE filo.analysis ADD CONSTRAINT sequence_fk FOREIGN KEY (sequence_id)
REFERENCES filo.sequence (sequence_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.sexe | type: TABLE --
-- DROP TABLE IF EXISTS filo.sexe CASCADE;
CREATE TABLE filo.sexe (
	sexe_id integer NOT NULL,
	sexe_name varchar NOT NULL,
	sexe_code varchar NOT NULL,
	CONSTRAINT sexe_pk PRIMARY KEY (sexe_id)

);
-- ddl-end --
COMMENT ON TABLE filo.sexe IS E'Sexe of fishs';
-- ddl-end --
COMMENT ON COLUMN filo.sexe.sexe_code IS E'Code of the sexe, according to the nomenclature sandre.eaufrance.fr 437';
-- ddl-end --
ALTER TABLE filo.sexe OWNER TO filo;
-- ddl-end --

INSERT INTO filo.sexe (sexe_id, sexe_name, sexe_code) VALUES (E'1', E'Femelle', E'F');
-- ddl-end --
INSERT INTO filo.sexe (sexe_id, sexe_name, sexe_code) VALUES (E'2', E'Mâle', E'M');
-- ddl-end --
INSERT INTO filo.sexe (sexe_id, sexe_name, sexe_code) VALUES (E'3', E'Inconnu', E'N');
-- ddl-end --
INSERT INTO filo.sexe (sexe_id, sexe_name, sexe_code) VALUES (E'4', E'Non identifié', E'R');
-- ddl-end --

-- object: sexe_fk | type: CONSTRAINT --
-- ALTER TABLE filo.individual DROP CONSTRAINT IF EXISTS sexe_fk CASCADE;
ALTER TABLE filo.individual ADD CONSTRAINT sexe_fk FOREIGN KEY (sexe_id)
REFERENCES filo.sexe (sexe_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.pathology_pathology_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.pathology_pathology_id_seq CASCADE;
CREATE SEQUENCE filo.pathology_pathology_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.pathology_pathology_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.pathology | type: TABLE --
-- DROP TABLE IF EXISTS filo.pathology CASCADE;
CREATE TABLE filo.pathology (
	pathology_id integer NOT NULL DEFAULT nextval('filo.pathology_pathology_id_seq'::regclass),
	pathology_name varchar NOT NULL,
	pathology_code varchar,
	pathology_description varchar,
	CONSTRAINT pathology_pk PRIMARY KEY (pathology_id)

);
-- ddl-end --
COMMENT ON TABLE filo.pathology IS E'List of pathologies';
-- ddl-end --
COMMENT ON COLUMN filo.pathology.pathology_name IS E'Name of the pathology';
-- ddl-end --
COMMENT ON COLUMN filo.pathology.pathology_code IS E'Code of the pathology, according to the nomenclature sandre.eaufrance.fr 129';
-- ddl-end --
COMMENT ON COLUMN filo.pathology.pathology_description IS E'Description of the pathology';
-- ddl-end --
ALTER TABLE filo.pathology OWNER TO filo;
-- ddl-end --

INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'1', E'00', E'Ni poux, ni traces de poux', E'Le poisson, généralement un salmonidé migrateur venu de la mer, n''héberge aucun pou de mer et ne présente aucune lésion visible consécutive à une colonisation par le pou de mer (qui est en fait un crustacé parasite des salmonidés migrateurs)');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'2', E'AA', E'Altération de l''aspect', E'Le corps du poisson examiné présente des altérations morphologiques caractérisées, pouvant éventuellement être détaillées ou non.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'3', E'AC', E'Altération de la couleur', E'La pigmentation présente des altérations entrainant une coloration anormale de tout ou partie du corps du poisson.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'4', E'AD', E'Difforme', E'Le corps du poisson présente des déformations anormales se traduisant par des acures ou des bosselures,extériorisation possible d''une atteinte interne, virale par exemple (ex : nécrose pancréatique infectieuse de la truite arc-en-ciel)');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'5', E'AG', E'Grosseur, excroissance', E'Le corps du poisson présente une ou des déformations marquées constituant des excroissances ou des tumeurs');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'6', E'AH', E'Aspect hérissé (écailles)', E'Les écailles du poisson ont tendance à se relever perpendiculairement au corps, à la suite généralement d''une infection au niveau des téguments');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'7', E'AM', E'Maigreur', E'Le corps du poisson présente une minceur marquée par rapport à la normalité');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'8', E'AO', E'Absence d''organe', E'L''altération morphologique observée sur le poisson se traduit par l''absence d''un organe (nageoire, opercule, oeil, machoire)');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'9', E'BG', E'Bulle de gaz', E'Présence de bulle de gaz pouvant être observées sous la peau, au bord des nageoires, au niveau des yeux, des branchies ou de la bouche.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'10', E'CA', E'Coloration anormale', E'L''altération de la pigmentation entraîne la différenciation de zones diversement colorées, avec en particulier des zones sombres.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'11', E'CB', E'Branchiures (Argulus...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de crustacés branchiures à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'12', E'CC', E'Copépodes (Ergasilus, Lerna,...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de crustacés parasites, à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'13', E'CO', E'Coloration opaque (oeil)', E'L''altération de la coloration se traduit par une opacification de l''un ou des deux yeux.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'14', E'CR', E'Présence de crustacés', E'Présence visible, à la surface du corps ou des branchies du poisson, de crustacés parasites, à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'15', E'CS', E'Coloration sombre', E'L''altération de la coloration du corps du poisson se traduit par un assombrissement de tout ou partie de celui-ci (noircissement).');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'16', E'CT', E'Coloration terne (pâle)', E'L''altération de la coloration du corps du poisson se traduit par une absence de reflets lui conférant un aspect terne, pâle, voire une décoloration.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'17', E'ER', E'Erosion', DEFAULT);
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'18', E'EX', E'Exophtalmie ou proptose', DEFAULT);
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'19', E'HA', E'Acanthocéphales', E'Présence visible, à la surface du corps ou des branchies du poisson, d''acanthocéphales à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'20', E'HC', E'Cestodes (Ligula,  Bothriocephalus, ...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de cestodes à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'21', E'HE', E'Hémorragie', E'Ecoulement de sang pouvant être observ?? à la surface du corps ou au niveau des branchies.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'22', E'HH', E'Hirudinés (Piscicola)', E'Présence visible sur le poisson de sangsue(s)');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'23', E'HN', E'Nématodes (Philometra, Philimena...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de  nématodes à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'24', E'HS', E'Stade pre-mortem', E'Le poisson présente un état pathologique tel qu''il n''est plus capable de se mouvoir normalement dans son milieu et qu''il est voué à une mort certaine à brève échéance.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'25', E'HT', E'Trématodes (Bucephalus, ...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de trématodes parasites à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'26', E'IS', E'Individu sain', E'Après examen du poisson, aucun signe externe, caractéristique d''une pathologie quelconque, n''est décelable à l''oeil nu');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'27', E'LD', E'Lésions diverses', E'Les téguments présentent une altération quelconque de leur intégrité.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'28', E'NE', E'Nécrose', E'Lésion(s) observée(s) à la surface du corps avec mortification des tissus.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'29', E'NN', E'Pathologie non renseigné', E'L''aspect pathologique du poisson n''a fait l''objet d''aucun examen et aucune information n''est fournie à ce sujet');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'30', E'OO', E'Absence de lésions ou de parasites', DEFAULT);
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'31', E'PA', E'Parasitisme', E'Présence visible, à la surface du corps ou des branchies du poisson, d''organismes parasites vivant à ses dépens.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'32', E'PB', E'Points blancs', E'Présence de points blancs consécutive à la prolifération de certains protozoaires parasites comme Ichtyopthtirius (ne pas confondre avec les boutons de noces, formations kératinisées apparaissant  lors de la période de reproduction)');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'33', E'PC', E'Champignons (mousse, ...)', E'Présence d''un développement à la surface du corps, d''un mycélium formant une sorte de plaque rappelant l''aspect de la mousse et appartenant à une espèce de champignon colonisant les tissus du poisson.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'34', E'PL', E'Plaie - blessure', E'Présence d''une ou plusieurs lésions à la surface du tégument généralement due à un prédateur (poisson, oiseau,.)');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'35', E'PN', E'Points noirs', E'Présence de tâches noires bien individualisées sur la surface du tégument du poisson');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'36', E'PT', E'Parasites (PB ou PC ou CR ou HH ou PX)', DEFAULT);
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'37', E'PX', E'Autres parasites (autre que CR, HH, PB, PC)', DEFAULT);
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'38', E'SM', E'Sécrétion de mucus importante', E'Présence anormale de mucus sur le corps ou au niveau de la chambre branchiale.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'39', E'UH', E'Ulcère hémorragique', E'Ecoulement de sang observé au niveau d''une zone d''altération des tissus.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'40', E'US', E'Anus rouge ou saillant', DEFAULT);
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'41', E'VL', E'Vésicule contenant un liquide', E'Présence d''un oedème constituant une excroissance.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'42', E'ZO', E'Etat pathologie multiforme', E'Le poisson présente plus de deux caractéristiques pathologiques différentes');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'43', E'01', E'Traces de poux', E'Le poisson ne porte aucun pou mais présente des lésions cutanées consécutives à une colonisation par le pou de mer. La présence du poisson en eau douce a été suffisante pour obliger les poux à quitter leur hôte.');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'44', E'11', E'<10 poux , sans flagelles', E'Le poisson présente moins de 10 poux de mer, mais ces derniers, en raison d''un présence prolongée en eau douce, ont déjà perdu leur flagelle');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'45', E'21', E'<10 poux , avec flagelles', E'Le poisson présente moins de 10 poux de mer, mais ces derniers, compte-tenu de l''arrivée récente de leur hôte en eau douce, n''ont pas encore perdu leur flagelle');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'46', E'31', E'>10 poux, sans flagelles', E'Le poisson présente plus de 10 poux de mer, mais ces derniers, en raison d''un présence prolongée en eau douce, ont déjà perdu leur flagelle');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'47', E'42', E'>10 poux, avec flagelles', E'Le poisson présente plus de 10 poux de mer, mais ces derniers, compte-tenu de l''arrivée récente de leur hôte en eau douce, n''ont pas encore perdu leur flagelle');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'48', E'NC', E'Signe pathologique d''origine inconnue', E'Signe pathologique d''origine inconnue');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'49', E'AP', E'Aphanomycose ou peste de l’écrevisse', DEFAULT);
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'50', E'TH', E'Thélohaniose ou maladie de porcelaine', DEFAULT);
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'51', E'BR', E'Branchiobdellidae (Branchiobdella, Xironogiton, ...)', E'Présence de Branchiobdellidae (Branchiobdella, Xironogiton, ...)');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'52', E'CH', E'Chytridiomycose', E'maladie mortelle menaçant les amphibiens, cette maladie fongique est provoqué par champignon Batrachochytrium dendrobatidis, plus connu sous l’appellation de chytride');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'53', E'RO', E'Rouille', E'provoquée par un champignons parasites, elle se caractérisent par la présence de taches brun rouge ou noires entourées de rouge sur la carapace');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'54', E'MY', E'Mycose des oeufs', E'Les mycoses des oeufs: provoquent la mort et un changement de coloration de ceux-ci (deviennent orangés)');
-- ddl-end --
INSERT INTO filo.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'55', E'PF', E'Paragnathia formica', E'Paragnathia formica est un parasite qui est présent sur les saumons sauvages');
-- ddl-end --

-- object: pathology_fk | type: CONSTRAINT --
-- ALTER TABLE filo.individual DROP CONSTRAINT IF EXISTS pathology_fk CASCADE;
ALTER TABLE filo.individual ADD CONSTRAINT pathology_fk FOREIGN KEY (pathology_id)
REFERENCES filo.pathology (pathology_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: station_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation DROP CONSTRAINT IF EXISTS station_fk CASCADE;
ALTER TABLE filo.operation ADD CONSTRAINT station_fk FOREIGN KEY (station_id)
REFERENCES filo.station (station_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.facies_facies_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.facies_facies_id_seq CASCADE;
CREATE SEQUENCE filo.facies_facies_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 11
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.facies_facies_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.ambience_ambience_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.ambience_ambience_id_seq CASCADE;
CREATE SEQUENCE filo.ambience_ambience_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.ambience_ambience_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.situation_situation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.situation_situation_id_seq CASCADE;
CREATE SEQUENCE filo.situation_situation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 11
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.situation_situation_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.facies | type: TABLE --
-- DROP TABLE IF EXISTS filo.facies CASCADE;
CREATE TABLE filo.facies (
	facies_id integer NOT NULL DEFAULT nextval('filo.facies_facies_id_seq'::regclass),
	facies_name varchar NOT NULL,
	facies_code varchar,
	CONSTRAINT facies_pk PRIMARY KEY (facies_id)

);
-- ddl-end --
COMMENT ON TABLE filo.facies IS E'List of facies';
-- ddl-end --
ALTER TABLE filo.facies OWNER TO filo;
-- ddl-end --

INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'1', E'Rapide', E'10');
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'2', E'Radier', E'9');
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'3', E'Plat courant', E'8');
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'4', E'Plat lent', E'6');
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'5', E'Mouille ou profond', E'7');
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'6', E'Chenal lotique (profond courant)', E'1');
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'7', E'Chenal lentique (profond lent)', E'2');
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'8', E'Remous ou contre-courant', DEFAULT);
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'9', E'Bras mort ou lône', E'4');
-- ddl-end --
INSERT INTO filo.facies (facies_id, facies_name, facies_code) VALUES (E'10', E'Darse', E'26');
-- ddl-end --

-- object: filo.ambience | type: TABLE --
-- DROP TABLE IF EXISTS filo.ambience CASCADE;
CREATE TABLE filo.ambience (
	ambience_id integer NOT NULL DEFAULT nextval('filo.ambience_ambience_id_seq'::regclass),
	operation_id integer,
	ambience_name varchar,
	ambience_length float,
	ambience_width float,
	ambience_comment varchar,
	ambience_long double precision,
	ambience_lat double precision,
	current_speed float,
	current_speed_max float,
	current_speed_min float,
	water_height smallint,
	water_height_max smallint,
	water_height_min smallint,
	facies_id integer,
	situation_id integer,
	speed_id integer,
	shady_id integer,
	localisation_id integer,
	vegetation_id integer,
	dominant_granulometry_id integer,
	secondary_granulometry_id integer,
	herbarium_cache_abundance_id integer,
	branch_cache_abundance_id integer,
	vegetation_cache_abundance_id integer,
	subbank_cache_abundance_id integer,
	granulometry_cache_abundance_id integer,
	clogging_id integer,
	sinuosity_id integer,
	flow_trend_id integer,
	turbidity_id integer,
	sequence_id integer,
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	ambience_geom geometry(POINT, 4326),
	other_measures json,
	CONSTRAINT ambience_pk PRIMARY KEY (ambience_id)

);
-- ddl-end --
COMMENT ON TABLE filo.ambience IS E'Description of the ambiences of the operation';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.ambience_name IS E'Name of the point';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.ambience_length IS E'Length of the point, in meter';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.ambience_width IS E'Width of the point, in meter';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.ambience_long IS E'Longitude of the point of observation, in decimal WGS84';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.ambience_lat IS E'Latitude of the point of observation, in decimal WGS84';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.current_speed IS E'Speed measured of the current, in cm/s';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.current_speed_max IS E'Maximum value of the current, in cm/s';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.current_speed_min IS E'Minimum speed of the current, in cm/s';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.water_height IS E'Average height of water, in cm';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.water_height_max IS E'Max height of water, in cm';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.water_height_min IS E'Min of height of water, in cm';
-- ddl-end --
COMMENT ON COLUMN filo.ambience.other_measures IS E'Other measures attached to an ambience';
-- ddl-end --
ALTER TABLE filo.ambience OWNER TO filo;
-- ddl-end --

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES filo.operation (operation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.situation | type: TABLE --
-- DROP TABLE IF EXISTS filo.situation CASCADE;
CREATE TABLE filo.situation (
	situation_id integer NOT NULL DEFAULT nextval('filo.situation_situation_id_seq'::regclass),
	situation_name varchar NOT NULL,
	situation_code varchar,
	CONSTRAINT situation_pk PRIMARY KEY (situation_id)

);
-- ddl-end --
COMMENT ON TABLE filo.situation IS E'List of situations';
-- ddl-end --
ALTER TABLE filo.situation OWNER TO filo;
-- ddl-end --

INSERT INTO filo.situation (situation_id, situation_name) VALUES (E'3', E'Confluence ruisseau');
-- ddl-end --
INSERT INTO filo.situation (situation_id, situation_name) VALUES (E'4', E'Palplanche');
-- ddl-end --
INSERT INTO filo.situation (situation_id, situation_name) VALUES (E'5', E'Exutoire d''étang');
-- ddl-end --
INSERT INTO filo.situation (situation_id, situation_name) VALUES (E'6', E'Maçonnerie');
-- ddl-end --
INSERT INTO filo.situation (situation_id, situation_name) VALUES (E'7', E'Aval d''ouvrage');
-- ddl-end --
INSERT INTO filo.situation (situation_id, situation_name) VALUES (E'8', E'Enrochement');
-- ddl-end --
INSERT INTO filo.situation (situation_id, situation_name) VALUES (E'9', E'Rejet');
-- ddl-end --
INSERT INTO filo.situation (situation_id, situation_name) VALUES (E'10', E'Aval turbine/gabion');
-- ddl-end --

-- object: filo.localisation_localisation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.localisation_localisation_id_seq CASCADE;
CREATE SEQUENCE filo.localisation_localisation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 3
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.localisation_localisation_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.localisation | type: TABLE --
-- DROP TABLE IF EXISTS filo.localisation CASCADE;
CREATE TABLE filo.localisation (
	localisation_id integer NOT NULL DEFAULT nextval('filo.localisation_localisation_id_seq'::regclass),
	localisation_name varchar NOT NULL,
	localisation_code varchar,
	CONSTRAINT localisation_pk PRIMARY KEY (localisation_id)

);
-- ddl-end --
COMMENT ON TABLE filo.localisation IS E'List of localisations of the ambience';
-- ddl-end --
ALTER TABLE filo.localisation OWNER TO filo;
-- ddl-end --

INSERT INTO filo.localisation (localisation_id, localisation_name) VALUES (E'1', E'Chenal');
-- ddl-end --
INSERT INTO filo.localisation (localisation_id, localisation_name) VALUES (E'2', E'Berge');
-- ddl-end --

-- object: filo.speed | type: TABLE --
-- DROP TABLE IF EXISTS filo.speed CASCADE;
CREATE TABLE filo.speed (
	speed_id integer NOT NULL,
	speed_name varchar NOT NULL,
	speed_code varchar,
	CONSTRAINT speed_pk PRIMARY KEY (speed_id)

);
-- ddl-end --
COMMENT ON TABLE filo.speed IS E'Speed of current, in cm/s';
-- ddl-end --
ALTER TABLE filo.speed OWNER TO filo;
-- ddl-end --

INSERT INTO filo.speed (speed_id, speed_name) VALUES (E'1', E'< 10 cm/s');
-- ddl-end --
INSERT INTO filo.speed (speed_id, speed_name) VALUES (E'2', E'11 à 40 cm/s');
-- ddl-end --
INSERT INTO filo.speed (speed_id, speed_name) VALUES (E'3', E'41 à 80 cm/s');
-- ddl-end --
INSERT INTO filo.speed (speed_id, speed_name) VALUES (E'4', E'81 à 150 cm/s');
-- ddl-end --
INSERT INTO filo.speed (speed_id, speed_name) VALUES (E'5', E'> 151 cm/s');
-- ddl-end --

-- object: filo.shady | type: TABLE --
-- DROP TABLE IF EXISTS filo.shady CASCADE;
CREATE TABLE filo.shady (
	shady_id integer NOT NULL,
	shady_name varchar NOT NULL,
	shady_code varchar,
	CONSTRAINT shady_pk PRIMARY KEY (shady_id)

);
-- ddl-end --
COMMENT ON TABLE filo.shady IS E'List of shaddies used for ambiences';
-- ddl-end --
ALTER TABLE filo.shady OWNER TO filo;
-- ddl-end --

INSERT INTO filo.shady (shady_id, shady_name) VALUES (E'1', E'Rivière couverte (>90% d''ombrage)');
-- ddl-end --
INSERT INTO filo.shady (shady_id, shady_name) VALUES (E'2', E'Rivière assez couverte (50 à 90% d''ombrage)');
-- ddl-end --
INSERT INTO filo.shady (shady_id, shady_name) VALUES (E'3', E'Rivière assez dégagée (10 à 50 % d''ombrage)');
-- ddl-end --
INSERT INTO filo.shady (shady_id, shady_name) VALUES (E'4', E'Rivière dégagée (< 10 % d''ombrage)');
-- ddl-end --

-- object: filo.granulometry_granulometry_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.granulometry_granulometry_id_seq CASCADE;
CREATE SEQUENCE filo.granulometry_granulometry_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 13
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.granulometry_granulometry_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.granulometry | type: TABLE --
-- DROP TABLE IF EXISTS filo.granulometry CASCADE;
CREATE TABLE filo.granulometry (
	granulometry_id integer NOT NULL DEFAULT nextval('filo.granulometry_granulometry_id_seq'::regclass),
	granulometry_name varchar NOT NULL,
	granulometry_code varchar,
	CONSTRAINT granulometry_pk PRIMARY KEY (granulometry_id)

);
-- ddl-end --
COMMENT ON TABLE filo.granulometry IS E'List of types of granulometry';
-- ddl-end --
ALTER TABLE filo.granulometry OWNER TO filo;
-- ddl-end --

INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'1', E'Argile (<3,9 µm)', E'A');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'2', E'Limons (de 3,9 à 62,5 µm)', E'L');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'3', E'Sables fins (de 62,5 à 0,5 µm)', E'SF');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'4', E'Sables grossiers (de 0,5 µm à 2 mm)', E'SG');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'5', E'Graviers (de 2 à 16 mm)', E'G');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'6', E'Cailloux fins (de 16 à 32 mm)', E'CF');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'7', E'Cailloux grossiers (de 32 à 64 mm)', E'CG');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'8', E'Pierres fines (de 64 à 128 mm)', E'PF');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'9', E'Pierres grossières (de 128 à 256 mm)', E'PG');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'10', E'Blocs (de 256 à 1024 mm)', E'B');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'11', E'Rochers (substra immergé avec protubérance)', E'R');
-- ddl-end --
INSERT INTO filo.granulometry (granulometry_id, granulometry_name, granulometry_code) VALUES (E'12', E'Dalle (substrat immergé sans protubérance)', E'D');
-- ddl-end --

-- object: filo.vegetation_vegetation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.vegetation_vegetation_id_seq CASCADE;
CREATE SEQUENCE filo.vegetation_vegetation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 9
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.vegetation_vegetation_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.vegetation | type: TABLE --
-- DROP TABLE IF EXISTS filo.vegetation CASCADE;
CREATE TABLE filo.vegetation (
	vegetation_id integer NOT NULL DEFAULT nextval('filo.vegetation_vegetation_id_seq'::regclass),
	vegetation_name varchar NOT NULL,
	vegetation_code varchar,
	CONSTRAINT vegetation_pk PRIMARY KEY (vegetation_id)

);
-- ddl-end --
COMMENT ON TABLE filo.vegetation IS E'List of types of vegetation';
-- ddl-end --
ALTER TABLE filo.vegetation OWNER TO filo;
-- ddl-end --

INSERT INTO filo.vegetation (vegetation_id, vegetation_name) VALUES (E'1', E'Algues - microphytes');
-- ddl-end --
INSERT INTO filo.vegetation (vegetation_id, vegetation_name) VALUES (E'2', E'Plantes immergées à petites feuilles');
-- ddl-end --
INSERT INTO filo.vegetation (vegetation_id, vegetation_name) VALUES (E'3', E'Plantes immergées à grandes feuilles');
-- ddl-end --
INSERT INTO filo.vegetation (vegetation_id, vegetation_name) VALUES (E'4', E'Plante immergées à feuilles rubanées');
-- ddl-end --
INSERT INTO filo.vegetation (vegetation_id, vegetation_name) VALUES (E'5', E'Plantes flottantes à petites feuilles');
-- ddl-end --
INSERT INTO filo.vegetation (vegetation_id, vegetation_name) VALUES (E'6', E'Plantes flottantes à grandes feuilles');
-- ddl-end --
INSERT INTO filo.vegetation (vegetation_id, vegetation_name) VALUES (E'7', E'Plantes émergées');
-- ddl-end --
INSERT INTO filo.vegetation (vegetation_id, vegetation_name) VALUES (E'8', E'Pas de végétation');
-- ddl-end --

-- object: filo.cache_abundance_cache_abundance_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.cache_abundance_cache_abundance_id_seq CASCADE;
CREATE SEQUENCE filo.cache_abundance_cache_abundance_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 6
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.cache_abundance_cache_abundance_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.cache_abundance | type: TABLE --
-- DROP TABLE IF EXISTS filo.cache_abundance CASCADE;
CREATE TABLE filo.cache_abundance (
	cache_abundance_id integer NOT NULL DEFAULT nextval('filo.cache_abundance_cache_abundance_id_seq'::regclass),
	cache_abundance_name varchar NOT NULL,
	cache_abundance_code varchar,
	CONSTRAINT cache_abundance_pk PRIMARY KEY (cache_abundance_id)

);
-- ddl-end --
COMMENT ON TABLE filo.cache_abundance IS E'Levels of abundance of caches';
-- ddl-end --
ALTER TABLE filo.cache_abundance OWNER TO filo;
-- ddl-end --

INSERT INTO filo.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'1', E'Nulle');
-- ddl-end --
INSERT INTO filo.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'2', E'Faible');
-- ddl-end --
INSERT INTO filo.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'3', E'Moyenne');
-- ddl-end --
INSERT INTO filo.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'4', E'Importante');
-- ddl-end --
INSERT INTO filo.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'5', E'Indéterminable');
-- ddl-end --

-- object: facies_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS facies_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT facies_fk FOREIGN KEY (facies_id)
REFERENCES filo.facies (facies_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: situation_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS situation_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT situation_fk FOREIGN KEY (situation_id)
REFERENCES filo.situation (situation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: speed_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS speed_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT speed_fk FOREIGN KEY (speed_id)
REFERENCES filo.speed (speed_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: shady_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS shady_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT shady_fk FOREIGN KEY (shady_id)
REFERENCES filo.shady (shady_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: localisation_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS localisation_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT localisation_fk FOREIGN KEY (localisation_id)
REFERENCES filo.localisation (localisation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: vegetation_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS vegetation_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT vegetation_fk FOREIGN KEY (vegetation_id)
REFERENCES filo.vegetation (vegetation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: granulometry_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS granulometry_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT granulometry_fk FOREIGN KEY (dominant_granulometry_id)
REFERENCES filo.granulometry (granulometry_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: granulometry_fk1 | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS granulometry_fk1 CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT granulometry_fk1 FOREIGN KEY (secondary_granulometry_id)
REFERENCES filo.granulometry (granulometry_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT cache_abundance_fk FOREIGN KEY (herbarium_cache_abundance_id)
REFERENCES filo.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk1 | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk1 CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT cache_abundance_fk1 FOREIGN KEY (branch_cache_abundance_id)
REFERENCES filo.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk2 | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk2 CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT cache_abundance_fk2 FOREIGN KEY (vegetation_cache_abundance_id)
REFERENCES filo.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk3 | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk3 CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT cache_abundance_fk3 FOREIGN KEY (subbank_cache_abundance_id)
REFERENCES filo.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk4 | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk4 CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT cache_abundance_fk4 FOREIGN KEY (granulometry_cache_abundance_id)
REFERENCES filo.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: gacl.aclgroup_aclgroup_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.aclgroup_aclgroup_id_seq CASCADE;
CREATE SEQUENCE gacl.aclgroup_aclgroup_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 7
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq OWNER TO filo;
-- ddl-end --

-- object: gacl.aclacl | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclacl CASCADE;
CREATE TABLE gacl.aclacl (
	aclaco_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id,aclgroup_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.aclacl IS E'Table des droits attribués';
-- ddl-end --
ALTER TABLE gacl.aclacl OWNER TO filo;
-- ddl-end --

INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'1', E'1');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'2', E'5');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'3', E'4');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'4', E'3');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'5', E'2');
-- ddl-end --
INSERT INTO gacl.aclacl (aclaco_id, aclgroup_id) VALUES (E'6', E'6');
-- ddl-end --

-- object: gacl.aclaco_aclaco_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.aclaco_aclaco_id_seq CASCADE;
CREATE SEQUENCE gacl.aclaco_aclaco_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 7
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.aclaco_aclaco_id_seq OWNER TO filo;
-- ddl-end --

-- object: gacl.aclaco | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclaco CASCADE;
CREATE TABLE gacl.aclaco (
	aclaco_id integer NOT NULL DEFAULT nextval('gacl.aclaco_aclaco_id_seq'::regclass),
	aclappli_id integer NOT NULL,
	aco character varying NOT NULL,
	CONSTRAINT aclaco_pk PRIMARY KEY (aclaco_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.aclaco IS E'Table des droits gérés';
-- ddl-end --
ALTER TABLE gacl.aclaco OWNER TO filo;
-- ddl-end --

INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'1', E'1', E'admin');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'2', E'1', E'param');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'3', E'1', E'project');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'4', E'1', E'gestion');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'5', E'1', E'consult');
-- ddl-end --
INSERT INTO gacl.aclaco (aclaco_id, aclappli_id, aco) VALUES (E'6', E'1', E'import');
-- ddl-end --

-- object: gacl.aclappli_aclappli_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.aclappli_aclappli_id_seq CASCADE;
CREATE SEQUENCE gacl.aclappli_aclappli_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.aclappli_aclappli_id_seq OWNER TO filo;
-- ddl-end --

-- object: gacl.aclappli | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclappli CASCADE;
CREATE TABLE gacl.aclappli (
	aclappli_id integer NOT NULL DEFAULT nextval('gacl.aclappli_aclappli_id_seq'::regclass),
	appli character varying NOT NULL,
	applidetail character varying,
	CONSTRAINT aclappli_pk PRIMARY KEY (aclappli_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.aclappli IS E'Table des applications gérées';
-- ddl-end --
COMMENT ON COLUMN gacl.aclappli.appli IS E'Nom de l''application pour la gestion des droits';
-- ddl-end --
COMMENT ON COLUMN gacl.aclappli.applidetail IS E'Description de l''application';
-- ddl-end --
ALTER TABLE gacl.aclappli OWNER TO filo;
-- ddl-end --

INSERT INTO gacl.aclappli (aclappli_id, appli, applidetail) VALUES (E'1', E'filo', DEFAULT);
-- ddl-end --

-- object: gacl.aclgroup | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclgroup CASCADE;
CREATE TABLE gacl.aclgroup (
	aclgroup_id integer NOT NULL DEFAULT nextval('gacl.aclgroup_aclgroup_id_seq'::regclass),
	groupe character varying NOT NULL,
	aclgroup_id_parent integer,
	CONSTRAINT aclgroup_pk PRIMARY KEY (aclgroup_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.aclgroup IS E'Groupes des logins';
-- ddl-end --
ALTER TABLE gacl.aclgroup OWNER TO filo;
-- ddl-end --

INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'1', E'admin', DEFAULT);
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'2', E'consult', DEFAULT);
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'3', E'gestion', E'2');
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'4', E'project', E'3');
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'5', E'param', E'4');
-- ddl-end --
INSERT INTO gacl.aclgroup (aclgroup_id, groupe, aclgroup_id_parent) VALUES (E'6', E'import', E'3');
-- ddl-end --

-- object: gacl.acllogin_acllogin_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.acllogin_acllogin_id_seq CASCADE;
CREATE SEQUENCE gacl.acllogin_acllogin_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.acllogin_acllogin_id_seq OWNER TO filo;
-- ddl-end --

-- object: gacl.acllogin | type: TABLE --
-- DROP TABLE IF EXISTS gacl.acllogin CASCADE;
CREATE TABLE gacl.acllogin (
	acllogin_id integer NOT NULL DEFAULT nextval('gacl.acllogin_acllogin_id_seq'::regclass),
	login character varying NOT NULL,
	logindetail character varying NOT NULL,
	CONSTRAINT acllogin_pk PRIMARY KEY (acllogin_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.acllogin IS E'Table des logins des utilisateurs autorisés';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.logindetail IS E'Nom affiché';
-- ddl-end --
ALTER TABLE gacl.acllogin OWNER TO filo;
-- ddl-end --

INSERT INTO gacl.acllogin (acllogin_id, login, logindetail) VALUES (E'1', E'admin', E'admin');
-- ddl-end --

-- object: gacl.acllogingroup | type: TABLE --
-- DROP TABLE IF EXISTS gacl.acllogingroup CASCADE;
CREATE TABLE gacl.acllogingroup (
	acllogin_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT acllogingroup_pk PRIMARY KEY (acllogin_id,aclgroup_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.acllogingroup IS E'Table des relations entre les logins et les groupes';
-- ddl-end --
ALTER TABLE gacl.acllogingroup OWNER TO filo;
-- ddl-end --

INSERT INTO gacl.acllogingroup (acllogin_id, aclgroup_id) VALUES (E'1', E'1');
-- ddl-end --
INSERT INTO gacl.acllogingroup (acllogin_id, aclgroup_id) VALUES (E'1', E'5');
-- ddl-end --

-- object: gacl.log_log_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.log_log_id_seq CASCADE;
CREATE SEQUENCE gacl.log_log_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.log_log_id_seq OWNER TO filo;
-- ddl-end --

-- object: gacl.log | type: TABLE --
-- DROP TABLE IF EXISTS gacl.log CASCADE;
CREATE TABLE gacl.log (
	log_id integer NOT NULL DEFAULT nextval('gacl.log_log_id_seq'::regclass),
	login character varying(32) NOT NULL,
	nom_module character varying,
	log_date timestamp NOT NULL,
	commentaire character varying,
	ipaddress character varying,
	CONSTRAINT log_pk PRIMARY KEY (log_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.log IS E'Liste des connexions ou des actions enregistrées';
-- ddl-end --
COMMENT ON COLUMN gacl.log.log_date IS E'Heure de connexion';
-- ddl-end --
COMMENT ON COLUMN gacl.log.commentaire IS E'Donnees complementaires enregistrees';
-- ddl-end --
COMMENT ON COLUMN gacl.log.ipaddress IS E'Adresse IP du client';
-- ddl-end --
ALTER TABLE gacl.log OWNER TO filo;
-- ddl-end --

-- object: gacl.seq_logingestion_id | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.seq_logingestion_id CASCADE;
CREATE SEQUENCE gacl.seq_logingestion_id
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 999999
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.seq_logingestion_id OWNER TO filo;
-- ddl-end --

-- object: gacl.login_oldpassword_login_oldpassword_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.login_oldpassword_login_oldpassword_id_seq CASCADE;
CREATE SEQUENCE gacl.login_oldpassword_login_oldpassword_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.login_oldpassword_login_oldpassword_id_seq OWNER TO filo;
-- ddl-end --

-- object: gacl.logingestion | type: TABLE --
-- DROP TABLE IF EXISTS gacl.logingestion CASCADE;
CREATE TABLE gacl.logingestion (
	id integer NOT NULL DEFAULT nextval('gacl.seq_logingestion_id'::regclass),
	login character varying(32) NOT NULL,
	password character varying(255),
	nom character varying(32),
	prenom character varying(32),
	mail character varying(255),
	datemodif timestamp,
	actif smallint DEFAULT 1,
	is_clientws boolean DEFAULT false,
	tokenws character varying,
	is_expired boolean DEFAULT false,
	CONSTRAINT pk_logingestion PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE gacl.logingestion OWNER TO filo;
-- ddl-end --

INSERT INTO gacl.logingestion (id, login, password, nom, prenom, mail, datemodif, actif, is_clientws, tokenws) VALUES (E'1', E'admin', E'cd916028a2d8a1b901e831246dd5b9b4d3832786ddc63bbf5af4b50d9fc98f50', E'Administrator', DEFAULT, DEFAULT, DEFAULT, E'1', DEFAULT, DEFAULT);
-- ddl-end --

-- object: log_date_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_date_idx CASCADE;
CREATE INDEX log_date_idx ON gacl.log
	USING btree
	(
	  log_date
	)
	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: log_login_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_login_idx CASCADE;
CREATE INDEX log_login_idx ON gacl.log
	USING btree
	(
	  login
	)
	WITH (FILLFACTOR = 90);
-- ddl-end --

-- object: filo.project_group | type: TABLE --
-- DROP TABLE IF EXISTS filo.project_group CASCADE;
CREATE TABLE filo.project_group (
	project_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT project_group_pk PRIMARY KEY (project_id,aclgroup_id)

);
-- ddl-end --
ALTER TABLE filo.project_group OWNER TO filo;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE filo.project_group DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE filo.project_group ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES filo.project (project_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE filo.project_group DROP CONSTRAINT IF EXISTS aclgroup_fk CASCADE;
ALTER TABLE filo.project_group ADD CONSTRAINT aclgroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.operator_operator_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.operator_operator_id_seq CASCADE;
CREATE SEQUENCE filo.operator_operator_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.operator_operator_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.operator | type: TABLE --
-- DROP TABLE IF EXISTS filo.operator CASCADE;
CREATE TABLE filo.operator (
	operator_id integer NOT NULL DEFAULT nextval('filo.operator_operator_id_seq'::regclass),
	firstname varchar,
	name varchar NOT NULL,
	is_active boolean NOT NULL DEFAULT 't',
	uuid uuid NOT NULL DEFAULT gen_random_uuid(),
	CONSTRAINT operator_pk PRIMARY KEY (operator_id)

);
-- ddl-end --
COMMENT ON TABLE filo.operator IS E'List of operators';
-- ddl-end --
COMMENT ON COLUMN filo.operator.firstname IS E'First name of the operator';
-- ddl-end --
COMMENT ON COLUMN filo.operator.name IS E'Last name of operator';
-- ddl-end --
COMMENT ON COLUMN filo.operator.is_active IS E'Is the opérator actually active ?';
-- ddl-end --
ALTER TABLE filo.operator OWNER TO filo;
-- ddl-end --

-- object: filo.operation_operator | type: TABLE --
-- DROP TABLE IF EXISTS filo.operation_operator CASCADE;
CREATE TABLE filo.operation_operator (
	is_responsible bool DEFAULT 't',
	operation_id integer NOT NULL,
	operator_id integer NOT NULL,
	CONSTRAINT operation_operator_pk PRIMARY KEY (operation_id,operator_id)

);
-- ddl-end --
COMMENT ON TABLE filo.operation_operator IS E'Operators rattached to an operation';
-- ddl-end --
COMMENT ON COLUMN filo.operation_operator.is_responsible IS E'True if the operator is responsible of the operation';
-- ddl-end --
ALTER TABLE filo.operation_operator OWNER TO filo;
-- ddl-end --

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation_operator DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE filo.operation_operator ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES filo.operation (operation_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: operator_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation_operator DROP CONSTRAINT IF EXISTS operator_fk CASCADE;
ALTER TABLE filo.operation_operator ADD CONSTRAINT operator_fk FOREIGN KEY (operator_id)
REFERENCES filo.operator (operator_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.analysis_template_analysis_template_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.analysis_template_analysis_template_id_seq CASCADE;
CREATE SEQUENCE filo.analysis_template_analysis_template_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.analysis_template_analysis_template_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.analysis_template | type: TABLE --
-- DROP TABLE IF EXISTS filo.analysis_template CASCADE;
CREATE TABLE filo.analysis_template (
	analysis_template_id integer NOT NULL DEFAULT nextval('filo.analysis_template_analysis_template_id_seq'::regclass),
	analysis_template_name varchar NOT NULL,
	analysis_template_schema json,
	CONSTRAINT analysis_template_pk PRIMARY KEY (analysis_template_id)

);
-- ddl-end --
COMMENT ON TABLE filo.analysis_template IS E'Table of types of complementary analysis';
-- ddl-end --
COMMENT ON COLUMN filo.analysis_template.analysis_template_name IS E'Name of the template';
-- ddl-end --
COMMENT ON COLUMN filo.analysis_template.analysis_template_schema IS E'Description of all parameters recorded, in Json format';
-- ddl-end --
ALTER TABLE filo.analysis_template OWNER TO filo;
-- ddl-end --

-- object: filo.cloggging_clogging_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.cloggging_clogging_id_seq CASCADE;
CREATE SEQUENCE filo.cloggging_clogging_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 10
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.cloggging_clogging_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.clogging | type: TABLE --
-- DROP TABLE IF EXISTS filo.clogging CASCADE;
CREATE TABLE filo.clogging (
	clogging_id integer NOT NULL DEFAULT nextval('filo.cloggging_clogging_id_seq'::regclass),
	clogging_name varchar NOT NULL,
	clogging_code varchar,
	CONSTRAINT clogging_pk PRIMARY KEY (clogging_id)

);
-- ddl-end --
COMMENT ON TABLE filo.clogging IS E'List of types of cloggings';
-- ddl-end --
COMMENT ON COLUMN filo.clogging.clogging_name IS E'Name of the type of clogging';
-- ddl-end --
ALTER TABLE filo.clogging OWNER TO filo;
-- ddl-end --

INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'1', E'Pas de colmatage');
-- ddl-end --
INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'2', E'Sable');
-- ddl-end --
INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'3', E'Vase');
-- ddl-end --
INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'4', E'Sédiments fins');
-- ddl-end --
INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'5', E'Recouvrements biologiques');
-- ddl-end --
INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'6', E'Débris végétaux');
-- ddl-end --
INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'7', E'Litières');
-- ddl-end --
INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'8', E'Dépôts incrustants');
-- ddl-end --
INSERT INTO filo.clogging (clogging_id, clogging_name) VALUES (E'9', E'Autres');
-- ddl-end --

-- object: clogging_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS clogging_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT clogging_fk FOREIGN KEY (clogging_id)
REFERENCES filo.clogging (clogging_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.sinuosity_sinuosity_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.sinuosity_sinuosity_id_seq CASCADE;
CREATE SEQUENCE filo.sinuosity_sinuosity_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 5
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.sinuosity_sinuosity_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.sinuosity | type: TABLE --
-- DROP TABLE IF EXISTS filo.sinuosity CASCADE;
CREATE TABLE filo.sinuosity (
	sinuosity_id integer NOT NULL DEFAULT nextval('filo.sinuosity_sinuosity_id_seq'::regclass),
	sinuosity_name varchar NOT NULL,
	sinuosity_code varchar,
	CONSTRAINT sinuosity_pk PRIMARY KEY (sinuosity_id)

);
-- ddl-end --
COMMENT ON TABLE filo.sinuosity IS E'List of types of sinuosities of the river';
-- ddl-end --
ALTER TABLE filo.sinuosity OWNER TO filo;
-- ddl-end --

INSERT INTO filo.sinuosity (sinuosity_id, sinuosity_name) VALUES (E'1', E'Cours d''eau rectiligne');
-- ddl-end --
INSERT INTO filo.sinuosity (sinuosity_id, sinuosity_name) VALUES (E'2', E'Cours d''eau sinueux');
-- ddl-end --
INSERT INTO filo.sinuosity (sinuosity_id, sinuosity_name) VALUES (E'3', E'Cours d''eau très sinueux');
-- ddl-end --
INSERT INTO filo.sinuosity (sinuosity_id, sinuosity_name) VALUES (E'4', E'Cours d''eau méandriforme');
-- ddl-end --

-- object: sinuosity_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS sinuosity_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT sinuosity_fk FOREIGN KEY (sinuosity_id)
REFERENCES filo.sinuosity (sinuosity_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.flow_trend_flow_trend_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.flow_trend_flow_trend_id_seq CASCADE;
CREATE SEQUENCE filo.flow_trend_flow_trend_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 5
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.flow_trend_flow_trend_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.flow_trend | type: TABLE --
-- DROP TABLE IF EXISTS filo.flow_trend CASCADE;
CREATE TABLE filo.flow_trend (
	flow_trend_id integer NOT NULL DEFAULT nextval('filo.flow_trend_flow_trend_id_seq'::regclass),
	flow_trend_name varchar NOT NULL,
	flow_trend_code varchar,
	CONSTRAINT flow_trend_pk PRIMARY KEY (flow_trend_id)

);
-- ddl-end --
COMMENT ON TABLE filo.flow_trend IS E'List of trends of flow';
-- ddl-end --
ALTER TABLE filo.flow_trend OWNER TO filo;
-- ddl-end --

INSERT INTO filo.flow_trend (flow_trend_id, flow_trend_name, flow_trend_code) VALUES (E'1', E'Augmentation (en crue)', E'2');
-- ddl-end --
INSERT INTO filo.flow_trend (flow_trend_id, flow_trend_name, flow_trend_code) VALUES (E'2', E'Diminution (en décrue)', E'3');
-- ddl-end --
INSERT INTO filo.flow_trend (flow_trend_id, flow_trend_name, flow_trend_code) VALUES (E'3', E'Stabilité', E'1');
-- ddl-end --
INSERT INTO filo.flow_trend (flow_trend_id, flow_trend_name, flow_trend_code) VALUES (E'4', E'Irrégularité', E'4');
-- ddl-end --

-- object: flow_trend_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS flow_trend_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT flow_trend_fk FOREIGN KEY (flow_trend_id)
REFERENCES filo.flow_trend (flow_trend_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.turbidity_id | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.turbidity_id CASCADE;
CREATE SEQUENCE filo.turbidity_id
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 5
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.turbidity_id OWNER TO filo;
-- ddl-end --

-- object: filo.turbidity | type: TABLE --
-- DROP TABLE IF EXISTS filo.turbidity CASCADE;
CREATE TABLE filo.turbidity (
	turbidity_id integer NOT NULL DEFAULT nextval('filo.turbidity_id'::regclass),
	turbidity_name varchar NOT NULL,
	turbidity_code varchar,
	CONSTRAINT turbidity_pk PRIMARY KEY (turbidity_id)

);
-- ddl-end --
COMMENT ON TABLE filo.turbidity IS E'List of types of turbidity';
-- ddl-end --
ALTER TABLE filo.turbidity OWNER TO filo;
-- ddl-end --

INSERT INTO filo.turbidity (turbidity_id, turbidity_name) VALUES (E'1', E'Nulle');
-- ddl-end --
INSERT INTO filo.turbidity (turbidity_id, turbidity_name) VALUES (E'2', E'Faible');
-- ddl-end --
INSERT INTO filo.turbidity (turbidity_id, turbidity_name) VALUES (E'3', E'Moyenne');
-- ddl-end --
INSERT INTO filo.turbidity (turbidity_id, turbidity_name) VALUES (E'4', E'Forte');
-- ddl-end --

-- object: turbidity_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS turbidity_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT turbidity_fk FOREIGN KEY (turbidity_id)
REFERENCES filo.turbidity (turbidity_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.protocol_protocol_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.protocol_protocol_id_seq CASCADE;
CREATE SEQUENCE filo.protocol_protocol_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.protocol_protocol_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.protocol | type: TABLE --
-- DROP TABLE IF EXISTS filo.protocol CASCADE;
CREATE TABLE filo.protocol (
	protocol_id integer NOT NULL DEFAULT nextval('filo.protocol_protocol_id_seq'::regclass),
	protocol_name varchar NOT NULL,
	protocol_url varchar,
	protocol_description varchar,
	protocol_pdf bytea,
	measure_default varchar NOT NULL DEFAULT 'sl',
	measure_default_only boolean NOT NULL DEFAULT false,
	analysis_template_id integer,
	existing_taxon_only boolean NOT NULL DEFAULT true,
	protocol_code varchar,
	ambience_template_id integer,
	CONSTRAINT protocol_pk PRIMARY KEY (protocol_id)

);
-- ddl-end --
COMMENT ON TABLE filo.protocol IS E'List of protocols used';
-- ddl-end --
COMMENT ON COLUMN filo.protocol.protocol_name IS E'Name of the protocol';
-- ddl-end --
COMMENT ON COLUMN filo.protocol.protocol_url IS E'Url where the description of the protocol can be found';
-- ddl-end --
COMMENT ON COLUMN filo.protocol.protocol_description IS E'Synthetic description of the protocol';
-- ddl-end --
COMMENT ON COLUMN filo.protocol.protocol_pdf IS E'Document attached in pdf format';
-- ddl-end --
COMMENT ON COLUMN filo.protocol.measure_default IS E'Name of the prefered measure in the protocol\nPossible values : sl, fl, tl, wd, ot';
-- ddl-end --
COMMENT ON COLUMN filo.protocol.measure_default_only IS E'If true, only the measure_default type is used during the protocol';
-- ddl-end --
COMMENT ON COLUMN filo.protocol.existing_taxon_only IS E'Limit the capacity to add a new taxon which is not defined in the taxon table';
-- ddl-end --
ALTER TABLE filo.protocol OWNER TO filo;
-- ddl-end --

INSERT INTO filo.protocol (protocol_id, protocol_name, protocol_url, protocol_description, protocol_pdf, measure_default, measure_default_only, analysis_template_id) VALUES (E'1', E'Default', DEFAULT, E'Protocole par défaut', DEFAULT, E'tl', E'0', DEFAULT);
-- ddl-end --

-- object: protocol_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation DROP CONSTRAINT IF EXISTS protocol_fk CASCADE;
ALTER TABLE filo.operation ADD CONSTRAINT protocol_fk FOREIGN KEY (protocol_id)
REFERENCES filo.protocol (protocol_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: taxon_fk | type: CONSTRAINT --
-- ALTER TABLE filo.measure_template DROP CONSTRAINT IF EXISTS taxon_fk CASCADE;
ALTER TABLE filo.measure_template ADD CONSTRAINT taxon_fk FOREIGN KEY (taxon_id)
REFERENCES filo.taxon (taxon_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.protocol_measure | type: TABLE --
-- DROP TABLE IF EXISTS filo.protocol_measure CASCADE;
CREATE TABLE filo.protocol_measure (
	protocol_id integer NOT NULL,
	measure_template_id integer NOT NULL,
	CONSTRAINT protocol_measure_pk PRIMARY KEY (protocol_id,measure_template_id)

);
-- ddl-end --
COMMENT ON TABLE filo.protocol_measure IS E'List of particular species measures used in the protocol';
-- ddl-end --
ALTER TABLE filo.protocol_measure OWNER TO filo;
-- ddl-end --

-- object: protocol_fk | type: CONSTRAINT --
-- ALTER TABLE filo.protocol_measure DROP CONSTRAINT IF EXISTS protocol_fk CASCADE;
ALTER TABLE filo.protocol_measure ADD CONSTRAINT protocol_fk FOREIGN KEY (protocol_id)
REFERENCES filo.protocol (protocol_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measure_template_fk | type: CONSTRAINT --
-- ALTER TABLE filo.protocol_measure DROP CONSTRAINT IF EXISTS measure_template_fk CASCADE;
ALTER TABLE filo.protocol_measure ADD CONSTRAINT measure_template_fk FOREIGN KEY (measure_template_id)
REFERENCES filo.measure_template (measure_template_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: analysis_template_fk | type: CONSTRAINT --
-- ALTER TABLE filo.protocol DROP CONSTRAINT IF EXISTS analysis_template_fk CASCADE;
ALTER TABLE filo.protocol ADD CONSTRAINT analysis_template_fk FOREIGN KEY (analysis_template_id)
REFERENCES filo.analysis_template (analysis_template_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.water_regime_water_regime_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.water_regime_water_regime_id_seq CASCADE;
CREATE SEQUENCE filo.water_regime_water_regime_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 5
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.water_regime_water_regime_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.water_regime | type: TABLE --
-- DROP TABLE IF EXISTS filo.water_regime CASCADE;
CREATE TABLE filo.water_regime (
	water_regime_id integer NOT NULL DEFAULT nextval('filo.water_regime_water_regime_id_seq'::regclass),
	water_regime_name varchar NOT NULL,
	water_regime_code varchar,
	CONSTRAINT water_regime_pk PRIMARY KEY (water_regime_id)

);
-- ddl-end --
COMMENT ON TABLE filo.water_regime IS E'List of water regimes';
-- ddl-end --
ALTER TABLE filo.water_regime OWNER TO filo;
-- ddl-end --

INSERT INTO filo.water_regime (water_regime_name, water_regime_id) VALUES (E'Étiage', E'1');
-- ddl-end --
INSERT INTO filo.water_regime (water_regime_name, water_regime_id) VALUES (E'Niveau moyen', E'2');
-- ddl-end --
INSERT INTO filo.water_regime (water_regime_name, water_regime_id) VALUES (E'Hautes eaux', E'3');
-- ddl-end --
INSERT INTO filo.water_regime (water_regime_name, water_regime_id) VALUES (E'Crue', E'4');
-- ddl-end --

-- object: water_regime_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation DROP CONSTRAINT IF EXISTS water_regime_fk CASCADE;
ALTER TABLE filo.operation ADD CONSTRAINT water_regime_fk FOREIGN KEY (water_regime_id)
REFERENCES filo.water_regime (water_regime_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.electric_current_type | type: TABLE --
-- DROP TABLE IF EXISTS filo.electric_current_type CASCADE;
CREATE TABLE filo.electric_current_type (
	electric_current_type_id smallint NOT NULL,
	electric_current_type_name varchar NOT NULL,
	electric_current_type_code varchar,
	CONSTRAINT electric_current_type_pk PRIMARY KEY (electric_current_type_id)

);
-- ddl-end --
ALTER TABLE filo.electric_current_type OWNER TO filo;
-- ddl-end --

INSERT INTO filo.electric_current_type (electric_current_type_id, electric_current_type_name) VALUES (E'1', E'Continu');
-- ddl-end --
INSERT INTO filo.electric_current_type (electric_current_type_id, electric_current_type_name) VALUES (E'2', E'Ondulé');
-- ddl-end --

-- object: filo.fishing_strategy_fishing_strategy_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.fishing_strategy_fishing_strategy_id_seq CASCADE;
CREATE SEQUENCE filo.fishing_strategy_fishing_strategy_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 3
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.fishing_strategy_fishing_strategy_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.fishing_strategy | type: TABLE --
-- DROP TABLE IF EXISTS filo.fishing_strategy CASCADE;
CREATE TABLE filo.fishing_strategy (
	fishing_strategy_id integer NOT NULL DEFAULT nextval('filo.fishing_strategy_fishing_strategy_id_seq'::regclass),
	fishing_strategy_name varchar NOT NULL,
	fishing_strategy_code varchar,
	CONSTRAINT fishing_strategy_pk PRIMARY KEY (fishing_strategy_id)

);
-- ddl-end --
ALTER TABLE filo.fishing_strategy OWNER TO filo;
-- ddl-end --

INSERT INTO filo.fishing_strategy (fishing_strategy_id, fishing_strategy_name) VALUES (E'1', E'Inventaire');
-- ddl-end --
INSERT INTO filo.fishing_strategy (fishing_strategy_id, fishing_strategy_name) VALUES (E'2', E'Sondage');
-- ddl-end --
INSERT INTO filo.fishing_strategy (fishing_strategy_id, fishing_strategy_name) VALUES (E'3', E'EPA');
-- ddl-end --

-- object: fishing_strategy_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation DROP CONSTRAINT IF EXISTS fishing_strategy_fk CASCADE;
ALTER TABLE filo.operation ADD CONSTRAINT fishing_strategy_fk FOREIGN KEY (fishing_strategy_id)
REFERENCES filo.fishing_strategy (fishing_strategy_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.scale_scale_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.scale_scale_id_seq CASCADE;
CREATE SEQUENCE filo.scale_scale_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 4
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.scale_scale_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.scale | type: TABLE --
-- DROP TABLE IF EXISTS filo.scale CASCADE;
CREATE TABLE filo.scale (
	scale_id integer NOT NULL DEFAULT nextval('filo.scale_scale_id_seq'::regclass),
	scale_name varchar NOT NULL,
	scale_code varchar,
	CONSTRAINT scale_pk PRIMARY KEY (scale_id)

);
-- ddl-end --
COMMENT ON TABLE filo.scale IS E'Scale of the operation (global station, point, ambience)';
-- ddl-end --
ALTER TABLE filo.scale OWNER TO filo;
-- ddl-end --

INSERT INTO filo.scale (scale_id, scale_name) VALUES (E'1', E'Global station');
-- ddl-end --
INSERT INTO filo.scale (scale_id, scale_name) VALUES (E'2', E'Ambiances');
-- ddl-end --
INSERT INTO filo.scale (scale_id, scale_name) VALUES (E'3', E'Points');
-- ddl-end --

-- object: scale_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation DROP CONSTRAINT IF EXISTS scale_fk CASCADE;
ALTER TABLE filo.operation ADD CONSTRAINT scale_fk FOREIGN KEY (scale_id)
REFERENCES filo.scale (scale_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.gear_method_gear_method_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.gear_method_gear_method_id_seq CASCADE;
CREATE SEQUENCE filo.gear_method_gear_method_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 3
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.gear_method_gear_method_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.gear_method | type: TABLE --
-- DROP TABLE IF EXISTS filo.gear_method CASCADE;
CREATE TABLE filo.gear_method (
	gear_method_id integer NOT NULL DEFAULT nextval('filo.gear_method_gear_method_id_seq'::regclass),
	gear_method_name varchar NOT NULL,
	gear_method_code varchar,
	CONSTRAINT gear_method_pk PRIMARY KEY (gear_method_id)

);
-- ddl-end --
COMMENT ON TABLE filo.gear_method IS E'Method of usage of the gear (in boat, walk fishing, etc.)';
-- ddl-end --
ALTER TABLE filo.gear_method OWNER TO filo;
-- ddl-end --

INSERT INTO filo.gear_method (gear_method_id, gear_method_name) VALUES (E'1', E'À pied');
-- ddl-end --
INSERT INTO filo.gear_method (gear_method_id, gear_method_name) VALUES (E'2', E'En bateau');
-- ddl-end --
INSERT INTO filo.gear_method (gear_method_id, gear_method_name) VALUES (E'3', E'Autre');
-- ddl-end --

-- object: gear_method_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sequence_gear DROP CONSTRAINT IF EXISTS gear_method_fk CASCADE;
ALTER TABLE filo.sequence_gear ADD CONSTRAINT gear_method_fk FOREIGN KEY (gear_method_id)
REFERENCES filo.gear_method (gear_method_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: electric_current_type_fk | type: CONSTRAINT --
-- ALTER TABLE filo.sequence_gear DROP CONSTRAINT IF EXISTS electric_current_type_fk CASCADE;
ALTER TABLE filo.sequence_gear ADD CONSTRAINT electric_current_type_fk FOREIGN KEY (electric_current_type_id)
REFERENCES filo.electric_current_type (electric_current_type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.dbparam | type: TABLE --
-- DROP TABLE IF EXISTS filo.dbparam CASCADE;
CREATE TABLE filo.dbparam (
	dbparam_id integer NOT NULL,
	dbparam_name character varying NOT NULL,
	dbparam_value character varying,
	CONSTRAINT dbparam_pk PRIMARY KEY (dbparam_id)

);
-- ddl-end --
COMMENT ON TABLE filo.dbparam IS E'Table des parametres associes de maniere intrinseque a l''instance';
-- ddl-end --
COMMENT ON COLUMN filo.dbparam.dbparam_name IS E'Nom du parametre';
-- ddl-end --
COMMENT ON COLUMN filo.dbparam.dbparam_value IS E'Valeur du paramètre';
-- ddl-end --
ALTER TABLE filo.dbparam OWNER TO filo;
-- ddl-end --

INSERT INTO filo.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'1', E'APPLI_title', E'Filo-Science');
-- ddl-end --
INSERT INTO filo.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'2', E'mapDefaultZoom', E'9');
-- ddl-end --
INSERT INTO filo.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'3', E'mapDefaultLong', E'0');
-- ddl-end --
INSERT INTO filo.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'4', E'mapDefaultLat', E'45');
-- ddl-end --
INSERT INTO filo.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'5', E'mapMinZoom', E'5');
-- ddl-end --
INSERT INTO filo.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'6', E'mapMaxZoom', E'18');
-- ddl-end --
INSERT INTO filo.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'7', E'APPLI_code', E'filoscience');
-- ddl-end --

-- object: filo.dbversion_dbversion_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.dbversion_dbversion_id_seq CASCADE;
CREATE SEQUENCE filo.dbversion_dbversion_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.dbversion_dbversion_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.dbversion | type: TABLE --
-- DROP TABLE IF EXISTS filo.dbversion CASCADE;
CREATE TABLE filo.dbversion (
	dbversion_id integer NOT NULL DEFAULT nextval('filo.dbversion_dbversion_id_seq'::regclass),
	dbversion_number character varying NOT NULL,
	dbversion_date timestamp NOT NULL,
	CONSTRAINT dbversion_pk PRIMARY KEY (dbversion_id)

);
-- ddl-end --
COMMENT ON TABLE filo.dbversion IS E'Table des versions de la base de donnees';
-- ddl-end --
COMMENT ON COLUMN filo.dbversion.dbversion_number IS E'Numero de la version';
-- ddl-end --
COMMENT ON COLUMN filo.dbversion.dbversion_date IS E'Date de la version';
-- ddl-end --
ALTER TABLE filo.dbversion OWNER TO filo;
-- ddl-end --

INSERT INTO filo.dbversion (dbversion_number, dbversion_date) VALUES (E'1.7', E'2020-08-07');
-- ddl-end --

-- object: filo.taxa_template_taxa_template_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.taxa_template_taxa_template_id_seq CASCADE;
CREATE SEQUENCE filo.taxa_template_taxa_template_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.taxa_template_taxa_template_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.taxa_template | type: TABLE --
-- DROP TABLE IF EXISTS filo.taxa_template CASCADE;
CREATE TABLE filo.taxa_template (
	taxa_template_id integer NOT NULL DEFAULT nextval('filo.taxa_template_taxa_template_id_seq'::regclass),
	taxa_template_name varchar NOT NULL,
	taxa_model json,
	freshwater boolean NOT NULL DEFAULT true,
	CONSTRAINT taxa_template_pk PRIMARY KEY (taxa_template_id)

);
-- ddl-end --
COMMENT ON TABLE filo.taxa_template IS E'List of templates used to select taxa';
-- ddl-end --
COMMENT ON COLUMN filo.taxa_template.taxa_model IS E'Model of emplacement of taxa on screen';
-- ddl-end --
COMMENT ON COLUMN filo.taxa_template.freshwater IS E'Does the template operate for freshwater?';
-- ddl-end --
ALTER TABLE filo.taxa_template OWNER TO filo;
-- ddl-end --

-- object: taxa_template_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation DROP CONSTRAINT IF EXISTS taxa_template_fk CASCADE;
ALTER TABLE filo.operation ADD CONSTRAINT taxa_template_fk FOREIGN KEY (taxa_template_id)
REFERENCES filo.taxa_template (taxa_template_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: sequence_fk | type: CONSTRAINT --
-- ALTER TABLE filo.ambience DROP CONSTRAINT IF EXISTS sequence_fk CASCADE;
ALTER TABLE filo.ambience ADD CONSTRAINT sequence_fk FOREIGN KEY (sequence_id)
REFERENCES filo.sequence (sequence_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.document_document_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.document_document_id_seq CASCADE;
CREATE SEQUENCE filo.document_document_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.document_document_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.document | type: TABLE --
-- DROP TABLE IF EXISTS filo.document CASCADE;
CREATE TABLE filo.document (
	document_id integer NOT NULL DEFAULT nextval('filo.document_document_id_seq'::regclass),
	document_import_date timestamp NOT NULL,
	document_name varchar NOT NULL,
	document_description varchar,
	data bytea,
	size integer,
	thumbnail bytea,
	mime_type_id integer NOT NULL,
	document_creation_date timestamp,
	CONSTRAINT document_pk PRIMARY KEY (document_id)

);
-- ddl-end --
COMMENT ON TABLE filo.document IS E'Documents stocked in the database';
-- ddl-end --
COMMENT ON COLUMN filo.document.document_name IS E'Name of the document';
-- ddl-end --
COMMENT ON COLUMN filo.document.document_description IS E'Description of the document';
-- ddl-end --
COMMENT ON COLUMN filo.document.data IS E'Content of the document, in binary format';
-- ddl-end --
COMMENT ON COLUMN filo.document.size IS E'Total size of the document';
-- ddl-end --
COMMENT ON COLUMN filo.document.thumbnail IS E'Thumbnail of the document, if it''s an image or a pdf';
-- ddl-end --
COMMENT ON COLUMN filo.document.document_creation_date IS E'Date of creation of the document';
-- ddl-end --
ALTER TABLE filo.document OWNER TO filo;
-- ddl-end --

-- object: filo.mime_type | type: TABLE --
-- DROP TABLE IF EXISTS filo.mime_type CASCADE;
CREATE TABLE filo.mime_type (
	mime_type_id integer NOT NULL,
	content_type varchar NOT NULL,
	extension varchar NOT NULL,
	CONSTRAINT mime_type_pk PRIMARY KEY (mime_type_id)

);
-- ddl-end --
COMMENT ON TABLE filo.mime_type IS E'List of types mime associable to the documents';
-- ddl-end --
COMMENT ON COLUMN filo.mime_type.content_type IS E'Normalized description of the type mime';
-- ddl-end --
COMMENT ON COLUMN filo.mime_type.extension IS E'Extension associated with the type mime';
-- ddl-end --
ALTER TABLE filo.mime_type OWNER TO filo;
-- ddl-end --

INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'1', E'pdf', E'application/pdf');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'2', E'zip', E'application/zip');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'3', E'mp3', E'audio/mpeg');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'4', E'jpg', E'image/jpeg');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'5', E'jpeg', E'image/jpeg');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'6', E'png', E'image/png');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'7', E'tiff', E'image/tiff');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'9', E'odt', E'application/vnd.oasis.opendocument.text');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'10', E'ods', E'application/vnd.oasis.opendocument.spreadsheet');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'11', E'xls', E'application/vnd.ms-excel');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'12', E'xlsx', E'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'13', E'doc', E'application/msword');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'14', E'docx', E'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
-- ddl-end --
INSERT INTO filo.mime_type (mime_type_id, extension, content_type) VALUES (E'8', E'csv', E'text/csv');
-- ddl-end --

-- object: mime_type_fk | type: CONSTRAINT --
-- ALTER TABLE filo.document DROP CONSTRAINT IF EXISTS mime_type_fk CASCADE;
ALTER TABLE filo.document ADD CONSTRAINT mime_type_fk FOREIGN KEY (mime_type_id)
REFERENCES filo.mime_type (mime_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.project_document | type: TABLE --
-- DROP TABLE IF EXISTS filo.project_document CASCADE;
CREATE TABLE filo.project_document (
	project_id integer NOT NULL,
	document_id integer NOT NULL,
	CONSTRAINT project_document_pk PRIMARY KEY (project_id,document_id)

);
-- ddl-end --
COMMENT ON TABLE filo.project_document IS E'Documents associated with a project';
-- ddl-end --
ALTER TABLE filo.project_document OWNER TO filo;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE filo.project_document DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE filo.project_document ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES filo.project (project_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: document_fk | type: CONSTRAINT --
-- ALTER TABLE filo.project_document DROP CONSTRAINT IF EXISTS document_fk CASCADE;
ALTER TABLE filo.project_document ADD CONSTRAINT document_fk FOREIGN KEY (document_id)
REFERENCES filo.document (document_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.protocol_document | type: TABLE --
-- DROP TABLE IF EXISTS filo.protocol_document CASCADE;
CREATE TABLE filo.protocol_document (
	protocol_id integer NOT NULL,
	document_id integer NOT NULL,
	CONSTRAINT protocol_document_pk PRIMARY KEY (protocol_id,document_id)

);
-- ddl-end --
COMMENT ON TABLE filo.protocol_document IS E'List of the documents associated with a protocol';
-- ddl-end --
ALTER TABLE filo.protocol_document OWNER TO filo;
-- ddl-end --

-- object: protocol_fk | type: CONSTRAINT --
-- ALTER TABLE filo.protocol_document DROP CONSTRAINT IF EXISTS protocol_fk CASCADE;
ALTER TABLE filo.protocol_document ADD CONSTRAINT protocol_fk FOREIGN KEY (protocol_id)
REFERENCES filo.protocol (protocol_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: document_fk | type: CONSTRAINT --
-- ALTER TABLE filo.protocol_document DROP CONSTRAINT IF EXISTS document_fk CASCADE;
ALTER TABLE filo.protocol_document ADD CONSTRAINT document_fk FOREIGN KEY (document_id)
REFERENCES filo.document (document_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: log_commentaire_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_commentaire_idx CASCADE;
CREATE INDEX log_commentaire_idx ON gacl.log
	USING btree
	(
	  commentaire
	);
-- ddl-end --

-- object: logingestion_login_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.logingestion_login_idx CASCADE;
CREATE UNIQUE INDEX logingestion_login_idx ON gacl.logingestion
	USING btree
	(
	  login
	);
-- ddl-end --

-- object: gacl.passwordlost_passwordlost_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS gacl.passwordlost_passwordlost_id_seq CASCADE;
CREATE SEQUENCE gacl.passwordlost_passwordlost_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE gacl.passwordlost_passwordlost_id_seq OWNER TO filo;
-- ddl-end --

-- object: gacl.passwordlost | type: TABLE --
-- DROP TABLE IF EXISTS gacl.passwordlost CASCADE;
CREATE TABLE gacl.passwordlost (
	passwordlost_id integer NOT NULL DEFAULT nextval('gacl.passwordlost_passwordlost_id_seq'::regclass),
	id integer NOT NULL,
	token varchar NOT NULL,
	expiration timestamp NOT NULL,
	usedate timestamp,
	CONSTRAINT passwordlost_pk PRIMARY KEY (passwordlost_id)

);
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.token IS E'Token used to reinit the password';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.expiration IS E'Date of expiration of the token';
-- ddl-end --
COMMENT ON COLUMN gacl.passwordlost.usedate IS E'Date of use of the token';
-- ddl-end --
ALTER TABLE gacl.passwordlost OWNER TO filo;
-- ddl-end --

-- object: logingestion_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.passwordlost DROP CONSTRAINT IF EXISTS logingestion_fk CASCADE;
ALTER TABLE gacl.passwordlost ADD CONSTRAINT logingestion_fk FOREIGN KEY (id)
REFERENCES gacl.logingestion (id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.operation_document | type: TABLE --
-- DROP TABLE IF EXISTS filo.operation_document CASCADE;
CREATE TABLE filo.operation_document (
	operation_id integer NOT NULL,
	document_id integer NOT NULL,
	CONSTRAINT operation_document_pk PRIMARY KEY (operation_id,document_id)

);
-- ddl-end --
COMMENT ON TABLE filo.operation_document IS E'Documents associated with an operation';
-- ddl-end --
ALTER TABLE filo.operation_document OWNER TO filo;
-- ddl-end --

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation_document DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE filo.operation_document ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES filo.operation (operation_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: document_fk | type: CONSTRAINT --
-- ALTER TABLE filo.operation_document DROP CONSTRAINT IF EXISTS document_fk CASCADE;
ALTER TABLE filo.operation_document ADD CONSTRAINT document_fk FOREIGN KEY (document_id)
REFERENCES filo.document (document_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: filo.v_individual_other_measures | type: VIEW --
-- DROP VIEW IF EXISTS filo.v_individual_other_measures CASCADE;
CREATE VIEW filo.v_individual_other_measures
AS 

select individual_id, 
string_agg( metadata.key || ':' || metadata.value, ', '::varchar) as other_measures 
from individual, 
json_each_text(individual.other_measure) as metadata
group by individual_id;
-- ddl-end --
ALTER VIEW filo.v_individual_other_measures OWNER TO filo;
-- ddl-end --

-- object: tracking.release_place_release_place_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.release_place_release_place_id_seq CASCADE;
CREATE SEQUENCE tracking.release_place_release_place_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.release_place_release_place_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.individual_tracking | type: TABLE --
-- DROP TABLE IF EXISTS tracking.individual_tracking CASCADE;
CREATE TABLE tracking.individual_tracking (
	individual_id integer NOT NULL,
	release_station_id integer,
	taxon_id integer NOT NULL,
	project_id integer NOT NULL,
	transmitter_type_id integer,
	CONSTRAINT individual_tracking_pk PRIMARY KEY (individual_id)

);
-- ddl-end --
ALTER TABLE tracking.individual_tracking OWNER TO filo;
-- ddl-end --

-- object: individual_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS individual_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT individual_fk FOREIGN KEY (individual_id)
REFERENCES filo.individual (individual_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: individual_tracking_uq | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS individual_tracking_uq CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT individual_tracking_uq UNIQUE (individual_id);
-- ddl-end --

-- object: tracking.station_tracking | type: TABLE --
-- DROP TABLE IF EXISTS tracking.station_tracking CASCADE;
CREATE TABLE tracking.station_tracking (
	station_id integer NOT NULL,
	station_type_id integer NOT NULL,
	CONSTRAINT station_tracking_pk PRIMARY KEY (station_id)

);
-- ddl-end --
ALTER TABLE tracking.station_tracking OWNER TO filo;
-- ddl-end --

-- object: station_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.station_tracking DROP CONSTRAINT IF EXISTS station_fk CASCADE;
ALTER TABLE tracking.station_tracking ADD CONSTRAINT station_fk FOREIGN KEY (station_id)
REFERENCES filo.station (station_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.station_type_station_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.station_type_station_type_id_seq CASCADE;
CREATE SEQUENCE tracking.station_type_station_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.station_type_station_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.station_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.station_type CASCADE;
CREATE TABLE tracking.station_type (
	station_type_id integer NOT NULL DEFAULT nextval('tracking.station_type_station_type_id_seq'::regclass),
	station_type_name varchar NOT NULL,
	CONSTRAINT station_type_pk PRIMARY KEY (station_type_id)

);
-- ddl-end --
ALTER TABLE tracking.station_type OWNER TO filo;
-- ddl-end --

INSERT INTO tracking.station_type (station_type_name) VALUES (E'Station de mesure physico-chimique');
-- ddl-end --
INSERT INTO tracking.station_type (station_type_name) VALUES (E'Station d''enregistrement');
-- ddl-end --
INSERT INTO tracking.station_type (station_type_name) VALUES (E'Station de lacher');
-- ddl-end --

-- object: station_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.station_tracking DROP CONSTRAINT IF EXISTS station_type_fk CASCADE;
ALTER TABLE tracking.station_tracking ADD CONSTRAINT station_type_fk FOREIGN KEY (station_type_id)
REFERENCES tracking.station_type (station_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.antenna_antenna_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.antenna_antenna_id_seq CASCADE;
CREATE SEQUENCE tracking.antenna_antenna_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.antenna_antenna_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna | type: TABLE --
-- DROP TABLE IF EXISTS tracking.antenna CASCADE;
CREATE TABLE tracking.antenna (
	antenna_id integer NOT NULL DEFAULT nextval('tracking.antenna_antenna_id_seq'::regclass),
	station_id integer NOT NULL,
	technology_type_id integer NOT NULL,
	antenna_code varchar NOT NULL,
	radius smallint,
	geom_polygon geometry(POLYGON, 4326),
	CONSTRAINT antenna_pk PRIMARY KEY (antenna_id)

);
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.antenna_code IS E'Antenna or receiver code';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.radius IS E'radius, in metres, of the useful reception';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna.geom_polygon IS E'Geometry of the reception zone, in polygonal form, wgs84';
-- ddl-end --
ALTER TABLE tracking.antenna OWNER TO filo;
-- ddl-end --

-- object: station_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.antenna DROP CONSTRAINT IF EXISTS station_tracking_fk CASCADE;
ALTER TABLE tracking.antenna ADD CONSTRAINT station_tracking_fk FOREIGN KEY (station_id)
REFERENCES tracking.station_tracking (station_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.detection_detection_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.detection_detection_id_seq CASCADE;
CREATE SEQUENCE tracking.detection_detection_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.detection_detection_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.detection | type: TABLE --
-- DROP TABLE IF EXISTS tracking.detection CASCADE;
CREATE TABLE tracking.detection (
	detection_id integer NOT NULL DEFAULT nextval('tracking.detection_detection_id_seq'::regclass),
	individual_id integer NOT NULL,
	antenna_id integer,
	detection_date timestamp NOT NULL,
	nb_events smallint,
	duration double precision,
	validity boolean NOT NULL DEFAULT 't',
	signal_force smallint,
	observation varchar,
	CONSTRAINT detection_pk PRIMARY KEY (detection_id)

);
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
ALTER TABLE tracking.detection OWNER TO filo;
-- ddl-end --

-- object: individual_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
ALTER TABLE tracking.detection ADD CONSTRAINT individual_tracking_fk FOREIGN KEY (individual_id)
REFERENCES tracking.individual_tracking (individual_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: station_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS station_tracking_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT station_tracking_fk FOREIGN KEY (release_station_id)
REFERENCES tracking.station_tracking (station_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.probe_probe_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.probe_probe_id_seq CASCADE;
CREATE SEQUENCE tracking.probe_probe_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.probe_probe_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.probe | type: TABLE --
-- DROP TABLE IF EXISTS tracking.probe CASCADE;
CREATE TABLE tracking.probe (
	probe_id integer NOT NULL DEFAULT nextval('tracking.probe_probe_id_seq'::regclass),
	station_id integer NOT NULL,
	probe_code varchar NOT NULL,
	CONSTRAINT probe_pk PRIMARY KEY (probe_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.probe IS E'Probe used to record the environmental variables';
-- ddl-end --
COMMENT ON COLUMN tracking.probe.probe_code IS E'Code of the probe';
-- ddl-end --
ALTER TABLE tracking.probe OWNER TO filo;
-- ddl-end --

-- object: station_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe DROP CONSTRAINT IF EXISTS station_tracking_fk CASCADE;
ALTER TABLE tracking.probe ADD CONSTRAINT station_tracking_fk FOREIGN KEY (station_id)
REFERENCES tracking.station_tracking (station_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.probe_measure_probe_measure_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.probe_measure_probe_measure_id_seq CASCADE;
CREATE SEQUENCE tracking.probe_measure_probe_measure_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.probe_measure_probe_measure_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.probe_measure | type: TABLE --
-- DROP TABLE IF EXISTS tracking.probe_measure CASCADE;
CREATE TABLE tracking.probe_measure (
	probe_measure_id integer NOT NULL DEFAULT nextval('tracking.probe_measure_probe_measure_id_seq'::regclass),
	probe_id integer NOT NULL,
	parameter_measure_type_id integer NOT NULL,
	probe_measure_date timestamp NOT NULL,
	probe_measure_value double precision NOT NULL,
	CONSTRAINT probe_measure_pk PRIMARY KEY (probe_measure_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.probe_measure IS E'List of the measures recorded by a probe';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_measure.probe_measure_date IS E'Date-time of the record';
-- ddl-end --
COMMENT ON COLUMN tracking.probe_measure.probe_measure_value IS E'Value measured';
-- ddl-end --
ALTER TABLE tracking.probe_measure OWNER TO filo;
-- ddl-end --

-- object: probe_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe_measure DROP CONSTRAINT IF EXISTS probe_fk CASCADE;
ALTER TABLE tracking.probe_measure ADD CONSTRAINT probe_fk FOREIGN KEY (probe_id)
REFERENCES tracking.probe (probe_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.transmitter_type_transmitter_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.transmitter_type_transmitter_type_id_seq CASCADE;
CREATE SEQUENCE tracking.transmitter_type_transmitter_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.transmitter_type_transmitter_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.transmitter_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.transmitter_type CASCADE;
CREATE TABLE tracking.transmitter_type (
	transmitter_type_id integer NOT NULL DEFAULT nextval('tracking.transmitter_type_transmitter_type_id_seq'::regclass),
	transmitter_type_name varchar NOT NULL,
	characteristics varchar,
	technology varchar,
	CONSTRAINT transmitter_type_pk PRIMARY KEY (transmitter_type_id)

);
-- ddl-end --
COMMENT ON COLUMN tracking.transmitter_type.transmitter_type_name IS E'Code or name of the transmitter';
-- ddl-end --
COMMENT ON COLUMN tracking.transmitter_type.characteristics IS E'General characteristics of the transmitter';
-- ddl-end --
COMMENT ON COLUMN tracking.transmitter_type.technology IS E'Technology used by the transmitter';
-- ddl-end --
ALTER TABLE tracking.transmitter_type OWNER TO filo;
-- ddl-end --

-- object: transmitter_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS transmitter_type_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT transmitter_type_fk FOREIGN KEY (transmitter_type_id)
REFERENCES tracking.transmitter_type (transmitter_type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.position_position_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.position_position_id_seq CASCADE;
CREATE SEQUENCE tracking.position_position_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.position_position_id_seq OWNER TO filo;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES filo.project (project_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: import.import_description_import_description_id | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.import_description_import_description_id CASCADE;
CREATE SEQUENCE import.import_description_import_description_id
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.import_description_import_description_id OWNER TO filo;
-- ddl-end --

-- object: import.import_description | type: TABLE --
-- DROP TABLE IF EXISTS import.import_description CASCADE;
CREATE TABLE import.import_description (
	import_description_id integer NOT NULL DEFAULT nextval('import.import_description_import_description_id'::regclass),
	import_type_id integer NOT NULL,
	csv_type_id smallint NOT NULL,
	import_description_name varchar NOT NULL,
	separator varchar NOT NULL DEFAULT ';',
	first_line smallint,
	CONSTRAINT import_type_pk PRIMARY KEY (import_description_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_description IS E'Import templates';
-- ddl-end --
COMMENT ON COLUMN import.import_description.import_description_name IS E'Name of the description of the import';
-- ddl-end --
COMMENT ON COLUMN import.import_description.separator IS E'separator used between fields (; , tab, space)';
-- ddl-end --
COMMENT ON COLUMN import.import_description.first_line IS E'First line to treat in the file';
-- ddl-end --
ALTER TABLE import.import_description OWNER TO filo;
-- ddl-end --

-- object: import.csv_type | type: TABLE --
-- DROP TABLE IF EXISTS import.csv_type CASCADE;
CREATE TABLE import.csv_type (
	csv_type_id smallint NOT NULL,
	csv_type_name varchar NOT NULL,
	CONSTRAINT csv_type_pk PRIMARY KEY (csv_type_id)

);
-- ddl-end --
ALTER TABLE import.csv_type OWNER TO filo;
-- ddl-end --

INSERT INTO import.csv_type (csv_type_id, csv_type_name) VALUES (E'1', E'Data in columns: classic format for CSV');
-- ddl-end --
INSERT INTO import.csv_type (csv_type_id, csv_type_name) VALUES (E'2', E'Data in lines: format entity-relation');
-- ddl-end --

-- object: csv_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_description DROP CONSTRAINT IF EXISTS csv_type_fk CASCADE;
ALTER TABLE import.import_description ADD CONSTRAINT csv_type_fk FOREIGN KEY (csv_type_id)
REFERENCES import.csv_type (csv_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: import.column_er_column_er_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.column_er_column_er_id_seq CASCADE;
CREATE SEQUENCE import.column_er_column_er_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.column_er_column_er_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.import_column_import_column_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.import_column_import_column_id_seq CASCADE;
CREATE SEQUENCE import.import_column_import_column_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.import_column_import_column_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.import_column | type: TABLE --
-- DROP TABLE IF EXISTS import.import_column CASCADE;
CREATE TABLE import.import_column (
	import_column_id integer NOT NULL DEFAULT nextval('import.import_column_import_column_id_seq'::regclass),
	import_description_id integer NOT NULL,
	column_order smallint NOT NULL DEFAULT 1,
	table_column_name varchar,
	CONSTRAINT column_pk PRIMARY KEY (import_column_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_column IS E'List of all columns of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_column.column_order IS E'Place of the column in the file, from 1';
-- ddl-end --
COMMENT ON COLUMN import.import_column.table_column_name IS E'name of the attribute of the column in the database table';
-- ddl-end --
ALTER TABLE import.import_column OWNER TO filo;
-- ddl-end --

-- object: import_description_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_column DROP CONSTRAINT IF EXISTS import_description_fk CASCADE;
ALTER TABLE import.import_column ADD CONSTRAINT import_description_fk FOREIGN KEY (import_description_id)
REFERENCES import.import_description (import_description_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE filo.station DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE filo.station ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES filo.project (project_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: log_ip_idx | type: INDEX --
-- DROP INDEX IF EXISTS gacl.log_ip_idx CASCADE;
CREATE INDEX log_ip_idx ON gacl.log
	USING btree
	(
	  ipaddress
	);
-- ddl-end --


-- object: taxon_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.individual_tracking DROP CONSTRAINT IF EXISTS taxon_fk CASCADE;
ALTER TABLE tracking.individual_tracking ADD CONSTRAINT taxon_fk FOREIGN KEY (taxon_id)
REFERENCES filo.taxon (taxon_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: protocol_fk | type: CONSTRAINT --
-- ALTER TABLE filo.project DROP CONSTRAINT IF EXISTS protocol_fk CASCADE;
ALTER TABLE filo.project ADD CONSTRAINT protocol_fk FOREIGN KEY (protocol_default_id)
REFERENCES filo.protocol (protocol_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: import.function_type_function_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.function_type_function_type_id_seq CASCADE;
CREATE SEQUENCE import.function_type_function_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.function_type_function_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.function_type | type: TABLE --
-- DROP TABLE IF EXISTS import.function_type CASCADE;
CREATE TABLE import.function_type (
	function_type_id integer NOT NULL DEFAULT nextval('import.function_type_function_type_id_seq'::regclass),
	function_name varchar NOT NULL,
	description varchar NOT NULL,
	CONSTRAINT function_type_pk PRIMARY KEY (function_type_id)

);
-- ddl-end --
COMMENT ON TABLE import.function_type IS E'List of functions writed in the application, and usable to test or transform the data';
-- ddl-end --
COMMENT ON COLUMN import.function_type.function_name IS E'Name of the function. Must be the same in the application code';
-- ddl-end --
COMMENT ON COLUMN import.function_type.description IS E'Usage of the function';
-- ddl-end --
ALTER TABLE import.function_type OWNER TO filo;
-- ddl-end --

INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'1', E'testValue', E'Teste si un champ contient la valeur indiquée');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'2', E'getSecondsFromTime', E'Transforme un champ de type hh:mm:ss.u en ss.u');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'3', E'extractRightChar', E'Extrait les n caractères à droite du champ');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'4', E'formatDateTime', E'Transforme une datetime dans un format reconnu par la base de données, à partir du format indiqué. Exemple : d/m/Y H:i:s pour une date de type 13/01/2019 08:50:00. La liste des formats autorisés est disponible ici : https://www.php.net/manual/fr/datetime.createfromformat.php');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'5', E'concatenateDateAndTime', E'Concatène un champ date et un champ time. L''argument doit correspondre au numéro de la colonne time');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'6', E'transformJulianToDate', E'Transforme un nombre de jours depuis la date indiquée en référence (au format Y-m-d) en date exploitable au format Y-m-d');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'7', E'verifyTypeNumber', E'Vérifie si une valeur est numérique ou non');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'8', E'testColumnsNumber', E'Vérifie que le nombre de colonnes de la ligne courante correspond bien au nombre attendu');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'9', E'getIndividualFromTag', E'Récupère l''identifiant du poisson à partir du tag (RFID)');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'10', E'getIndividualFromTransmitter', E'Récupère l''identifiant du poisson à partir du transmetteur (radio ou acoustique)');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'11', E'numericToHexa', E'Transforme une valeur numérique en valeur Hexa, si celle-ci ne l''est pas. La valeur Hexa doit comprendre au moins une lettre. L''argument doit préciser le nombre de caractères attendus (multiple de 2) pour formater la chaine dans une zone de zéros');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'12', E'concatenate', E'Associe le contenu de colonnes ou du texte. L''argument doit etre au format JSON, sous la forme : [{"type":"col","val":4},{type:"str","val":":"}]');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'13', E'matchingCode', E'Remplace la valeur courante par une autre valeur, définie dans un argument JSON au format : {"valueSearched":correspondingValue, "2ndvalue":corresp2}. Pour la recherche des paramètres de sonde, valueSearched doit correspondre au libellé utilisé par la sonde, et correspondingValue à la valeur de la clé dans la table des paramètres');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'14', E'decodeAll', E'Transforme un jeu de caractère particulier en UTF-8. L''argument doit comprendre le jeu de caractère à transcoder, par exemple UTF-32');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'15', E'transformDecimalSeparator', E'Transforme la virgule en point, pour les champs décimaux en français');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'16', E'getIndividualFromCode', E'Récupère l''identifiant du poisson à partir de son code');
-- ddl-end --
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'17', E'getAntennaFromCode', E'Récupère l''antenne de détection à partir de son code');
-- ddl-end --

-- object: import.import_function_import_function_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.import_function_import_function_id_seq CASCADE;
CREATE SEQUENCE import.import_function_import_function_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.import_function_import_function_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.import_function | type: TABLE --
-- DROP TABLE IF EXISTS import.import_function CASCADE;
CREATE TABLE import.import_function (
	import_function_id integer NOT NULL DEFAULT nextval('import.import_function_import_function_id_seq'::regclass),
	import_description_id integer NOT NULL,
	function_type_id integer NOT NULL,
	column_number smallint NOT NULL DEFAULT 1,
	execution_order smallint NOT NULL DEFAULT 1,
	arguments varchar,
	column_result smallint,
	CONSTRAINT import_function_pk PRIMARY KEY (import_function_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_function IS E'List of functions to be performed for each row of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_function.column_number IS E'Number of the column, from 1 to n. If 0: entire row';
-- ddl-end --
COMMENT ON COLUMN import.import_function.execution_order IS E'Order of execution of the function';
-- ddl-end --
COMMENT ON COLUMN import.import_function.arguments IS E'Values of arguments, separated by a comma. Arguments are described in function_type.description';
-- ddl-end --
COMMENT ON COLUMN import.import_function.column_result IS E'Number of column that gets the result of the function, from 1 to n. Not used for control functions';
-- ddl-end --
ALTER TABLE import.import_function OWNER TO filo;
-- ddl-end --

-- object: import_description_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_function DROP CONSTRAINT IF EXISTS import_description_fk CASCADE;
ALTER TABLE import.import_function ADD CONSTRAINT import_description_fk FOREIGN KEY (import_description_id)
REFERENCES import.import_description (import_description_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: function_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_function DROP CONSTRAINT IF EXISTS function_type_fk CASCADE;
ALTER TABLE import.import_function ADD CONSTRAINT function_type_fk FOREIGN KEY (function_type_id)
REFERENCES import.function_type (function_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

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

-- object: import.import_type | type: TABLE --
-- DROP TABLE IF EXISTS import.import_type CASCADE;
CREATE TABLE import.import_type (
	import_type_id integer NOT NULL DEFAULT nextval('import.import_type_import_type_id_seq'::regclass),
	import_type_name varchar NOT NULL,
	tablename varchar,
	column_list varchar,
	CONSTRAINT import_type_pk_1 PRIMARY KEY (import_type_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_type IS E'List of types of import';
-- ddl-end --
COMMENT ON COLUMN import.import_type.tablename IS E'Name of the table to import into';
-- ddl-end --
COMMENT ON COLUMN import.import_type.column_list IS E'List of the columns used in the table to import into, separed by a comma';
-- ddl-end --
ALTER TABLE import.import_type OWNER TO filo;
-- ddl-end --

INSERT INTO import.import_type (import_type_id, import_type_name, tablename, column_list) VALUES (E'1', E'Detection', E'detection', E'individual_id,detection_date,nb_events,duration,signal_force,antenna_id');
-- ddl-end --
INSERT INTO import.import_type (import_type_id, import_type_name, tablename, column_list) VALUES (E'2', E'Probe data/données de sonde', E'probe_measure', E'probe_measure_date,probe_measure_value');
-- ddl-end --
INSERT INTO import.import_type (import_type_id, import_type_name, tablename, column_list) VALUES (E'3', E'Manual detection', E'location', E'individual_id,detection_date,signal_force,observation,location_long,location_lat,antenna_type_id');
-- ddl-end --

-- object: import.technology_technology_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.technology_technology_type_id_seq CASCADE;
CREATE SEQUENCE import.technology_technology_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 4
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.technology_technology_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.technology_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.technology_type CASCADE;
CREATE TABLE tracking.technology_type (
	technology_type_id integer NOT NULL DEFAULT nextval('import.technology_technology_type_id_seq'::regclass),
	technology_type_name varchar NOT NULL,
	CONSTRAINT technology_type_pk PRIMARY KEY (technology_type_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.technology_type IS E'Types of technologies used for detection';
-- ddl-end --
ALTER TABLE tracking.technology_type OWNER TO filo;
-- ddl-end --

INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'1', E'RFID');
-- ddl-end --
INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'2', E'Acoustic');
-- ddl-end --
INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'3', E'Radio');
-- ddl-end --

-- object: technology_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.antenna DROP CONSTRAINT IF EXISTS technology_type_fk CASCADE;
ALTER TABLE tracking.antenna ADD CONSTRAINT technology_type_fk FOREIGN KEY (technology_type_id)
REFERENCES tracking.technology_type (technology_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: import_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_description DROP CONSTRAINT IF EXISTS import_type_fk CASCADE;
ALTER TABLE import.import_description ADD CONSTRAINT import_type_fk FOREIGN KEY (import_type_id)
REFERENCES import.import_type (import_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: antenna_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS antenna_fk CASCADE;
ALTER TABLE tracking.detection ADD CONSTRAINT antenna_fk FOREIGN KEY (antenna_id)
REFERENCES tracking.antenna (antenna_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.location_location_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.location_location_id_seq CASCADE;
CREATE SEQUENCE tracking.location_location_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.location_location_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.location | type: TABLE --
-- DROP TABLE IF EXISTS tracking.location CASCADE;
CREATE TABLE tracking.location (
	location_id integer NOT NULL DEFAULT nextval('tracking.location_location_id_seq'::regclass),
	antenna_type_id integer,
	individual_id integer NOT NULL,
	detection_date timestamp NOT NULL,
	location_pk float,
	location_long double precision,
	location_lat double precision,
	signal_force smallint,
	observation varchar,
	geom geometry(POINT, 4326),
	CONSTRAINT location_pk PRIMARY KEY (location_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.location IS E'List of locations of manual detections';
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
ALTER TABLE tracking.location OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna_type_antenna_type_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.antenna_type_antenna_type_id_seq CASCADE;
CREATE SEQUENCE tracking.antenna_type_antenna_type_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.antenna_type_antenna_type_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna_type | type: TABLE --
-- DROP TABLE IF EXISTS tracking.antenna_type CASCADE;
CREATE TABLE tracking.antenna_type (
	antenna_type_id integer NOT NULL DEFAULT nextval('tracking.antenna_type_antenna_type_id_seq'::regclass),
	antenna_type_name varchar NOT NULL,
	CONSTRAINT antenna_type_pk PRIMARY KEY (antenna_type_id)

);
-- ddl-end --
ALTER TABLE tracking.antenna_type OWNER TO filo;
-- ddl-end --

-- object: antenna_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.location DROP CONSTRAINT IF EXISTS antenna_type_fk CASCADE;
ALTER TABLE tracking.location ADD CONSTRAINT antenna_type_fk FOREIGN KEY (antenna_type_id)
REFERENCES tracking.antenna_type (antenna_type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.antenna_event_antenna_event_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS tracking.antenna_event_antenna_event_id_seq CASCADE;
CREATE SEQUENCE tracking.antenna_event_antenna_event_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE tracking.antenna_event_antenna_event_id_seq OWNER TO filo;
-- ddl-end --

-- object: tracking.antenna_event | type: TABLE --
-- DROP TABLE IF EXISTS tracking.antenna_event CASCADE;
CREATE TABLE tracking.antenna_event (
	antenna_event_id integer NOT NULL DEFAULT nextval('tracking.antenna_event_antenna_event_id_seq'::regclass),
	antenna_id integer NOT NULL,
	date_start timestamp,
	date_end timestamp,
	comment varchar,
	CONSTRAINT antenna_event_pk PRIMARY KEY (antenna_event_id)

);
-- ddl-end --
COMMENT ON TABLE tracking.antenna_event IS E'Events occured on an antenna';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.date_start IS E'Start datetime of the event';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.date_end IS E'End datetime of the event';
-- ddl-end --
COMMENT ON COLUMN tracking.antenna_event.comment IS E'Event occurred';
-- ddl-end --
ALTER TABLE tracking.antenna_event OWNER TO filo;
-- ddl-end --

-- object: antenna_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.antenna_event DROP CONSTRAINT IF EXISTS antenna_fk CASCADE;
ALTER TABLE tracking.antenna_event ADD CONSTRAINT antenna_fk FOREIGN KEY (antenna_id)
REFERENCES tracking.antenna (antenna_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

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
COMMENT ON TABLE tracking.parameter_measure_type IS E'Types of parameters used with probes';
-- ddl-end --
COMMENT ON COLUMN tracking.parameter_measure_type.parameter IS E'Normalized measured parameter (O2, TEMP, etc.)';
-- ddl-end --
COMMENT ON COLUMN tracking.parameter_measure_type.unit IS E'Unit of the parameter';
-- ddl-end --
ALTER TABLE tracking.parameter_measure_type OWNER TO filo;
-- ddl-end --

-- object: parameter_measure_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.probe_measure DROP CONSTRAINT IF EXISTS parameter_measure_type_fk CASCADE;
ALTER TABLE tracking.probe_measure ADD CONSTRAINT parameter_measure_type_fk FOREIGN KEY (parameter_measure_type_id)
REFERENCES tracking.parameter_measure_type (parameter_measure_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.v_station_tracking | type: VIEW --
-- DROP VIEW IF EXISTS tracking.v_station_tracking CASCADE;
CREATE VIEW tracking.v_station_tracking
AS 

SELECT
   station_id, station_name, station_long, station_lat, station_pk, geom
,station_type_id, station_type_name
,project_id, project_name

FROM
   tracking.station_tracking
join filo.station using (station_id)
join tracking.station_type using (station_type_id)
join filo.project using (project_id);
-- ddl-end --
COMMENT ON VIEW tracking.v_station_tracking IS E'List of stations used for tracking, with geom object';
-- ddl-end --
ALTER VIEW tracking.v_station_tracking OWNER TO filo;
-- ddl-end --

-- object: tracking.v_individual_tracking | type: VIEW --
-- DROP VIEW IF EXISTS tracking.v_individual_tracking CASCADE;
CREATE VIEW tracking.v_individual_tracking
AS 

SELECT
   individual_id, scientific_name, taxon_id
,tag, transmitter
,project.project_id, project_name
,transmitter_type_name, transmitter_type_id
,station_name as release_station_name, release_station_id
FROM
   filo.individual
join tracking.individual_tracking using (individual_id)
join filo.taxon using (taxon_id)
join filo.project using (project_id)
left outer join tracking.transmitter_type using (transmitter_type_id)
left outer join tracking.station_tracking st on (st.station_id = release_station_id)
left outer join filo.station on (st.station_id = station.station_id);
-- ddl-end --
COMMENT ON VIEW tracking.v_individual_tracking IS E'View of the fishes tracked';
-- ddl-end --
ALTER VIEW tracking.v_individual_tracking OWNER TO filo;
-- ddl-end --

-- object: individual_tracking_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.location DROP CONSTRAINT IF EXISTS individual_tracking_fk CASCADE;
ALTER TABLE tracking.location ADD CONSTRAINT individual_tracking_fk FOREIGN KEY (individual_id)
REFERENCES tracking.individual_tracking (individual_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: tracking.v_station_tracking_update | type: FUNCTION --
-- DROP FUNCTION IF EXISTS tracking.v_station_tracking_update() CASCADE;
CREATE FUNCTION tracking.v_station_tracking_update ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
update filo.station set geom = NEW.geom,
station_long = NEW.station_long,
station_lat = NEW.station_lat,
station_pk = NEW.station_pk,
station_name = NEW.station_name
where station_id = NEW.station_id ;
return null;
END;
$$;
-- ddl-end --
ALTER FUNCTION tracking.v_station_tracking_update() OWNER TO filo;
-- ddl-end --

-- object: v_station_tracking_update | type: TRIGGER --
-- DROP TRIGGER IF EXISTS v_station_tracking_update ON tracking.v_station_tracking CASCADE;
CREATE TRIGGER v_station_tracking_update
	INSTEAD OF UPDATE
	ON tracking.v_station_tracking
	FOR EACH ROW
	EXECUTE PROCEDURE tracking.v_station_tracking_update();
-- ddl-end --

-- object: tracking.v_station_tracking_insert | type: FUNCTION --
-- DROP FUNCTION IF EXISTS tracking.v_station_tracking_insert() CASCADE;
CREATE FUNCTION tracking.v_station_tracking_insert ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
insert into filo.station (station_name, project_id, station_long, station_lat, station_pk, geom)
values (NEW.station_name, NEW.project_id, NEW.station_long, NEW.station_lat, NEW.station_pk,NEW.geom);
insert into tracking.station_tracking (station_id, station_type_id) values (lastval(), NEW.station_type_id);
return null;
END;
$$;
-- ddl-end --
ALTER FUNCTION tracking.v_station_tracking_insert() OWNER TO filo;
-- ddl-end --

-- object: v_station_tracking_insert | type: TRIGGER --
-- DROP TRIGGER IF EXISTS v_station_tracking_insert ON tracking.v_station_tracking CASCADE;
CREATE TRIGGER v_station_tracking_insert
	INSTEAD OF INSERT 
	ON tracking.v_station_tracking
	FOR EACH ROW
	EXECUTE PROCEDURE tracking.v_station_tracking_insert();
-- ddl-end --

-- object: tracking.v_antenna | type: VIEW --
-- DROP VIEW IF EXISTS tracking.v_antenna CASCADE;
CREATE VIEW tracking.v_antenna
AS 

SELECT
   antenna_id, station_id, technology_type_id
,antenna_code, radius, geom_polygon
,technology_type_name
,station_type_id, station_type_name
,project_id, project_name, metric_srid
,station_name,station_long, station_lat, station_pk
,geom
FROM
   tracking.antenna
join tracking.technology_type using (technology_type_id)
join tracking.station_tracking using (station_id)
join filo.station using (station_id)
join filo.project using(project_id)
join tracking.station_type using (station_type_id);
-- ddl-end --
ALTER VIEW tracking.v_antenna OWNER TO filo;
-- ddl-end --

-- object: tracking.v_antenna_update | type: FUNCTION --
-- DROP FUNCTION IF EXISTS tracking.v_antenna_update() CASCADE;
CREATE FUNCTION tracking.v_antenna_update ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
if NEW.radius > 0 then
update tracking.antenna set geom_polygon = 
st_transform (
	st_buffer ( 
		st_transform (
		  st_setsrid(st_point(new.station_long, new.station_lat),4326)
		,new.metric_srid)
      , new.radius)
,4326),
radius = new.radius,
station_id = new.station_id,
technology_type_id = new.technology_type_id
where antenna_id = new.antenna_id;
END IF;
return null;
END;
$$;
-- ddl-end --
ALTER FUNCTION tracking.v_antenna_update() OWNER TO filo;
-- ddl-end --

-- object: v_antenna_update | type: TRIGGER --
-- DROP TRIGGER IF EXISTS v_antenna_update ON tracking.v_antenna CASCADE;
CREATE TRIGGER v_antenna_update
	INSTEAD OF UPDATE
	ON tracking.v_antenna
	FOR EACH ROW
	EXECUTE PROCEDURE tracking.v_antenna_update();
-- ddl-end --

-- object: tracking.v_detection_location | type: VIEW --
-- DROP VIEW IF EXISTS tracking.v_detection_location CASCADE;
CREATE VIEW tracking.v_detection_location
AS 

SELECT
   detection_id as id, individual_id, detection_date
	, nb_events, duration, validity, signal_force, observation
	,station_long long, station_lat lat, station_name, station_pk as pk
	,antenna_code, technology_type_name as antenna_type
	,geom
	,'stationary' as detection_type
from tracking.detection
	join tracking.antenna using (antenna_id)
	join filo.station using (station_id)
	left outer join tracking.technology_type using (technology_type_id)
union
select location_id as id, individual_id, detection_date
	, null nb_events, null duration, true validity, signal_force, observation
	, location_long, location_lat, null station_name, location_pk as pk
	,null as antenna_code, antenna_type_name as antenna_type
	,geom
	,'mobile' as detection_type
from tracking.location 
	left outer join tracking.antenna_type using (antenna_type_id);
-- ddl-end --
COMMENT ON VIEW tracking.v_detection_location IS E'List of all detections and locations for a fish';
-- ddl-end --
ALTER VIEW tracking.v_detection_location OWNER TO filo;
-- ddl-end --

-- object: import.export_model_export_model_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS import.export_model_export_model_id_seq CASCADE;
CREATE SEQUENCE import.export_model_export_model_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE import.export_model_export_model_id_seq OWNER TO filo;
-- ddl-end --

-- object: import.export_model | type: TABLE --
-- DROP TABLE IF EXISTS import.export_model CASCADE;
CREATE TABLE import.export_model (
	export_model_id integer NOT NULL DEFAULT nextval('import.export_model_export_model_id_seq'::regclass),
	export_model_name varchar NOT NULL,
	pattern json,
	CONSTRAINT export_model_pk PRIMARY KEY (export_model_id)

);
-- ddl-end --
COMMENT ON TABLE import.export_model IS E'Structure of an export/import of table data';
-- ddl-end --
COMMENT ON COLUMN import.export_model.export_model_name IS E'Name of the structure of export';
-- ddl-end --
COMMENT ON COLUMN import.export_model.pattern IS E'Pattern of the export/import.\nStructure:\n[{technicalKey:string,businessKey:string,tableName:string,tableAlias:string,children[table1,table2],parentKey:string,secondaryParentKey:string}]';
-- ddl-end --
ALTER TABLE import.export_model OWNER TO filo;
-- ddl-end --

INSERT INTO import.export_model (export_model_name, pattern) VALUES (E'operation', E'[{"tableName":"operation","technicalKey":"operation_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["freshwater"],"children":[{"aliasName":"sequence","isStrict":false},{"aliasName":"operationAmbience","isStrict":false},{"aliasName":"operation_operator","isStrict":false}],"parameters":[{"aliasName":"station","fieldName":"station_id"},{"aliasName":"protocol","fieldName":"protocol_id"},{"aliasName":"water_regime","fieldName":"water_regime_id"},{"aliasName":"fishing_strategy","fieldName":"fishing_strategy_id"},{"aliasName":"scale","fieldName":"scale_id"},{"aliasName":"taxa_template","fieldName":"taxa_template_id"}],"istablenn":false},{"tableName":"sequence","technicalKey":"sequence_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"sequenceAmbience","isStrict":false},{"aliasName":"sequence_gear","isStrict":false},{"aliasName":"analysis","isStrict":false},{"aliasName":"sample","isStrict":false}],"parameters":[],"istablenn":false},{"tableName":"operation_operator","isEmpty":false,"parentKey":"operation_id","istable11":false,"booleanFields":["is_responsible"],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"operator_id","tableAlias":"operator"}},{"tableName":"operator","technicalKey":"operator_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[],"istablenn":false},{"tableName":"ambience","tableAlias":"operationAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"ambience","tableAlias":"sequenceAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"sample","technicalKey":"sample_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"individual","isStrict":false}],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"sequence_gear","technicalKey":"sequence_gear_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"gear","fieldName":"gear_id"},{"aliasName":"gear_method","fieldName":"gear_method_id"},{"aliasName":"electric_current_type","fieldName":"electric_current_type_id"}],"istablenn":false},{"tableName":"analysis","technicalKey":"analysis_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"individual","technicalKey":"individual_id","isEmpty":false,"businessKey":"uuid","parentKey":"sample_id","istable11":false,"booleanFields":["measure_estimated"],"children":[{"aliasName":"individual_tracking","isStrict":false}],"parameters":[{"aliasName":"sexe","fieldName":"sexe_id"},{"aliasName":"pathology","fieldName":"pathology_id"}],"istablenn":false},{"tableName":"individual_tracking","technicalKey":"individual_id","isEmpty":false,"parentKey":"individual_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"transmitter_type","fieldName":"transmitter_type_id"},{"aliasName":"taxon","fieldName":"taxon_id"},{"aliasName":"project","fieldName":"project_id"},{"aliasName":"station","fieldName":"release_station_id"}],"istablenn":false},{"tableName":"station","technicalKey":"station_id","isEmpty":true,"businessKey":"station_name","istable11":false,"booleanFields":[],"children":[{"aliasName":"station_tracking","isStrict":false}],"parameters":[{"aliasName":"river","fieldName":"river_id"},{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"station_tracking","technicalKey":"station_id","isEmpty":false,"parentKey":"station_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"station_type","fieldName":"station_type_id"}],"istablenn":false},{"tableName":"station_type","technicalKey":"station_type_id","isEmpty":true,"businessKey":"station_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[],"parameters":[{"aliasName":"analyse_template","fieldName":"analyse_template_id"}],"istablenn":false},{"tableName":"analyse_template","technicalKey":"analyse_template_id","isEmpty":true,"businessKey":"analyse_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"water_regime","technicalKey":"water_regime_id","isEmpty":true,"businessKey":"water_regime_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"fishing_strategy","technicalKey":"fishing_strategy_id","isEmpty":true,"businessKey":"fishing_strategy_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"scale","technicalKey":"scale_id","isEmpty":true,"businessKey":"scale_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxa_template","technicalKey":"taxa_template_id","isEmpty":true,"businessKey":"taxa_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"facies","technicalKey":"facies_id","isEmpty":true,"businessKey":"facies_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"situation","technicalKey":"situation_id","isEmpty":true,"businessKey":"situation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"speed","technicalKey":"speed_id","isEmpty":true,"businessKey":"speed_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"shady","technicalKey":"shady_id","isEmpty":true,"businessKey":"shady_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"localisation","technicalKey":"localisation_id","isEmpty":true,"businessKey":"localisation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"granulometry","technicalKey":"granulometry_id","isEmpty":true,"businessKey":"granulometry_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"cache_abundance","technicalKey":"cache_abundance_id","isEmpty":true,"businessKey":"cache_abundance_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"clogging","technicalKey":"clogging_id","isEmpty":true,"businessKey":"clogging_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sinuosity","technicalKey":"sinuosity_id","isEmpty":true,"businessKey":"sinuosity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"flow_trend","technicalKey":"flow_trend_id","isEmpty":true,"businessKey":"flow_trend_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"turbidity","technicalKey":"turbidity_id","isEmpty":true,"businessKey":"turbidity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"river","technicalKey":"river_id","isEmpty":true,"businessKey":"river_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear","technicalKey":"gear_id","isEmpty":true,"businessKey":"gear_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear_method","technicalKey":"gear_method_id","isEmpty":true,"businessKey":"gear_method_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"electric_current_type","technicalKey":"electric_current_type_id","isEmpty":true,"businessKey":"electric_current_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sexe","technicalKey":"sexe_id","isEmpty":true,"businessKey":"sexe_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"vegetation","technicalKey":"vegetation_id","isEmpty":true,"businessKey":"vegetation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"pathology","technicalKey":"pathology_id","isEmpty":true,"businessKey":"pathology_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"transmitter_type","technicalKey":"transmitter_type_id","isEmpty":true,"businessKey":"transmitter_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]');
-- ddl-end --
INSERT INTO import.export_model (export_model_name, pattern) VALUES (E'campaign', E'[{"tableName":"campaign","technicalKey":"campaign_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":[],"children":[{"aliasName":"operation","isStrict":false}],"parameters":[{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"operation","technicalKey":"operation_id","isEmpty":false,"businessKey":"uuid","parentKey":"campaign_id","istable11":false,"booleanFields":["freshwater"],"children":[{"aliasName":"sequence","isStrict":false},{"aliasName":"operationAmbience","isStrict":false},{"aliasName":"operation_operator","isStrict":false}],"parameters":[{"aliasName":"station","fieldName":"station_id"},{"aliasName":"protocol","fieldName":"protocol_id"},{"aliasName":"water_regime","fieldName":"water_regime_id"},{"aliasName":"fishing_strategy","fieldName":"fishing_strategy_id"},{"aliasName":"scale","fieldName":"scale_id"},{"aliasName":"taxa_template","fieldName":"taxa_template_id"}],"istablenn":false},{"tableName":"sequence","technicalKey":"sequence_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"sequenceAmbience","isStrict":false},{"aliasName":"sequence_gear","isStrict":false},{"aliasName":"analysis","isStrict":false},{"aliasName":"sample","isStrict":false}],"parameters":[],"istablenn":false},{"tableName":"operation_operator","isEmpty":false,"parentKey":"operation_id","istable11":false,"booleanFields":["is_responsible"],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"operator_id","tableAlias":"operator"}},{"tableName":"operator","technicalKey":"operator_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[],"istablenn":false},{"tableName":"ambience","tableAlias":"operationAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"operation_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"ambience","tableAlias":"sequenceAmbience","technicalKey":"ambience_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"facies","fieldName":"facies_id"},{"aliasName":"situation","fieldName":"situation_id"},{"aliasName":"speed","fieldName":"speed_id"},{"aliasName":"shady","fieldName":"shady_id"},{"aliasName":"localisation","fieldName":"localisation_id"},{"aliasName":"vegetation","fieldName":"vegetation_id"},{"aliasName":"granulometry","fieldName":"dominant_granulometry_id"},{"aliasName":"granulometry","fieldName":"secondary_granulometry_id"},{"aliasName":"cache_abundance","fieldName":"herbarium_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"branch_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"vegetation_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"subbank_cache_abundance_id"},{"aliasName":"cache_abundance","fieldName":"granulometry_cache_abundance_id"},{"aliasName":"clogging","fieldName":"clogging_id"},{"aliasName":"sinuosity","fieldName":"sinuosity_id"},{"aliasName":"flow_trend","fieldName":"flow_trend_id"},{"aliasName":"turbidity","fieldName":"turbidity_id"}],"istablenn":false},{"tableName":"sample","technicalKey":"sample_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[{"aliasName":"individual","isStrict":false}],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"sequence_gear","technicalKey":"sequence_gear_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"gear","fieldName":"gear_id"},{"aliasName":"gear_method","fieldName":"gear_method_id"},{"aliasName":"electric_current_type","fieldName":"electric_current_type_id"}],"istablenn":false},{"tableName":"analysis","technicalKey":"analysis_id","isEmpty":false,"businessKey":"uuid","parentKey":"sequence_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"individual","technicalKey":"individual_id","isEmpty":false,"businessKey":"uuid","parentKey":"sample_id","istable11":false,"booleanFields":["measure_estimated"],"children":[{"aliasName":"individual_tracking","isStrict":false}],"parameters":[{"aliasName":"sexe","fieldName":"sexe_id"},{"aliasName":"pathology","fieldName":"pathology_id"}],"istablenn":false},{"tableName":"individual_tracking","technicalKey":"individual_id","isEmpty":false,"parentKey":"individual_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"transmitter_type","fieldName":"transmitter_type_id"},{"aliasName":"taxon","fieldName":"taxon_id"},{"aliasName":"project","fieldName":"project_id"},{"aliasName":"station","fieldName":"release_station_id"}],"istablenn":false},{"tableName":"station","technicalKey":"station_id","isEmpty":true,"businessKey":"station_name","istable11":false,"booleanFields":[],"children":[{"aliasName":"station_tracking","isStrict":false}],"parameters":[{"aliasName":"river","fieldName":"river_id"},{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"station_tracking","technicalKey":"station_id","isEmpty":false,"parentKey":"station_id","istable11":true,"booleanFields":[],"children":[],"parameters":[{"aliasName":"station_type","fieldName":"station_type_id"}],"istablenn":false},{"tableName":"station_type","technicalKey":"station_type_id","isEmpty":true,"businessKey":"station_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[],"parameters":[{"aliasName":"analyse_template","fieldName":"analyse_template_id"}],"istablenn":false},{"tableName":"analyse_template","technicalKey":"analyse_template_id","isEmpty":true,"businessKey":"analyse_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"water_regime","technicalKey":"water_regime_id","isEmpty":true,"businessKey":"water_regime_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"fishing_strategy","technicalKey":"fishing_strategy_id","isEmpty":true,"businessKey":"fishing_strategy_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"scale","technicalKey":"scale_id","isEmpty":true,"businessKey":"scale_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxa_template","technicalKey":"taxa_template_id","isEmpty":true,"businessKey":"taxa_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"facies","technicalKey":"facies_id","isEmpty":true,"businessKey":"facies_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"situation","technicalKey":"situation_id","isEmpty":true,"businessKey":"situation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"speed","technicalKey":"speed_id","isEmpty":true,"businessKey":"speed_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"shady","technicalKey":"shady_id","isEmpty":true,"businessKey":"shady_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"localisation","technicalKey":"localisation_id","isEmpty":true,"businessKey":"localisation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"granulometry","technicalKey":"granulometry_id","isEmpty":true,"businessKey":"granulometry_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"cache_abundance","technicalKey":"cache_abundance_id","isEmpty":true,"businessKey":"cache_abundance_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"clogging","technicalKey":"clogging_id","isEmpty":true,"businessKey":"clogging_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sinuosity","technicalKey":"sinuosity_id","isEmpty":true,"businessKey":"sinuosity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"flow_trend","technicalKey":"flow_trend_id","isEmpty":true,"businessKey":"flow_trend_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"turbidity","technicalKey":"turbidity_id","isEmpty":true,"businessKey":"turbidity_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"river","technicalKey":"river_id","isEmpty":true,"businessKey":"river_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear","technicalKey":"gear_id","isEmpty":true,"businessKey":"gear_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"gear_method","technicalKey":"gear_method_id","isEmpty":true,"businessKey":"gear_method_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"electric_current_type","technicalKey":"electric_current_type_id","isEmpty":true,"businessKey":"electric_current_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"sexe","technicalKey":"sexe_id","isEmpty":true,"businessKey":"sexe_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"vegetation","technicalKey":"vegetation_id","isEmpty":true,"businessKey":"vegetation_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"pathology","technicalKey":"pathology_id","isEmpty":true,"businessKey":"pathology_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"transmitter_type","technicalKey":"transmitter_type_id","isEmpty":true,"businessKey":"transmitter_type_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]');
-- ddl-end --
INSERT INTO import.export_model (export_model_name, pattern) VALUES (E'export_model', E'[{"tableName":"export_model","businessKey":"export_model_name","istable11":false,"children":[],"booleanFields":[],"istablenn":false}]');
-- ddl-end --
INSERT INTO import.export_model (export_model_name, pattern) VALUES (E'campaignOnly', E'[{"tableName":"campaign","technicalKey":"campaign_id","isEmpty":false,"businessKey":"uuid","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"project","fieldName":"project_id"}],"istablenn":false},{"tableName":"project","technicalKey":"project_id","isEmpty":true,"businessKey":"project_name","istable11":false,"booleanFields":["is_active"],"children":[],"parameters":[{"aliasName":"protocol","fieldName":"protocol_default_id"}],"istablenn":false},{"tableName":"protocol","technicalKey":"protocol_id","isEmpty":true,"businessKey":"protocol_name","istable11":false,"booleanFields":["measure_default_only"],"children":[{"aliasName":"protocol_measure","isStrict":true}],"parameters":[{"aliasName":"analysis_template","fieldName":"analysis_template_id"}],"istablenn":false},{"tableName":"analysis_template","technicalKey":"analysis_template_id","isEmpty":true,"businessKey":"analysis_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false},{"tableName":"measure_template","technicalKey":"measure_template_id","isEmpty":false,"businessKey":"measure_template_name","istable11":false,"booleanFields":[],"children":[],"parameters":[{"aliasName":"taxon","fieldName":"taxon_id"}],"istablenn":false},{"tableName":"protocol_measure","isEmpty":false,"parentKey":"protocol_id","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":true,"tablenn":{"secondaryParentKey":"measure_template_id","tableAlias":"measure_template"}},{"tableName":"taxon","technicalKey":"taxon_id","isEmpty":true,"businessKey":"scientific_name","istable11":false,"booleanFields":[],"children":[],"parameters":[],"istablenn":false}]');
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
COMMENT ON COLUMN filo.sequence_point.fish_number IS E'Number of fishes detected at this point';
-- ddl-end --
ALTER TABLE filo.sequence_point OWNER TO filo;
-- ddl-end --

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

-- object: filo.request_request_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS filo.request_request_id_seq CASCADE;
CREATE SEQUENCE filo.request_request_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE filo.request_request_id_seq OWNER TO filo;
-- ddl-end --

-- object: filo.request | type: TABLE --
-- DROP TABLE IF EXISTS filo.request CASCADE;
CREATE TABLE filo.request (
	request_id integer NOT NULL DEFAULT nextval('filo.request_request_id_seq'::regclass),
	create_date timestamp NOT NULL,
	last_exec timestamp,
	title character varying NOT NULL,
	body character varying NOT NULL,
	login character varying NOT NULL,
	datefields character varying,
	CONSTRAINT request_pk PRIMARY KEY (request_id)

);
-- ddl-end --
COMMENT ON TABLE filo.request IS E'Request table in database';
-- ddl-end --
COMMENT ON COLUMN filo.request.create_date IS E'Date of create of the request';
-- ddl-end --
COMMENT ON COLUMN filo.request.last_exec IS E'Date of the last execution';
-- ddl-end --
COMMENT ON COLUMN filo.request.title IS E'Title of the request';
-- ddl-end --
COMMENT ON COLUMN filo.request.body IS E'Body of the request. Don''t begin it by SELECT, which will be added automatically';
-- ddl-end --
COMMENT ON COLUMN filo.request.login IS E'Login of the creator of the request';
-- ddl-end --
COMMENT ON COLUMN filo.request.datefields IS E'List of the date fields used in the request, separated by a comma, for format it';
-- ddl-end --
ALTER TABLE filo.request OWNER TO filo;
-- ddl-end --

INSERT INTO filo.request (create_date, last_exec, title, body, login, datefields) VALUES (now(), DEFAULT, E'Number of operations by campaign', E'campaign_name, count(*) as operations_nb from campaign join operation using (campaign_id) group by campaign_name', E'admin', DEFAULT);
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

-- object: ambience_template_fk | type: CONSTRAINT --
-- ALTER TABLE filo.protocol DROP CONSTRAINT IF EXISTS ambience_template_fk CASCADE;
ALTER TABLE filo.protocol ADD CONSTRAINT ambience_template_fk FOREIGN KEY (ambience_template_id)
REFERENCES filo.ambience_template (ambience_template_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE DEFERRABLE INITIALLY IMMEDIATE;
-- ddl-end --

-- object: aclaco_aclacl_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.aclacl DROP CONSTRAINT IF EXISTS aclaco_aclacl_fk CASCADE;
ALTER TABLE gacl.aclacl ADD CONSTRAINT aclaco_aclacl_fk FOREIGN KEY (aclaco_id)
REFERENCES gacl.aclaco (aclaco_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_aclacl_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.aclacl DROP CONSTRAINT IF EXISTS aclgroup_aclacl_fk CASCADE;
ALTER TABLE gacl.aclacl ADD CONSTRAINT aclgroup_aclacl_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclappli_aclaco_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.aclaco DROP CONSTRAINT IF EXISTS aclappli_aclaco_fk CASCADE;
ALTER TABLE gacl.aclaco ADD CONSTRAINT aclappli_aclaco_fk FOREIGN KEY (aclappli_id)
REFERENCES gacl.aclappli (aclappli_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.aclgroup DROP CONSTRAINT IF EXISTS aclgroup_aclgroup_fk CASCADE;
ALTER TABLE gacl.aclgroup ADD CONSTRAINT aclgroup_aclgroup_fk FOREIGN KEY (aclgroup_id_parent)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: aclgroup_acllogingroup_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.acllogingroup DROP CONSTRAINT IF EXISTS aclgroup_acllogingroup_fk CASCADE;
ALTER TABLE gacl.acllogingroup ADD CONSTRAINT aclgroup_acllogingroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: acllogin_acllogingroup_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.acllogingroup DROP CONSTRAINT IF EXISTS acllogin_acllogingroup_fk CASCADE;
ALTER TABLE gacl.acllogingroup ADD CONSTRAINT acllogin_acllogingroup_fk FOREIGN KEY (acllogin_id)
REFERENCES gacl.acllogin (acllogin_id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


