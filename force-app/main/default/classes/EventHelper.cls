public without sharing class EventHelper {  
    // validates new event start date is after orignal start date
    // if 'cancelled' is selected, updates event subject to include cancelled and sets cancelled by user
    public static void validateUpdateEvent(List<Event> eventRecords, Map<Id, Event> oldEventMap) {
        List<String> subjectList = new List<String>();
        List<Event> filteredEvents = new List<Event>();
        // filter to only events that have a corresponding meeting, as validation only applies to them
        for (Event updatedEvent : eventRecords) {
            if (event.Meeting__c != null) {
                filteredEvents.add(updatedEvent);
            }
        }
        for (Event eventRecord : filteredEvents) {
            // add 'cancelled' to subject and get cancelled by user
            if (eventRecord.Cancelled__c == true && oldEventMap.get(eventRecord.Id).Cancelled__c == false) {
                eventRecord.Subject = '[Cancelled] ' + eventRecord.Subject;
                eventRecord.Cancelled_By__c = UserInfo.getUserId(); 
            } else {
                // events with a meeting can only be updated forward from original start date
                if (eventRecord.StartDateTime < oldEventMap.get(eventRecord.Id).StartDateTime) {
                    eventRecord.addError('Events with a related Meeting can only be moved forward in time.');
                }
            }         
        }
    }

    public static void cancelEvents(List<Event> eventRecords, Map<Id, Event> oldEventMap) {
        Set<Id> eventMeetingIds = new Set<Id>();
        List<Event> cancelledEvents = new List<Event>();
        for (Event updatedEvent : eventRecords) {
            if (updatedEvent.Meeting__c != null && updatedEvent.Cancelled__c == true && oldEventMap.get(updatedEvent.Id).Cancelled__c == false) {
                cancelledEvents.add(updatedEvent);
            }
        }
        if(cancelledEvents.size() > 0){
            for (Event e : cancelledEvents) {
                eventMeetingIds.add(e.Meeting__c);
            }
            List<Task> tasksToUpdate = new List<Task>();
            List<Meeting__c> meetingsToUpdate = new List<Meeting__c>();
            Meeting__c meetingRelatedToEvent = new Meeting__c();
            Map<Id, Meeting__c> eventMeetingsMap = new Map<Id, Meeting__c>([SELECT Account__c, Cancelled__c,Description__c,
                                                                                End_Date__c, Id,Location__c, Meeting_Template__c, Name, Start_Date__c 
                                                                            FROM   Meeting__c 
                                                                            WHERE  Id IN :eventMeetingIds]);

            // get all associated tasks with each event in trigger
            Map<Id, List<Task>> tasksByMeeting = MeetingService.getTasksByMeeting(eventMeetingsMap.values());
            
            for (Event eventRecord : cancelledEvents) {
                // for each task, cancel if event cancelled, update due date and set completed reschedulable tasks to open
                if (!tasksByMeeting.isEmpty()) {
                    for (Task tsk : tasksByMeeting.get(eventRecord.Meeting__c)) {
                        tsk.Status = 'Canceled';
                        tasksToUpdate.add(tsk);
                    }
                }
                
                // update meeting__c to match event
                meetingRelatedToEvent = eventMeetingsMap.get(eventRecord.Meeting__c);
                if (meetingRelatedToEvent != null) {
                    meetingRelatedToEvent.Start_Date__c = eventRecord.StartDateTime;
                    meetingRelatedToEvent.End_Date__c = eventRecord.EndDateTime;
                    meetingRelatedToEvent.Cancelled__c = eventRecord.Cancelled__c;
                    meetingRelatedToEvent.Name = eventRecord.Subject;
                    meetingRelatedToEvent.Description__c = eventRecord.Description;
                    // meetingRelatedToEvent.OwnerId = eventRecord.OwnerId;
                    // meetingRelatedToEvent.Account__c = eventRecord.WhatId;
                    // meetingRelatedToEvent.Meeting_Template__c = eventRecord.Meeting_Template__c;
                    meetingsToUpdate.add(meetingRelatedToEvent);
                }
            }

            if (!tasksToUpdate.isEmpty()) {
                update tasksToUpdate;
            }
            if (!meetingsToUpdate.isEmpty()) {
                Approval.unlock(meetingsToUpdate, false);
                update meetingsToUpdate;
                Approval.lock(meetingsToUpdate, false);
            }
        }
    }

    public static void updateEventStartTime(List<Event> eventRecords, Map<Id, Event> oldEventMap) {
        Integer dateDiff;
        Set<Id> eventMeetingIds = new Set<Id>();
        List<Event> updatedStartEvents = new List<Event>();
        for (Event updatedEvent : eventRecords) {
            if (updatedEvent.Meeting__c != null && updatedEvent.StartDateTime != oldEventMap.get(updatedEvent.Id).StartDateTime) {
                updatedStartEvents.add(updatedEvent);
            }
        }
        if(updatedStartEvents.size()>0){
            for (Event e : updatedStartEvents) {
                eventMeetingIds.add(e.Meeting__c);
            }
            List<Task> tasksToUpdate = new List<Task>();
            List<Meeting__c> meetingsToUpdate = new List<Meeting__c>();
            Meeting__c meetingRelatedToEvent = new Meeting__c();
            Map<Id, Meeting__c> eventMeetingsMap = new Map<Id, Meeting__c>([SELECT Account__c, Cancelled__c,Description__c,
                                                                                End_Date__c, Id,Location__c, Meeting_Template__c, Name, Start_Date__c 
                                                                            FROM   Meeting__c 
                                                                            WHERE  Id IN :eventMeetingIds]);

            // get all associated tasks with each event in trigger
            Map<Id, List<Task>> tasksByMeeting = MeetingService.getTasksByMeeting(eventMeetingsMap.values());
            // get all associated task templates for each task
            // this is not being used right now, with formula fields on the task object
            // Map<Id, List<Meeting_Task_Template__c>> taskTemplatesMap = MeetingService.getTaskTemplatesByMeetingTemplate(eventMeetingsMap.values());
            
            for (Event eventRecord : updatedStartEvents) {
                dateDiff = oldEventMap.get(eventRecord.Id).StartDateTime.date().daysBetween(eventRecord.StartDateTime.date());
                // for each task, cancel if event cancelled, update due date and set completed reschedulable tasks to open
                if (!tasksByMeeting.isEmpty()) {
                    for (Task tsk : tasksByMeeting.get(eventRecord.Meeting__c)) {
                        // system.debug('old task due date: ' + tsk.ActivityDate);
                        // if difference between event start date and today's date is less than required number of days, set due date to today, 
                        // otherwise, increase due date in line with new event date
                        Integer daysUntilEvent = Date.today().daysBetween(eventRecord.StartDateTime.date());
                        // system.debug('days until event: ' + daysUntilEvent);
                        // system.debug('task before/after/on: ' + tsk.Before_After_On__c + '\ntask days req: ' + tsk.Days__c);
                        if(tsk.Status == 'Open' || tsk.Reschedulable__c == true){
                            if (tsk.Before_After_On__c == 'Before' && (daysUntilEvent < tsk.Days__c)) {
                                tsk.ActivityDate = Date.today();
                            } else {
                                tsk.ActivityDate = tsk.ActivityDate.addDays(dateDiff);
                            }
                            // system.debug('new task due date: ' + tsk.ActivityDate);
                            if (tsk.Status == 'Completed') {
                                tsk.Status = 'Open';
                            }
                            tasksToUpdate.add(tsk);
                        }
                    }
                }
                
                // update meeting__c to match event
                meetingRelatedToEvent = eventMeetingsMap.get(eventRecord.Meeting__c);
                if (meetingRelatedToEvent != null) {
                    meetingRelatedToEvent.Start_Date__c = eventRecord.StartDateTime;
                    meetingRelatedToEvent.End_Date__c = eventRecord.EndDateTime;
                    meetingRelatedToEvent.Cancelled__c = eventRecord.Cancelled__c;
                    meetingRelatedToEvent.Name = eventRecord.Subject;
                    meetingRelatedToEvent.Description__c = eventRecord.Description;
                    // meetingRelatedToEvent.OwnerId = eventRecord.OwnerId;
                    // meetingRelatedToEvent.Account__c = eventRecord.WhatId;
                    // meetingRelatedToEvent.Meeting_Template__c = eventRecord.Meeting_Template__c;
                    meetingsToUpdate.add(meetingRelatedToEvent);
                }
            }

            if (!tasksToUpdate.isEmpty()) {
                update tasksToUpdate;
            }
            if (!meetingsToUpdate.isEmpty()) {
                Approval.unlock(meetingsToUpdate, false);
                update meetingsToUpdate;
                Approval.lock(meetingsToUpdate, false);
            }
        }
    }
}