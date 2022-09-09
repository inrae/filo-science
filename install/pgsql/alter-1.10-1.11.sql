DROP FUNCTION IF EXISTS tracking.detection_count(integer) CASCADE;
CREATE FUNCTION tracking.detection_count (individu_id integer)
	RETURNS bigint
	LANGUAGE sql
	VOLATILE
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS $$
select count(*) from tracking.detection
where individual_id = $1
$$;
-- ddl-end --
ALTER FUNCTION tracking.detection_count(integer) OWNER TO filo;
-- ddl-end --
COMMENT ON FUNCTION tracking.detection_count(integer) IS E'Count the number of detections for a fish';
-- ddl-end --

insert into filo.dbversion (dbversion_date, dbversion_number) values ('2022-09-09', '1.11');
