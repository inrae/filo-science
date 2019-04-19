-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2-beta
-- PostgreSQL version: 9.6
-- Project Site: pgmodeler.io
-- Model Author: ---

-- -- object: measfish | type: ROLE --
-- -- DROP ROLE IF EXISTS measfish;
-- CREATE ROLE measfish WITH ;
-- -- ddl-end --
-- 

-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: measfish | type: DATABASE --
-- -- DROP DATABASE IF EXISTS measfish;
-- CREATE DATABASE measfish;
-- -- ddl-end --
-- COMMENT ON DATABASE measfish IS 'Recording of measurements taken during scientific fisheries';
-- -- ddl-end --
-- 

-- object: measfish | type: SCHEMA --
-- DROP SCHEMA IF EXISTS measfish CASCADE;
CREATE SCHEMA measfish;
-- ddl-end --
ALTER SCHEMA measfish OWNER TO measfish;
-- ddl-end --
COMMENT ON SCHEMA measfish IS 'Scientific fisheries management - schema of data';
-- ddl-end --

-- object: gacl | type: SCHEMA --
-- DROP SCHEMA IF EXISTS gacl CASCADE;
CREATE SCHEMA gacl;
-- ddl-end --
ALTER SCHEMA gacl OWNER TO measfish;
-- ddl-end --

SET search_path TO pg_catalog,public,measfish,gacl;
-- ddl-end --

