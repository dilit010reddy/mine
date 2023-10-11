/*
    Name: MeetingService
    Author: Vincent Boyle
    Date: 5/19/2021
    Description: Service class for MeetingHelper and EventHelper classes,
                 get associated Meeting Templates and Meeting Task Templates for each meeting in trigger
*/

public without sharing class MeetingService {
    public static Map<Id, List<Meeting_Task_Template__c>> getTaskTemplatesByMeetingTemplate (List<Meeting__c> newRecords) {
        // Holds a Set of Ids pertaining to all Meeting Templates for the Meetings being inserted
        Set<Id> meetingTemplateIdSet = new Set<Id>();
        // List that contains a List of all Meeting Task Templates
        List<Meeting_Task_Template__c> meetingTaskTemplateList = new List<Meeting_Task_Template__c>();
        // Map of a List of Meeting Task Templates keyed by the Meeting Template Id
        Map<Id, List<Meeting_Task_Template__c>> meetingTaskTemplatesByMeetingTemplateMap = new Map<Id, List<Meeting_Task_Template__c>>();

        // Organize all of the Meeting Template IDs into a Set
        for (Meeting__c meeting : newRecords) {
            meetingTemplateIdSet.add(meeting.Meeting_Template__c);
        }

        // Get a list of all Task Templates for all of the Meeting Templates you care about
        meetingTaskTemplateList = [SELECT Id, Name, Before_After_On__c, Days__c,
                                          Description__c, Reschedulable__c,
                                          Meeting_Template__r.Id 
                                   FROM   Meeting_Task_Template__c 
                                   WHERE  Meeting_Template__c IN :meetingTemplateIdSet];

        for (Meeting_Task_Template__c mtt : meetingTaskTemplateList) {
            // Check if you already have a key for that Meeting Template
            if (!meetingTaskTemplatesByMeetingTemplateMap.containsKey(mtt.Meeting_Template__r.Id)) {
                // If the key doesn't exist instantiate a new Key/Value pair where the Key is the Meeting Template Id and the Value is a new List of Meeting Task Templates
                // This only happens the first time you see a new Meeting Template Id
                meetingTaskTemplatesByMeetingTemplateMap.put(mtt.Meeting_Template__r.Id, new List<Meeting_Task_Template__c>());
            }
            // Now that you can ensure that you have a Key for this specific Meeting Template, start aadding Meeting Task Templates to the Value (List of Meeting Task Templates)
            meetingTaskTemplatesByMeetingTemplateMap.get(mtt.Meeting_Template__r.Id).add(mtt);
        }

        return meetingTaskTemplatesByMeetingTemplateMap;
    }

    // return a map of all tasks by meeting id for meetings in the trigger
    public static Map<Id, List<Task>> getTasksByMeeting (List<Meeting__c> newRecords) {
        Set<Id> meetingIdSet = new Set<Id>();
        List<Task> taskList = new List<Task>();
        Map<Id, List<Task>> tasksByMeetingMap = new Map<Id, List<Task>>();

        for (Meeting__c meeting : newRecords) {
            meetingIdSet.add(meeting.Id);
        }

        // get all open tasks, or completed tasks that are reschedulable
        taskList = [SELECT Id, Subject, Description, Reschedulable__c, Status,
                           ActivityDate, Meeting__r.Id, Meeting_Task_Template__r.Id,
                           Before_After_On__c, Days__c
                    FROM   Task 
                    WHERE  Meeting__c IN :meetingIdSet
                    AND    (Status = 'Open' OR (Status = 'Completed' AND Reschedulable__c = true))];

        for (Task tsk : taskList) {
            if (!tasksByMeetingMap.containsKey(tsk.Meeting__r.Id)) {
                tasksByMeetingMap.put(tsk.Meeting__r.Id, new List<Task>());
            }
            tasksByMeetingMap.get(tsk.Meeting__r.Id).add(tsk);
        }

        return tasksByMeetingMap;
    }
}