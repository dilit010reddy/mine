/*
    Name: MeetingTrigger
    Author: Vincent Boyle
    Date: 6/11/2021
    Description: Handles the trigger logic for the Meeting Task Template custom object
*/

public with sharing class MeetingTaskTemplateTriggerHandler {
    // Variables
    private Boolean isExecuting = false;
    private Integer batchSize = 0;

    // Constructor
    public MeetingTaskTemplateTriggerHandler(Boolean isExecuting, Integer size) {
        this.isExecuting = isExecuting;
        this.batchSize = size;
    }

    // Public methods
    // public void beforeInsert(SObject[] records) {
    // }

    // public void afterInsert(SObject[] records, Boolean afterTrigger, Boolean updateTrigger) {
    // }

    // public void beforeUpdate(SObject[] records, SObject[] oldRecords, Map<Id, SObject> recordMap, Map<Id, SObject> oldRecordMap) {
    // }

    // public void afterUpdate(SObject[] records, SObject[] oldRecords, Map<Id, SObject> recordMap, Map<Id, SObject> oldRecordMap, Boolean afterTrigger, Boolean updateTrigger) {
    // }

    public void beforeDelete(SObject[] records, Map<Id, SObject> recordMap) {  
        MeetingTaskTemplateHelper.checkIfExistingTasks(records);
    }

    // public void afterDelete(SObject[] records, Map<Id, SObject> recordMap) {
    // }

    // public void afterUndelete(SObject[] records) {
    // }

    // Private methods
}