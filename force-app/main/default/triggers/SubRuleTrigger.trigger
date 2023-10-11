trigger SubRuleTrigger on Subrule__c (before insert,after delete) {
	SubRuleHandler handler = new SubRuleHandler();
     if ( trigger.isInsert && trigger.isBefore ){
            handler.onBeforeInsert(trigger.new);
     }
    
    if ( trigger.isDelete && trigger.isafter ){
        	handler.onAfterDelete(trigger.old);
    }
}