alter table filo.sequence add column sequence_name varchar;
comment on column filo.sequence.sequence_name is 'Name of the sequence';
alter table filo.station add column station_number varchar;
comment on column filo.station.station_number is 'Working number of the station';
INSERT INTO import.function_type (function_type_id, function_name, description) VALUES (E'17', E'getAntennaFromCode', E'Récupère l''antenne de détection à partir de son code');
update import.import_type set column_list = 'individual_id,detection_date,nb_events,duration,signal_force,antenna_id' where import_type_id = 1;
alter table filo.individual
  add column spaghetti_brand varchar,
	add column catching_time time,
	add column release_time time,
	add column anesthesia_duration time,
	add column marking_duration smallint,
	add column anesthesia_product varchar,
	add column product_concentration varchar;
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

INSERT INTO filo.dbversion (dbversion_number, dbversion_date) VALUES (E'1.7', E'2020-08-07');