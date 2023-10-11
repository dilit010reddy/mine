trigger RuleTrigger on Rule__c (before insert,after delete) {
	RuleHandler handler = new RuleHandler();
     if ( trigger.isInsert && trigger.isBefore ){
            handler.onBeforeInsert(trigger.new);
     }
    
    if ( trigger.isDelete && trigger.isafter ){
        	handler.onAfterDelete(trigger.old);
    }
}