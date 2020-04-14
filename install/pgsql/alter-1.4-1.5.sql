alter table import.import_description add column first_line smallint;
comment on column import.import_description.first_line is 'First line to treat in the file';
alter table filo.protocol add column existing_taxon_only boolean NOT NULL DEFAULT true;
comment on column filo.protocol.existing_taxon_only is 'Limit the capacity to add a new taxon which is not defined in the taxon table';

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


insert into filo.dbversion (dbversion_date, dbversion_number) values ('2020-04-10', '1.5');
