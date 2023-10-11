/*
    Name: MeetingTrigger
    Author: Vincent Boyle
    Date: 5/18/2021
    Description: Handles trigger logic for the MeetingTrigger
*/

public without sharing class MeetingTriggerHandler {
    // Variables
    private Boolean isExecuting = false;
    private Integer batchSize = 0;

    // Constructor
    public MeetingTriggerHandler(Boolean isExecuting, Integer size) {
        this.isExecuting = isExecuting;
        this.batchSize = size;
    }

    // Public methods
    public void beforeInsert(SObject[] records) {
        MeetingHelper.validateMeeting(records);
        MeetingHelper.setDefaultMeetingValues(records);
    }

    public void afterInsert(SObject[] records, Boolean afterTrigger, Boolean updateTrigger) {
        MeetingHelper.createEvents(records);
        MeetingHelper.createTasks(records);
        MeetingHelper.lockMeetingRecords(records);
    }

    // public void beforeUpdate(SObject[] records, SObject[] oldRecords, Map<Id, SObject> recordMap, Map<Id, SObject> oldRecordMap) {
    // }

    // public void afterUpdate(SObject[] records, SObject[] oldRecords, Map<Id, SObject> recordMap, Map<Id, SObject> oldRecordMap, Boolean afterTrigger, Boolean updateTrigger) {
    // }

    // public void beforeDelete(SObject[] records, Map<Id, SObject> recordMap) {   
    // }

    // public void afterDelete(SObject[] records, Map<Id, SObject> recordMap) {
    // }

    // public void afterUndelete(SObject[] records) {
    // }

    // Private methods
}