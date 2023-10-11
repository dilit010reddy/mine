public without sharing class EventTriggerHandler {
            
    private Boolean isExecuting = false;
    private Integer batchSize = 0;

    // Constructor
    public EventTriggerHandler(Boolean isExecuting, Integer size) {
        this.isExecuting = isExecuting;
        this.batchSize = size;
    }

    // Public methods
    //public void beforeInsert(SObject[] records) {
    //}

    //public void afterInsert(SObject[] records, Boolean afterTrigger, Boolean updateTrigger) {
    //}

    public void beforeUpdate(SObject[] records, SObject[] oldRecords, Map<Id, SObject> recordMap, Map<Id, SObject> oldRecordMap) {
        EventHelper.validateUpdateEvent(records, (Map<Id, Event>) oldRecordMap);
    }

    public void afterUpdate(SObject[] records, SObject[] oldRecords, Map<Id, SObject> recordMap, Map<Id, SObject> oldRecordMap, Boolean afterTrigger, Boolean updateTrigger) {
        //EventHelper.updateTasksAndMeetings(records, (Map<Id, Event>) oldRecordMap);
        EventHelper.cancelEvents(records, (Map<Id, Event>) oldRecordMap);
        EventHelper.updateEventStartTime(records, (Map<Id, Event>) oldRecordMap);
    }

    // public void beforeDelete(SObject[] records, Map<Id, SObject> recordMap) {   
    // }

    // public void afterDelete(SObject[] records, Map<Id, SObject> recordMap) {
    // }

    // public void afterUndelete(SObject[] records) {
    // }

    // Private methods
}