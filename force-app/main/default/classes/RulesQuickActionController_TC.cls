@isTest
public class RulesQuickActionController_TC {
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
        String ruledetailId = rd.Id;
        RulesQuickActionController.approveRule(ruledetailId);
        RulesQuickActionController.cloneRule(ruledetailId);
        RulesQuickActionController.denyRule(ruledetailId);
    }
}