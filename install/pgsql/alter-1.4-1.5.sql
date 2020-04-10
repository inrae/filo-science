alter table import.import_description add column first_line smallint;
comment on column import.import_description.first_line is 'First line to treat in the file';
alter table filo.protocol add column existing_taxon_only boolean NOT NULL DEFAULT true;
comment on column filo.protocol.existing_taxon_only is 'Limit the capacity to add a new taxon which is not defined in the taxon table';

insert into filo.dbversion (dbversion_date, dbversion_number) values ('2020-04-10', '1.5');
