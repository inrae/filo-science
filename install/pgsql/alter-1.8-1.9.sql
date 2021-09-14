/**
 * Creation des index pour la recherche sur l'année de détection
 */
create index detection_year_idx on tracking.detection (extract (year from detection_date));
create index location_detection_year_idx on tracking.location (extract (year from detection_date));


alter table tracking.individual_tracking add column year smallint[] DEFAULT array[extract (year from now())::smallint];

select * from tracking.individual_tracking  where 2021 = any (year);

update tracking.individual_tracking set year = '{2020,2021}' where individual_id in (5, 6);

select array_to_string(year, ',') as year from tracking.individual_tracking ;