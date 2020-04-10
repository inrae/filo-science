alter table import.import_description add column first_line smallint;
comment on column import.import_description.first_line is 'First line to treat in the file';
insert into filo.dbversion (dbversion_date, dbversion_number) values ('2020-04-10', '1.5');
