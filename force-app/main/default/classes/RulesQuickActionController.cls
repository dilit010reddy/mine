public class RulesQuickActionController {
    @AuraEnabled
    public static boolean approveRule(string ruledetailId){
        /*Rule_Detail__c rdtoupdate = [select Id,Status__c, Revised_Date__c,Rule__r.Active__c,Title__c, Text__c from Rule_Detail__c WHERE Id =:ruledetailId];
        rdtoupdate.Status__c = 'Active';
        update rdtoupdate;*/
        
        update new Rule_Detail__c(Id=ruledetailId,Status__c = 'Active');
        return true;
    }
    
    @AuraEnabled
    public static boolean denyRule(string ruledetailId){
        update new Rule_Detail__c(Id=ruledetailId,Status__c = 'Denied');
        return true;
    }

    @AuraEnabled
    public static string cloneRule(string ruledetailId){
        //update new Rule_Detail__c(Id=ruledetailId,Status__c = 'Denied');
        Rule_Detail__c initialRd = [select Id,Title__c, Text__c,Rule__c from Rule_Detail__c WHERE Id =:ruledetailId];
        Rule_Detail__c rd = new Rule_Detail__c(Title__c=initialRd.Title__c,Text__c=initialRd.Text__c,Rule__c=initialRd.Rule__c);
        insert rd;
        List<Subrule__c> srList = new List<Subrule__c>();
        for(Subrule__c sr: [select Description__c, Rule_Detail__c from Subrule__c WHERE Rule_Detail__c=:ruledetailId ORDER BY Order__c]){
            Subrule__c srtoinsert = new Subrule__c(Description__c=sr.Description__c,Rule_Detail__c=rd.Id);
            srList.add(srtoinsert);
        }
        insert srList;
        return rd.Id;
    }
    
}