trigger EventTrigger on Event (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    //trigger MeetingTrigger on Meeting__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
        EventTriggerHandler objectHandler = new EventTriggerHandler(Trigger.isExecuting, Trigger.size);
        // TriggerStatus.shouldRunTrigger is toggled off in test class to turn off account trigger
        switch on Trigger.operationType {
            //when BEFORE_INSERT {
            //    objectHandler.beforeInsert(Trigger.new);
            //}
    
            //when AFTER_INSERT {
            //    objectHandler.afterInsert(Trigger.new, Trigger.isAfter, Trigger.isUpdate);
            //}
    
            when BEFORE_UPDATE {
                objectHandler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
            }
    
            when AFTER_UPDATE {
               objectHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap, Trigger.isAfter, Trigger.isUpdate);
            }
    
            // when BEFORE_DELETE {
            //     objectHandler.beforeDelete(Trigger.old, Trigger.oldMap);
            // }
    
            // when AFTER_DELETE {
            //     objectHandler.afterDelete(Trigger.old, Trigger.oldMap);
            // }
    
            // when AFTER_UNDELETE {
            //     objectHandler.afterUndelete(Trigger.new);
            // }
        }
}