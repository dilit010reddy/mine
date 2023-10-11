public class RulesPdfcmpController {
	@AuraEnabled
    public static string RulesPdfupdate(String recordId){
        try {
            PageReference RulesPdf = Page.RulesPdf;
            //excelPage.getParameters().put('cid',contactId);
            Blob pdfBlob = RulesPdf.getContent();
            String base64Pdf = EncodingUtil.base64Encode(pdfBlob);
            
            Rule_Detail__c RulesVar =  [SELECT Id,Status__c, Revised_Date__c,Rule__r.Active__c,Title__c, Text__c FROM Rule_Detail__c WHERE Id =:recordId];
            RulesVar.Status__c = 'Proposed';
            update RulesVar;
            return base64Pdf;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}