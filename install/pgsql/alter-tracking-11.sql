-- Diff code generated with pgModeler (PostgreSQL Database Modeler)
-- pgModeler version: 0.9.2-beta1
-- Diff date: 2019-10-16 09:49:16
-- Source model: filo
-- Database: filo
-- PostgreSQL version: 11.0

-- [ Diff summary ]
-- Dropped objects: 0
-- Created objects: 5
-- Changed objects: 41
-- Truncated tables: 0

SET search_path=public,pg_catalog,filo,gacl,tracking,import;
-- ddl-end --


-- [ Created objects ] --
-- object: geom | type: COLUMN --
-- ALTER TABLE filo.station DROP COLUMN IF EXISTS geom CASCADE;
ALTER TABLE filo.station ADD COLUMN geom geometry(POINT, 4326);
-- ddl-end --

COMMENT ON COLUMN filo.station.geom IS 'Geographical representation of the situation of the station';
-- ddl-end --


-- object: geom_polygon | type: COLUMN --
-- ALTER TABLE tracking.antenna DROP COLUMN IF EXISTS geom_polygon CASCADE;
ALTER TABLE tracking.antenna ADD COLUMN geom_polygon geometry(POLYGON, 4326);
-- ddl-end --

COMMENT ON COLUMN tracking.antenna.geom_polygon IS 'Geometry of the reception zone, in polygonal form, wgs84';
-- ddl-end --


-- object: geom | type: COLUMN --
-- ALTER TABLE tracking."position" DROP COLUMN IF EXISTS geom CASCADE;
ALTER TABLE tracking."position" ADD COLUMN geom geometry(POINT, 4326);
-- ddl-end --

COMMENT ON COLUMN tracking."position".geom IS 'Geometric representation';
-- ddl-end --


-- object: geom | type: COLUMN --
-- ALTER TABLE tracking.location DROP COLUMN IF EXISTS geom CASCADE;
ALTER TABLE tracking.location ADD COLUMN geom geometry(POINT, 4326);
-- ddl-end --

COMMENT ON COLUMN tracking.location.geom IS 'Geographic point of the location';
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
COMMENT ON VIEW tracking.v_station_tracking IS 'List of stations used for tracking, with geom object';
-- ddl-end --
ALTER VIEW tracking.v_station_tracking OWNER TO filo;
-- ddl-end --



-- [ Changed objects ] --
ALTER ROLE filo
	ENCRYPTED PASSWORD 'filoPassword';
-- ddl-end --
COMMENT ON EXTENSION postgis IS '';
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
ALTER TABLE tracking.detection ALTER COLUMN validity SET DEFAULT 't';
-- ddl-end --
ALTER TABLE tracking.technology_type ALTER COLUMN technology_type_id SET DEFAULT nextval('import.technology_technology_type_id_seq'::regclass);
-- ddl-end --
ALTER TABLE tracking.location ALTER COLUMN location_pk TYPE float;
-- ddl-end --
