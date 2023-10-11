public class RulePdfController {
    public List<Rule_Detail__c> RulesVar { get; set; }
    public List<Subrule__c> subruleVar { get; set; }   
    public RulePdfController(){
        RulesVar =  [SELECT Id,Status__c, Revised_Date__c,Rule__r.Active__c,Title__c, Text__c,Order__c FROM Rule_Detail__c WHERE Status__c = 'Active' AND Rule__c =: ApexPages.currentPage().getParameters().get('id')];
        subruleVar = [SELECT Id,Description__c,Order__c,Alpha_Order__c FROM Subrule__c WHERE Rule_Detail__c=:RulesVar[0].Id ORDER BY Order__c];
    }
}