-- object: measfish.project_project_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.project_project_id_seq CASCADE;
CREATE SEQUENCE measfish.project_project_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.project_project_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.campaign_campaign_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.campaign_campaign_id_seq CASCADE;
CREATE SEQUENCE measfish.campaign_campaign_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.campaign_campaign_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.project | type: TABLE --
-- DROP TABLE IF EXISTS measfish.project CASCADE;
CREATE TABLE measfish.project (
	project_id integer NOT NULL DEFAULT nextval('measfish.project_project_id_seq'::regclass),
	project_name varchar NOT NULL,
	CONSTRAINT project_id_pk PRIMARY KEY (project_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.project IS 'List of projects. This table is used for grant rights';
-- ddl-end --
COMMENT ON COLUMN measfish.project.project_name IS 'Name of the project';
-- ddl-end --
ALTER TABLE measfish.project OWNER TO measfish;
-- ddl-end --

-- object: measfish.campaign | type: TABLE --
-- DROP TABLE IF EXISTS measfish.campaign CASCADE;
CREATE TABLE measfish.campaign (
	campaign_id integer NOT NULL DEFAULT nextval('measfish.campaign_campaign_id_seq'::regclass),
	project_id integer NOT NULL,
	campaign_name varchar NOT NULL,
	CONSTRAINT campaign_id_pk PRIMARY KEY (campaign_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.campaign IS 'List of campaigns rattached to a project';
-- ddl-end --
COMMENT ON COLUMN measfish.campaign.campaign_name IS 'Name of the campaign';
-- ddl-end --
ALTER TABLE measfish.campaign OWNER TO measfish;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.campaign DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE measfish.campaign ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES measfish.project (project_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.station_station_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.station_station_id_seq CASCADE;
CREATE SEQUENCE measfish.station_station_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.station_station_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.operation_operation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.operation_operation_id_seq CASCADE;
CREATE SEQUENCE measfish.operation_operation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.operation_operation_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.place_place_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.place_place_id_seq CASCADE;
CREATE SEQUENCE measfish.place_place_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.place_place_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.station | type: TABLE --
-- DROP TABLE IF EXISTS measfish.station CASCADE;
CREATE TABLE measfish.station (
	station_id integer NOT NULL DEFAULT nextval('measfish.station_station_id_seq'::regclass),
	station_name varchar NOT NULL,
	project_id integer,
	station_long double precision,
	station_lat double precision,
	station_pk smallint,
	station_code varchar,
	river_id integer,
	CONSTRAINT station_id_pk PRIMARY KEY (station_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.station IS 'List of the stations used for a project';
-- ddl-end --
COMMENT ON COLUMN measfish.station.station_name IS 'Name of the station';
-- ddl-end --
COMMENT ON COLUMN measfish.station.station_long IS 'Longitude of the station, in WGS84, numeric value';
-- ddl-end --
COMMENT ON COLUMN measfish.station.station_lat IS 'Latitude of the station, in WGS84, numeric value';
-- ddl-end --
COMMENT ON COLUMN measfish.station.station_pk IS 'Kilometer point from source, in meters';
-- ddl-end --
COMMENT ON COLUMN measfish.station.station_code IS 'Code of the station, according to the nomenclature sandre.eaufrance.fr';
-- ddl-end --
ALTER TABLE measfish.station OWNER TO measfish;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.station DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE measfish.station ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES measfish.project (project_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.taxon_taxon_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.taxon_taxon_id_seq CASCADE;
CREATE SEQUENCE measfish.taxon_taxon_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.taxon_taxon_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.sample_sample_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.sample_sample_id_seq CASCADE;
CREATE SEQUENCE measfish.sample_sample_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.sample_sample_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.taxon | type: TABLE --
-- DROP TABLE IF EXISTS measfish.taxon CASCADE;
CREATE TABLE measfish.taxon (
	taxon_id integer NOT NULL DEFAULT nextval('measfish.taxon_taxon_id_seq'::regclass),
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
COMMENT ON TABLE measfish.taxon IS 'List of taxons';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.scientific_name IS 'Scientific name of the taxon';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.author IS 'Author of the description of the taxon';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.common_name IS 'Common name of the taxon';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.taxon_code IS 'Code used for reference the taxon in national nomenclature';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.fresh_code IS 'code mnemotechnic used for fishing operations in fresh water';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.sea_code IS 'Code mnemotechnic used for fishing operations in sea water';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.ecotype IS 'Specific ecotype used for this taxon';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.length_max IS 'Length maximum, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.taxon.weight_max IS 'weight maximum, in g';
-- ddl-end --
ALTER TABLE measfish.taxon OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leucaspius delineatus', E'Heckel 1843', E'Able de Heckel', E'2117', E'ABH', E'ABH', E'10.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alburnus alburnus', E'Linnaeus, 1758', E'Ablette', E'2090', E'ABL', E'ABL', E'25.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa alosa', E'Linnaeus, 1758', E'Alose (Grande Alose)', E'2056', E'ALA', E'ALA', E'83.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa fallax fallax', DEFAULT, E'Alose feinte', DEFAULT, DEFAULT, DEFAULT, E'50.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa fallax rhodanensis', DEFAULT, E'Alose du Rhône', E'2058', E'ALR', DEFAULT, E'70.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Anguilla anguilla', E'Linnaeus, 1758', E'Anguille', E'2038', E'ANG', E'ANG', E'133.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aphanius fasciatus', E'(Valenciennes), 1821', E'Aphanius de Corse', E'2142', E'APC', DEFAULT, E'6.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aphanius iberus', E'Valenciennes, 1846', E'Aphanius d''Espagne', E'2143', E'APE', DEFAULT, E'5.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Austropotamobius pallipes', DEFAULT, E'Ecrevisse à pieds blancs', E'868', E'APP', DEFAULT, E'12.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zingel asper', DEFAULT, E'Apron', E'2197', E'APR', DEFAULT, E'22.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Astacus astacus', DEFAULT, E'Ecrevisse à pieds rouges', E'866', E'ASA', DEFAULT, E'18.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Astacus leptodactylus', DEFAULT, E'Ecrevisse à pieds grêles', E'2963', E'ASL', DEFAULT, E'20.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aspius aspius', DEFAULT, E'Aspe', E'2094', E'ASP', DEFAULT, E'100.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina boyeri', E'Risso 1810', E'Joël', E'2041', DEFAULT, E'ATB', E'12.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Barbus barbus', E'Linnaeus, 1758', E'Barbeau fluviatile', E'2096', E'BAF', DEFAULT, E'120.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Barbus meridionalis', DEFAULT, E'Barbeau méridional', E'2097', E'BAM', DEFAULT, E'30.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dicentrarchus labrax', E'Linnaeus, 1758', E'Loup', E'2234', E'LOU', E'LOU', E'103.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Micropterus salmoides', E'Lacepède 1802', E'Achigan à grande bouche', E'2053', E'BBG', DEFAULT, E'97.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Micropterus dolomieu', DEFAULT, E'Achigan à petite bouche', DEFAULT, DEFAULT, DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salaria fluviatilis', E'Asso, 1801', E'Blennie fluviatile', E'2045', E'BLE', DEFAULT, E'25.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Telestes souffia', DEFAULT, E'Blageon', E'25609', E'BLN', DEFAULT, E'36.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rhodeus amarus', E'Bloch 1782', E'Bouvière', E'2131', E'BOU', DEFAULT, E'11.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Blicca bjoerkna', E'Linnaeus, 1758', E'Brème bordelière', E'2099', E'BRB', E'BRB', E'36.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Abramis brama', E'Linnaeus, 1758', E'Brème commune', E'2086', E'BRE', E'BRE', E'82.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Abramis sp.', DEFAULT, E'Brème (non identifiée)', DEFAULT, DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Esox lucius', E'Linnaeus, 1758', E'Brochet', E'2151', E'BRO', E'BRO', E'150.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius auratus', DEFAULT, E'Carassin doré', E'20597', E'CAD', DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius gibelio', DEFAULT, E'Carassin argenté', E'20550', E'CAG', DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hypophthalmichthys molitrix', DEFAULT, E'Carpe argentée', E'2115', E'CAR', DEFAULT, E'105.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius carassius', E'Linnaeus, 1758', E'Carassin commun', E'2102', E'CAS', E'CAR', E'64.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyprinus carpio', E'Linnaeus, 1758', E'Carpe commune', E'2109', E'CMI', E'CCO', E'134.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ambloplites rupestris', DEFAULT, E'Crapet de roche', E'2048', E'CDR', DEFAULT, E'43.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cottus gobio', E'Linnaeus, 1758', E'Chabot', E'2080', E'CHA', DEFAULT, E'18.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Squalius cephalus', DEFAULT, E'Chevaine', E'31041', E'CHE', DEFAULT, E'72.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cottus petiti', DEFAULT, E'Chabot du Lez', E'2354', E'CHP', DEFAULT, E'4.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chondrostoma sp.', DEFAULT, E'Chondrostome', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Coregonus lavaretus', DEFAULT, E'Lavaret', DEFAULT, DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Valencia hispanica', DEFAULT, E'Cyprinodonte de Valence', E'2145', E'CPV', DEFAULT, E'8.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salvelinus namaycush', DEFAULT, E'Cristivomer', E'2228', E'CRI', DEFAULT, E'150.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ctenopharyngodon idella', DEFAULT, E'Carpe amour', E'31039', E'CTI', DEFAULT, E'150.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyprinidae', DEFAULT, E'Cyprinidae indeterminé', DEFAULT, DEFAULT, DEFAULT, E'5.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus eperlanus', E'Linnaeus, 1758', E'Eperlan', E'2188', E'EPE', E'EPE', E'45.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gasterosteus gymnurus', DEFAULT, E'Epinoche', DEFAULT, DEFAULT, DEFAULT, E'8.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pungitius pungitius', E'Linnaeus, 1758', E'Epinochette', E'2167', E'EPT', E'EPT', E'9.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenser sturio', E'Linnaeus, 1758', E'Esturgeon', E'2032', E'EST', E'EST', E'600.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys flesus', E'Linnaeus, 1758', E'Flet', E'2203', E'FLE', E'FLE', E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gambusia holbrooki', DEFAULT, E'Gambusie', DEFAULT, DEFAULT, DEFAULT, E'7.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rutilus rutilus', E'Linnaeus, 1758', E'Gardon', E'2133', E'GAR', E'GAR', E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobio gobio', E'Linnaeus, 1758', E'Goujon', E'2113', E'GOU', E'GOU', E'20.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gymnocephalus cernuus', E'Linnaeus, 1758', E'Grémille', E'2191', E'GRE', E'GRE', E'25.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chondrostoma nasus', E'Linnaeus, 1758', E'Hotu', E'2104', E'HOT', DEFAULT, E'50.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hucho hucho', DEFAULT, E'Huchon', E'2214', E'HUC', DEFAULT, E'150.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leuciscus idus', E'Linnaeus, 1758', E'Ide mélanote', E'2121', E'IDE', DEFAULT, E'104.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cobitis bilineata', DEFAULT, E'Loche transalpine', E'34369', E'LOB', DEFAULT, E'12.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Misgurnus fossilis', E'Linnaeus, 1758', E'Loche d''étang', E'2069', E'LOE', DEFAULT, E'30.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Barbatula barbatula', E'Linnaeus, 1758', E'Loche franche', E'2071', E'LOF', E'LOF', E'21.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cobitis taenia', E'Ikeda 1936', E'Loche épineuse', E'2067', E'LOR', DEFAULT, E'13.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lota lota', DEFAULT, E'Lote de rivière', E'2156', E'LOT', DEFAULT, E'152.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'non identifiee', DEFAULT, E'Lamproie (ammocoete)', DEFAULT, DEFAULT, DEFAULT, E'20.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzon marinus', E'Linnaeus, 1758', E'Lamproie marine', E'2014', E'LPM', E'LPM', E'120.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lampetra planeri', E'Bloch 1784', E'Lamproie de Planer', E'2012', E'LPP', E'LPP', E'20.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lampetra fluviatilis', E'Linnaeus, 1758', E'Lamproie de rivière', E'2011', E'LPR', E'LPR', E'50.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chelon labrosus', E'Risso 1827', E'Mulet à grosses lèvres', E'2180', E'MGL', E'MGL', E'84.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mugil cephalus', E'Linnaeus, 1758', E'Mulet cabot', E'2185', E'MUC', DEFAULT, E'114.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liza aurata', E'Risso 1810', E'Mulet doré', E'2182', E'MUD', E'MUD', E'59.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liza ramada', E'Risso 1810', E'Mulet porc', E'2183', E'MUP', E'MUP', E'70.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Poissons non identifés', DEFAULT, E'Poissons non identifés', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pas de poisson', DEFAULT, E'Pas de poisson', DEFAULT, DEFAULT, DEFAULT, E'0.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salvelinus alpinus', DEFAULT, E'Omble chevalier', DEFAULT, DEFAULT, DEFAULT, E'80.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Thymallus thymallus', E'Linnaeus, 1758', E'Ombre commun', E'2247', E'OBR', DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Orconectes limosus', E'Rafinesque 1817', E'Ecrevisse américaine', E'871', E'OCL', E'ORL', E'12.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Procambarus clarkii', E'Girard 1852', E'Ecrevisse de Louisiane', E'2028', E'PCC', E'ECL', E'15.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ameiurus melas', E'Rafinesque 1820', E'Poisson chat', E'2177', E'PCH', DEFAULT, E'66.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Perca fluviatilis', E'Linnaeus, 1758', E'Perche commune', E'2193', E'PER', E'PER', E'67.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepomis gibbosus', E'Linnaeus, 1758', E'Perche soleil', E'2050', E'PES', E'PES', E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pacifastacus leniusculus', DEFAULT, E'Ecrevisse signal', E'873', E'PFL', DEFAULT, E'18.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pimephales promelas', DEFAULT, E'Tête de boule', E'2127', E'PIM', DEFAULT, E'10.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pleuronectes platessa', E'Linnaeus, 1758', E'Plie', E'2205', E'PLI', E'PLI', E'126.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pseudorasbora parva', E'Temminck & Schlegel, 1846', E'Pseudorasbora', E'2129', E'PSR', E'PSE', E'11.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scardinius erythrophthalmus', E'Linnaeus, 1758', E'Rotengle', E'2135', E'ROT', E'ROT', E'51.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sander lucioperca', E'Linnaeus, 1758', E'Sandre', E'2195', E'SAN', DEFAULT, E'127.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo salar', E'Linnaeus, 1758', E'Saumon Atlantique', E'2220', E'SAT', E'SAT', E'150.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salvelinus fontinalis', DEFAULT, E'Omble de fontaine', E'2227', E'SDF', DEFAULT, E'94.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Silurus glanis', E'Linnaeus, 1758', E'Silure', E'2238', E'SIL', E'SIL', E'500.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alburnoides bipunctatus', E'Bloch 1782', E'Spirlin', E'2088', E'SPI', DEFAULT, E'16.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenser ruthenus', DEFAULT, E'Sterlet', E'3217', E'STL', DEFAULT, E'125.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Oncorhynchus mykiss', E'Walbaum 1792', E'Truite arc en ciel', E'2216', E'TAC', DEFAULT, E'120.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Tinca tinca', E'Linnaeus, 1758', E'Tanche', E'2137', E'TAN', E'TAN', E'82.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parachondrostoma toxostoma', DEFAULT, E'Toxostome', E'31135', E'TOX', DEFAULT, E'30.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo trutta', E'Berg 1908', E'Truite commune', DEFAULT, DEFAULT, E'TRM', E'100.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbra pygmea', DEFAULT, E'Umbre pygmée', DEFAULT, DEFAULT, DEFAULT, E'10.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Phoxinus phoxinus', E'Linnaeus, 1758', E'Vairon', E'2125', E'VAI', E'VAI', E'14.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leuciscus leuciscus', E'Linnaeus, 1758', E'Vandoise', E'2122', E'VAN', DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Vimba vimba', DEFAULT, E'Vimbe', E'2139', E'VIM', DEFAULT, E'50.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Abramis', E'Cuvier 1817', E'Brèmes d''eau douce nca', E'2085', E'BRX', DEFAULT, E'36.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Abramis brama, Blicca bjoerkna', DEFAULT, E'Brèmes', E'19511', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenser', E'Linnaeus, 1758', E'Esturgeons', E'2031', E'ES?', DEFAULT, E'600.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenser baerii', E'Brandt, 1869', E'Esturgeon de Sibérie', E'3218', E'BAE', DEFAULT, E'200.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenseridae', DEFAULT, E'Esturgeons nca', E'2030', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Acipenseriformes', DEFAULT, E'Acipenseriformes', E'3347', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Agonus cataphractus', E'Linnaeus, 1758', E'Souris de mer', E'3544', DEFAULT, DEFAULT, E'21.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alloteuthis', DEFAULT, E'calmars nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alloteuthis subulata', E'Lamarck 1798', E'calmar commun', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa alosa x fallax', DEFAULT, E'Aloses vraie et feinte', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa fallax', E'Lacepède 1803', E'Alose feinte', E'2057', E'ALF', E'ALF', E'70.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Alosa sp.', E'Linck 1790', E'Aloses nca', E'2055', DEFAULT, E'ALS', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ammodytes marinus', E'Raitt 1934', E'Lançon équille', E'3422', DEFAULT, DEFAULT, E'25.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ammodytes tobianus', E'Linnaeus, 1758', E'Equille', E'2035', E'LAN', DEFAULT, E'30.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Anguilla', E'Schrank 1798', E'Anguilles nca', E'2037', E'AN?', DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Anguillidae', DEFAULT, E'Anguilles', E'2036', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aphia minuta', E'Risso 1810', E'Nonnat', E'2170', E'APH', DEFAULT, E'7.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aplysia', E'Linnaeus, 1767', E'Aplysie nca', E'2143', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aplysia punctata', E'Cuvier, 1803', E'Lièvre de mer', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Apogon imberbis', E'Linnaeus, 1758', E'Castagnole rouge', E'20736', DEFAULT, DEFAULT, E'15.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Argyrosomus regius', E'Asso 1801', E'Maigre commun', E'2231', E'MAI', E'MAI', E'230.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Argyrosomus sp.', E'De La Pylaie 1835', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Arnoglossus imperialis', E'Rafinesque, 1810', E'Arnoglosse impérial', E'3505', DEFAULT, DEFAULT, E'25.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Arnoglossus laterna', E'Walbaum 1792', E'Arnoglosse de Méditerranée', E'3506', DEFAULT, DEFAULT, E'19.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Arnoglossus thori', E'Kyle 1913', E'Arnoglosse tacheté', E'3507', DEFAULT, DEFAULT, E'20.5', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Aspitrigla cuculus', E'Linnaeus, 1758', E'Grondin rouge', E'19453', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atelecyclus rotundatus', E'Olivi 1792', E'Petit crabe circulaire', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atelecyclus undecimdentatus', E'(Herbst, 1783)', E'Crabe circulaire', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Athanas nitescens', E'(Leach, 1814)', E'crevette athanas', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina', E'Linnaeus, 1758', E'Athérines nca', E'2040', E'AT?', DEFAULT, E'20.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina hepsetus', E'Linnaeus, 1758', E'Athèrine sauclet', E'3264', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina presbyter', E'Cuvier 1829', E'Prêtre', E'2042', DEFAULT, E'ATP', E'20.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherina sp.', DEFAULT, E'Atherine sp', DEFAULT, DEFAULT, E'SILP', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atherinidae', DEFAULT, E'Athérinidés', E'2039', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Atyaephyra desmaresti,Palemon varians', DEFAULT, E'crevettes divers', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Balistes carolinensis', E'Gmelin, 1789', E'Baliste', E'19460', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Barbus', E'Cuvier 1817', E'Barbeaux nca', E'2095', E'BAX', DEFAULT, E'120.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Belone belone', E'Linnaeus 1761', E'Orphie', E'3378', DEFAULT, E'ORF', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Belone sp.', E'Cuvier 1817', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Bivalvia', E'Linnaeus, 1758', E'bivalves', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Blennius ocellaris', E'Linnaeus, 1758', E'Blennie papillon', E'3430', DEFAULT, DEFAULT, E'20.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Boops boops', E'Linnaeus, 1758', E'Bogue', E'3482', DEFAULT, E'BOG', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Bothus podas', E'Delaroche, 1809', E'Rombou commun', E'25283', DEFAULT, DEFAULT, E'45.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Brachyura', DEFAULT, E'Crabes nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Buglossidium luteum', E'Risso 1810', E'Petite sole jaune', E'3535', DEFAULT, DEFAULT, E'15.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus', E'Linnaeus, 1758', E'Callionymes', E'3369', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus lyra', E'Linnaeus, 1758', E'Callionyme lyre', E'3370', DEFAULT, E'CAL', E'30.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus pusillus', E'Delaroche, 1809', E'Dragonnet élégant', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus reticulatus', E'Valenciennes 1837', E'Callionyme réticulé', E'3372', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Callionymus risso', E'Lesueur 1814', E'Callionyme bélène', E'19458', DEFAULT, DEFAULT, E'11.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cancer pagurus', E'Linnaeus, 1758', E'Tourteau', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius', E'Nilsson 1832', E'Carassins nca', E'2100', E'CAX', DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius auratus auratus', E'Linnaeus, 1758', E'Carassin doré', E'5208', E'CAA', DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carassius auratus gibelio', E'Bloch, 1782', E'Carassin argenté', E'5207', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carcinus aestuarii', E'Nardo 1847', E'Crabe vert de la Méditerranée', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Carcinus maenas', E'Linnaeus, 1758', E'Crabe vert', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Centrolabrus exoletus', E'Linnaeus, 1758', E'Petite vieille', E'3459', DEFAULT, DEFAULT, E'18.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chelidonichthys lucernus', E'Linnaeus, 1758', E'Grondin perlon', E'3563', DEFAULT, DEFAULT, E'75.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chelon', E'Artedi, 1793', E'Mulets nca', E'2179', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chlamys opercularis', DEFAULT, E'Coquille Saint Jacques', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chlamys varia', E'(Linnaeus, 1758)', E'Pétoncle', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Chromis chromis', E'Linnaeus, 1758', E'Castagnole', E'20738', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ciliata', E'Couch 1832', E'Motelle', E'2153', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ciliata mustela', E'Linnaeus, 1758', E'Motelle à cinq barbillons', E'2154', E'MOT', E'MOT', E'25.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ciliata septentrionalis', E'Collett 1875', E'Motelle à moustaches', E'3384', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Clupea harengus', E'Linnaeus, 1758', E'Hareng de l''Atlantique', E'2060', E'HAR', E'HER', E'45.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Clupea sp.', E'Linnaeus 1758', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Clupeidae', DEFAULT, E'Harengs, sardines nca', E'2054', E'CLU', DEFAULT, E'41.76', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Conger conger', E'Linnaeus, 1758', E'Congre d''Europe', E'2074', E'CGR', E'CON', E'300.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Coris julis', E'Linnaeus, 1758', E'Girelle', E'19451', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cottus', E'Linnaeus, 1758', E'Chabot nca', E'2079', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crangon', DEFAULT, E'Crevettes crangon nca', E'3281', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crangon crangon', E'Linnaeus, 1758', E'Crevette grise', E'3282', E'CRG', E'CRG', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crangonidae', DEFAULT, E'Crevettes crangonidés', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crassostrea gigas', E'Thunberg 1793', E'Huître creuse du Pacifique', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Crystallogobius linearis', E'Düben 1845', E'Gobie cristal', E'3445', DEFAULT, DEFAULT, E'4.7', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ctenolabrus rupestris', E'Linnaeus, 1758', E'Rouquié', E'3461', DEFAULT, E'ROU', E'18.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyclopterus lumpus', E'Linnaeus, 1758', E'Lompe', E'3551', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyprinidae', DEFAULT, E'Cyprinidés', E'2084', E'CYP', E'CYP', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cypriniformes', DEFAULT, E'Cypriniformes', E'3362', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Cyprinus', E'Linnaeus, 1758', E'Carpes nca', E'2108', E'CCX', DEFAULT, E'134.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dasyatis', E'Rafinesque 1810', E'Pastenagues nca', E'3588', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dasyatis pastinaca', E'Linnaeus, 1758', E'Pastenague', E'3589', DEFAULT, E'WSX', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dentex dentex', E'Linnaeus, 1758', E'Denté commun', E'20740', DEFAULT, DEFAULT, E'100.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dicentrarchus', E'Gill 1860', E'Bars nca', E'2233', DEFAULT, DEFAULT, E'86.5', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dicentrarchus punctatus', E'Bloch 1792', E'Bar tacheté', E'2235', E'LOM', E'SPU', E'70.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dicologlossa cuneata', E'Moreau 1881', E'Cèteau', E'3537', DEFAULT, DEFAULT, E'30.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplecogaster bimaculata bimaculata', E'Bonnaterre, 1788', E'Gluette rougeoleuse', E'3415', DEFAULT, DEFAULT, E'6.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus annularis', E'Linnaeus, 1758', E'Sparaillon commun', E'19481', DEFAULT, DEFAULT, E'24.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus cervinus', E'Lowe 1838', E'Sar à grosses lèvres', E'19482', DEFAULT, DEFAULT, E'61.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus puntazzo', E'Cetti, 1777', E'Sar à museau pointu', E'20741', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus sargus', E'Linnaeus, 1758', E'Sar commun', E'19483', DEFAULT, DEFAULT, E'45.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Diplodus vulgaris', E'Geoffroy St. Hilaire 1817', E'Sar à tête noire', E'19484', DEFAULT, E'SRG', E'45.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dromia', E'Weber, 1795', E'Dromie nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Dromia personata', E'Linnaeus, 1758', E'Crabe dormeur', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Echiichthys vipera', E'Cuvier 1829', E'Petite vive', E'19480', DEFAULT, DEFAULT, E'16.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Enchelyopus cimbrius', E'Linnaeus 1766', E'Motelle à quatre barbillons', E'3402', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Engraulis', E'Cuvier 1817', E'Anchois nca', E'2147', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Engraulis encrasicolus', E'Linnaeus, 1758', E'Anchois', E'2148', E'ANC', E'ANC', E'20.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Enophrys bubalis', E'Euphrasen, 1786', E'chabot buffle', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Entelurus aequoreus', E'Linnaeus, 1758', E'Entélure', E'3567', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eriocheir sinensis', E'H. Milne Edwards 1853', E'Crabe chinois', E'879', E'CRC', DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eupagurus bernhardus', E'Linnaeus, 1758', E'Bernard l’ermite commun', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eurynome', E'Leach, 1814', E'Majidé eurynome', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eurynome aspera', E'(Pennant, 1777)', E'Eurynome rugeuse', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Eutrigla gurnardus', E'Linnaeus, 1758', E'Grondin gris', E'19478', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gadidae', DEFAULT, E'Gadidés', E'2152', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gadus morhua', E'Linnaeus, 1758', E'Morue de l''Atlantique', E'3386', DEFAULT, E'COD', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gaidropsarus mediterraneus', E'Linnaeus, 1758', E'Motelle de Méditerranée', E'3388', DEFAULT, DEFAULT, E'50.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gaidropsarus vulgaris', E'Cloquet 1824', E'Motelle commune', E'3389', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galathea rugosa', E'Fabricius, 1775', E'Galathée rose', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galathea squamifera', E'Leach, 1814', E'Galathée écailleuse', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galathea strigosa', DEFAULT, E'Galathée striée', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galeorhinus galeus', E'Linnaeus, 1758', E'Requin-hâ', E'3581', DEFAULT, E'LSK', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Galeus melastomus', E'Rafinesque 1810', E'Chien espagnol', E'19487', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gambusia', E'Poey 1854', E'Gambusie nca', E'2207', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gambusia affinis', E'Baird & Girard 1853', E'Gambusie', E'2208', E'GAM', E'GAM', E'4.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gammaridae', DEFAULT, E'Gammares', E'887', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gasterosteus', E'Linnaeus, 1758', E'Epinoches', E'2164', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gasterosteus aculeatus', E'Linnaeus, 1758', E'Epinoche à trois épines', E'2165', DEFAULT, E'EPI', E'11.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Glyptocephalus cynoglossus', E'Linnaeus, 1758', E'Plie cynoglosse', E'3512', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobiidae', DEFAULT, E'Gobidés', E'2168', DEFAULT, DEFAULT, E'8.25', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius cobitis', E'Pallas 1814', E'Gobie céphalote', E'19490', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius cruentatus', E'Gmelin 1789', E'Gobie ensanglanté', E'19491', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobiusculus flavescens', E'Fabricius 1779', E'Gobie nageur', E'3451', DEFAULT, DEFAULT, E'6.3', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius geniporus', E'Valenciennes 1837', E'Gobie à joues poreuses', E'19492', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius niger', E'Linnaeus, 1758', E'Gobie noir', E'2172', E'GBN', DEFAULT, E'18.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius paganellus', E'Linnaeus, 1758', E'Gobie paganel', E'19493', DEFAULT, DEFAULT, E'12.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gobius roulei', E'De Buen 1928', E'Gobie paganel gros oeil', E'19494', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Goneplax rhomboides', E'Linnaeus, 1758', E'crabe', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Gymnammodytes semisquamatus', E'Jourdain 1879', E'Lançon aiguille', E'3424', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hemigrapsus', DEFAULT, E'crabe japonais', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hemigrapsus penicillatus', E'De Haan, 1835', E'crabe japonais', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus', E'Rafinesque 1810', E'Hippocampes nca', E'3568', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus erectus', E'Perry', E'Hippocampe rayé', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus guttulatus', E'Cuvier, 1829', E'Hippocampe moucheté', E'3569', DEFAULT, DEFAULT, E'21.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus hippocampus', E'Linnaeus, 1758', E'Hippocampe à museau court', E'19485', DEFAULT, E'HIP', E'15.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus ingens', E'Girard', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus ramulosus', E'Leach 1814', E'Hippocampe moucheté', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus reidi', E'Ginsburg', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippocampus zosterae', E'Jordan&Gilbert', E'Hippocampe Atlantique ouest', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippoglossoides platessoides', E'Fabricius 1780', E'Balai de l''Atlantique', E'3514', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hippolyte varians', E'Leach, 1814', E'Crevette hippolyte', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hyperoplus', E'Linné, 1758', E'lançon ind', E'3426', DEFAULT, DEFAULT, E'37.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hyperoplus immaculatus', E'Corbin, 1950', E'Lançon jolivet', E'3427', DEFAULT, DEFAULT, E'35.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Hyperoplus lanceolatus', E'Le Sauvage 1824', E'Lançon commun', E'3428', DEFAULT, DEFAULT, E'39.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ictalurus', E'Rafinesque 1820', E'Barbottes nca', E'2176', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ictalurus melas', DEFAULT, E'Poisson chat', DEFAULT, DEFAULT, E'PCH', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Ictalurus punctatus', E'Rafinesque 1818', E'Barbue d''Amérique', E'19486', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Idotea baltica', DEFAULT, E'isopode', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Inachus', E'Weber, 1795', E'Crabe inachus', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Inachus dorsettensis', E'Pennant, 1777', E'Crabe des anémones', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Labrus bergylta', E'Ascanius 1767', E'Vieille commune', E'3463', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Labrus merula', E'Linnaeus, 1758', E'Merle', E'19474', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Labrus mixtus', E'Linnaeus,1758', E'Coquette', E'19489', DEFAULT, DEFAULT, E'35.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Labrus viridis', E'Linnaeus,1758', E'Labre vert', E'19479', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lampetra', E'Gray 1851', E'Lamproie Lampetra', E'2010', E'LPX', DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepadogaster candolii', E'Risso, 1810', E'Gluette petite queue', E'3417', DEFAULT, DEFAULT, E'7.5', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepadogaster lepadogaster', E'Walbaum 1792', E'Gluette barbier', E'3418', DEFAULT, DEFAULT, E'6.5', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepidorhombus whiffiagonis', E'Walbaum 1792', E'Cardine franche', E'3523', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lepomis sp.', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lesueurigobius friesii', E'Malm 1874', E'Gobie raôlet', E'19469', DEFAULT, DEFAULT, E'13.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leuciscus cephalus', E'Linnaeus, 1758', E'Chevaine', E'2120', DEFAULT, E'CHE', E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leuciscus souffia', E'Risso 1827', E'Blageon', E'2119', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Leucoraja naevus', E'Müller & Henle, 1841', E'Raie fleurie', E'3599', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lichia amia', E'Linnaeus, 1758', E'Liche', E'25286', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Limanda limanda', E'Linnaeus, 1758', E'Limande', E'3518', DEFAULT, DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus', E'Stimpson, 1870', E'Etrille nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus arcuatus', E'Leach, 1814', E'Etrille arcuatus', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus depurator', E'Linnaeus, 1758', E'Etrille pattes bleues', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus holsatus', E'Fabricius, 1798', E'Etrille nageuse', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liocarcinus navigator', E'(Hebst, 1794)', E'Etrille pattes bleues', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liparis liparis', E'Linnaeus 1766', E'Limace de mer', E'3553', DEFAULT, DEFAULT, E'15.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liparis montagui', E'Donovan 1804', E'Limace anicotte', E'2083', E'LIP', DEFAULT, E'12.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lipophrys dalmatinus', E'Steindachner & Kolombatovic, 1884', E'Blennie dalmate', E'20742', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lipophrys pholis', E'Linnaeus, 1758', E'Blennie mordocet', E'3431', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lithognathus mormyrus', E'Linnaeus, 1758', E'Marbré', E'19465', DEFAULT, DEFAULT, E'37.6', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liza', E'Jordan&Swain 1884', E'Mulets nca', E'2181', DEFAULT, DEFAULT, E'59.15', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Liza saliens', E'Risso 1810', E'Mulet sauteur', E'3267', E'MUS', DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Loliginidae', E'D''Orbigny, 1848', E'Calmars côtiers nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Loligo', DEFAULT, E'Calmars nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Loligo vulgaris', E'Lamarck 1798', E'Encornet', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Lophius piscatorius', E'Linnaeus, 1758', E'Baudroie commune', E'3421', DEFAULT, E'ANF', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Macoma balthica', E'Linnaeus, 1758', E'Telline de la Baltique', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Macropodia', DEFAULT, E'Macropode nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Macropodia longirostris', E'Fabricius, 1775', E'Macropode longirostris', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Macropodia rostrata', E'Linnaeus, 1761', E'Macropode commun', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Maja brachydactyla', DEFAULT, E'Araignée de mer', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Maja squinado', E'Herbst, 1788', E'Araignée de mer', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Maurolicus muelleri', E'Gmelin 1789', E'Brossé améthyste', E'19466', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Medorippe lanata', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Melanogrammus aeglefinus', E'Linnaeus, 1758', E'Eglefin', E'19467', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Merlangius merlangus', E'Linnaeus, 1758', E'Merlan', E'2158', E'MER', E'WHG', E'7.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Merluccius merluccius', E'Linnaeus, 1758', E'Merlu européen', E'3410', DEFAULT, E'HKE', E'140.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Micrenophrys lilljeborgii', E'Collett 1875', E'Chabot têtu', E'3549', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Microchirus variegatus', E'Donovan, 1808', E'Sole perdrix', E'3539', DEFAULT, DEFAULT, E'35.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Micromesistius poutassou', E'Risso 1827', E'Merlan bleu', E'3391', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Microstomus kitt', E'Walbaum 1792', E'Limande sole', E'3520', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Molva molva', E'Linnaeus, 1758', E'Lingue', E'3393', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mugil', E'Linnaeus, 1758', E'Mulets nca', E'2184', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mugilidae', DEFAULT, E'Mugilidés', E'2178', DEFAULT, DEFAULT, E'78.33', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mugil liza', E'Valenciennes 1836', E'Mulet lebranche', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mullus', E'Linnaeus, 1758', E'Rougets nca', E'3471', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mullus barbatus', E'Linnaeus, 1758', E'Rouget de vase', E'3472', DEFAULT, DEFAULT, E'33.2', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mullus sp.', DEFAULT, E'Mullus sp.', DEFAULT, DEFAULT, E'MUL', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mullus surmuletus', E'Linnaeus, 1758', E'Rouget de roche', E'3473', DEFAULT, E'MUS', E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mustelus asterias', E'Cloquet 1821', E'Emissole tachetée', E'3584', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Mustelus mustelus', E'Linnaeus, 1758', E'Emissole lisse', E'3585', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Myoxocephalus scorpius', E'Linnaeus, 1758', E'Chaboisseau à épines courtes', E'3546', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Myxine glutinosa', E'Linnaeus, 1758', E'Myxine', E'19470', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Necora puber', E'Linnaeus 1767', E'Etrille commune', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Nerophis lumbriciformis', E'Jenyns 1835', E'Nérophis petit nez', E'19471', DEFAULT, DEFAULT, E'16.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Nerophis maculatus', E'Rafinesque, 1810', E'Nérophis tacheté', DEFAULT, DEFAULT, DEFAULT, E'30.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Nerophis ophidion', E'Linnaeus, 1758', E'Nérophis tête bleue', E'19472', DEFAULT, DEFAULT, E'29.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'NoName', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Oblada melanura', E'Linnaeus, 1758', E'Oblade', E'3485', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Octopus vulgaris', DEFAULT, E'poulpe commun', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus mordax', E'Steindachner & Kner 1870', E'Eperlan arc-en-ciel', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus mordax dentex', E'Steind. 1870', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus mordax mordax', E'Mitchill 1814', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus sp.', E'Linnaeus 1758', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Osmerus sp., Hypomesus sp.', DEFAULT, E'Eperlans nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pachygrapsus', DEFAULT, E'Crabes Pachygrapsus', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pachygrapsus marmoratus', E'Fabricius 1787', E'Grapse marbré', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pachygrapsus transversus', E'Gibbes 1850', E'Anglette africaine', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pagellus bogaraveo', E'Linnaeus, 1758', E'Pageot rose', DEFAULT, DEFAULT, DEFAULT, E'70.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pagellus erythrinus', E'Linnaeus, 1758', E'Pageot commun', E'23613', DEFAULT, DEFAULT, E'51.7', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pagurus prideauxi', E'Leach, 1814', E'Gonfaron', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon', E'Weber, 1795', E'Crevettes Palaemon nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon adspersus', E'Rathke, 1837', E'Bouquet balte', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon elegans', E'Rathke 1837', E'Bouquet flaque', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemonetes varians', E'Leach 1814', E'Bouquet atlantique des canaux', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemonidae', E'Rafinesque, 1815', E'Palaemonidés', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon longirostris', E'H. Milne Edwards 1837', E'Crevette blanche', E'3280', E'CRB', E'CRB', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon longirostris, P. serratus', DEFAULT, E'crevettes blanche et rose', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon macrodactylus', E'M.J. Rathbun 1902', E'Bouquet migrateur', DEFAULT, DEFAULT, E'CRM', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon serratus', E'Pennant 1777', E'Bouquet commun', DEFAULT, DEFAULT, E'CRR', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Palaemon sp.', DEFAULT, E'Palaemon sp.', DEFAULT, DEFAULT, E'PAL', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Panopeus africanus', E'A. Milne Edwards 1867', E'Crabe caillou africain', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parablennius gattorugine', E'Linnaeus, 1758', E'Blennie cabot', E'3429', DEFAULT, DEFAULT, E'30.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parablennius pilicornis', E'Cuvier, 1829', E'Blennie pilicorne', E'20743', DEFAULT, DEFAULT, E'12.7', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parablennius sanguinolentus', E'Pallas 1814', E'Baveuse', E'19473', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Parthenope angulifrons', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pecten maximus', E'(Linnaeus, 1758)', E'Coquille St Jacques', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pegusa impar', E'Bennett, 1831', E'Sole adriatique', E'20746', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pegusa lascaris', E'Ben-Tuvia 1990', E'Sole-pole', E'3540', DEFAULT, DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Penaeus japonicus', E'Bate 1888', E'Crevette kuruma', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Penaeus kerathurus', E'Forskal 1775', E'Caramote', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzon marinus, Lampetra fluviatilis', DEFAULT, E'lamproie marine et lamproie de rivière', E'19512', DEFAULT, E'LPS', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzon sp.', E'Linnaeus 1758', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzontidae', DEFAULT, E'Lamproies nca', E'2009', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Petromyzontiformes', DEFAULT, E'Petromyzontiformes', E'5070', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Philocheras trispinosus', E'(Hailstone, 1835)', E'crevette philocheras', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pholis gunnellus', E'Linnaeus, 1758', E'Gonelle', E'2200', E'GON', DEFAULT, E'25.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Phoxinus', E'Rafinesque 1820', E'Vairons nca', E'2124', E'PHX', DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pilumnus hirtellus', E'Linnaeus, 1758', E'Crabe rouge poilu', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pirimela denticulata', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pisa tetraodon', E'(Pennant, 1777)', E'Araignée cornue', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pisidia longicornis', E'Linnaeus 1767', E'Porcellane noire', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Planes minutus', E'Linnaeus, 1758', E'Grapse des tortues', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys flesus flesus', E'L. 1758', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys flesus italicus', E'Gsnt. 1862', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys flesus luscus', E'Pallas 1811', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Platichthys sp.', E'Girard 1856', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pleuronectes', E'Linnaeus, 1758', E'Plies nca', E'2204', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pleuronectidae', DEFAULT, E'Pleuronectidés', E'2201', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pollachius pollachius', E'Linnaeus, 1758', E'Lieu jaune', E'2160', E'LIJ', E'POL', E'130.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pollachius virens', E'Linnaeus, 1758', E'Lieu noir', E'3398', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Polybius holsatus', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatomus saltatrix', E'Linnaeus, 1766', E'Tassergal', E'20744', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus', E'Gill 1864', E'Gobies Pomatoschistus', E'2173', DEFAULT, DEFAULT, E'7.66', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus lozanoi', E'De Buen, 1923', E'Gobie rouillé', E'19464', DEFAULT, DEFAULT, E'8.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus marmoratus', E'Risso, 1810', E'Gobie marbré', E'19463', DEFAULT, DEFAULT, E'8.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus microps', E'Kroeyer 1838', E'Gobie tacheté', E'3455', DEFAULT, DEFAULT, E'6.8', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus minutus', E'Pallas 1770', E'Gobie buhotte', E'2174', E'GOB', E'GOB', E'11.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus pictus', E'Malm 1865', E'Gobie varié', E'3456', DEFAULT, DEFAULT, E'8.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pomatoschistus quagga', E'Gil, 1863', E'Gobie quagga', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Porcellana platycheles', E'Pennant 1777', E'Crabe porcelaine', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Portumnus latipes', E'Pennant 1777', E'Etrille elegante', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Portunidae', E'Rafinesque, 1815', E'crabes portunidés nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Procambarus', DEFAULT, E'Ecrevisses nca', E'2027', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Processa edulis', E'Risso 1816', E'Guernade nica', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Processa nouveli', E'Al Adhub & Williamson, 1975', E'Guernade nouveli', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Processa parva', DEFAULT, E'crevette ind', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Psetta maxima', E'Linnaeus, 1758', E'Turbot', E'19468', DEFAULT, E'TUR', E'100.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Psetta sp.', E'Swainson 1839', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Pycnogonidae', DEFAULT, E'Pycnogonide nca', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja', E'Linnaeus, 1758', E'Raie nca', E'2210', DEFAULT, DEFAULT, E'112.2', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja brachyura', E'Lafont 1873', E'Raie lisse', E'3591', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja clavata', E'Linnaeus, 1758', E'Raie bouclée', E'2211', E'RBC', E'RJC', E'105.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja microocellata', E'Montagu 1818', E'Raie mélée', E'3592', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja montagui', E'Fowler, 1910', E'Raie étoilée', E'3593', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja naevus', E'Müller & Henle 1841', E'Raie fleurie', DEFAULT, DEFAULT, E'RJN', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raja undulata', E'Lacepède 1802', E'Raie brunette', E'3594', DEFAULT, E'SKA', E'120.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rajella fyllae', E'Lütken, 1887', E'Raie ronde', E'3602', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Raniceps raninus', E'Linnaeus, 1758', E'Trident', E'3400', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rhithropanopeus', E'Gould 1832', E'Crabe', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rhithropanopeus harrisii', E'Gould, 1841', E'Crabe de vase', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rhodeus sericeus', E'Pallas 1776', E'Bouvière', DEFAULT, DEFAULT, E'BOU', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Rutilus', E'Rafinesque 1820', E'Gardons nca', E'2132', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salaria basilisca', E'Valenciennes, 1836', E'Blennie basilic', E'25285', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salaria pavo', E'Risso 1810', E'Blennie paon', E'19488', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo', E'Linnaeus, 1758', E'Truites nca', E'2219', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmonidae', DEFAULT, E'Salmonidés', E'2212', E'SAL', DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo trutta fario', E'Linnaeus, 1758', E'Truite fario', E'2221', E'TRF', DEFAULT, E'100.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Salmo trutta trutta', E'Linnaeus, 1758', E'Truite de mer brune', E'2224', E'TRM', DEFAULT, E'100.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sander', DEFAULT, E'Sandres nca', E'5074', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sardina pilchardus', E'Walbaum 1792', E'Sardine commune', E'2062', E'SAR', E'SAR', E'27.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sardinella aurita', E'Valenciennes 1847', E'Allache', E'19476', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sarpa salpa', E'Linnaeus, 1758', E'Saupe', E'19475', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sciaena umbra', E'Linnaeus, 1758', E'Corb commun', E'19477', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scomber scombrus', E'Linnaeus, 1758', E'Maquereau commun', E'3475', DEFAULT, E'MAC', E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scophthalmus maximus', E'Linnaeus, 1758', E'Turbot', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scophthalmus rhombus', E'Linnaeus, 1758', E'Barbue', E'3531', DEFAULT, E'BLL', E'75.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scophthalmus sp.', E'Rafinesque 1810', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scorpaena porcus', E'Linnaeus, 1758', E'Rascasse brune', E'20745', DEFAULT, DEFAULT, E'37.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scyliorhinus canicula', E'Linnaeus, 1758', E'Petite roussette', E'3609', DEFAULT, DEFAULT, E'100.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Scyliorhinus stellaris', E'Linnaeus, 1758', E'Grande roussette', E'3610', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepia', E'Linnaeus, 1758', E'Seiches', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepia officinalis', E'Linnaeus, 1758', E'Seiche commune', DEFAULT, DEFAULT, E'SEI', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepiola', E'Leach, 1817', E'Sépioles', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepiola atlantica', E'Orbigny 1840', E'Sépiole grandes oreilles', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sepiola rondeleti', E'Leach, 1817', E'Sepiole rondeleti', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Serranus hepatus', E'Linné, 1758', E'Serran tambour', E'3479', DEFAULT, DEFAULT, E'25.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sicyonia carinata', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Silurus', E'Linnaeus, 1758', E'Silures nca', E'2237', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea', E'Quensel 1806', E'Soles', E'2240', DEFAULT, E'SOL', E'65.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea aegyptiaca', E'Chabanaud, 1927', E'Sole egyptienne', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea lascaris', DEFAULT, E'Sole pole', DEFAULT, DEFAULT, E'SOS', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea senegalensis', E'Kaup 1858', E'Sole sénégalaise', E'3541', DEFAULT, E'SOX', E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea solea', E'Linnaeus, 1758', E'Sole', E'2241', E'SOL', DEFAULT, E'70.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Solea vulgaris', E'Quensel 1806', E'Sole commune', DEFAULT, DEFAULT, E'SOL', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sparidae', DEFAULT, E'sparidés nca', E'3481', DEFAULT, DEFAULT, E'48.07', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sparus aurata', E'Linnaeus, 1758', E'Dorade royale', E'3490', DEFAULT, E'DRO', E'70.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Spicara smaris', E'Linnaeus, 1758', E'Picarel', E'3449', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Spinachia spinachia', E'Linnaeus, 1758', E'Epinoche de mer', E'19452', DEFAULT, DEFAULT, E'19.1', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Spondyliosoma cantharus', E'Linnaeus, 1758', E'Griset', E'3492', DEFAULT, E'BRD', E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sprattus sp.', E'Girgensohn 1846', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Sprattus sprattus', E'Linnaeus, 1758', E'Sprat', E'2064', E'SPT', E'SPT', E'16.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Squalus acanthias', E'Linnaeus, 1758', E'Aiguillat commun', E'3614', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Stizostedion lucioperca', DEFAULT, E'Sandre', DEFAULT, DEFAULT, E'SAN', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus bailloni', E'Valenciennes in Cuv. & Val., 1839', E'Crénilabre grelue', E'19443', DEFAULT, DEFAULT, E'21.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus cinereus', E'(Bonnaterre), 1788', E'Crénilabre balafré', E'19449', DEFAULT, DEFAULT, E'16.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus melops', E'Linnaeus, 1758', E'Crénilabre melops', E'3466', DEFAULT, DEFAULT, E'24.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus ocellatus', E'(Forsskål, 1775)', E'Crénilabre ocellé', E'19448', DEFAULT, DEFAULT, E'12.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus roissali', E'Risso 1810', E'Crénilabre langaneu', E'19447', DEFAULT, DEFAULT, E'17.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Symphodus tinca', E'Linnaeus, 1758', E'Crénilabre paon', E'19450', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Synapturichthys kleinii', E'Risso, 1827', E'Sole tachetée', E'25284', DEFAULT, DEFAULT, E'42.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Synchiropus phaeton', E'(Günther 1861)', E'Callionyme paille-en-queue', E'19445', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathidae', DEFAULT, E'Syngnathes', E'2242', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus', E'Linnaeus, 1758', E'Syngnathes', E'2243', DEFAULT, DEFAULT, E'29.75', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus abaster', E'Risso 1827', E'Syngnathe gorge claire', E'19444', DEFAULT, DEFAULT, E'21.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus acus', E'Linnaeus, 1758', E'Syngnathe aiguille', E'2244', E'SYN', DEFAULT, E'2.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus rostellatus', E'Nilsson 1855', E'Syngnathe de Duméril', E'3570', DEFAULT, E'SYN', E'20.5', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus taenionotus', E'Canestrini 1871', E'Syngnathe taenionotus', E'19459', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus typhle', E'Linnaeus, 1758', E'Siphonostome', E'3571', DEFAULT, DEFAULT, E'36.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Syngnathus typhle typhle', E'Linnaeus, 1758', E'Siphonostome atlantique', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Taurulus bubalis', E'Euphrasen 1786', E'Chabot buffle', E'3548', DEFAULT, DEFAULT, E'17.5', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Thorogobius ephippiatus', DEFAULT, E'gobie léopard', DEFAULT, DEFAULT, DEFAULT, E'12.9', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Tinca sp.', E'Cuvier 1817', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Torpedo marmorata', E'Risso 1810', E'Torpille marbrée', E'19461', DEFAULT, E'TOE', E'61.2', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Torpedo torpedo', E'Linné, 1758', E'Torpille ocelée', E'25287', DEFAULT, DEFAULT, E'55.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trachinotus ovatus', E'Linnaeus, 1758', E'Liche glauque', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trachinus draco', E'Linnaeus, 1758', E'Grande vive', E'3498', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trachurus trachurus', E'Linnaeus, 1758', E'Chinchard d''Europe', E'3375', DEFAULT, E'HOM', E'70.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trigla', E'Linnaeus, 1758', E'Grondins nca', E'3562', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trigla lucerna', DEFAULT, E'Grondin perlon', DEFAULT, DEFAULT, E'GUP', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trigla lyra', E'Linnaeus, 1758', E'Grondin lyre', E'19455', DEFAULT, DEFAULT, E'60.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Triglidae', DEFAULT, E'Grondins, cavillones nca', E'3557', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Tripterygion delaisi', E'Cadenat & Blache, 1970', E'Triptérygion commun', E'19454', DEFAULT, DEFAULT, E'8.9', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trisopterus', E'Rafinesque, 1814', E'Tacaud nca', E'2161', DEFAULT, DEFAULT, E'43.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trisopterus esmarkii', E'Nilsson 1855', E'Tacaud norvégien', E'3404', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trisopterus luscus', E'Linnaeus, 1758', E'Tacaud commun', E'2162', E'TAD', E'BIB', E'46.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Trisopterus minutus', E'Linnaeus, 1758', E'Capelan', E'3406', DEFAULT, DEFAULT, E'40.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbrina', E'Cuvier, 1816', E'Ombrine nca', E'19435', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbrina canariensis', E'Valenciennes 1843', E'Ombrine bronze', E'19456', DEFAULT, E'UMBB', E'80.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbrina cirrosa', E'Linnaeus, 1758', E'Ombrine côtière', E'19457', DEFAULT, E'UMBC', E'100.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Umbrina sp.', DEFAULT, E'Ombrine sp.', DEFAULT, DEFAULT, E'UMB', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Upogebia pusilla', E'Petagna, 1792', E'Crevette fouisseuse', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Xantho incisus', E'Herbst, 1790', E'Crabe de pierre', DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zebrus zebrus', E'Risso, 1827', E'Gobie zébré', E'19446', DEFAULT, DEFAULT, E'5.5', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zeugopterus punctatus', E'Bloch 1787', E'Targeur', E'3533', DEFAULT, DEFAULT, E'27.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zeus faber', E'Linnaeus, 1758', E'Saint Pierre', E'3577', DEFAULT, DEFAULT, E'59.0', DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zoarces viviparus', E'Linnaeus, 1758', E'Loquette d''Europe', E'3501', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO measfish.taxon (scientific_name, author, common_name, taxon_code, fresh_code, sea_code, length_max, weight_max) VALUES (E'Zosterisessor ophiocephalus', E'Pallas 1814', E'Gobie lotte', E'19462', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
-- ddl-end --

-- object: measfish.operation | type: TABLE --
-- DROP TABLE IF EXISTS measfish.operation CASCADE;
CREATE TABLE measfish.operation (
	operation_id integer NOT NULL DEFAULT nextval('measfish.operation_operation_id_seq'::regclass),
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
	CONSTRAINT operation_id_pk PRIMARY KEY (operation_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.operation IS 'Description of operation';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.operation_id IS 'Operations rattached at a campaign';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.operation_name IS 'Name of operation';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.date_start IS 'Start date of operation';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.date_end IS 'Date of end of operation';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.freshwater IS 'Is the operation in fresh water ?';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.long_start IS 'Longitude of the first point, in wgs84 (decimal)';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.lat_start IS 'Latitude of the first point, in WGS84 (decimal)';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.long_end IS 'Longitude of the last point, in WGS84 (decimal)';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.lat_end IS 'Latitude of the last point, in WGS84 (decimal)';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.pk_source IS 'Distance from the source, in meter';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.pk_mouth IS 'Distance from the mouth, in meter';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.length IS 'Length of the sampled zone, in meter';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.side IS 'Position in the river (left side, central, right side, etc.)';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.altitude IS 'Altitude, in meter';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.tidal_coef IS 'Tidal coefficient or water high of the tidal';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.debit IS 'Debit of the river, in m³/s';
-- ddl-end --
COMMENT ON COLUMN measfish.operation.surface IS 'Surface parsed, in square meters';
-- ddl-end --
ALTER TABLE measfish.operation OWNER TO measfish;
-- ddl-end --

-- object: campaign_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation DROP CONSTRAINT IF EXISTS campaign_fk CASCADE;
ALTER TABLE measfish.operation ADD CONSTRAINT campaign_fk FOREIGN KEY (campaign_id)
REFERENCES measfish.campaign (campaign_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.sequence | type: TABLE --
-- DROP TABLE IF EXISTS measfish.sequence CASCADE;
CREATE TABLE measfish.sequence (
	sequence_id integer NOT NULL DEFAULT nextval('measfish.place_place_id_seq'::regclass),
	operation_id integer NOT NULL,
	sequence_number smallint,
	date_start timestamp NOT NULL,
	date_end timestamp,
	fishing_duration float,
	ambience_id integer,
	CONSTRAINT place_id_pk PRIMARY KEY (sequence_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.sequence IS 'Catching sequence';
-- ddl-end --
COMMENT ON COLUMN measfish.sequence.sequence_number IS 'Number of sequence in the operation';
-- ddl-end --
COMMENT ON COLUMN measfish.sequence.date_start IS 'Start time of fishing at this place';
-- ddl-end --
COMMENT ON COLUMN measfish.sequence.date_end IS 'End time of fishing at this place';
-- ddl-end --
COMMENT ON COLUMN measfish.sequence.fishing_duration IS 'Fishing duration, in mn';
-- ddl-end --
ALTER TABLE measfish.sequence OWNER TO measfish;
-- ddl-end --

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.sequence DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE measfish.sequence ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES measfish.operation (operation_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.sample | type: TABLE --
-- DROP TABLE IF EXISTS measfish.sample CASCADE;
CREATE TABLE measfish.sample (
	sample_id integer NOT NULL DEFAULT nextval('measfish.sample_sample_id_seq'::regclass),
	sequence_id integer NOT NULL,
	taxon_name varchar NOT NULL,
	total_number smallint NOT NULL DEFAULT 1,
	total_measured smallint,
	total_weight double precision,
	sample_size_min float,
	sample_size_max float,
	sample_comment varchar,
	taxon_id integer,
	CONSTRAINT sample_id_pk PRIMARY KEY (sample_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.sample IS 'List of samplings. One or many for a taxon';
-- ddl-end --
COMMENT ON COLUMN measfish.sample.taxon_name IS 'Name of the taxon, issued from the table of taxa or created if a new taxon discovered';
-- ddl-end --
COMMENT ON COLUMN measfish.sample.total_number IS 'Total number of catched elements
0 : presence of the taxon, but number not estimated';
-- ddl-end --
COMMENT ON COLUMN measfish.sample.total_measured IS 'Number of elements measured';
-- ddl-end --
COMMENT ON COLUMN measfish.sample.total_weight IS 'Total weight, in g';
-- ddl-end --
COMMENT ON COLUMN measfish.sample.sample_size_min IS 'Minimal size of fishes in this sample, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.sample.sample_size_max IS 'Maximal size of fishes in this sample, in cm';
-- ddl-end --
ALTER TABLE measfish.sample OWNER TO measfish;
-- ddl-end --

-- object: sequence_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.sample DROP CONSTRAINT IF EXISTS sequence_fk CASCADE;
ALTER TABLE measfish.sample ADD CONSTRAINT sequence_fk FOREIGN KEY (sequence_id)
REFERENCES measfish.sequence (sequence_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: taxon_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.sample DROP CONSTRAINT IF EXISTS taxon_fk CASCADE;
ALTER TABLE measfish.sample ADD CONSTRAINT taxon_fk FOREIGN KEY (taxon_id)
REFERENCES measfish.taxon (taxon_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.item_item_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.item_item_id_seq CASCADE;
CREATE SEQUENCE measfish.item_item_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.item_item_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.individual | type: TABLE --
-- DROP TABLE IF EXISTS measfish.individual CASCADE;
CREATE TABLE measfish.individual (
	individual_id integer NOT NULL DEFAULT nextval('measfish.item_item_id_seq'::regclass),
	sample_id integer NOT NULL,
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
	pathology_code varchar,
	tag varchar,
	tag_posed varchar,
	sexe_id integer,
	pathology_id integer,
	CONSTRAINT individual_id_pk PRIMARY KEY (individual_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.individual IS 'List of individuals measured';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.other_measure IS 'List of others measures realized on an item';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.sl IS 'Standard length, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.fl IS 'Fork length, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.tl IS 'Total length, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.wd IS 'Width of disk, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.ot IS 'Other length, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.weight IS 'Weight, in g';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.age IS 'Age of fish, in year';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.measure_estimated IS 'Is the measure estimated ?';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.pathology_code IS 'List of codes of pathologies or remarks';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.tag IS 'Read tag';
-- ddl-end --
COMMENT ON COLUMN measfish.individual.tag_posed IS 'Tag posed on the fish';
-- ddl-end --
ALTER TABLE measfish.individual OWNER TO measfish;
-- ddl-end --

-- object: sample_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.individual DROP CONSTRAINT IF EXISTS sample_fk CASCADE;
ALTER TABLE measfish.individual ADD CONSTRAINT sample_fk FOREIGN KEY (sample_id)
REFERENCES measfish.sample (sample_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.measure_template_measure_template_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.measure_template_measure_template_id_seq CASCADE;
CREATE SEQUENCE measfish.measure_template_measure_template_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.measure_template_measure_template_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.measure_template | type: TABLE --
-- DROP TABLE IF EXISTS measfish.measure_template CASCADE;
CREATE TABLE measfish.measure_template (
	measure_template_id integer NOT NULL DEFAULT nextval('measfish.measure_template_measure_template_id_seq'::regclass),
	measure_template_name smallint NOT NULL,
	measure_template_value json,
	taxon_id integer NOT NULL,
	CONSTRAINT measure_template_pk PRIMARY KEY (measure_template_id)

);
-- ddl-end --
COMMENT ON COLUMN measfish.measure_template.measure_template_value IS 'List of all measures usable by a taxon.
For each type : name, extended.
By default : total_length and weight';
-- ddl-end --
ALTER TABLE measfish.measure_template OWNER TO measfish;
-- ddl-end --

-- object: measfish.operation_template_operation_template_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.operation_template_operation_template_id_seq CASCADE;
CREATE SEQUENCE measfish.operation_template_operation_template_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.operation_template_operation_template_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.item_generated_item_generated_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.item_generated_item_generated_id_seq CASCADE;
CREATE SEQUENCE measfish.item_generated_item_generated_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.item_generated_item_generated_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.gear_gear_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.gear_gear_id_seq CASCADE;
CREATE SEQUENCE measfish.gear_gear_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.gear_gear_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.sequence_gear_sequence_gear_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.sequence_gear_sequence_gear_id_seq CASCADE;
CREATE SEQUENCE measfish.sequence_gear_sequence_gear_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.sequence_gear_sequence_gear_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.gear | type: TABLE --
-- DROP TABLE IF EXISTS measfish.gear CASCADE;
CREATE TABLE measfish.gear (
	gear_id integer NOT NULL DEFAULT nextval('measfish.gear_gear_id_seq'::regclass),
	gear_name varchar NOT NULL,
	gear_length float,
	gear_height float,
	mesh_size varchar,
	CONSTRAINT fishing_gear_pk PRIMARY KEY (gear_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.gear IS 'Gear used for fishery';
-- ddl-end --
COMMENT ON COLUMN measfish.gear.gear_length IS 'Length of the net or other gear, in metter';
-- ddl-end --
COMMENT ON COLUMN measfish.gear.gear_height IS 'Height of the net or other gear, in metter';
-- ddl-end --
COMMENT ON COLUMN measfish.gear.mesh_size IS 'Size of the mesh, in textual form';
-- ddl-end --
ALTER TABLE measfish.gear OWNER TO measfish;
-- ddl-end --

-- object: measfish.sequence_gear | type: TABLE --
-- DROP TABLE IF EXISTS measfish.sequence_gear CASCADE;
CREATE TABLE measfish.sequence_gear (
	sequence_gear_id integer NOT NULL DEFAULT nextval('measfish.sequence_gear_sequence_gear_id_seq'::regclass),
	voltage float,
	amperage float,
	gear_nb smallint NOT NULL DEFAULT 1,
	depth float,
	sequence_id integer NOT NULL,
	gear_id integer NOT NULL,
	gear_method_id_gear_method integer,
	electric_current_type_id smallint,
	CONSTRAINT sequence_gear_pk PRIMARY KEY (sequence_gear_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.sequence_gear IS 'List of gear used during operation';
-- ddl-end --
COMMENT ON COLUMN measfish.sequence_gear.voltage IS 'Voltage used during electric fishing, in volt';
-- ddl-end --
COMMENT ON COLUMN measfish.sequence_gear.amperage IS 'Amperage used during electric fishing, in ampere';
-- ddl-end --
COMMENT ON COLUMN measfish.sequence_gear.gear_nb IS 'Nb of gears';
-- ddl-end --
COMMENT ON COLUMN measfish.sequence_gear.depth IS 'Depth of the gear';
-- ddl-end --
ALTER TABLE measfish.sequence_gear OWNER TO measfish;
-- ddl-end --

-- object: measfish.engine_engine_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.engine_engine_id_seq CASCADE;
CREATE SEQUENCE measfish.engine_engine_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.engine_engine_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.river_river_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.river_river_id_seq CASCADE;
CREATE SEQUENCE measfish.river_river_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.river_river_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.river | type: TABLE --
-- DROP TABLE IF EXISTS measfish.river CASCADE;
CREATE TABLE measfish.river (
	river_id integer NOT NULL DEFAULT nextval('measfish.river_river_id_seq'::regclass),
	river_name varchar NOT NULL,
	CONSTRAINT river_pk PRIMARY KEY (river_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.river IS 'River, estuary, sea...';
-- ddl-end --
ALTER TABLE measfish.river OWNER TO measfish;
-- ddl-end --

-- object: river_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.station DROP CONSTRAINT IF EXISTS river_fk CASCADE;
ALTER TABLE measfish.station ADD CONSTRAINT river_fk FOREIGN KEY (river_id)
REFERENCES measfish.river (river_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: sequence_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.sequence_gear DROP CONSTRAINT IF EXISTS sequence_fk CASCADE;
ALTER TABLE measfish.sequence_gear ADD CONSTRAINT sequence_fk FOREIGN KEY (sequence_id)
REFERENCES measfish.sequence (sequence_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: gear_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.sequence_gear DROP CONSTRAINT IF EXISTS gear_fk CASCADE;
ALTER TABLE measfish.sequence_gear ADD CONSTRAINT gear_fk FOREIGN KEY (gear_id)
REFERENCES measfish.gear (gear_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.analysis_analysis_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.analysis_analysis_id_seq CASCADE;
CREATE SEQUENCE measfish.analysis_analysis_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.analysis_analysis_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.analysis | type: TABLE --
-- DROP TABLE IF EXISTS measfish.analysis CASCADE;
CREATE TABLE measfish.analysis (
	analysis_id integer NOT NULL DEFAULT nextval('measfish.analysis_analysis_id_seq'::regclass),
	sequence_id integer,
	analysis_date timestamp,
	ph float,
	temperature float,
	o2_pc float,
	o2_mg float,
	salinity float,
	conductivity float,
	secchi float,
	other_analysis json,
	CONSTRAINT analysis_pk PRIMARY KEY (analysis_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.analysis IS 'Water analysis';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.analysis_date IS 'Date/time of the sampling';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.ph IS 'pH';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.temperature IS 'Temperature, in °C';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.o2_pc IS 'Percentage of oxygen saturation';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.o2_mg IS 'Oxygen level, in mg/l';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.salinity IS 'Salinity';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.conductivity IS 'Conductivity, in µS/cm';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.secchi IS 'Secchi depth, in meter';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis.other_analysis IS 'Others analysis performed (cf. analysis_template)';
-- ddl-end --
ALTER TABLE measfish.analysis OWNER TO measfish;
-- ddl-end --

-- object: sequence_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.analysis DROP CONSTRAINT IF EXISTS sequence_fk CASCADE;
ALTER TABLE measfish.analysis ADD CONSTRAINT sequence_fk FOREIGN KEY (sequence_id)
REFERENCES measfish.sequence (sequence_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.sexe | type: TABLE --
-- DROP TABLE IF EXISTS measfish.sexe CASCADE;
CREATE TABLE measfish.sexe (
	sexe_id integer NOT NULL,
	sexe_name varchar NOT NULL,
	sexe_code varchar NOT NULL,
	CONSTRAINT sexe_pk PRIMARY KEY (sexe_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.sexe IS 'Sexe of fishs';
-- ddl-end --
COMMENT ON COLUMN measfish.sexe.sexe_code IS 'Code of the sexe, according to the nomenclature sandre.eaufrance.fr 437';
-- ddl-end --
ALTER TABLE measfish.sexe OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.sexe (sexe_id, sexe_name, sexe_code) VALUES (E'1', E'Femelle', E'F');
-- ddl-end --
INSERT INTO measfish.sexe (sexe_id, sexe_name, sexe_code) VALUES (E'2', E'Mâle', E'M');
-- ddl-end --
INSERT INTO measfish.sexe (sexe_id, sexe_name, sexe_code) VALUES (E'3', E'Inconnu', E'N');
-- ddl-end --
INSERT INTO measfish.sexe (sexe_id, sexe_name, sexe_code) VALUES (E'4', E'Non identifié', E'R');
-- ddl-end --

-- object: sexe_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.individual DROP CONSTRAINT IF EXISTS sexe_fk CASCADE;
ALTER TABLE measfish.individual ADD CONSTRAINT sexe_fk FOREIGN KEY (sexe_id)
REFERENCES measfish.sexe (sexe_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.pathology_pathology_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.pathology_pathology_id_seq CASCADE;
CREATE SEQUENCE measfish.pathology_pathology_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.pathology_pathology_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.pathology | type: TABLE --
-- DROP TABLE IF EXISTS measfish.pathology CASCADE;
CREATE TABLE measfish.pathology (
	pathology_id integer NOT NULL DEFAULT nextval('measfish.pathology_pathology_id_seq'::regclass),
	pathology_name varchar NOT NULL,
	pathology_code varchar,
	pathology_description varchar,
	CONSTRAINT pathology_pk PRIMARY KEY (pathology_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.pathology IS 'List of pathologies';
-- ddl-end --
COMMENT ON COLUMN measfish.pathology.pathology_name IS 'Name of the pathology';
-- ddl-end --
COMMENT ON COLUMN measfish.pathology.pathology_code IS 'Code of the pathology, according to the nomenclature sandre.eaufrance.fr 129';
-- ddl-end --
COMMENT ON COLUMN measfish.pathology.pathology_description IS 'Description of the pathology';
-- ddl-end --
ALTER TABLE measfish.pathology OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'1', E'00', E'Ni poux, ni traces de poux', E'Le poisson, généralement un salmonidé migrateur venu de la mer, n''héberge aucun pou de mer et ne présente aucune lésion visible consécutive à une colonisation par le pou de mer (qui est en fait un crustacé parasite des salmonidés migrateurs)');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'2', E'AA', E'Altération de l''aspect', E'Le corps du poisson examiné présente des altérations morphologiques caractérisées, pouvant éventuellement être détaillées ou non.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'3', E'AC', E'Altération de la couleur', E'La pigmentation présente des altérations entrainant une coloration anormale de tout ou partie du corps du poisson.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'4', E'AD', E'Difforme', E'Le corps du poisson présente des déformations anormales se traduisant par des acures ou des bosselures,extériorisation possible d''une atteinte interne, virale par exemple (ex : nécrose pancréatique infectieuse de la truite arc-en-ciel)');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'5', E'AG', E'Grosseur, excroissance', E'Le corps du poisson présente une ou des déformations marquées constituant des excroissances ou des tumeurs');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'6', E'AH', E'Aspect hérissé (écailles)', E'Les écailles du poisson ont tendance à se relever perpendiculairement au corps, à la suite généralement d''une infection au niveau des téguments');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'7', E'AM', E'Maigreur', E'Le corps du poisson présente une minceur marquée par rapport à la normalité');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'8', E'AO', E'Absence d''organe', E'L''altération morphologique observée sur le poisson se traduit par l''absence d''un organe (nageoire, opercule, oeil, machoire)');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'9', E'BG', E'Bulle de gaz', E'Présence de bulle de gaz pouvant être observées sous la peau, au bord des nageoires, au niveau des yeux, des branchies ou de la bouche.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'10', E'CA', E'Coloration anormale', E'L''altération de la pigmentation entraîne la différenciation de zones diversement colorées, avec en particulier des zones sombres.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'11', E'CB', E'Branchiures (Argulus...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de crustacés branchiures à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'12', E'CC', E'Copépodes (Ergasilus, Lerna,...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de crustacés parasites, à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'13', E'CO', E'Coloration opaque (oeil)', E'L''altération de la coloration se traduit par une opacification de l''un ou des deux yeux.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'14', E'CR', E'Présence de crustacés', E'Présence visible, à la surface du corps ou des branchies du poisson, de crustacés parasites, à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'15', E'CS', E'Coloration sombre', E'L''altération de la coloration du corps du poisson se traduit par un assombrissement de tout ou partie de celui-ci (noircissement).');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'16', E'CT', E'Coloration terne (pâle)', E'L''altération de la coloration du corps du poisson se traduit par une absence de reflets lui conférant un aspect terne, pâle, voire une décoloration.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'17', E'ER', E'Erosion', DEFAULT);
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'18', E'EX', E'Exophtalmie ou proptose', DEFAULT);
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'19', E'HA', E'Acanthocéphales', E'Présence visible, à la surface du corps ou des branchies du poisson, d''acanthocéphales à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'20', E'HC', E'Cestodes (Ligula,  Bothriocephalus, ...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de cestodes à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'21', E'HE', E'Hémorragie', E'Ecoulement de sang pouvant être observ?? à la surface du corps ou au niveau des branchies.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'22', E'HH', E'Hirudinés (Piscicola)', E'Présence visible sur le poisson de sangsue(s)');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'23', E'HN', E'Nématodes (Philometra, Philimena...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de  nématodes à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'24', E'HS', E'Stade pre-mortem', E'Le poisson présente un état pathologique tel qu''il n''est plus capable de se mouvoir normalement dans son milieu et qu''il est voué à une mort certaine à brève échéance.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'25', E'HT', E'Trématodes (Bucephalus, ...)', E'Présence visible, à la surface du corps ou des branchies du poisson, de trématodes parasites à un stade donné de leur cycle de développement.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'26', E'IS', E'Individu sain', E'Après examen du poisson, aucun signe externe, caractéristique d''une pathologie quelconque, n''est décelable à l''oeil nu');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'27', E'LD', E'Lésions diverses', E'Les téguments présentent une altération quelconque de leur intégrité.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'28', E'NE', E'Nécrose', E'Lésion(s) observée(s) à la surface du corps avec mortification des tissus.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'29', E'NN', E'Pathologie non renseigné', E'L''aspect pathologique du poisson n''a fait l''objet d''aucun examen et aucune information n''est fournie à ce sujet');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'30', E'OO', E'Absence de lésions ou de parasites', DEFAULT);
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'31', E'PA', E'Parasitisme', E'Présence visible, à la surface du corps ou des branchies du poisson, d''organismes parasites vivant à ses dépens.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'32', E'PB', E'Points blancs', E'Présence de points blancs consécutive à la prolifération de certains protozoaires parasites comme Ichtyopthtirius (ne pas confondre avec les boutons de noces, formations kératinisées apparaissant  lors de la période de reproduction)');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'33', E'PC', E'Champignons (mousse, ...)', E'Présence d''un développement à la surface du corps, d''un mycélium formant une sorte de plaque rappelant l''aspect de la mousse et appartenant à une espèce de champignon colonisant les tissus du poisson.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'34', E'PL', E'Plaie - blessure', E'Présence d''une ou plusieurs lésions à la surface du tégument généralement due à un prédateur (poisson, oiseau,.)');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'35', E'PN', E'Points noirs', E'Présence de tâches noires bien individualisées sur la surface du tégument du poisson');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'36', E'PT', E'Parasites (PB ou PC ou CR ou HH ou PX)', DEFAULT);
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'37', E'PX', E'Autres parasites (autre que CR, HH, PB, PC)', DEFAULT);
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'38', E'SM', E'Sécrétion de mucus importante', E'Présence anormale de mucus sur le corps ou au niveau de la chambre branchiale.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'39', E'UH', E'Ulcère hémorragique', E'Ecoulement de sang observé au niveau d''une zone d''altération des tissus.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'40', E'US', E'Anus rouge ou saillant', DEFAULT);
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'41', E'VL', E'Vésicule contenant un liquide', E'Présence d''un oedème constituant une excroissance.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'42', E'ZO', E'Etat pathologie multiforme', E'Le poisson présente plus de deux caractéristiques pathologiques différentes');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'43', E'01', E'Traces de poux', E'Le poisson ne porte aucun pou mais présente des lésions cutanées consécutives à une colonisation par le pou de mer. La présence du poisson en eau douce a été suffisante pour obliger les poux à quitter leur hôte.');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'44', E'11', E'<10 poux , sans flagelles', E'Le poisson présente moins de 10 poux de mer, mais ces derniers, en raison d''un présence prolongée en eau douce, ont déjà perdu leur flagelle');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'45', E'21', E'<10 poux , avec flagelles', E'Le poisson présente moins de 10 poux de mer, mais ces derniers, compte-tenu de l''arrivée récente de leur hôte en eau douce, n''ont pas encore perdu leur flagelle');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'46', E'31', E'>10 poux, sans flagelles', E'Le poisson présente plus de 10 poux de mer, mais ces derniers, en raison d''un présence prolongée en eau douce, ont déjà perdu leur flagelle');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'47', E'42', E'>10 poux, avec flagelles', E'Le poisson présente plus de 10 poux de mer, mais ces derniers, compte-tenu de l''arrivée récente de leur hôte en eau douce, n''ont pas encore perdu leur flagelle');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'48', E'NC', E'Signe pathologique d''origine inconnue', E'Signe pathologique d''origine inconnue');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'49', E'AP', E'Aphanomycose ou peste de l’écrevisse', DEFAULT);
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'50', E'TH', E'Thélohaniose ou maladie de porcelaine', DEFAULT);
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'51', E'BR', E'Branchiobdellidae (Branchiobdella, Xironogiton, ...)', E'Présence de Branchiobdellidae (Branchiobdella, Xironogiton, ...)');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'52', E'CH', E'Chytridiomycose', E'maladie mortelle menaçant les amphibiens, cette maladie fongique est provoqué par champignon Batrachochytrium dendrobatidis, plus connu sous l’appellation de chytride');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'53', E'RO', E'Rouille', E'provoquée par un champignons parasites, elle se caractérisent par la présence de taches brun rouge ou noires entourées de rouge sur la carapace');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'54', E'MY', E'Mycose des oeufs', E'Les mycoses des oeufs: provoquent la mort et un changement de coloration de ceux-ci (deviennent orangés)');
-- ddl-end --
INSERT INTO measfish.pathology (pathology_id, pathology_code, pathology_name, pathology_description) VALUES (E'55', E'PF', E'Paragnathia formica', E'Paragnathia formica est un parasite qui est présent sur les saumons sauvages');
-- ddl-end --

-- object: pathology_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.individual DROP CONSTRAINT IF EXISTS pathology_fk CASCADE;
ALTER TABLE measfish.individual ADD CONSTRAINT pathology_fk FOREIGN KEY (pathology_id)
REFERENCES measfish.pathology (pathology_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: station_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation DROP CONSTRAINT IF EXISTS station_fk CASCADE;
ALTER TABLE measfish.operation ADD CONSTRAINT station_fk FOREIGN KEY (station_id)
REFERENCES measfish.station (station_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.facies_facies_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.facies_facies_id_seq CASCADE;
CREATE SEQUENCE measfish.facies_facies_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 11
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.facies_facies_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.ambience_ambience_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.ambience_ambience_id_seq CASCADE;
CREATE SEQUENCE measfish.ambience_ambience_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.ambience_ambience_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.situation_situation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.situation_situation_id_seq CASCADE;
CREATE SEQUENCE measfish.situation_situation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 11
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.situation_situation_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.facies | type: TABLE --
-- DROP TABLE IF EXISTS measfish.facies CASCADE;
CREATE TABLE measfish.facies (
	facies_id integer NOT NULL DEFAULT nextval('measfish.facies_facies_id_seq'::regclass),
	facies_name varchar NOT NULL,
	CONSTRAINT facies_pk PRIMARY KEY (facies_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.facies IS 'List of facies';
-- ddl-end --
ALTER TABLE measfish.facies OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'1', E'Rapide');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'2', E'Radier');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'3', E'Plat courant');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'4', E'Plat lent');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'5', E'Mouille ou profond');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'6', E'Chenal lotique (profond courant)');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'7', E'Chenal lentique (profond lent)');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'8', E'Remous ou contre-courant');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'9', E'Bras mort ou lône');
-- ddl-end --
INSERT INTO measfish.facies (facies_id, facies_name) VALUES (E'10', E'Darse');
-- ddl-end --

-- object: measfish.ambience | type: TABLE --
-- DROP TABLE IF EXISTS measfish.ambience CASCADE;
CREATE TABLE measfish.ambience (
	ambience_id integer NOT NULL DEFAULT nextval('measfish.ambience_ambience_id_seq'::regclass),
	operation_id integer NOT NULL,
	ambience_name varchar,
	ambience_length float,
	ambience_width float,
	ambience_depth float,
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
	turbidity_id_turbidity integer,
	CONSTRAINT ambience_pk PRIMARY KEY (ambience_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.ambience IS 'Description of the ambiences of the operation';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.ambience_name IS 'Name of the point';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.ambience_length IS 'Length of the point, in meter';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.ambience_width IS 'Width of the point, in meter';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.ambience_depth IS 'Average depth of water, in meter';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.ambience_long IS 'Longitude of the point of observation, in decimal WGS84';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.ambience_lat IS 'Latitude of the point of observation, in decimal WGS84';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.current_speed IS 'Speed measured of the current, in cm/s';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.current_speed_max IS 'Maximum value of the current, in cm/s';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.current_speed_min IS 'Minimum speed of the current, in cm/s';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.water_height IS 'Average height of water, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.water_height_max IS 'Max height of water, in cm';
-- ddl-end --
COMMENT ON COLUMN measfish.ambience.water_height_min IS 'Min of height of water, in cm';
-- ddl-end --
ALTER TABLE measfish.ambience OWNER TO measfish;
-- ddl-end --

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES measfish.operation (operation_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.situation | type: TABLE --
-- DROP TABLE IF EXISTS measfish.situation CASCADE;
CREATE TABLE measfish.situation (
	situation_id integer NOT NULL DEFAULT nextval('measfish.situation_situation_id_seq'::regclass),
	situation_name varchar NOT NULL,
	CONSTRAINT situation_pk PRIMARY KEY (situation_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.situation IS 'List of situations';
-- ddl-end --
ALTER TABLE measfish.situation OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.situation (situation_id, situation_name) VALUES (E'3', E'Confluence ruisseau');
-- ddl-end --
INSERT INTO measfish.situation (situation_id, situation_name) VALUES (E'4', E'Palplanche');
-- ddl-end --
INSERT INTO measfish.situation (situation_id, situation_name) VALUES (E'5', E'Exutoire d''étang');
-- ddl-end --
INSERT INTO measfish.situation (situation_id, situation_name) VALUES (E'6', E'Maçonnerie');
-- ddl-end --
INSERT INTO measfish.situation (situation_id, situation_name) VALUES (E'7', E'Aval d''ouvrage');
-- ddl-end --
INSERT INTO measfish.situation (situation_id, situation_name) VALUES (E'8', E'Enrochement');
-- ddl-end --
INSERT INTO measfish.situation (situation_id, situation_name) VALUES (E'9', E'Rejet');
-- ddl-end --
INSERT INTO measfish.situation (situation_id, situation_name) VALUES (E'10', E'Aval turbine/gabion');
-- ddl-end --

-- object: measfish.localisation_localisation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.localisation_localisation_id_seq CASCADE;
CREATE SEQUENCE measfish.localisation_localisation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 3
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.localisation_localisation_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.localisation | type: TABLE --
-- DROP TABLE IF EXISTS measfish.localisation CASCADE;
CREATE TABLE measfish.localisation (
	localisation_id integer NOT NULL DEFAULT nextval('measfish.localisation_localisation_id_seq'::regclass),
	localisation_name varchar NOT NULL,
	CONSTRAINT localisation_pk PRIMARY KEY (localisation_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.localisation IS 'List of localisations of the ambience';
-- ddl-end --
ALTER TABLE measfish.localisation OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.localisation (localisation_id, localisation_name) VALUES (E'1', E'Chenal');
-- ddl-end --
INSERT INTO measfish.localisation (localisation_id, localisation_name) VALUES (E'2', E'Berge');
-- ddl-end --

-- object: measfish.speed | type: TABLE --
-- DROP TABLE IF EXISTS measfish.speed CASCADE;
CREATE TABLE measfish.speed (
	speed_id integer NOT NULL,
	speed_name varchar NOT NULL,
	CONSTRAINT speed_pk PRIMARY KEY (speed_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.speed IS 'Speed of current, in cm/s';
-- ddl-end --
ALTER TABLE measfish.speed OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.speed (speed_id, speed_name) VALUES (E'1', E'< 10 cm/s');
-- ddl-end --
INSERT INTO measfish.speed (speed_id, speed_name) VALUES (E'2', E'11 à 40 cm/s');
-- ddl-end --
INSERT INTO measfish.speed (speed_id, speed_name) VALUES (E'3', E'41 à 80 cm/s');
-- ddl-end --
INSERT INTO measfish.speed (speed_id, speed_name) VALUES (E'4', E'81 à 150 cm/s');
-- ddl-end --
INSERT INTO measfish.speed (speed_id, speed_name) VALUES (E'5', E'> 151 cm/s');
-- ddl-end --

-- object: measfish.shady | type: TABLE --
-- DROP TABLE IF EXISTS measfish.shady CASCADE;
CREATE TABLE measfish.shady (
	shady_id integer NOT NULL,
	shady_name varchar NOT NULL,
	CONSTRAINT shady_pk PRIMARY KEY (shady_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.shady IS 'List of shaddies used for ambiences';
-- ddl-end --
ALTER TABLE measfish.shady OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.shady (shady_id, shady_name) VALUES (E'1', E'Rivière couverte (>90% d''ombrage)');
-- ddl-end --
INSERT INTO measfish.shady (shady_id, shady_name) VALUES (E'2', E'Rivière assez couverte (50 à 90% d''ombrage)');
-- ddl-end --
INSERT INTO measfish.shady (shady_id, shady_name) VALUES (E'3', E'Rivière assez dégagée (10 à 50 % d''ombrage)');
-- ddl-end --
INSERT INTO measfish.shady (shady_id, shady_name) VALUES (E'4', E'Rivière dégagée (< 10 % d''ombrage)');
-- ddl-end --

-- object: measfish.granulometry_granulometry_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.granulometry_granulometry_id_seq CASCADE;
CREATE SEQUENCE measfish.granulometry_granulometry_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 13
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.granulometry_granulometry_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.granulometry | type: TABLE --
-- DROP TABLE IF EXISTS measfish.granulometry CASCADE;
CREATE TABLE measfish.granulometry (
	granulometry_id integer NOT NULL DEFAULT nextval('measfish.granulometry_granulometry_id_seq'::regclass),
	granulometry_name varchar NOT NULL,
	CONSTRAINT granulometry_pk PRIMARY KEY (granulometry_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.granulometry IS 'List of types of granulometry';
-- ddl-end --
ALTER TABLE measfish.granulometry OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'1', E'Argile (<3,9 µm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'2', E'Limons (de 3,9 à 62,5 µm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'3', E'Sables fins (de 62,5 à 0,5 µm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'4', E'Sables grossiers (de 0,5 µm à 2 mm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'5', E'Graviers (de 2 à 16 mm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'6', E'Cailloux fins (de 16 à 32 mm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'7', E'Cailloux grossiers (de 32 à 64 mm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'8', E'Pierres fines (de 64 à 128 mm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'9', E'Pierres grossières (de 128 à 256 mm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'10', E'Blocs (de 256 à 1024 mm)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'11', E'Rochers (substra immergé avec protubérance)');
-- ddl-end --
INSERT INTO measfish.granulometry (granulometry_id, granulometry_name) VALUES (E'12', E'Dalle (substrat immergé sans protubérance)');
-- ddl-end --

-- object: measfish.vegetation_vegetation_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.vegetation_vegetation_id_seq CASCADE;
CREATE SEQUENCE measfish.vegetation_vegetation_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 9
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.vegetation_vegetation_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.vegetation | type: TABLE --
-- DROP TABLE IF EXISTS measfish.vegetation CASCADE;
CREATE TABLE measfish.vegetation (
	vegetation_id integer NOT NULL DEFAULT nextval('measfish.vegetation_vegetation_id_seq'::regclass),
	vegetation_name varchar NOT NULL,
	CONSTRAINT vegetation_pk PRIMARY KEY (vegetation_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.vegetation IS 'List of types of vegetation';
-- ddl-end --
ALTER TABLE measfish.vegetation OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.vegetation (vegetation_id, vegetation_name) VALUES (E'1', E'Algues - microphytes');
-- ddl-end --
INSERT INTO measfish.vegetation (vegetation_id, vegetation_name) VALUES (E'2', E'Plantes immergées à petites feuilles');
-- ddl-end --
INSERT INTO measfish.vegetation (vegetation_id, vegetation_name) VALUES (E'3', E'Plantes immergées à grandes feuilles');
-- ddl-end --
INSERT INTO measfish.vegetation (vegetation_id, vegetation_name) VALUES (E'4', E'Plante immergées à feuilles rubanées');
-- ddl-end --
INSERT INTO measfish.vegetation (vegetation_id, vegetation_name) VALUES (E'5', E'Plantes flottantes à petites feuilles');
-- ddl-end --
INSERT INTO measfish.vegetation (vegetation_id, vegetation_name) VALUES (E'6', E'Plantes flottantes à grandes feuilles');
-- ddl-end --
INSERT INTO measfish.vegetation (vegetation_id, vegetation_name) VALUES (E'7', E'Plantes émergées');
-- ddl-end --
INSERT INTO measfish.vegetation (vegetation_id, vegetation_name) VALUES (E'8', E'Pas de végétation');
-- ddl-end --

-- object: measfish.cache_abundance_cache_abundance_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.cache_abundance_cache_abundance_id_seq CASCADE;
CREATE SEQUENCE measfish.cache_abundance_cache_abundance_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 6
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.cache_abundance_cache_abundance_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.cache_abundance | type: TABLE --
-- DROP TABLE IF EXISTS measfish.cache_abundance CASCADE;
CREATE TABLE measfish.cache_abundance (
	cache_abundance_id integer NOT NULL DEFAULT nextval('measfish.cache_abundance_cache_abundance_id_seq'::regclass),
	cache_abundance_name varchar NOT NULL,
	CONSTRAINT cache_abundance_pk PRIMARY KEY (cache_abundance_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.cache_abundance IS 'Levels of abundance of caches';
-- ddl-end --
ALTER TABLE measfish.cache_abundance OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'1', E'Nulle');
-- ddl-end --
INSERT INTO measfish.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'2', E'Faible');
-- ddl-end --
INSERT INTO measfish.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'3', E'Moyenne');
-- ddl-end --
INSERT INTO measfish.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'4', E'Importante');
-- ddl-end --
INSERT INTO measfish.cache_abundance (cache_abundance_id, cache_abundance_name) VALUES (E'5', E'Indéterminable');
-- ddl-end --

-- object: facies_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS facies_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT facies_fk FOREIGN KEY (facies_id)
REFERENCES measfish.facies (facies_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: situation_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS situation_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT situation_fk FOREIGN KEY (situation_id)
REFERENCES measfish.situation (situation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: speed_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS speed_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT speed_fk FOREIGN KEY (speed_id)
REFERENCES measfish.speed (speed_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: shady_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS shady_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT shady_fk FOREIGN KEY (shady_id)
REFERENCES measfish.shady (shady_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: localisation_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS localisation_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT localisation_fk FOREIGN KEY (localisation_id)
REFERENCES measfish.localisation (localisation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: vegetation_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS vegetation_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT vegetation_fk FOREIGN KEY (vegetation_id)
REFERENCES measfish.vegetation (vegetation_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: granulometry_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS granulometry_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT granulometry_fk FOREIGN KEY (dominant_granulometry_id)
REFERENCES measfish.granulometry (granulometry_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: granulometry_fk1 | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS granulometry_fk1 CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT granulometry_fk1 FOREIGN KEY (secondary_granulometry_id)
REFERENCES measfish.granulometry (granulometry_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT cache_abundance_fk FOREIGN KEY (herbarium_cache_abundance_id)
REFERENCES measfish.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk1 | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk1 CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT cache_abundance_fk1 FOREIGN KEY (branch_cache_abundance_id)
REFERENCES measfish.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk2 | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk2 CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT cache_abundance_fk2 FOREIGN KEY (vegetation_cache_abundance_id)
REFERENCES measfish.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk3 | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk3 CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT cache_abundance_fk3 FOREIGN KEY (subbank_cache_abundance_id)
REFERENCES measfish.cache_abundance (cache_abundance_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: cache_abundance_fk4 | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS cache_abundance_fk4 CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT cache_abundance_fk4 FOREIGN KEY (granulometry_cache_abundance_id)
REFERENCES measfish.cache_abundance (cache_abundance_id) MATCH FULL
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
ALTER SEQUENCE gacl.aclgroup_aclgroup_id_seq OWNER TO measfish;
-- ddl-end --

-- object: gacl.aclacl | type: TABLE --
-- DROP TABLE IF EXISTS gacl.aclacl CASCADE;
CREATE TABLE gacl.aclacl (
	aclaco_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT aclacl_pk PRIMARY KEY (aclaco_id,aclgroup_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.aclacl IS 'Table des droits attribués';
-- ddl-end --
ALTER TABLE gacl.aclacl OWNER TO measfish;
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
ALTER SEQUENCE gacl.aclaco_aclaco_id_seq OWNER TO measfish;
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
COMMENT ON TABLE gacl.aclaco IS 'Table des droits gérés';
-- ddl-end --
ALTER TABLE gacl.aclaco OWNER TO measfish;
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
ALTER SEQUENCE gacl.aclappli_aclappli_id_seq OWNER TO measfish;
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
COMMENT ON TABLE gacl.aclappli IS 'Table des applications gérées';
-- ddl-end --
COMMENT ON COLUMN gacl.aclappli.appli IS 'Nom de l''application pour la gestion des droits';
-- ddl-end --
COMMENT ON COLUMN gacl.aclappli.applidetail IS 'Description de l''application';
-- ddl-end --
ALTER TABLE gacl.aclappli OWNER TO measfish;
-- ddl-end --

INSERT INTO gacl.aclappli (aclappli_id, appli, applidetail) VALUES (E'1', E'measfish', DEFAULT);
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
COMMENT ON TABLE gacl.aclgroup IS 'Groupes des logins';
-- ddl-end --
ALTER TABLE gacl.aclgroup OWNER TO measfish;
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
ALTER SEQUENCE gacl.acllogin_acllogin_id_seq OWNER TO measfish;
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
COMMENT ON TABLE gacl.acllogin IS 'Table des logins des utilisateurs autorisés';
-- ddl-end --
COMMENT ON COLUMN gacl.acllogin.logindetail IS 'Nom affiché';
-- ddl-end --
ALTER TABLE gacl.acllogin OWNER TO measfish;
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
COMMENT ON TABLE gacl.acllogingroup IS 'Table des relations entre les logins et les groupes';
-- ddl-end --
ALTER TABLE gacl.acllogingroup OWNER TO measfish;
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
ALTER SEQUENCE gacl.log_log_id_seq OWNER TO measfish;
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
COMMENT ON TABLE gacl.log IS 'Liste des connexions ou des actions enregistrées';
-- ddl-end --
COMMENT ON COLUMN gacl.log.log_date IS 'Heure de connexion';
-- ddl-end --
COMMENT ON COLUMN gacl.log.commentaire IS 'Donnees complementaires enregistrees';
-- ddl-end --
COMMENT ON COLUMN gacl.log.ipaddress IS 'Adresse IP du client';
-- ddl-end --
ALTER TABLE gacl.log OWNER TO measfish;
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
ALTER SEQUENCE gacl.seq_logingestion_id OWNER TO measfish;
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
ALTER SEQUENCE gacl.login_oldpassword_login_oldpassword_id_seq OWNER TO measfish;
-- ddl-end --

-- object: gacl.login_oldpassword | type: TABLE --
-- DROP TABLE IF EXISTS gacl.login_oldpassword CASCADE;
CREATE TABLE gacl.login_oldpassword (
	login_oldpassword_id integer NOT NULL DEFAULT nextval('gacl.login_oldpassword_login_oldpassword_id_seq'::regclass),
	id integer NOT NULL DEFAULT nextval('gacl.seq_logingestion_id'::regclass),
	password character varying(255),
	CONSTRAINT login_oldpassword_pk PRIMARY KEY (login_oldpassword_id)

);
-- ddl-end --
COMMENT ON TABLE gacl.login_oldpassword IS 'Table contenant les anciens mots de passe';
-- ddl-end --
ALTER TABLE gacl.login_oldpassword OWNER TO measfish;
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
	datemodif date,
	actif smallint DEFAULT 1,
	is_clientws boolean NOT NULL DEFAULT false,
	tokenws character varying,
	CONSTRAINT pk_logingestion PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE gacl.logingestion OWNER TO measfish;
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

-- object: measfish.project_group | type: TABLE --
-- DROP TABLE IF EXISTS measfish.project_group CASCADE;
CREATE TABLE measfish.project_group (
	project_id integer NOT NULL,
	aclgroup_id integer NOT NULL,
	CONSTRAINT project_group_pk PRIMARY KEY (project_id,aclgroup_id)

);
-- ddl-end --
ALTER TABLE measfish.project_group OWNER TO measfish;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.project_group DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE measfish.project_group ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES measfish.project (project_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: aclgroup_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.project_group DROP CONSTRAINT IF EXISTS aclgroup_fk CASCADE;
ALTER TABLE measfish.project_group ADD CONSTRAINT aclgroup_fk FOREIGN KEY (aclgroup_id)
REFERENCES gacl.aclgroup (aclgroup_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.operator_operator_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.operator_operator_id_seq CASCADE;
CREATE SEQUENCE measfish.operator_operator_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.operator_operator_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.operator | type: TABLE --
-- DROP TABLE IF EXISTS measfish.operator CASCADE;
CREATE TABLE measfish.operator (
	operator_id integer NOT NULL DEFAULT nextval('measfish.operator_operator_id_seq'::regclass),
	firstname varchar,
	name varchar NOT NULL,
	is_active boolean NOT NULL DEFAULT 't',
	CONSTRAINT operator_pk PRIMARY KEY (operator_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.operator IS 'List of operators';
-- ddl-end --
COMMENT ON COLUMN measfish.operator.firstname IS 'First name of the operator';
-- ddl-end --
COMMENT ON COLUMN measfish.operator.name IS 'Last name of operator';
-- ddl-end --
COMMENT ON COLUMN measfish.operator.is_active IS 'Is the opérator actually active ?';
-- ddl-end --
ALTER TABLE measfish.operator OWNER TO measfish;
-- ddl-end --

-- object: measfish.operation_operator | type: TABLE --
-- DROP TABLE IF EXISTS measfish.operation_operator CASCADE;
CREATE TABLE measfish.operation_operator (
	is_responsible bool DEFAULT 't',
	operation_id integer NOT NULL,
	operator_id integer NOT NULL,
	CONSTRAINT operation_operator_pk PRIMARY KEY (operation_id,operator_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.operation_operator IS 'Operators rattached to an operation';
-- ddl-end --
COMMENT ON COLUMN measfish.operation_operator.is_responsible IS 'True if the operator is responsible of the operation';
-- ddl-end --
ALTER TABLE measfish.operation_operator OWNER TO measfish;
-- ddl-end --

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation_operator DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE measfish.operation_operator ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES measfish.operation (operation_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: operator_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation_operator DROP CONSTRAINT IF EXISTS operator_fk CASCADE;
ALTER TABLE measfish.operation_operator ADD CONSTRAINT operator_fk FOREIGN KEY (operator_id)
REFERENCES measfish.operator (operator_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.analysis_template_analysis_template_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.analysis_template_analysis_template_id_seq CASCADE;
CREATE SEQUENCE measfish.analysis_template_analysis_template_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.analysis_template_analysis_template_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.analysis_template | type: TABLE --
-- DROP TABLE IF EXISTS measfish.analysis_template CASCADE;
CREATE TABLE measfish.analysis_template (
	analysis_template_id integer NOT NULL DEFAULT nextval('measfish.analysis_template_analysis_template_id_seq'::regclass),
	analysis_template_name varchar NOT NULL,
	analysis_template_value json,
	CONSTRAINT analysis_template_pk PRIMARY KEY (analysis_template_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.analysis_template IS 'Table of types of complementary analysis';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis_template.analysis_template_name IS 'Name of the template';
-- ddl-end --
COMMENT ON COLUMN measfish.analysis_template.analysis_template_value IS 'Description of all parameters recorded, in Json format';
-- ddl-end --
ALTER TABLE measfish.analysis_template OWNER TO measfish;
-- ddl-end --

-- object: measfish.cloggging_clogging_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.cloggging_clogging_id_seq CASCADE;
CREATE SEQUENCE measfish.cloggging_clogging_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 10
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.cloggging_clogging_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.clogging | type: TABLE --
-- DROP TABLE IF EXISTS measfish.clogging CASCADE;
CREATE TABLE measfish.clogging (
	clogging_id integer NOT NULL DEFAULT nextval('measfish.cloggging_clogging_id_seq'::regclass),
	clogging_name varchar NOT NULL,
	CONSTRAINT clogging_pk PRIMARY KEY (clogging_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.clogging IS 'List of types of cloggings';
-- ddl-end --
COMMENT ON COLUMN measfish.clogging.clogging_name IS 'Name of the type of clogging';
-- ddl-end --
ALTER TABLE measfish.clogging OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'1', E'Pas de colmatage');
-- ddl-end --
INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'2', E'Sable');
-- ddl-end --
INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'3', E'Vase');
-- ddl-end --
INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'4', E'Sédiments fins');
-- ddl-end --
INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'5', E'Recouvrements biologiques');
-- ddl-end --
INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'6', E'Débris végétaux');
-- ddl-end --
INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'7', E'Litières');
-- ddl-end --
INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'8', E'Dépôts incrustants');
-- ddl-end --
INSERT INTO measfish.clogging (clogging_id, clogging_name) VALUES (E'9', E'Autres');
-- ddl-end --

-- object: clogging_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS clogging_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT clogging_fk FOREIGN KEY (clogging_id)
REFERENCES measfish.clogging (clogging_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.sinuosity_sinuosity_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.sinuosity_sinuosity_id_seq CASCADE;
CREATE SEQUENCE measfish.sinuosity_sinuosity_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 5
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.sinuosity_sinuosity_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.sinuosity | type: TABLE --
-- DROP TABLE IF EXISTS measfish.sinuosity CASCADE;
CREATE TABLE measfish.sinuosity (
	sinuosity_id integer NOT NULL DEFAULT nextval('measfish.sinuosity_sinuosity_id_seq'::regclass),
	sinuosity_name varchar NOT NULL,
	CONSTRAINT sinuosity_pk PRIMARY KEY (sinuosity_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.sinuosity IS 'List of types of sinuosities of the river';
-- ddl-end --
ALTER TABLE measfish.sinuosity OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.sinuosity (sinuosity_id, sinuosity_name) VALUES (E'1', E'Cours d''eau rectiligne');
-- ddl-end --
INSERT INTO measfish.sinuosity (sinuosity_id, sinuosity_name) VALUES (E'2', E'Cours d''eau sinueux');
-- ddl-end --
INSERT INTO measfish.sinuosity (sinuosity_id, sinuosity_name) VALUES (E'3', E'Cours d''eau très sinueux');
-- ddl-end --
INSERT INTO measfish.sinuosity (sinuosity_id, sinuosity_name) VALUES (E'4', E'Cours d''eau méandriforme');
-- ddl-end --

-- object: sinuosity_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS sinuosity_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT sinuosity_fk FOREIGN KEY (sinuosity_id)
REFERENCES measfish.sinuosity (sinuosity_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.flow_trend_flow_trend_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.flow_trend_flow_trend_id_seq CASCADE;
CREATE SEQUENCE measfish.flow_trend_flow_trend_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 5
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.flow_trend_flow_trend_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.flow_trend | type: TABLE --
-- DROP TABLE IF EXISTS measfish.flow_trend CASCADE;
CREATE TABLE measfish.flow_trend (
	flow_trend_id integer NOT NULL DEFAULT nextval('measfish.flow_trend_flow_trend_id_seq'::regclass),
	flow_trend_name varchar NOT NULL,
	CONSTRAINT flow_trend_pk PRIMARY KEY (flow_trend_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.flow_trend IS 'List of trends of flow';
-- ddl-end --
ALTER TABLE measfish.flow_trend OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.flow_trend (flow_trend_id, flow_trend_name) VALUES (E'1', E'Augmentation (en crue)');
-- ddl-end --
INSERT INTO measfish.flow_trend (flow_trend_id, flow_trend_name) VALUES (E'2', E'Diminution (en décrue)');
-- ddl-end --
INSERT INTO measfish.flow_trend (flow_trend_id, flow_trend_name) VALUES (E'3', E'Stabilité');
-- ddl-end --
INSERT INTO measfish.flow_trend (flow_trend_id, flow_trend_name) VALUES (E'4', E'Irrégularité');
-- ddl-end --

-- object: flow_trend_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS flow_trend_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT flow_trend_fk FOREIGN KEY (flow_trend_id)
REFERENCES measfish.flow_trend (flow_trend_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.turbidity_id | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.turbidity_id CASCADE;
CREATE SEQUENCE measfish.turbidity_id
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 5
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.turbidity_id OWNER TO postgres;
-- ddl-end --

-- object: measfish.turbidity | type: TABLE --
-- DROP TABLE IF EXISTS measfish.turbidity CASCADE;
CREATE TABLE measfish.turbidity (
	turbidity_id integer NOT NULL DEFAULT nextval('measfish.turbidity_id'::regclass),
	turbidity_name varchar NOT NULL,
	CONSTRAINT turbidity_pk PRIMARY KEY (turbidity_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.turbidity IS 'List of types of turbidity';
-- ddl-end --
ALTER TABLE measfish.turbidity OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.turbidity (turbidity_id, turbidity_name) VALUES (E'1', E'Nulle');
-- ddl-end --
INSERT INTO measfish.turbidity (turbidity_id, turbidity_name) VALUES (E'2', E'Faible');
-- ddl-end --
INSERT INTO measfish.turbidity (turbidity_id, turbidity_name) VALUES (E'3', E'Moyenne');
-- ddl-end --
INSERT INTO measfish.turbidity (turbidity_id, turbidity_name) VALUES (E'4', E'Forte');
-- ddl-end --

-- object: turbidity_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.ambience DROP CONSTRAINT IF EXISTS turbidity_fk CASCADE;
ALTER TABLE measfish.ambience ADD CONSTRAINT turbidity_fk FOREIGN KEY (turbidity_id_turbidity)
REFERENCES measfish.turbidity (turbidity_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: ambience_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.sequence DROP CONSTRAINT IF EXISTS ambience_fk CASCADE;
ALTER TABLE measfish.sequence ADD CONSTRAINT ambience_fk FOREIGN KEY (ambience_id)
REFERENCES measfish.ambience (ambience_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.protocol_protocol_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.protocol_protocol_id_seq CASCADE;
CREATE SEQUENCE measfish.protocol_protocol_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 2
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.protocol_protocol_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.protocol | type: TABLE --
-- DROP TABLE IF EXISTS measfish.protocol CASCADE;
CREATE TABLE measfish.protocol (
	protocol_id integer NOT NULL DEFAULT nextval('measfish.protocol_protocol_id_seq'::regclass),
	protocol_name varchar NOT NULL,
	protocol_url varchar,
	protocol_description varchar,
	protocol_pdf bytea,
	measure_default varchar NOT NULL DEFAULT 'sl',
	measure_default_only boolean NOT NULL DEFAULT false,
	analysis_template_id integer,
	CONSTRAINT protocol_pk PRIMARY KEY (protocol_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.protocol IS 'List of protocols used';
-- ddl-end --
COMMENT ON COLUMN measfish.protocol.protocol_name IS 'Name of the protocol';
-- ddl-end --
COMMENT ON COLUMN measfish.protocol.protocol_url IS 'Url where the description of the protocol can be found';
-- ddl-end --
COMMENT ON COLUMN measfish.protocol.protocol_description IS 'Synthetic description of the protocol';
-- ddl-end --
COMMENT ON COLUMN measfish.protocol.protocol_pdf IS 'Document attached in pdf format';
-- ddl-end --
COMMENT ON COLUMN measfish.protocol.measure_default IS 'Name of the prefered measure in the protocol
Possible values : sl, fl, tl, wd, ot';
-- ddl-end --
COMMENT ON COLUMN measfish.protocol.measure_default_only IS 'If true, only the measure_default type is used during the protocol';
-- ddl-end --
ALTER TABLE measfish.protocol OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.protocol (protocol_id, protocol_name, protocol_url, protocol_description, protocol_pdf, measure_default, measure_default_only, analysis_template_id) VALUES (E'1', E'Default', DEFAULT, E'Protocole par défaut', DEFAULT, E'lt', E'0', DEFAULT);
-- ddl-end --

-- object: protocol_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation DROP CONSTRAINT IF EXISTS protocol_fk CASCADE;
ALTER TABLE measfish.operation ADD CONSTRAINT protocol_fk FOREIGN KEY (protocol_id)
REFERENCES measfish.protocol (protocol_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: taxon_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.measure_template DROP CONSTRAINT IF EXISTS taxon_fk CASCADE;
ALTER TABLE measfish.measure_template ADD CONSTRAINT taxon_fk FOREIGN KEY (taxon_id)
REFERENCES measfish.taxon (taxon_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.protocol_measure | type: TABLE --
-- DROP TABLE IF EXISTS measfish.protocol_measure CASCADE;
CREATE TABLE measfish.protocol_measure (
	protocol_id integer NOT NULL,
	measure_template_id integer NOT NULL,
	CONSTRAINT protocol_measure_pk PRIMARY KEY (protocol_id,measure_template_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.protocol_measure IS 'List of particular species measures used in the protocol';
-- ddl-end --
ALTER TABLE measfish.protocol_measure OWNER TO measfish;
-- ddl-end --

-- object: protocol_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.protocol_measure DROP CONSTRAINT IF EXISTS protocol_fk CASCADE;
ALTER TABLE measfish.protocol_measure ADD CONSTRAINT protocol_fk FOREIGN KEY (protocol_id)
REFERENCES measfish.protocol (protocol_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: measure_template_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.protocol_measure DROP CONSTRAINT IF EXISTS measure_template_fk CASCADE;
ALTER TABLE measfish.protocol_measure ADD CONSTRAINT measure_template_fk FOREIGN KEY (measure_template_id)
REFERENCES measfish.measure_template (measure_template_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: analysis_template_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.protocol DROP CONSTRAINT IF EXISTS analysis_template_fk CASCADE;
ALTER TABLE measfish.protocol ADD CONSTRAINT analysis_template_fk FOREIGN KEY (analysis_template_id)
REFERENCES measfish.analysis_template (analysis_template_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.water_regime_water_regime_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.water_regime_water_regime_id_seq CASCADE;
CREATE SEQUENCE measfish.water_regime_water_regime_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 5
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.water_regime_water_regime_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.water_regime | type: TABLE --
-- DROP TABLE IF EXISTS measfish.water_regime CASCADE;
CREATE TABLE measfish.water_regime (
	water_regime_id integer NOT NULL DEFAULT nextval('measfish.water_regime_water_regime_id_seq'::regclass),
	water_regime_name varchar NOT NULL,
	CONSTRAINT water_regime_pk PRIMARY KEY (water_regime_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.water_regime IS 'List of water regimes';
-- ddl-end --
ALTER TABLE measfish.water_regime OWNER TO measfish;
-- ddl-end --






-- object: water_regime_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation DROP CONSTRAINT IF EXISTS water_regime_fk CASCADE;
ALTER TABLE measfish.operation ADD CONSTRAINT water_regime_fk FOREIGN KEY (water_regime_id)
REFERENCES measfish.water_regime (water_regime_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.electric_current_type | type: TABLE --
-- DROP TABLE IF EXISTS measfish.electric_current_type CASCADE;
CREATE TABLE measfish.electric_current_type (
	electric_current_type_id smallint NOT NULL,
	electric_current_type_name varchar NOT NULL,
	CONSTRAINT electric_current_type_pk PRIMARY KEY (electric_current_type_id)

);
-- ddl-end --
ALTER TABLE measfish.electric_current_type OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.electric_current_type (electric_current_type_id, electric_current_type_name) VALUES (E'1', E'Continu');
-- ddl-end --
INSERT INTO measfish.electric_current_type (electric_current_type_id, electric_current_type_name) VALUES (E'2', E'Ondulé');
-- ddl-end --

-- object: measfish.fishing_strategy_fishing_strategy_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.fishing_strategy_fishing_strategy_id_seq CASCADE;
CREATE SEQUENCE measfish.fishing_strategy_fishing_strategy_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 3
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.fishing_strategy_fishing_strategy_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.fishing_strategy | type: TABLE --
-- DROP TABLE IF EXISTS measfish.fishing_strategy CASCADE;
CREATE TABLE measfish.fishing_strategy (
	fishing_strategy_id integer NOT NULL DEFAULT nextval('measfish.fishing_strategy_fishing_strategy_id_seq'::regclass),
	fishing_strategy_name varchar NOT NULL,
	CONSTRAINT fishing_strategy_pk PRIMARY KEY (fishing_strategy_id)

);
-- ddl-end --
ALTER TABLE measfish.fishing_strategy OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.fishing_strategy (fishing_strategy_id, fishing_strategy_name) VALUES (E'1', E'Inventaire');
-- ddl-end --
INSERT INTO measfish.fishing_strategy (fishing_strategy_id, fishing_strategy_name) VALUES (E'2', E'Sondage');
-- ddl-end --
INSERT INTO measfish.fishing_strategy (fishing_strategy_id, fishing_strategy_name) VALUES (E'3', E'EPA');
-- ddl-end --

-- object: fishing_strategy_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation DROP CONSTRAINT IF EXISTS fishing_strategy_fk CASCADE;
ALTER TABLE measfish.operation ADD CONSTRAINT fishing_strategy_fk FOREIGN KEY (fishing_strategy_id)
REFERENCES measfish.fishing_strategy (fishing_strategy_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.scale_scale_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.scale_scale_id_seq CASCADE;
CREATE SEQUENCE measfish.scale_scale_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 4
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.scale_scale_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.scale | type: TABLE --
-- DROP TABLE IF EXISTS measfish.scale CASCADE;
CREATE TABLE measfish.scale (
	scale_id integer NOT NULL DEFAULT nextval('measfish.scale_scale_id_seq'::regclass),
	scale_name varchar NOT NULL,
	CONSTRAINT scale_pk PRIMARY KEY (scale_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.scale IS 'Scale of the operation (global station, point, ambience)';
-- ddl-end --
ALTER TABLE measfish.scale OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.scale (scale_id, scale_name) VALUES (E'1', E'Global station');
-- ddl-end --
INSERT INTO measfish.scale (scale_id, scale_name) VALUES (E'2', E'Ambiances');
-- ddl-end --
INSERT INTO measfish.scale (scale_id, scale_name) VALUES (E'3', E'Points');
-- ddl-end --

-- object: scale_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation DROP CONSTRAINT IF EXISTS scale_fk CASCADE;
ALTER TABLE measfish.operation ADD CONSTRAINT scale_fk FOREIGN KEY (scale_id)
REFERENCES measfish.scale (scale_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.gear_method_gear_method_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.gear_method_gear_method_id_seq CASCADE;
CREATE SEQUENCE measfish.gear_method_gear_method_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 3
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.gear_method_gear_method_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.gear_method | type: TABLE --
-- DROP TABLE IF EXISTS measfish.gear_method CASCADE;
CREATE TABLE measfish.gear_method (
	gear_method_id integer NOT NULL DEFAULT nextval('measfish.gear_method_gear_method_id_seq'::regclass),
	gear_method_name varchar NOT NULL,
	CONSTRAINT gear_method_pk PRIMARY KEY (gear_method_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.gear_method IS 'Method of usage of the gear (in boat, walk fishing, etc.)';
-- ddl-end --
ALTER TABLE measfish.gear_method OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.gear_method (gear_method_id, gear_method_name) VALUES (E'1', E'À pied');
-- ddl-end --
INSERT INTO measfish.gear_method (gear_method_id, gear_method_name) VALUES (E'2', E'En bateau');
-- ddl-end --
INSERT INTO measfish.gear_method (gear_method_id, gear_method_name) VALUES (E'3', E'Autre');
-- ddl-end --

-- object: gear_method_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.sequence_gear DROP CONSTRAINT IF EXISTS gear_method_fk CASCADE;
ALTER TABLE measfish.sequence_gear ADD CONSTRAINT gear_method_fk FOREIGN KEY (gear_method_id_gear_method)
REFERENCES measfish.gear_method (gear_method_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: electric_current_type_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.sequence_gear DROP CONSTRAINT IF EXISTS electric_current_type_fk CASCADE;
ALTER TABLE measfish.sequence_gear ADD CONSTRAINT electric_current_type_fk FOREIGN KEY (electric_current_type_id)
REFERENCES measfish.electric_current_type (electric_current_type_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
-- ddl-end --

-- object: measfish.dbparam | type: TABLE --
-- DROP TABLE IF EXISTS measfish.dbparam CASCADE;
CREATE TABLE measfish.dbparam (
	dbparam_id integer NOT NULL,
	dbparam_name character varying NOT NULL,
	dbparam_value character varying,
	CONSTRAINT dbparam_pk PRIMARY KEY (dbparam_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.dbparam IS 'Table des parametres associes de maniere intrinseque a l''instance';
-- ddl-end --
COMMENT ON COLUMN measfish.dbparam.dbparam_name IS 'Nom du parametre';
-- ddl-end --
COMMENT ON COLUMN measfish.dbparam.dbparam_value IS 'Valeur du paramètre';
-- ddl-end --
ALTER TABLE measfish.dbparam OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.dbparam (dbparam_id, dbparam_name, dbparam_value) VALUES (E'1', E'APPLI_title', E'Measfish');
-- ddl-end --

-- object: measfish.dbversion_dbversion_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.dbversion_dbversion_id_seq CASCADE;
CREATE SEQUENCE measfish.dbversion_dbversion_id_seq
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.dbversion_dbversion_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.dbversion | type: TABLE --
-- DROP TABLE IF EXISTS measfish.dbversion CASCADE;
CREATE TABLE measfish.dbversion (
	dbversion_id integer NOT NULL DEFAULT nextval('measfish.dbversion_dbversion_id_seq'::regclass),
	dbversion_number character varying NOT NULL,
	dbversion_date timestamp NOT NULL,
	CONSTRAINT dbversion_pk PRIMARY KEY (dbversion_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.dbversion IS 'Table des versions de la base de donnees';
-- ddl-end --
COMMENT ON COLUMN measfish.dbversion.dbversion_number IS 'Numero de la version';
-- ddl-end --
COMMENT ON COLUMN measfish.dbversion.dbversion_date IS 'Date de la version';
-- ddl-end --
ALTER TABLE measfish.dbversion OWNER TO measfish;
-- ddl-end --

INSERT INTO measfish.dbversion (dbversion_number, dbversion_date) VALUES (E'0.1', E'2019-04-15');
-- ddl-end --

-- object: measfish.taxa_template_taxa_template_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS measfish.taxa_template_taxa_template_id_seq CASCADE;
CREATE SEQUENCE measfish.taxa_template_taxa_template_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --
ALTER SEQUENCE measfish.taxa_template_taxa_template_id_seq OWNER TO measfish;
-- ddl-end --

-- object: measfish.taxa_template | type: TABLE --
-- DROP TABLE IF EXISTS measfish.taxa_template CASCADE;
CREATE TABLE measfish.taxa_template (
	taxa_template_id integer NOT NULL DEFAULT nextval('measfish.taxa_template_taxa_template_id_seq'::regclass),
	taxa_template_name varchar NOT NULL,
	taxa_model json,
	CONSTRAINT taxa_template_pk PRIMARY KEY (taxa_template_id)

);
-- ddl-end --
COMMENT ON TABLE measfish.taxa_template IS 'List of templates used to select taxa';
-- ddl-end --
COMMENT ON COLUMN measfish.taxa_template.taxa_model IS 'Model of emplacement of taxa on screen';
-- ddl-end --
ALTER TABLE measfish.taxa_template OWNER TO measfish;
-- ddl-end --

-- object: taxa_template_fk | type: CONSTRAINT --
-- ALTER TABLE measfish.operation DROP CONSTRAINT IF EXISTS taxa_template_fk CASCADE;
ALTER TABLE measfish.operation ADD CONSTRAINT taxa_template_fk FOREIGN KEY (taxa_template_id)
REFERENCES measfish.taxa_template (taxa_template_id) MATCH FULL
ON DELETE SET NULL ON UPDATE CASCADE;
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

-- object: logingestion_login_oldpassword_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.login_oldpassword DROP CONSTRAINT IF EXISTS logingestion_login_oldpassword_fk CASCADE;
ALTER TABLE gacl.login_oldpassword ADD CONSTRAINT logingestion_login_oldpassword_fk FOREIGN KEY (id)
REFERENCES gacl.logingestion (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


