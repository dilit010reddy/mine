public class SubRuleHandler {    
    public static Map<Decimal,string> alphaMap;
    public static List<string> alphaList;
    Static{
        alphaMap  = new Map<Decimal,string>();
        alphaList  = new List<string>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
        for(string alphabet : alphaList){
            alphaMap.put(alphaList.indexOf(alphabet)+1,alphabet);
        }
    }
	public void onBeforeInsert(List<Subrule__c> subrules){
		Set<Id> detailIds = new Set<Id>();
		Map<Id,List<Subrule__c>> detailSubruleMap = new Map<Id,List<Subrule__c>>();		
        
		for(Subrule__c sr:subrules){
			detailIds.add(sr.Rule_Detail__c);
		}
        system.debug('detailIds'+detailIds);
		for(Id detailId : detailIds){
			List<Subrule__c> relatedsubrules = [SELECT Id,Rule_Detail__c,Order__c FROM Subrule__c WHERE Rule_Detail__c=:detailIds ORDER BY Order__c];
			system.debug('relatedsubrules--'+relatedsubrules);
			Decimal maxSequence = 0;
			if (relatedsubrules.size() > 0) {
				maxSequence = relatedsubrules[0].Order__c;
				for (integer i = 0; i < relatedsubrules.size(); i++) {
					if (relatedsubrules[i].Order__c > maxSequence) {
						maxSequence = relatedsubrules[i].Order__c;
					}
				}
			}
			List<Subrule__c> independentsubrules = new List<Subrule__c>();
			for(Subrule__c sr1 : subrules){
				if(sr1.Rule_Detail__c==detailId){
						independentsubrules.add(sr1);
					}
			}	
			system.debug('independentsubrules--'+independentsubrules);
			for (Subrule__c rule : independentsubrules) {
				rule.Order__c = maxSequence + 1;
                rule.Alpha_Order__c = alphaMap.get(rule.Order__c);
				maxSequence += 1;
			}
            system.debug('maxSequence--'+maxSequence);
		}
    }
    
    public void onAfterDelete(List<Subrule__c> subrules){
        Map<Id, Subrule__c> subRuleDMLMap = new Map<Id, Subrule__c>();
		Set<Id> detailIds = new Set<Id>();
		for(Subrule__c sr:subrules){
			detailIds.add(sr.Rule_Detail__c);
		}
        
		for(Id detailId : detailIds){
			//Resequencing subrules
			List<Subrule__c> relatedsubrules = [SELECT Id, Order__c FROM Subrule__c WHERE Rule_Detail__c=:detailId ORDER BY Order__c ];
			
			//Go through subrules and resequence all subrules after the one being deleted
			if (!relatedsubrules.isEmpty()) {
				for (integer i = 0; i < relatedsubrules.size(); i++) {
					Subrule__c sr = relatedsubrules[i];
					sr.Order__c = i + 1;
					sr.Alpha_Order__c = alphaMap.get(sr.Order__c);
					//Add to Map
					subRuleDMLMap.put(sr.Id, sr);
				}
			}			
		}
        update subRuleDMLMap.values();
    }

	@AuraEnabled
    public static List<Subrule__c> getSubrules(string detailId){
        return [SELECT Id,Description__c,Order__c,Alpha_Order__c FROM Subrule__c WHERE Rule_Detail__c=:detailId ORDER BY Order__c];
    }
}