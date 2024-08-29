CREATE SCHEMA IF NOT EXISTS myschema;

CREATE SEQUENCE IF NOT EXISTS myschema.myaccount_item_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

CREATE TABLE myschema.myaccount_item
(
    id integer NOT NULL DEFAULT nextval('myschema.myaccount_item_id_seq'::regclass),
    location VARCHAR(255),
    -- FK cannot be forced as the table refers to a Heroku Connect table
    myaccount_extid VARCHAR(255) NOT NULL,
        
    CONSTRAINT myaccount_item_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;