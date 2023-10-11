public class RuleHandler {
    public void onBeforeInsert(List<Rule__c> rules){
        //sequencing rules
        Set<Id> accountIds = new Set<Id>();
        for(Rule__c sr:rules){
			accountIds.add(sr.Account__c);
		}
        for(Id accountId:accountIds){        
            List<Rule__c> relatedRules = [SELECT Id,Order__c FROM Rule__c WHERE Account__c=:accountId ORDER BY Order__c];
            Decimal maxSequence = 0;
            if (relatedRules.size() > 0) {
                maxSequence = relatedRules[0].Order__c;
                for (integer i = 0; i < relatedRules.size(); i++) {
                    if (relatedRules[i].Order__c > maxSequence) {
                        maxSequence = relatedRules[i].Order__c;
                    }
                }
            }
            List<Rule__c> independentrules = new List<Rule__c>();
			for(Rule__c r : rules){
				if(r.Account__c==accountId){
						independentrules.add(r);
					}
			}
            for (Rule__c rule : independentrules) {
                rule.Order__c = maxSequence + 1;
                maxSequence += 1;
            }					
    	}
    }
    
    public void onAfterDelete(List<Rule__c> rules){
        //Resequencing rules
        Set<Id> accountIds = new Set<Id>();
        Map<Id, Rule__c> ruleDMLMap = new Map<Id, Rule__c>();
        for(Rule__c sr:rules){
			accountIds.add(sr.Account__c);
		}
        for(Id accountId:accountIds){   
        	List<Rule__c> relatedRules = [SELECT Id, Order__c FROM Rule__c WHERE Account__c=:accountId ORDER BY Order__c];
            
            //Go through Rules and resequence all Rules after the one being deleted
            if (!relatedRules.isEmpty()) {
                for (integer i = 0; i < relatedRules.size(); i++) {
                    Rule__c dt = relatedRules[i];
                    dt.Order__c = i + 1;
                    //Add to Map
                    ruleDMLMap.put(dt.Id, dt);
                }
            }
        }
        update ruleDMLMap.values();
    }
    
    @AuraEnabled
    public static List<Rule__c> getAccRules(string accountId){
        return [SELECT Id,Rule_Name__c,Order__c FROM Rule__c WHERE Account__c=:accountId ORDER BY Order__c];
    }
}