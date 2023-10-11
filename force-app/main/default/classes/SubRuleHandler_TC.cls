@isTest
public class SubRuleHandler_TC {
    static testMethod void testSubRule(){
        Account testAccount = new Account();
        testAccount.Name = 'ABCDEF';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId(); 
        testAccount.RecordTypeId = devRecordTypeId;
        testAccount.VMS_Company_Key__c = 1;
        insert testAccount;
        
        Rule__c rule = new Rule__c( Rule_Name__c='RULE-1',Account__c = testAccount.Id);
        insert rule;
        
        Rule_Detail__c rd = new Rule_Detail__c(Rule__c=rule.Id,Text__c='Test Rule Detail',Title__c=rule.Rule_Name__c);
        insert rd;
        List<Subrule__c> srList = new List<Subrule__c>();
        Subrule__c  sr1 = new  Subrule__c(Rule_Detail__c=rd.Id,Description__c='test Subrule__c1');
        Subrule__c  sr2 = new  Subrule__c(Rule_Detail__c=rd.Id,Description__c='test Subrule__c2');
        Subrule__c  sr3 = new  Subrule__c(Rule_Detail__c=rd.Id,Description__c='test Subrule__c3');
        srList.add(sr1);
        srList.add(sr2);
        srList.add(sr3);       
        insert srList;

		delete srList[1];
    }
}