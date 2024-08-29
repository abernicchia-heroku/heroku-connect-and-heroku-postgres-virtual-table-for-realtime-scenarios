CREATE OR REPLACE FUNCTION myschema.account_update_proc() RETURNS TRIGGER AS $$
BEGIN
   -- All statements in a function are executed in a single transaction

   -- myaccount is prioritised over account until it is reconciled
    -- also myaccount should only contain 10k of records at max then the look up will be faster
    IF EXISTS (SELECT FROM myschema.myaccount ma WHERE ma.my_ext_id__c = NEW.my_ext_id__c) THEN
        UPDATE myschema.myaccount SET name = NEW.name, channelprogramname = NEW.channelprogramname, accountnumber = NEW.accountnumber, sfid = NEW.sfid WHERE my_ext_id__c = NEW.my_ext_id__c;
    ELSE
        -- in this case sfid doesn't have to be updated (H.Connect is in charge of this field) and if a record is present it means it was previously synced by HC (along with the sfid)
        UPDATE salesforce.account SET name = NEW.name, channelprogramname = NEW.channelprogramname, accountnumber = NEW.accountnumber WHERE my_ext_id__c = NEW.my_ext_id__c;
    END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- the trigger inherits the schema of its table
CREATE TRIGGER account_view_before_update_trigger
  INSTEAD OF UPDATE ON myschema.account_view
  FOR EACH ROW
  EXECUTE PROCEDURE myschema.account_update_proc();