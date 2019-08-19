set search_path = gacl;
alter table logingestion add column is_expired boolean default false;
alter table logingestion alter column datemodif type timestamp;
drop table login_oldpassword cascade;
create index log_commentaire_idx on log using btree ( commentaire);
create unique index logingestion_login_idx on logingestion using btree(login);
alter table logingestion alter column is_clientws drop not null;

CREATE SEQUENCE "passwordlost_passwordlost_id_seq";

CREATE TABLE "passwordlost" (
                "passwordlost_id" INTEGER NOT NULL DEFAULT nextval('"passwordlost_passwordlost_id_seq"'),
                "id" INTEGER NOT NULL,
                "token" VARCHAR NOT NULL,
                "expiration" TIMESTAMP NOT NULL,
                "usedate" TIMESTAMP,
                CONSTRAINT "passwordlost_pk" PRIMARY KEY ("passwordlost_id")
);
COMMENT ON TABLE "passwordlost" IS 'Table de suivi des pertes de mots de passe';
COMMENT ON COLUMN "passwordlost"."token" IS 'Jeton utilise pour le renouvellement';
COMMENT ON COLUMN "passwordlost"."expiration" IS 'Date d''expiration du jeton';


ALTER SEQUENCE "passwordlost_passwordlost_id_seq" OWNED BY "passwordlost"."passwordlost_id";

ALTER TABLE "passwordlost" ADD CONSTRAINT "logingestion_passwordlost_fk"
FOREIGN KEY ("id")
REFERENCES "logingestion" ("id")
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
