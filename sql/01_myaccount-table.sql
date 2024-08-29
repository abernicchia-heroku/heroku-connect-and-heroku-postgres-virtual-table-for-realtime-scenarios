CREATE SCHEMA IF NOT EXISTS myschema;

CREATE SEQUENCE IF NOT EXISTS myschema.myaccount_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

-- unused columns (not replicated) from the salesforce.account table ####
-- isdeleted
-- systemmodstamp
-- _hc_lastop
-- _hc_err
CREATE TABLE myschema.myaccount
(
    id integer NOT NULL DEFAULT nextval('myschema.myaccount_id_seq'::regclass),
    name VARCHAR(255),
    channelprogramname VARCHAR(255),
    accountnumber VARCHAR(40),
    my_ext_id__c VARCHAR(255) UNIQUE,
    sfid VARCHAR(18) COLLATE pg_catalog."ucs_basic" UNIQUE,
        
    CONSTRAINT myaccount_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

DROP TABLE myschema.myaccount;