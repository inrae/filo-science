set search_path = filo,gacl,public;
create unique index if not exists dbparamname_idx on dbparam (dbparam_name);
alter table dbparam add column if not exists dbparam_description varchar;
alter table dbparam add column if not exists dbparam_description_en varchar;
create sequence filo.dbparam_dbparam_id_seq;
alter table dbparam alter column dbparam_id set default nextval('filo.dbparam_dbparam_id_seq');
select setval ('filo.dbparam_dbparam_id_seq', (select max(dbparam_id) from dbparam));
insert into dbparam (dbparam_name, dbparam_value, dbparam_description, dbparam_description_en)
values (
'APPLI_code', 
'code_of_instance',
'Code de l''instance, pour les exportations',
'Code of the instance, to export data'
) 
on conflict do nothing;
alter table gacl.acllogin add column email varchar;
alter table gacl.logingestion add column if not exists is_expired boolean;
alter table gacl.logingestion add column if not exists nbattempts integer;
alter table gacl.logingestion add column if not exists lastattempt timestamp;

update gacl.aclgroup set groupe = 'manage' where groupe = 'gestion';
update gacl.aclaco set aco = 'manage' where aco = 'gestion';
insert into filo.dbversion (dbversion_date, dbversion_number) values ('2025-05-12', '25.0');

select setval('filo.pathology_pathology_id_seq', (select max(pathology_id) from filo.pathology));
select setval('filo.fishing_strategy_fishing_strategy_id_seq', (select max(fishing_strategy_id) from filo.fishing_strategy));
select setval('filo.gear_method_gear_method_id_seq', (select max(gear_method_id) from filo.gear_method));
