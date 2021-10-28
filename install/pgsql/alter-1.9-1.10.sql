alter table gacl.acllogin add column totp_key varchar;

COMMENT ON COLUMN gacl.acllogin.totp_key IS E'TOTP secret key for the user';
