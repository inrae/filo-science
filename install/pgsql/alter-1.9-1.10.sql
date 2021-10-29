alter table gacl.acllogin add column totp_key varchar;
COMMENT ON COLUMN gacl.acllogin.totp_key IS E'TOTP secret key for the user';
insert into filo.dbparam (dbparam_id, dbparam_name, dbparam_value) values (8, 'otp_issuer', 'filo-science');
insert into filo.dbversion (dbversion_date, dbversion_number) values ('2021-10-29', '1.10');