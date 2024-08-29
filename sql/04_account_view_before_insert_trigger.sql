CREATE OR REPLACE FUNCTION myschema.account_insert_proc() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO myschema.myaccount(name,channelprogramname,accountnumber,my_ext_id__c,sfid) VALUES(NEW.name,NEW.channelprogramname,NEW.accountnumber,NEW.my_ext_id__c,NEW.sfid);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- the trigger inherits the schema of its table
CREATE TRIGGER account_view_before_insert_trigger
  INSTEAD OF INSERT ON myschema.account_view
  FOR EACH ROW
  EXECUTE PROCEDURE myschema.account_insert_proc();