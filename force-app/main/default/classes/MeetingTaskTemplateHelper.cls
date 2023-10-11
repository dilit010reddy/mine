/*
    Name: MeetingTrigger
    Author: Vincent Boyle
    Date: 6/11/2021
    Description: Handles the logic for the Meeting Task Template custom object
*/

public with sharing class MeetingTaskTemplateHelper {
    public static void checkIfExistingTasks(List<Meeting_Task_Template__c> triggerTaskTemplates) {
        // get existing tasks by task template id
        Map<Id, List<Task>> existingTasks = getTasksByMeetingTaskTemplate(triggerTaskTemplates);
        // if tasks exist, prevent deletion of record
        for (Meeting_Task_Template__c taskTemplate : triggerTaskTemplates) {
            if (existingTasks.containsKey(taskTemplate.Id)) {
                taskTemplate.addError('Cannot delete this meeting task template: existing tasks are using this template. Existing tasks must be completed or deleted first.');
            }
        }
    }

    // return a map of all tasks by meeting task template id
    public static Map<Id, List<Task>> getTasksByMeetingTaskTemplate (List<Meeting_Task_Template__c> taskTemplateRecords) {
        Set<Id> taskTemplateIdSet = new Set<Id>();
        List<Task> taskList = new List<Task>();
        Map<Id, List<Task>> tasksByMeetingTaskTemplateMap = new Map<Id, List<Task>>();

        for (Meeting_Task_Template__c taskTemplate : taskTemplateRecords) {
            taskTemplateIdSet.add(taskTemplate.Id);
        }

        // get all open tasks that are referencing a meeting task template
        // or the task is related to a meeting in the future (since it could be completed and reschedulable)
        taskList = [SELECT Id, Subject, Meeting_Task_Template__r.Id, Meeting__r.Start_Date__c
                    FROM   Task 
                    WHERE  Meeting_Task_Template__c IN :taskTemplateIdSet
                    AND    (Status = 'Open' OR (Meeting__r.Start_Date__c > TODAY))];

        // probably don't need a list of all existing tasks, if one exists deletion would be prevented
        // will keep in case tasks need to be referenced in future
        for (Task tsk : taskList) {
            if (!tasksByMeetingTaskTemplateMap.containsKey(tsk.Meeting_Task_Template__r.Id)) {
                tasksByMeetingTaskTemplateMap.put(tsk.Meeting_Task_Template__r.Id, new List<Task>());
            }
            tasksByMeetingTaskTemplateMap.get(tsk.Meeting_Task_Template__r.Id).add(tsk);
        }

        return tasksByMeetingTaskTemplateMap;
    }
}