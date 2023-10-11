public class RuleDetailHelper {
    
    public void PopulateRevisedDate(list<Rule_Detail__c> ruleDetails){
        for(Rule_Detail__c rd:ruleDetails){
            if(rd.Status__c=='Active'){
                rd.Revised_Date__c = Date.today();
            }
        }
    }
    
    public void DisableactiveRule(List<Rule_Detail__c> ruleDetails,Map<Id,Rule_Detail__c> oldruleDetailMap){
        Set<Id> ruleIdupdateSet = new Set<Id>();
        for(Rule_Detail__c rd:ruleDetails){
            Rule_Detail__c oldRd = oldruleDetailMap.get(rd.ID);
            if(rd.Status__c=='Inactive' && oldRd.Status__c=='Active'){
                ruleIdupdateSet.add(rd.Rule__c);
            }
            system.debug('ruset--'+ruleIdupdateSet);
        }
        List<Rule__c> rulesupdateList = new List<Rule__c>();
        for(Rule__c rl: [SELECT Active__c FROM Rule__c WHERE ID IN:ruleIdupdateSet]){
            rl.Active__c = false;
            rulesupdateList.add(rl);
        }
        system.debug('rulst--'+rulesupdateList);
        if(rulesupdateList.size()>0)
            update rulesupdateList;
    }
    
    public void DisableactiveRuleDetails(list<Rule_Detail__c> ruleDetails){
        List<Rule__c> rulesupdateList = new List<Rule__c>();
        list<Rule_Detail__c> rdupdateList = new list<Rule_Detail__c>();
        Set<Id> ruleIdupdateSet = new Set<Id>();
        Set<Id> ruledetailSet = new Set<Id>();
        
        for(Rule_Detail__c rd:ruleDetails){
            ruledetailSet.add(rd.Id);
            if(rd.Status__c=='Active'){                    
                ruleIdupdateSet.add(rd.Rule__c);
            }
        }
        
        for(Rule__c rl: [SELECT Active__c FROM Rule__c WHERE ID IN:ruleIdupdateSet]){
            rl.Active__c = true;
            rulesupdateList.add(rl);
        }
        
        if(rulesupdateList.size()>0)
            update rulesupdateList;
        
        for(Rule_Detail__c rd:[SELECT Id,Status__c FROM Rule_Detail__c WHERE Rule__c =:ruleIdupdateSet AND Status__c='Active' AND ID!=:ruledetailSet]){
            //make other rules inactive
            if(rd.Status__c=='Active'){
                rd.Status__c = 'Inactive';
                rdupdateList.add(rd);
            }  
            system.debug('rd'+rdupdateList);
        }
        if(rdupdateList.size()>0){
            TriggerStatus.setDoNotRunTrigger();
            update rdupdateList;
        }      
    }
    
}