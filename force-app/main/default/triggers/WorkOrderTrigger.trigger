trigger WorkOrderTrigger on WorkOrder (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    WorkOrderTriggerHandler handler = new WorkOrderTriggerHandler();
    if(TriggerStatus.shouldRunTrigger()){
        if( trigger.isInsert && trigger.isAfter ){
            handler.OnAfterInsert(trigger.new, trigger.newMap);
        }
        /* if( trigger.isInsert && trigger.isBefore){
            handler.OnBeforeInsert(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
        } */
    }

}