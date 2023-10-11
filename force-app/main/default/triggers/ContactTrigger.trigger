/*
@Author: C. Reynolds, Admins on Call
@Date: 07-12-2020
@Description: Generic Trigger Interface for Contact.

@History:
*/
trigger ContactTrigger on Contact (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
    
    ContactTriggerHandler handler = new ContactTriggerHandler(trigger.isExecuting, trigger.size);
    
    if(TriggerStatus.shouldRunTrigger()){
        if ( trigger.isInsert && trigger.isBefore ){
            handler.OnBeforeInsert(trigger.new, trigger.newMap );
            }
            else if( trigger.isInsert && trigger.isAfter ){
                handler.OnAfterInsert(trigger.new, trigger.newMap); 
                //ContactTriggerHandler.OnAfterInsertAsync(trigger.newMap.keySet());
            }     
            else if( trigger.isUpdate && trigger.isBefore ){
                handler.OnBeforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
            }
            else if( trigger.isUpdate && trigger.isAfter ){
                handler.OnAfterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
                //ContactTriggerHandler.OnAfterUpdateAsync(trigger.newMap.keySet());
            }
            else if( trigger.isDelete && trigger.isBefore ){
                //handler.OnBeforeDelete(trigger.old, trigger.oldMap);
            }
            else if( trigger.isDelete && trigger.isAfter ){
                //handler.OnAfterDelete(trigger.old, trigger.oldMap);
                //ContactTriggerHandler.OnAfterDeleteAsync(trigger.oldMap.keySet());
            }
            else if( trigger.isUnDelete ){
                //handler.OnUndelete(trigger.new, trigger.newMap);   
            }

    }
}