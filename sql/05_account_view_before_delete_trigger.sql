CREATE OR REPLACE FUNCTION myschema.account_delete_proc() RETURNS TRIGGER AS $$
BEGIN
    -- delete from both the tables regardless if records are present or not, those statements won't fails and it avoids records look up that is implicit in DELETEs
    DELETE FROM myschema.myaccount WHERE my_ext_id__c = OLD.my_ext_id__c;
    DELETE FROM salesforce.account WHERE my_ext_id__c = OLD.my_ext_id__c;   
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- the trigger inherits the schema of its table
CREATE TRIGGER account_view_before_delete_trigger
  INSTEAD OF DELETE ON myschema.account_view
  FOR EACH ROW
  EXECUTE PROCEDURE myschema.account_delete_proc();