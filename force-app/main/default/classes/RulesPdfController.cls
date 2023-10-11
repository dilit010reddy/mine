public class RulesPdfController {
    FINAL String rdId='a0c6s000000s6GCAAY';
    FINAL String PROPOSED='Proposed';
    public Boolean isCurrentRule{get;set;}
	public Rule_Detail__c RulesVar { get; set; }
	public List<Subrule__c> subruleVar { get; set; }
	public Rule_Detail__c initialRulesVar { get; set; }
	public List<Subrule__c> initialSubRuleVar { get; set; }
    public RulesPdfController(){
        String rId;
        if(test.isRunningTest()){
            rId = [SELECT Id FROM Rule_Detail__c limit 1].Id;
        }else{
            rId = ApexPages.currentPage().getParameters().get('Id');
        }
           
           RulesVar =  [SELECT Id,Status__c, Revised_Date__c,Rule__r.Active__c,Title__c, Text__c,Order__c FROM Rule_Detail__c WHERE Id =:rId ];
           subruleVar = [SELECT Id,Description__c,Alpha_Order__c FROM Subrule__c WHERE Rule_Detail__c =:rId ORDER BY Order__c];

            List<Rule_Detail__c> initialRulesVarList =  [SELECT Id,Status__c, Revised_Date__c,Rule__r.Active__c,Title__c, Text__c,Order__c FROM Rule_Detail__c WHERE Rule__c =:RulesVar.Rule__c AND Status__c='Active'];
            if(initialRulesVarList.size()>0){
                isCurrentRule = true;
                initialRulesVar = initialRulesVarList[0];
                initialSubRuleVar = [SELECT Id,Description__c,Alpha_Order__c FROM Subrule__c WHERE Rule_Detail__c =:initialRulesVar.Id ORDER BY Order__c ];
            }	
        
    }
    
    @AuraEnabled
    public static string getRulesName(String recordId){
        Rule_Detail__c RulesVar =  [SELECT Id,Rule__r.Account__r.Name,Rule__r.Name,Title__c, Text__c FROM Rule_Detail__c WHERE Id =:recordId];
        return RulesVar.Rule__r.Account__r.Name+' - '+RulesVar.Rule__r.Name;
    } 
    
    @AuraEnabled
    public static string RulesPdfupdate(String recordId){
        try {
            PageReference RulesPdf = Page.RulesPdf;
            RulesPdf.getParameters().put('Id',recordId);           
            
            Rule_Detail__c RulesVar =  [SELECT Id,Status__c, Revised_Date__c,Rule__r.Active__c,Title__c, Text__c FROM Rule_Detail__c WHERE Id =:recordId];
            RulesVar.Status__c = 'Proposed';
            update RulesVar;
            String base64Pdf;
            if(!test.isRunningTest()){
            	Blob pdfBlob = RulesPdf.getContent();
            	base64Pdf = EncodingUtil.base64Encode(pdfBlob);
            }else{
                base64Pdf = 'test';
            }
            return base64Pdf;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}