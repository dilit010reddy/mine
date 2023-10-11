/*
    Name: MeetingTrigger
    Author: Vincent Boyle
    Date: 6/14/2021
    Description: Test methods for MeetingTaskTemplateHelper class
*/

@isTest
public with sharing class MeetingTaskTemplateHelper_TC {
    @testSetup static void createTestData() {
        // Turn off account trigger that looks for association accounts, this test class only has account types of 'other'
        TriggerStatus.setDoNotRunTrigger();

        // test users
        // test classes can see all user/profile data in org
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        List<User> testUsers = new List<User>();
        testUsers.add(new User(
            FirstName = 'testHelsing1',
            Alias = 'testA',
            Email = 'test@test.com',
            ProfileId = profile.Id,
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            TimeZoneSidKey='America/Los_Angeles', UserName='testHelsingMeeting@test.com'
        ));
        insert testUsers;

        // test accounts
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(
            Name = 'testAccount1',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Other').getRecordTypeId(),
            OwnerId = testUsers[0].Id
        ));
        insert testAccounts;
        // system.debug('test account: ' + testAccounts);

        // test meeting templates
        List<Meeting_Template__c> testMeetingTemplates = new List<Meeting_Template__c>();
        testMeetingTemplates.add(new Meeting_Template__c(
            Name = 'Annual Meeting',
            Description__c = 'test meeting template'
        ));
        insert testMeetingTemplates;
        // system.debug('test meeting templates: ' + testMeetingTemplates);

        // task meeting templates, task templates are unique to each meeting template
        List<Meeting_Task_Template__c> meetingTaskTemplates = new List<Meeting_Task_Template__c>();
        meetingTaskTemplates.add(new Meeting_Task_Template__c(
            Name = 'Prepare Notice and Agenda',
            Before_After_On__c = 'Before',
            Description__c = 'test',
            Days__c = 12,
            Reschedulable__c = false,
            Meeting_Template__c = testMeetingTemplates[0].Id
        ));
        insert meetingTaskTemplates;
        // system.debug('test meeting task templates: ' + meetingTaskTemplates);   
        
        // test tasks
        // do not create meetings/events so we don't fire meeting/event triggers and can isolate this test class
        List<Task> testTasks = new List<Task>();
        testTasks.add(new Task(
            Subject = 'testTask',
            Meeting_Task_Template__c = meetingTaskTemplates[0].Id,
            Priority = 'Normal',
            Status = 'Open'
        ));


        // not using since referencing Meeting_Template__c instead of Meeting_Template__r.Id avoids non-selective soql query error
        // create over 200,000 tasks to test querying large SObject
        /*
        for (Integer i = 0; i < 250000; i++) {
                testTasks.add(new Task(
                Subject = 'testTask' + i,
                Priority = 'Normal',
                Status = 'Closed'
            ));
        } */
        insert testTasks;
    }

    @isTest
    public static void successfulDelete() {
        Boolean successfulDelete = true;
        List<Meeting_Task_Template__c> taskTemplate = [SELECT Id FROM Meeting_Task_Template__c];
        // query for related tasks, only one created for this test class
        List<Task> existingTasks = [SELECT Id FROM Task];
        delete existingTasks[0];

        try {
            delete taskTemplate[0];
        } catch(Exception e) {
            system.debug('Exception occurred: ' + e.getMessage());
            successfulDelete = false;
        }
        // assert task template was successfully deleted
        system.assertEquals(true, successfulDelete, 'Meeting task template should successfully delete if there are no related tasks.');
    }

    @isTest
    public static void unsuccessfulDelete() {
        Boolean successfulDelete = true;
        List<Meeting_Task_Template__c> taskTemplate = [SELECT Id FROM Meeting_Task_Template__c];

        try {
            delete taskTemplate[0];
        } catch(Exception e) {
            system.debug('Exception occurred: ' + e.getMessage());
            successfulDelete = false;
        }
        // assert task template was successfully deleted
        system.assertEquals(false, successfulDelete, 'Meeting task template should not delete if there are related tasks.');
    }
}