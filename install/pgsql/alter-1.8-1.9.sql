/**
 * Creation des index pour la recherche sur l'année de détection
 */
create index detection_year_idx on tracking.detection (extract (year from detection_date));
create index location_detection_year_idx on tracking.location (extract (year from detection_date));

alter table tracking.individual_tracking add column year smallint[] DEFAULT array[extract (year from now())::smallint];

alter table tracking.antenna add column date_from timestamp;
alter table tracking.antenna add column	date_to timestamp;
COMMENT ON COLUMN tracking.antenna.date_from IS E'Date of installation of the antenna';
COMMENT ON COLUMN tracking.antenna.date_to IS E'Date of end of use of the antenna';

update tracking.antenna set date_from = '2020-01-01', date_to = now();

alter table tracking.station_tracking add column station_active bool NOT NULL DEFAULT true;
COMMENT ON COLUMN tracking.station_tracking.station_active IS E'True if the station is used';

alter table tracking.probe add column date_from timestamp;
alter table tracking.probe add column date_to timestamp;
COMMENT ON COLUMN tracking.probe.date_from IS E'Date of installation of the probe';
COMMENT ON COLUMN tracking.probe.date_to IS E'Date of end of use of the probe';
update tracking.probe set date_from = '2020-01-01', date_to = now();

update import.function_type
set description = 'Récupère l''antenne de détection à partir de son code et de la date de la détection. La colonne contenant la date doit être indiquée dans le champ "argument complémentaire"'
where function_type_id = 17;

INSERT INTO filo.dbversion (dbversion_number, dbversion_date) VALUES (E'1.9', E'2021-09-22');
