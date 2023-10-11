/*
    Name: MeetingTaskTemplateTrigger
    Author: Vincent Boyle
    Date: 6/11/2021
    Description: Handles the logic for the Meeting Task Template custom object
*/

trigger MeetingTaskTemplateTrigger on Meeting_Task_Template__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    MeetingTaskTemplateTriggerHandler objectHandler = new MeetingTaskTemplateTriggerHandler(Trigger.isExecuting, Trigger.size);
    switch on Trigger.operationType {
        // when BEFORE_INSERT {
        //     objectHandler.beforeInsert(Trigger.new);
        // }

        // when AFTER_INSERT {
        //     objectHandler.afterInsert(Trigger.new, Trigger.isAfter, Trigger.isUpdate);
        // }

        // when BEFORE_UPDATE {
        //     objectHandler.beforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        // }

        // when AFTER_UPDATE {
        //     objectHandler.afterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap, Trigger.isAfter, Trigger.isUpdate);
        // }

        when BEFORE_DELETE {
            objectHandler.beforeDelete(Trigger.old, Trigger.oldMap);
        }

        // when AFTER_DELETE {
        //     objectHandler.afterDelete(Trigger.old, Trigger.oldMap);
        // }

        // when AFTER_UNDELETE {
        //     objectHandler.afterUndelete(Trigger.new);
        // }
    }
}