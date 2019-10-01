-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-10-01 11:28:54
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 9
-- Created objects: 23
-- Changed objects: 45
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Dropped objects ] --
ALTER TABLE import.column_matching DROP CONSTRAINT IF EXISTS column_fk CASCADE;
-- ddl-end --
ALTER TABLE import."column" DROP CONSTRAINT IF EXISTS import_type_fk CASCADE;
-- ddl-end --
ALTER TABLE import."column" DROP CONSTRAINT IF EXISTS format_type_fk CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP CONSTRAINT IF EXISTS csv_type_fk CASCADE;
-- ddl-end --
ALTER TABLE tracking.detection DROP CONSTRAINT IF EXISTS antenna_fk CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP CONSTRAINT IF EXISTS import_type_pk CASCADE;
-- ddl-end --
DROP TABLE IF EXISTS import."column" CASCADE;
-- ddl-end --
DROP SEQUENCE IF EXISTS import.column_column_id_seq CASCADE;
-- ddl-end --
DROP SEQUENCE IF EXISTS import.import_type_import_type_id CASCADE;
-- ddl-end --
ALTER TABLE tracking.detection DROP COLUMN IF EXISTS antenna_id CASCADE;
-- ddl-end --
ALTER TABLE import.column_matching DROP COLUMN IF EXISTS column_id CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP COLUMN IF EXISTS csv_type_id CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP COLUMN IF EXISTS schema_name CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP COLUMN IF EXISTS table_name CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP COLUMN IF EXISTS separator CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP COLUMN IF EXISTS header_size CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP COLUMN IF EXISTS is_table_er CASCADE;
-- ddl-end --
ALTER TABLE import.import_type DROP COLUMN IF EXISTS repeat_header_number CASCADE;
-- ddl-end --


-- [ Created objects ] --
-- object: radius | type: COLUMN --
-- ALTER TABLE tracking.antenna DROP COLUMN IF EXISTS radius CASCADE;
ALTER TABLE tracking.antenna rename COLUMN diameter to radius;
-- ddl-end --

COMMENT ON COLUMN tracking.antenna.radius IS 'radius, in metres, of the useful reception';
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
	import_type_id smallint NOT NULL,
	csv_type_id smallint NOT NULL,
	import_description_name varchar NOT NULL,
	separator varchar NOT NULL DEFAULT ';',
	is_table_er boolean NOT NULL DEFAULT 'f',
	CONSTRAINT import_type_pk PRIMARY KEY (import_description_id)

);
-- ddl-end --
COMMENT ON COLUMN import.import_description.import_description_name IS 'Name of the description of the import';
-- ddl-end --
COMMENT ON COLUMN import.import_description.separator IS 'separator used between fields (; , tab)';
-- ddl-end --
COMMENT ON COLUMN import.import_description.is_table_er IS 'Is the destination table in format entity-relation? (example: probe_measure)';
-- ddl-end --
ALTER TABLE import.import_description OWNER TO filo;
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
	format_type_id smallint NOT NULL,
	column_order smallint NOT NULL DEFAULT 1,
	table_column_name varchar NOT NULL,
	specific_format varchar,
	is_er boolean NOT NULL DEFAULT 'f',
	is_value boolean NOT NULL DEFAULT 'f',
	CONSTRAINT column_pk PRIMARY KEY (import_column_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_column IS 'List of all columns of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_column.column_order IS 'Place of the column in the file, from 1';
-- ddl-end --
COMMENT ON COLUMN import.import_column.table_column_name IS 'name of the attribute of the column in the database table';
-- ddl-end --
COMMENT ON COLUMN import.import_column.specific_format IS 'Specific format, as datetime format. Example: YYYY-MM-DDThh:mm:ss';
-- ddl-end --
COMMENT ON COLUMN import.import_column.is_er IS 'Specify if the column is an entity-relation identifier';
-- ddl-end --
COMMENT ON COLUMN import.import_column.is_value IS 'Specifiy if the column contain the value of an entity-relation row';
-- ddl-end --
ALTER TABLE import.import_column OWNER TO filo;
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
	is_control boolean NOT NULL DEFAULT false,
	CONSTRAINT function_type_pk PRIMARY KEY (function_type_id)

);
-- ddl-end --
COMMENT ON TABLE import.function_type IS 'List of functions writed in the application, and usable to test or transform the data';
-- ddl-end --
COMMENT ON COLUMN import.function_type.function_name IS 'Name of the function. Must be the same in the application code';
-- ddl-end --
COMMENT ON COLUMN import.function_type.description IS 'Usage of the function';
-- ddl-end --
COMMENT ON COLUMN import.function_type.is_control IS 'Is the function a function to control the validity of the row ?';
-- ddl-end --
ALTER TABLE import.function_type OWNER TO filo;
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
	"order" smallint NOT NULL DEFAULT 1,
	arguments varchar,
	column_result smallint,
	CONSTRAINT import_function_pk PRIMARY KEY (import_function_id)

);
-- ddl-end --
COMMENT ON TABLE import.import_function IS 'List of functions to be performed for each row of the file';
-- ddl-end --
COMMENT ON COLUMN import.import_function.column_number IS 'Number of the column, from 1 to n. If 0: entire row';
-- ddl-end --
COMMENT ON COLUMN import.import_function."order" IS 'Order of execution of the function';
-- ddl-end --
COMMENT ON COLUMN import.import_function.arguments IS 'Values of arguments, separated by a comma. Arguments are described in function_type.description';
-- ddl-end --
COMMENT ON COLUMN import.import_function.column_result IS 'Number of column that gets the result of the function, from 1 to n. Not used for control functions';
-- ddl-end --
ALTER TABLE import.import_function OWNER TO filo;
-- ddl-end --

