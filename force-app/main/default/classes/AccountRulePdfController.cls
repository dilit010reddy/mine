public class AccountRulePdfController {
    FINAL String rdId='a0c6s000000s6GCAAY';
    public List<Rule__c> ruleList = new List<Rule__c>();
    public List<Rule_Detail__c> RulesVar { get; set; }
    public Map<String,List<Subrule__c>> subruleVar{ get; set; }  
    public String relatedDateLabel{ get; set; } 
    public AccountRulePdfController(){
        getAccountRules();        
    }
    public void getAccountRules(){
        List<Subrule__c> srList = new List<Subrule__c>();
        subruleVar= new  Map<String,List<Subrule__c>>();
        ruleList = [SELECT Id,Active__c FROM Rule__c WHERE Active__c=true AND Account__c =: ApexPages.currentPage().getParameters().get('id')];
        RulesVar =  [SELECT Id,Status__c,Order__c, Revised_Date__c,Rule__r.Active__c,Title__c, Text__c FROM Rule_Detail__c WHERE Status__c = 'Active' AND Rule__c =:ruleList ORDER BY Order__c];
        relatedDateLabel='Revised Date : ';
        
        for(Subrule__c sr:[SELECT Id,Rule_Detail__c,Order__c,Alpha_Order__c,Description__c FROM Subrule__c WHERE Rule_Detail__c =:RulesVar ORDER BY Order__c]){
            srList.add(sr);
        }
        for(Rule_Detail__c rd:RulesVar){
            List<Subrule__c> srList1 = new List<Subrule__c>();
            for(Subrule__c sr1:srList){
                if(sr1.Rule_Detail__c==rd.Id){
                    srList1.add(sr1);
                }
            }
            subruleVar.put(rd.Id,srList1);
                        
        }
    }
}