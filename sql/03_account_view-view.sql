-- myaccount is prioritised over account until it is reconciled and 
-- removed from myschema.myaccount
-- UNION ALL to avoid perf impact, as UNION returns only distinct records then requires additional checks
-- NOT EXISTS is faster (and usually the fastest) than NOT IN
CREATE OR REPLACE VIEW myschema.account_view AS
 select id, name, channelprogramname,accountnumber,my_ext_id__c,sfid 
    from salesforce.account WHERE NOT EXISTS (SELECT 1 FROM myschema.myaccount WHERE myaccount.my_ext_id__c = account.my_ext_id__c)
    UNION ALL
 select id,name,channelprogramname,accountnumber,my_ext_id__c,sfid 
    from myschema.myaccount    
;