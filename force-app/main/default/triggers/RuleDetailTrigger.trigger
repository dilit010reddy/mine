trigger RuleDetailTrigger on Rule_Detail__c (after update, before update) {
    if(TriggerStatus.shouldRunTrigger()){
        RuleDetailHandler handler = new RuleDetailHandler();
        
        if ( trigger.isUpdate && trigger.isBefore ){
            handler.onBeforeUpdate(trigger.new);
        }
        
        if ( trigger.isUpdate && trigger.isafter ){
            handler.onAfterUpdate(trigger.new,trigger.oldMap);
                /*Set<Id> ruleIdupdateSet = new Set<Id>();
                 for(Rule_Detail__c rd:trigger.new){
                    Rule_Detail__c oldRd = Trigger.oldMap.get(rd.ID);
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
                    update rulesupdateList;*/
        }
             
     }
}