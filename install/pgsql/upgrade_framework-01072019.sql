set search_path = gacl;
alter table logingestion add column is_expired boolean default false;
alter table logingestion alter column datemodif type timestamp;