-- object: transmitter | type: COLUMN --
-- ALTER TABLE filo.individual DROP COLUMN IF EXISTS transmitter CASCADE;
ALTER TABLE filo.individual ADD COLUMN transmitter varchar;
-- ddl-end --

COMMENT ON COLUMN filo.individual.transmitter IS 'Acoustic or radio transmitter identifier';
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
COMMENT ON TABLE tracking.technology_type IS 'Types of technologies used for detection';
-- ddl-end --
ALTER TABLE tracking.technology_type OWNER TO filo;
-- ddl-end --

INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'1', E'RFID');
-- ddl-end --
INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'2', E'Acoustic');
-- ddl-end --
INSERT INTO tracking.technology_type (technology_type_id, technology_type_name) VALUES (E'3', E'Radio');
-- ddl-end --

-- object: import_column_id | type: COLUMN --
-- ALTER TABLE import.column_matching DROP COLUMN IF EXISTS import_column_id CASCADE;
ALTER TABLE import.column_matching ADD COLUMN import_column_id integer NOT NULL;
-- ddl-end --


-- object: technology_type_id | type: COLUMN --
-- ALTER TABLE tracking.antenna DROP COLUMN IF EXISTS technology_type_id CASCADE;
ALTER TABLE tracking.antenna ADD COLUMN technology_type_id integer NOT NULL;
-- ddl-end --




-- [ Changed objects ] --
ALTER ROLE filo
	ENCRYPTED PASSWORD 'filoPassword';
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
COMMENT ON COLUMN filo.individual.tag IS 'RFID tag';
-- ddl-end --
COMMENT ON COLUMN filo.individual.tag_posed IS 'RFID tag posed on the fish';
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
ALTER TABLE tracking.manual_detection ALTER COLUMN validity SET DEFAULT 't';
-- ddl-end --
ALTER TABLE tracking.detection ALTER COLUMN duration TYPE double precision;
-- ddl-end --
COMMENT ON COLUMN tracking.detection.duration IS 'Duration of the detection, in seconds with milliseconds';
-- ddl-end --
ALTER TABLE tracking.detection ALTER COLUMN validity SET DEFAULT 't';
-- ddl-end --
COMMENT ON TABLE import.import_type IS 'List of types of import';
-- ddl-end --
ALTER TABLE import.import_type ALTER COLUMN import_type_id TYPE smallint;
-- ddl-end --
COMMENT ON COLUMN import.import_type.import_type_name IS '';
-- ddl-end --


-- [ Created constraints ] --
-- object: import_type_pk_1 | type: CONSTRAINT --
-- ALTER TABLE import.import_type DROP CONSTRAINT IF EXISTS import_type_pk_1 CASCADE;
ALTER TABLE import.import_type ADD CONSTRAINT import_type_pk_1 PRIMARY KEY (import_type_id);
-- ddl-end --



-- [ Created foreign keys ] --
-- object: csv_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_description DROP CONSTRAINT IF EXISTS csv_type_fk CASCADE;
ALTER TABLE import.import_description ADD CONSTRAINT csv_type_fk FOREIGN KEY (csv_type_id)
REFERENCES import.csv_type (csv_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: format_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_column DROP CONSTRAINT IF EXISTS format_type_fk CASCADE;
ALTER TABLE import.import_column ADD CONSTRAINT format_type_fk FOREIGN KEY (format_type_id)
REFERENCES import.format_type (format_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: import_description_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_column DROP CONSTRAINT IF EXISTS import_description_fk CASCADE;
ALTER TABLE import.import_column ADD CONSTRAINT import_description_fk FOREIGN KEY (import_description_id)
REFERENCES import.import_description (import_description_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: import_column_fk | type: CONSTRAINT --
-- ALTER TABLE import.column_matching DROP CONSTRAINT IF EXISTS import_column_fk CASCADE;
ALTER TABLE import.column_matching ADD CONSTRAINT import_column_fk FOREIGN KEY (import_column_id)
REFERENCES import.import_column (import_column_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
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

-- object: import_type_fk | type: CONSTRAINT --
-- ALTER TABLE import.import_description DROP CONSTRAINT IF EXISTS import_type_fk CASCADE;
ALTER TABLE import.import_description ADD CONSTRAINT import_type_fk FOREIGN KEY (import_type_id)
REFERENCES import.import_type (import_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: technology_type_fk | type: CONSTRAINT --
-- ALTER TABLE tracking.antenna DROP CONSTRAINT IF EXISTS technology_type_fk CASCADE;
ALTER TABLE tracking.antenna ADD CONSTRAINT technology_type_fk FOREIGN KEY (technology_type_id)
REFERENCES tracking.technology_type (technology_type_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

