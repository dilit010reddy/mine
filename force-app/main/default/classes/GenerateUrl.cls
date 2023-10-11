public with sharing class GenerateUrl{

    public static Id getAccountId(String caseId){
        List<Case> cases=[SELECT AccountId from Case where Id = :caseId AND Status = 'new' AND Signature_Card_Case__c = true Limit 1];
        if(cases.size()>0){
            return cases[0].AccountId;
        }
        return null;
    }

    @AuraEnabled
    public static String getUrl(String caseId){
        Id accId = getAccountId(caseId);
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        // Get the template ID of Signature Card. 
        String tId = [SELECT Id FROM APXTConga4__Conga_Template__c WHERE APXTConga4__Name__c = 'Signature Card for Conga Sign'].Id;
        // Genarting URL by adding required parameters.
        String congaUrl = baseUrl + '/apex/APXTConga4__Conga_Composer?SolMgr=1&serverUrl={!API.Partner_Server_URL_370}';
        String csrecipients = '';
        if (String.isNotBlank(caseId)){
            congaUrl += '&Id=' + caseId;
        }
        if (String.isNotBlank(tId)) {
            congaUrl += '&TemplateId=' + tId;
        }
        congaUrl+= '&CSVisible=1&CSRoutingType=PARALLEL&businessUnit=Board_Signature';
        // Create a list of Board members related to the Account.
        List<Contact> boardMembers = [SELECT Id from Contact where AccountId = :accId and BOD__c = true ORDER BY Signing_Order__c ASC Limit 10];
        if(boardMembers.size() > 0){
            for(Integer i=0; i< boardMembers.size(); i++){
                csrecipients +='&CSRecipient'+ (i+1) +'='+boardMembers[i].Id;
            }
        }
        congaUrl+=csrecipients;
        return congaUrl;
    }
}