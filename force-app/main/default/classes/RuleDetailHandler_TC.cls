@isTest
public class RuleDetailHandler_TC {
	static testMethod void testSubRule(){
        Account testAccount = new Account();
        testAccount.Name = 'ABCDEF';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId(); 
        testAccount.RecordTypeId = devRecordTypeId;
        testAccount.VMS_Company_Key__c = 1;
        insert testAccount;
        TriggerStatus.shouldRunTrigger();
        Rule__c rule = new Rule__c( Rule_Name__c='RULE-1',Account__c = testAccount.Id);
        insert rule;
        List<Rule_Detail__c> rdList = new List<Rule_Detail__c>();
        Rule_Detail__c rd = new Rule_Detail__c(Rule__c=rule.Id,Text__c='Test Rule Detail',Title__c=rule.Rule_Name__c);
        Rule_Detail__c rd1 = new Rule_Detail__c(Rule__c=rule.Id,Text__c='Test Rule Detail',Title__c=rule.Rule_Name__c,Status__c='Active');
        rdList.add(rd1);
        rdList.add(rd);
        insert rdList;
        
        rdList[1].Status__c = 'Active';
        update rdList[1];
        
        rdList[1].Status__c = 'Inactive';
        update rdList[1];
        
        
    }
}