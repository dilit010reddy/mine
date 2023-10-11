/*
    Name: MeetingHelper_TC
    Author: Vincent Boyle
    Date: 5/18/2021
    Description: Test class for the MeetingHelper class
*/

@isTest
private class MeetingHelper_TC {
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
        testUsers.add(new User(
            FirstName = 'testHelsing2',
            Alias = 'testA2',
            Email = 'test2@test.com',
            ProfileId = profile.Id,
            EmailEncodingKey='UTF-8', 
            LastName='Testing2', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            TimeZoneSidKey='America/Los_Angeles', UserName='testHelsingMeeting2@test.com'
        ));
        insert testUsers;

        // test accounts
        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(
            Name = 'testAccount1',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Other').getRecordTypeId(),
            OwnerId = testUsers[0].Id
        ));
        testAccounts.add(new Account(
            Name = 'testAccount2',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Other').getRecordTypeId(),
            OwnerId = testUsers[1].Id
        ));
        insert testAccounts;
        // system.debug('test account: ' + testAccounts);

        // test meeting templates
        List<Meeting_Template__c> testMeetingTemplates = new List<Meeting_Template__c>();
        testMeetingTemplates.add(new Meeting_Template__c(
            Name = 'Annual Meeting',
            Description__c = 'test meeting template'
        ));
        testMeetingTemplates.add(new Meeting_Template__c(
            Name = 'Board Meetings',
            Description__c = 'test meeting template'
        ));
        testMeetingTemplates.add(new Meeting_Template__c(
            Name = 'No task templates',
            Description__c = 'this meeting template has no tasks'
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
        // add task template with 'after' selected for code coverage
        meetingTaskTemplates.add(new Meeting_Task_Template__c(
            Name = 'Post Meeting Minutes in Minutes and Online Folders',
            Before_After_On__c = 'After',
            Description__c = 'test',
            Days__c = 2,
            Reschedulable__c = false,
            Meeting_Template__c = testMeetingTemplates[0].Id
        ));
        // add a reschedulable task template for code coverage
        meetingTaskTemplates.add(new Meeting_Task_Template__c(
            Name = 'Send Meeting Minutes to Board',
            Before_After_On__c = 'After',
            Description__c = 'test',
            Days__c = 2,
            Reschedulable__c = true,
            Meeting_Template__c = testMeetingTemplates[0].Id
        ));
        // create a task for second meeting template
        meetingTaskTemplates.add(new Meeting_Task_Template__c(
            Name = 'Enter next Board Meeting date into Salesforce',
            Before_After_On__c = 'Before',
            Description__c = 'test',
            Days__c = 1,
            Reschedulable__c = false,
            Meeting_Template__c = testMeetingTemplates[1].Id
        ));
        insert meetingTaskTemplates;
        // system.debug('test meeting task templates: ' + meetingTaskTemplates);      
    }

    // test before insert
    @isTest static void successfulMeetingInsert() {
        Account testAccount = [SELECT Id, Name, OwnerId FROM Account WHERE Name = 'testAccount1' LIMIT 1];
        List<Meeting_Template__c> testMeetingTemplates = [SELECT Id, Name FROM Meeting_Template__c WHERE Name = 'Annual Meeting'];
        Boolean successfulInsert = true;
        
        // test meetings
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        testMeetings.add(new Meeting__c(
            Name = 'testMeeting1',
            Meeting_Template__c = testMeetingTemplates[0].Id,
            Description__c = 'test meeting',
            Account__c = testAccount.Id,
            Location__c = 'Narnia',
            Start_Date__c = Datetime.now().addDays(13),
            End_Date__c = Datetime.now().addDays(14)
        ));

        test.startTest();
        try {
            insert testMeetings;
        } catch(Exception e) {
            system.debug('Exception occurred: ' + e.getMessage());
            successfulInsert = false; 
        }
        test.stopTest();

        List<Meeting__c> insertedMeetings = [SELECT Id, Account__r.OwnerId FROM Meeting__c WHERE Id IN :testMeetings];
        system.assertEquals(true, successfulInsert);
        system.assertEquals(testAccount.OwnerId, insertedMeetings[0].Account__r.OwnerId, 'Meeting owner Id different than associated Account owner.');
    }

    // test before insert
    @isTest static void failedMeetingInsert() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'testAccount1' LIMIT 1];
        List<Meeting_Template__c> testMeetingTemplates = [SELECT Id, Name FROM Meeting_Template__c WHERE Name = 'Annual Meeting'];
        Boolean successfulInsert = true;
        
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        testMeetings.add(new Meeting__c(
            Name = 'testMeeting1',
            Meeting_Template__c = testMeetingTemplates[0].Id,
            Description__c = 'test meeting',
            Account__c = testAccount.Id,
            Location__c = 'Narnia',
            Start_Date__c = Datetime.now().addDays(2),
            End_Date__c = Datetime.now().addDays(4)
        ));

        test.startTest();
        try {
            insert testMeetings;
        } catch(Exception e) {
            system.debug('Exception occurred: ' + e.getMessage());
            successfulInsert = false; 
        }
        test.stopTest();

        system.assertEquals(false, successfulInsert);
    }

    // test before insert with meeting template that has no task templates
    @isTest static void meetingTemplateNoTaskTemplates() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'testAccount1' LIMIT 1];
        List<Meeting_Template__c> testMeetingTemplates = [SELECT Id, Name FROM Meeting_Template__c];
        Boolean successfulInsert = true;
        
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        testMeetings.add(new Meeting__c(
            Name = 'no task template meeting',
            Meeting_Template__c = testMeetingTemplates[2].Id,
            Description__c = 'test meeting',
            Account__c = testAccount.Id,
            Location__c = 'Narnia',
            Start_Date__c = Datetime.now().addDays(2),
            End_Date__c = Datetime.now().addDays(4)
        ));

        test.startTest();
        try {
            insert testMeetings;
        } catch(Exception e) {
            system.debug('Exception occurred: ' + e.getMessage());
            successfulInsert = false; 
        }
        test.stopTest();

        system.assertEquals(false, successfulInsert);
    }

    // test event creation
    @isTest static void eventsCreated() {
        Account testAccount = [SELECT Id, Name FROM Account WHERE Name = 'testAccount1' LIMIT 1];
        List<Meeting_Template__c> testMeetingTemplates = [SELECT Id, Name FROM Meeting_Template__c WHERE Name = 'Annual Meeting'];

        List<Meeting__c> testMeetings = new List<Meeting__c>();
        testMeetings.add(new Meeting__c(
            Name = 'testMeeting1',
            Meeting_Template__c = testMeetingTemplates[0].Id,
            Description__c = 'test meeting',
            Account__c = testAccount.Id,
            Location__c = 'Narnia',
            Start_Date__c = Datetime.now().addDays(13),
            End_Date__c = Datetime.now().addDays(14)
        ));
        test.startTest();
        insert testMeetings;
        test.stopTest();
        
        // get associated events, 1 to 1 relationship between events and meetings
        List<Event> eventsForMeetings = [SELECT Id FROM Event WHERE Meeting__c IN :testMeetings];
        system.assertEquals(testMeetings.size(), eventsForMeetings.size());
    }

    // test all tasks were created for meeting
    @isTest static void tasksCreated() {
        Account testAccount = [SELECT Id, OwnerId, Name FROM Account WHERE Name = 'testAccount1' LIMIT 1];
        List<Meeting_Template__c> testMeetingTemplates = [SELECT Id, Name FROM Meeting_Template__c WHERE  Name = 'Annual Meeting'];
        Map<Id, Meeting_Task_Template__c> testTaskTemplates = new Map<Id, Meeting_Task_Template__c>([SELECT Id, Name, Before_After_On__c, Description__c, 
                                                                                                            Days__c, Reschedulable__c
                                                                                                     FROM   Meeting_Task_Template__c
                                                                                                     WHERE  Meeting_Template__c = :testMeetingTemplates[0].Id]);
                                                                   
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        testMeetings.add(new Meeting__c(
            Name = 'testMeeting1',
            Meeting_Template__c = testMeetingTemplates[0].Id,
            Description__c = 'test meeting',
            Account__c = testAccount.Id,
            Location__c = 'Narnia',
            Start_Date__c = Datetime.now().addDays(13),
            End_Date__c = Datetime.now().addDays(14)
        ));
        test.startTest();
        insert testMeetings;
        test.stopTest();

        // get created tasks
        List<Task> createdTasks = [SELECT Id, OwnerId, WhatId, Subject, Description, 
                                   Meeting__c, ActivityDate, Meeting_Task_Template__r.Id
                            FROM   Task
                            WHERE  Task.Meeting__c = :testMeetings[0].Id];

        // assert task created according to it's task template
        // there are 3 task templates for the above test meeting so there should be 3 tasks created
        system.assertEquals(3, createdTasks.size());
        // don't need to compare ActivityDate since it is calculated at run time
        for (Task tsk : createdTasks) {
            system.debug('ActivityDate: ' + tsk.ActivityDate);
            system.assertEquals(testAccount.Id, tsk.WhatId, 'Task not related to same account as meeting');
            system.assertEquals(testAccount.OwnerId, tsk.OwnerId, 'Task owner Id not the same as account owner Id');
            system.assertEquals(testTaskTemplates.get(tsk.Meeting_Task_Template__r.Id).Name, tsk.Subject);
            system.assertEquals(testTaskTemplates.get(tsk.Meeting_Task_Template__r.Id).Description__c, tsk.Description);
            system.assertEquals(testMeetings[0].Id, tsk.Meeting__c, 'Task not associated to correct meeting');
        }    
    }

    // test negative case with custom metadata Validate_Meeting_Creation__mdt, task due dates are not validated
    // only need negative test case as positive case is tested in original successfulMeetingInsert()
    // unable to manipulate custom metadata from test class, functionality verified in Salesforce UI and code coverage not affected
}