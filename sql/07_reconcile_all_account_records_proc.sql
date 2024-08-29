-- this must be called as CALL myschema.reconcile_all_account_records_proc(batchsize, stopat);
-- batchsize to commit after a certain number of record changes
-- stopat stop the procedure after a certain number of records have been processed 0=it won't stop
CREATE OR REPLACE PROCEDURE myschema.reconcile_all_account_records_proc(batchsize integer, stopat integer) AS $$
DECLARE 
    i integer := 0;
    ma record;
BEGIN
    --RAISE NOTICE 'Selecting myaccount records that are within account table';
    FOR ma IN (select myschema.myaccount.* from myschema.myaccount INNER JOIN salesforce.account ON myschema.myaccount.my_ext_id__c = salesforce.account.my_ext_id__c)
    LOOP
        --RAISE NOTICE 'Updating account record %', i;
        UPDATE salesforce.account SET name = ma.name, channelprogramname = ma.channelprogramname, accountnumber = ma.accountnumber WHERE salesforce.account.my_ext_id__c = ma.my_ext_id__c;
        --RAISE NOTICE 'Deleting myaccount record %', i;
        DELETE FROM myschema.myaccount WHERE my_ext_id__c = ma.my_ext_id__c;
        --RAISE NOTICE 'Deleted myaccount record %', i;
        i := i + 1;
        IF i % batchsize = 0 THEN
            COMMIT;
            --RAISE NOTICE 'Committing after inserting % rows', i;
        END IF;
        
        IF stopat <> 0 AND i >= stopat THEN
            EXIT;
        END IF;         
    END LOOP;
    -- if records are less than the batch size they'll autocommit https://www.postgresql.org/docs/12/plpgsql-transactions.html
END;
$$ LANGUAGE plpgsql;