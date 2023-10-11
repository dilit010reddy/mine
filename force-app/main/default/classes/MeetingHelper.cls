/*
    Name: MeetingTrigger
    Author: Vincent Boyle
    Date: 5/18/2021
    Description: Handles the logic for the Meeting custom object
*/

public without sharing class MeetingHelper {
    // Before update/insert - validate meeting is far enough in the future, start date must be no less than earliest task due date,
    // and gets account ownerId and sets meeting ownerId to same 
    public static void validateMeeting(List<Meeting__c> meetingRecords) {
        Integer numOfDaysOut;
        Integer closestTaskNum;
        String closestTaskName;
        Set<Id> meetingTemplateIds = new Set<Id>();
        Boolean meetingToggle;
        for (Meeting__c meeting : meetingRecords) {
            // system.debug('template id: ' + meeting.Meeting_Template__c);
            meetingTemplateIds.add(meeting.Meeting_Template__c);
        }
        Map<Id, Meeting_Task_Template__c> closestTaskDueDateMap2 = new Map<Id, Meeting_Task_Template__c>();
        // get metadata object used to toggle task due date validation
        // this does not count against SOQL limits
        // add error handling since this metadata is surfaced to sys admins at Helsing
        try {
            Validate_Meeting_Creation__mdt validateToggle = [SELECT Run_Meeting_Validation__c 
                                                             FROM Validate_Meeting_Creation__mdt 
                                                             WHERE DeveloperName = 'Validate_Meetings_Toggle'
                                                             LIMIT 1];
            meetingToggle = validateToggle.Run_Meeting_Validation__c;                                               
        } catch(Exception e) {
            system.debug('Error querying for Validate_Meetings_Toggle metadata record, system will automatically validate meetings. ' + e.getMessage());
            meetingToggle = true;
        }

        // use this query to prevent a meeting from being created if the corresponding meeting template has no task templates
        Map<Id, List<Meeting_Task_Template__c>> existingTaskTemplatesByMeetingTemplate = MeetingService.getTaskTemplatesByMeetingTemplate(meetingRecords);

        // query for task templates with due dates before start date
        List<Meeting_Task_Template__c> taskDueDates = [SELECT   Id, Name, Meeting_Template__r.Id, Days__c
                                                       FROM     Meeting_Task_Template__c
                                                       WHERE    Before_After_On__c = 'Before'
                                                       AND      Meeting_Template__r.Id IN :meetingTemplateIds
                                                       ORDER BY Days__c DESC];

        // loop through task template list, get first template for each template id and put to map
        // could add another aggregate query to count unique Ids and break loop once map is filled, don't want to use another soql query
        for (Meeting_Task_Template__c taskTemplate : taskDueDates) {
            if (!closestTaskDueDateMap2.containsKey(taskTemplate.Meeting_Template__r.Id)) {
                closestTaskDueDateMap2.put(taskTemplate.Meeting_Template__r.Id, taskTemplate);
            }
        }

        for (Meeting__c meeting : meetingRecords) {
            if (existingTaskTemplatesByMeetingTemplate.containsKey(meeting.Meeting_Template__c) == false) {
                meeting.addError('A meeting must have associated task templates to be created.');
            }
            // only validate task due dates if Validate_Meetings_Toggle is checked
            if (meetingToggle == true) {
                numOfDaysOut = Math.abs(meeting.Start_Date__c.date().daysBetween(Date.today()));
                if (closestTaskDueDateMap2.containsKey(meeting.Meeting_Template__c) == true) {
                    closestTaskNum = Integer.valueOf(closestTaskDueDateMap2.get(meeting.Meeting_Template__c).Days__c);
                    closestTaskName = closestTaskDueDateMap2.get(meeting.Meeting_Template__c).Name;
                    // system.debug('days out: ' + numOfDaysOut + '\nClosest task: ' + closestTaskNum + ' task name: ' + closestTaskName);
                    if (numOfDaysOut < closestTaskNum) {
                        meeting.addError('The meeting start date is too early to complete a task. At least ' + closestTaskNum + 
                                        ' days are needed for the task: ' + closestTaskName +'.');
                    }
                }
            }
        }
    }

    public static void setDefaultMeetingValues(List<Meeting__c> meetingRecords) {
        Set<Id> accountIds = new Set<Id>();
        for (Meeting__c meeting : meetingRecords) {
            if (meeting.Account__c != null) {
                accountIds.add(meeting.Account__c);
            }
        }
        // query for accounts related to meetings in trigger
        Map<Id, Account> meetingAccount = new Map<Id, Account>([SELECT Id, OwnerId FROM Account WHERE Id IN :accountIds]);
        for(Meeting__c meeting : meetingRecords) {
            if (meeting.Account__c != null && meetingAccount.get(meeting.Account__c).OwnerId != null) {
                meeting.ownerId = meetingAccount.get(meeting.Account__c).OwnerId;
            }
        }
    }
    
    // After update/insert - create event, find meeting templates and task templates, create tasks
    public static void createEvents(List<Meeting__c> meetingRecords) {
        List<Event> newEvents = new List<Event>();

        // create event for each meeting
        for (Meeting__c meeting : meetingRecords) {        
            newEvents.add(new Event(
                Subject = meeting.Name,
                OwnerId = meeting.OwnerId,
                WhatId = meeting.Account__c,
                StartDateTime = meeting.Start_Date__c,
                EndDateTime = meeting.End_Date__c,
                Location = meeting.Location__c,
                Description = meeting.Description__c,
                Meeting__c = meeting.Id,
                Meeting_Template__c = meeting.Meeting_Template__c
            ));  
        }

        if (!newEvents.isEmpty()) {
            insert newEvents;
        }
    }

    public static void createTasks(List<Meeting__c> meetingRecords) {
        List<Task> taskList = new List<Task>();
        Map<Id, List<Meeting_Task_Template__c>> meetingTaskTemplatesByMeetingTemplateMap = MeetingService.getTaskTemplatesByMeetingTemplate(meetingRecords);
        Date taskDueDate;
        // need to query for account owner Id, lookup fields not available in trigger context
        Map<Id, Meeting__c> meetingAccountOwnerMap = new Map<Id, Meeting__c>([SELECT Id, Account__r.OwnerId FROM Meeting__c WHERE Id IN :meetingRecords]);

        for (Meeting__c meeting : meetingRecords) {
            for (Meeting_Task_Template__c mtt : meetingTaskTemplatesByMeetingTemplateMap.get(meeting.Meeting_Template__c)) {
                if (mtt.Before_After_on__c == 'Before') {
                    taskDueDate = meeting.Start_Date__c.date().addDays((Integer) mtt.Days__c * -1);
                } else {
                    taskDueDate = meeting.Start_Date__c.date().addDays((Integer) mtt.Days__c);
                }

                // system.debug('meeting account owner: ' + meetingAccountOwnerMap.get(meeting.Id).Account__r.OwnerId);
                // Instantiate a new Task for each Meeting Task Template related to the Meeting's Meeting Template
                taskList.add(new Task(
                    // task owner is the owner of the account (aka HOA)
                    OwnerId = meetingAccountOwnerMap.get(meeting.Id).Account__r.OwnerId,
                    Subject = mtt.Name,
                    Description = mtt.Description__c,
                    // ActivityDate is due date of task, start date of meeting +- days of task
                    ActivityDate = taskDueDate,
                    Meeting_Task_Template__c = mtt.Id,
                    Meeting__c = meeting.Id,
                    WhatId = meeting.Account__c
                ));
            }
        }

        if (taskList.size() > 0) {
            insert taskList;
        }
    }

    // lock meeting records from edit, all changes will be made from Event object
    public static void lockMeetingRecords(List<Meeting__c> meetingRecords) {
        Approval.lock(meetingRecords, false);
    }
}