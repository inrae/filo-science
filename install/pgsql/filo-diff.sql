-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta
-- Diff date: 2019-08-19 15:36:58
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 13
-- Created objects: 12
-- Changed objects: 38
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE gacl.passwordlost DROP CONSTRAINT IF EXISTS logingestion_passwordlost_fk CASCADE;
-- ddl-end --
DROP INDEX IF EXISTS gacl.log_ip_idx CASCADE;
-- ddl-end --
DROP TABLE IF EXISTS gacl.passwordlost CASCADE;
-- ddl-end --
DROP SEQUENCE IF EXISTS gacl.passwordlost_passwordlost_id_seq CASCADE;
-- ddl-end --
DROP INDEX IF EXISTS gacl.logingestion_login_idx CASCADE;
-- ddl-end --
DROP INDEX IF EXISTS gacl.log_commentaire_idx CASCADE;
-- ddl-end --
DROP ROLE IF EXISTS dylaq_r;
-- ddl-end --
DROP ROLE IF EXISTS dylaq_rw;
-- ddl-end --
DROP ROLE IF EXISTS talend;
-- ddl-end --
DROP ROLE IF EXISTS quinton;
-- ddl-end --
DROP ROLE IF EXISTS prototypephp;
-- ddl-end --
DROP ROLE IF EXISTS collec;
-- ddl-end --
DROP ROLE IF EXISTS alosa_r;
-- ddl-end --
ALTER TABLE gacl.logingestion DROP COLUMN IF EXISTS is_expired CASCADE;
-- ddl-end --


-- [ Created objects ] --
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
ALTER TABLE gacl.login_oldpassword OWNER TO filo;
-- ddl-end --

-- object: filo.document | type: TABLE --
-- DROP TABLE IF EXISTS filo.document CASCADE;
CREATE TABLE filo.document (
	document_id integer NOT NULL DEFAULT nextval('filo.document_document_id_seq'::regclass),
	document_date_import timestamp NOT NULL,
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
COMMENT ON TABLE filo.document IS 'Documents stocked in the database';
-- ddl-end --
COMMENT ON COLUMN filo.document.document_name IS 'Name of the document';
-- ddl-end --
COMMENT ON COLUMN filo.document.document_description IS 'Description of the document';
-- ddl-end --
COMMENT ON COLUMN filo.document.data IS 'Content of the document, in binary format';
-- ddl-end --
COMMENT ON COLUMN filo.document.size IS 'Total size of the document';
-- ddl-end --
COMMENT ON COLUMN filo.document.thumbnail IS 'Thumbnail of the document, if it''s an image or a pdf';
-- ddl-end --
COMMENT ON COLUMN filo.document.document_creation_date IS 'Date of creation of the document';
-- ddl-end --
ALTER TABLE filo.document OWNER TO postgres;
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
ALTER SEQUENCE filo.document_document_id_seq OWNER TO postgres;
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
COMMENT ON TABLE filo.mime_type IS 'List of types mime associable to the documents';
-- ddl-end --
COMMENT ON COLUMN filo.mime_type.content_type IS 'Normalized description of the type mime';
-- ddl-end --
COMMENT ON COLUMN filo.mime_type.extension IS 'Extension associated with the type mime';
-- ddl-end --
ALTER TABLE filo.mime_type OWNER TO postgres;
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

-- object: filo.project_document | type: TABLE --
-- DROP TABLE IF EXISTS filo.project_document CASCADE;
CREATE TABLE filo.project_document (
	project_id integer NOT NULL,
	document_id integer NOT NULL,
	CONSTRAINT project_document_pk PRIMARY KEY (project_id,document_id)

);
-- ddl-end --
COMMENT ON TABLE filo.project_document IS 'Documents associated with a project';
-- ddl-end --
ALTER TABLE filo.project_document OWNER TO postgres;
-- ddl-end --

-- object: filo.protocol_document | type: TABLE --
-- DROP TABLE IF EXISTS filo.protocol_document CASCADE;
CREATE TABLE filo.protocol_document (
	protocol_id integer NOT NULL,
	document_id integer NOT NULL,
	CONSTRAINT protocol_document_pk PRIMARY KEY (protocol_id,document_id)

);
-- ddl-end --
COMMENT ON TABLE filo.protocol_document IS 'List of the documents associated with a protocol';
-- ddl-end --
ALTER TABLE filo.protocol_document OWNER TO postgres;
-- ddl-end --



-- [ Changed objects ] --
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
ALTER TABLE gacl.logingestion ALTER COLUMN datemodif TYPE date;
-- ddl-end --
ALTER TABLE gacl.logingestion ALTER COLUMN is_clientws SET NOT NULL;
-- ddl-end --
ALTER TABLE filo.operator ALTER COLUMN is_active SET DEFAULT 't';
-- ddl-end --
ALTER TABLE filo.operation_operator ALTER COLUMN is_responsible SET DEFAULT 't';
-- ddl-end --


-- [ Created foreign keys ] --
-- object: logingestion_login_oldpassword_fk | type: CONSTRAINT --
-- ALTER TABLE gacl.login_oldpassword DROP CONSTRAINT IF EXISTS logingestion_login_oldpassword_fk CASCADE;
ALTER TABLE gacl.login_oldpassword ADD CONSTRAINT logingestion_login_oldpassword_fk FOREIGN KEY (id)
REFERENCES gacl.logingestion (id) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: mime_type_fk | type: CONSTRAINT --
-- ALTER TABLE filo.document DROP CONSTRAINT IF EXISTS mime_type_fk CASCADE;
ALTER TABLE filo.document ADD CONSTRAINT mime_type_fk FOREIGN KEY (mime_type_id)
REFERENCES filo.mime_type (mime_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
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

