-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta
-- Diff date: 2019-08-19 15:36:58
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

SET search_path=filo;
-- ddl-end --


-- object: document_document_id_seq | type: SEQUENCE --
-- DROP SEQUENCE IF EXISTS document_document_id_seq CASCADE;
CREATE SEQUENCE document_document_id_seq
	INCREMENT BY 1
	MINVALUE 0
	MAXVALUE 2147483647
	START WITH 1
	CACHE 1
	NO CYCLE
	OWNED BY NONE;
-- ddl-end --

-- object: document | type: TABLE --
-- DROP TABLE IF EXISTS document CASCADE;
CREATE TABLE document (
	document_id integer NOT NULL DEFAULT nextval('document_document_id_seq'::regclass),
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
COMMENT ON TABLE document IS 'Documents stocked in the database';
-- ddl-end --
COMMENT ON COLUMN document.document_name IS 'Name of the document';
-- ddl-end --
COMMENT ON COLUMN document.document_description IS 'Description of the document';
-- ddl-end --
COMMENT ON COLUMN document.data IS 'Content of the document, in binary format';
-- ddl-end --
COMMENT ON COLUMN document.size IS 'Total size of the document';
-- ddl-end --
COMMENT ON COLUMN document.thumbnail IS 'Thumbnail of the document, if it''s an image or a pdf';
-- ddl-end --
COMMENT ON COLUMN document.document_creation_date IS 'Date of creation of the document';
-- ddl-end --


-- object: mime_type | type: TABLE --
-- DROP TABLE IF EXISTS mime_type CASCADE;
CREATE TABLE mime_type (
	mime_type_id integer NOT NULL,
	content_type varchar NOT NULL,
	extension varchar NOT NULL,
	CONSTRAINT mime_type_pk PRIMARY KEY (mime_type_id)

);
-- ddl-end --
COMMENT ON TABLE mime_type IS 'List of types mime associable to the documents';
-- ddl-end --
COMMENT ON COLUMN mime_type.content_type IS 'Normalized description of the type mime';
-- ddl-end --
COMMENT ON COLUMN mime_type.extension IS 'Extension associated with the type mime';
-- ddl-end --


INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'1', E'pdf', E'application/pdf');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'2', E'zip', E'application/zip');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'3', E'mp3', E'audio/mpeg');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'4', E'jpg', E'image/jpeg');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'5', E'jpeg', E'image/jpeg');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'6', E'png', E'image/png');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'7', E'tiff', E'image/tiff');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'9', E'odt', E'application/vnd.oasis.opendocument.text');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'10', E'ods', E'application/vnd.oasis.opendocument.spreadsheet');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'11', E'xls', E'application/vnd.ms-excel');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'12', E'xlsx', E'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'13', E'doc', E'application/msword');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'14', E'docx', E'application/vnd.openxmlformats-officedocument.wordprocessingml.document');
-- ddl-end --
INSERT INTO mime_type (mime_type_id, extension, content_type) VALUES (E'8', E'csv', E'text/csv');
-- ddl-end --

-- object: project_document | type: TABLE --
-- DROP TABLE IF EXISTS project_document CASCADE;
CREATE TABLE project_document (
	project_id integer NOT NULL,
	document_id integer NOT NULL,
	CONSTRAINT project_document_pk PRIMARY KEY (project_id,document_id)

);
-- ddl-end --
COMMENT ON TABLE project_document IS 'Documents associated with a project';
-- ddl-end --


-- object: protocol_document | type: TABLE --
-- DROP TABLE IF EXISTS protocol_document CASCADE;
CREATE TABLE protocol_document (
	protocol_id integer NOT NULL,
	document_id integer NOT NULL,
	CONSTRAINT protocol_document_pk PRIMARY KEY (protocol_id,document_id)

);
-- ddl-end --
COMMENT ON TABLE protocol_document IS 'List of the documents associated with a protocol';
-- ddl-end --

-- object: operation_document | type: TABLE --
-- DROP TABLE IF EXISTS operation_document CASCADE;
CREATE TABLE operation_document (
	operation_id integer NOT NULL,
	document_id integer NOT NULL,
	CONSTRAINT operation_document_pk PRIMARY KEY (operation_id,document_id)

);
-- ddl-end --
COMMENT ON TABLE operation_document IS 'Documents associated with an operation';
-- ddl-end --



-- object: mime_type_fk | type: CONSTRAINT --
-- ALTER TABLE document DROP CONSTRAINT IF EXISTS mime_type_fk CASCADE;
ALTER TABLE document ADD CONSTRAINT mime_type_fk FOREIGN KEY (mime_type_id)
REFERENCES mime_type (mime_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: project_fk | type: CONSTRAINT --
-- ALTER TABLE project_document DROP CONSTRAINT IF EXISTS project_fk CASCADE;
ALTER TABLE project_document ADD CONSTRAINT project_fk FOREIGN KEY (project_id)
REFERENCES project (project_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: document_fk | type: CONSTRAINT --
-- ALTER TABLE project_document DROP CONSTRAINT IF EXISTS document_fk CASCADE;
ALTER TABLE project_document ADD CONSTRAINT document_fk FOREIGN KEY (document_id)
REFERENCES document (document_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: protocol_fk | type: CONSTRAINT --
-- ALTER TABLE protocol_document DROP CONSTRAINT IF EXISTS protocol_fk CASCADE;
ALTER TABLE protocol_document ADD CONSTRAINT protocol_fk FOREIGN KEY (protocol_id)
REFERENCES protocol (protocol_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: document_fk | type: CONSTRAINT --
-- ALTER TABLE protocol_document DROP CONSTRAINT IF EXISTS document_fk CASCADE;
ALTER TABLE protocol_document ADD CONSTRAINT document_fk FOREIGN KEY (document_id)
REFERENCES document (document_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: operation_fk | type: CONSTRAINT --
-- ALTER TABLE operation_document DROP CONSTRAINT IF EXISTS operation_fk CASCADE;
ALTER TABLE operation_document ADD CONSTRAINT operation_fk FOREIGN KEY (operation_id)
REFERENCES operation (operation_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: document_fk | type: CONSTRAINT --
-- ALTER TABLE operation_document DROP CONSTRAINT IF EXISTS document_fk CASCADE;
ALTER TABLE operation_document ADD CONSTRAINT document_fk FOREIGN KEY (document_id)
REFERENCES document (document_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

alter table taxa_template add column freshwater boolean not null default true;
comment on column taxa_template.freshwater is 'Does the template operate for freshwater?';

alter table analysis_template rename column analysis_template_value to analysis_template_schema;
alter table measure_template rename column measure_template_value to measure_template_schema;
alter table measure_template alter column measure_template_name type varchar;

create view v_individual_other_measures as (
select individual_id, string_agg( metadata.key || ':' || metadata.value, ', '::varchar) as other_measures from individual, json_each_text(individual.other_measure) as metadata
group by individual_id
)
;

alter table project add column 	is_active boolean DEFAULT true;
comment on column project.is_active is 'Specify if the project is currently active';

INSERT INTO dbversion (dbversion_number, dbversion_date) VALUES (E'1.2', E'2019-08-29');
