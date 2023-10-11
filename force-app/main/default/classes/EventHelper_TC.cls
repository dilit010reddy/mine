@istest
public with sharing class EventHelper_TC {
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
        
        // test meetings
        List<Meeting__c> testMeetings = new List<Meeting__c>();
        testMeetings.add(new Meeting__c(
            Name = 'testMeeting1',
            Meeting_Template__c = testMeetingTemplates[0].Id,
            Description__c = 'test meeting',
            Account__c = testAccounts[0].Id,
            Location__c = 'Narnia',
            Start_Date__c = Datetime.now().addDays(13),
            End_Date__c = Datetime.now().addDays(14)
        ));
        insert testMeetings;  
    }

    // test cancelling event updates subject
    @isTest static void cancelEvent() {
        List<Meeting__c> createdMeetings = [SELECT Id FROM Meeting__c WHERE Name = 'testMeeting1'];
        List<Event> createdEvents = [SELECT Id, Cancelled__c, Subject FROM Event WHERE Meeting__r.Id in :createdMeetings];
        
        createdEvents[0].Cancelled__c = true;
        createdEvents[0].Cancel_Confirmation__c = true;
        update createdEvents;

        // assert event has cancelled in it's subject
        List<Event> updatedEvents = [SELECT Id, Cancelled__c, Subject FROM Event WHERE Id in :createdEvents];
        system.assertEquals('[Cancelled] ' + createdEvents[0].Subject, updatedEvents[0].Subject);
    }

    // test successful update
    @isTest static void successfulEventUpdate() {
        List<Meeting__c> createdMeetings = [SELECT Id FROM Meeting__c WHERE Name = 'testMeeting1'];
        List<Event> createdEvents = [SELECT Id, StartDateTime FROM Event WHERE Meeting__r.Id in :createdMeetings];
        Boolean successfulUpdate = true;

        createdEvents[0].StartDateTime = createdEvents[0].StartDateTime.addHours(1);
        
        try {
            update createdEvents;
        } catch(Exception e) {
            system.debug('Exception occurred: ' + e.getMessage());
            successfulUpdate = false; 
        }

        system.assertEquals(true, successfulUpdate, 'Event should successfully update.');
    }

    // test failed update
    @isTest static void failedEventUpdate() {
        List<Meeting__c> createdMeetings = [SELECT Id FROM Meeting__c WHERE Name = 'testMeeting1'];
        List<Event> createdEvents = [SELECT Id, StartDateTime FROM Event WHERE Meeting__r.Id in :createdMeetings];
        Boolean successfulUpdate = true;

        createdEvents[0].StartDateTime = createdEvents[0].StartDateTime.addHours(-1);
        
        try {
            update createdEvents;
        } catch(Exception e) {
            system.debug('Exception occurred: ' + e.getMessage());
            successfulUpdate = false; 
        }

        system.assertEquals(false, successfulUpdate, 'Event should not successfully update.');
    }

    // test meeting was updated
    @isTest static void meetingUpdated() {
        List<Meeting__c> createdMeetings = [SELECT Id FROM Meeting__c WHERE Name = 'testMeeting1'];
        List<Event> createdEvents = [SELECT Id, StartDateTime, EndDateTime,
                                            Cancelled__c, Description, Subject
                                     FROM   Event WHERE Meeting__r.Id in :createdMeetings];
        
        // update event
        createdEvents[0].StartDateTime.addDays(1);
        createdEvents[0].Cancelled__c = true;
        createdEvents[0].Cancel_Confirmation__c = true;
        createdEvents[0].Description = 'testing that meeting fields equal updated event fields';
        update createdEvents;

        // get updated event and meeting and assert the fields match
        List<Event> updatedEvents = [SELECT Id, StartDateTime, EndDateTime,
                                            Cancelled__c, Description, Subject
                                     FROM   Event WHERE Meeting__r.Id in :createdMeetings];
        List<Meeting__c> updatedMeetings = [SELECT Id, Start_Date__c, End_Date__c, 
                                                   Cancelled__c, Name, Description__c
                                            FROM   Meeting__c WHERE Id IN :createdMeetings];
        system.debug('meeting: ' + updatedMeetings + 'event: ' + createdEvents);
        system.assertEquals(updatedEvents[0].StartDateTime, updatedMeetings[0].Start_Date__c, 'Start date time not equal');
        system.assertEquals(updatedEvents[0].EndDateTime, updatedMeetings[0].End_Date__c, 'End date time not equal');
        system.assertEquals(updatedEvents[0].Cancelled__c, updatedMeetings[0].Cancelled__c, 'Meeting not cancelled');
        system.assertEquals(updatedEvents[0].Subject, updatedMeetings[0].Name, 'Meeting name does not match');
        system.assertEquals(updatedEvents[0].Description, updatedMeetings[0].Description__c, 'Meeting description does not match');
    }

    // test tasks were updated
    @isTest static void tasksUpdated() {
        List<Meeting__c> createdMeetings = [SELECT Id FROM Meeting__c WHERE Name = 'testMeeting1'];
        List<Task> tasksToUpdate = new List<Task>();

        // update the reschedulable task to completed to test that it was reset to open
        Map<Id, Task> createdTasks = new Map<Id, Task>([SELECT Id, Status, ActivityDate, Reschedulable__c FROM Task WHERE Meeting__r.Id IN :createdMeetings]);
        for (Task tsk : createdTasks.values()) {
            // system.debug('task name: ' + tsk.Id + ' old date: ' + tsk.ActivityDate);
            if (tsk.Reschedulable__c == true) {
                tsk.Status = 'Completed';
                tasksToUpdate.add(tsk);
            }
        }
        update tasksToUpdate;

        // update a task template so there are not enough days before event to complete it, code will set due date to today
        Meeting_Task_Template__c updateTaskTemplate = [SELECT Id, Days__C FROM Meeting_Task_Template__c WHERE Name = 'Prepare Notice and Agenda' LIMIT 1];
        updateTaskTemplate.Days__c = 16;
        update updateTaskTemplate;

        // update event
        List<Event> createdEvents = [SELECT Id, StartDateTime, ActivityDateTime, EndDateTime FROM Event WHERE Meeting__r.Id in :createdMeetings];
        // system.debug('original event date: ' + createdEvents[0].StartDateTime);
        createdEvents[0].StartDateTime = createdEvents[0].StartDateTime.addDays(1);
        // need to update these fields as well or SF throws an error
        createdEvents[0].EndDateTime = createdEvents[0].EndDateTime.addDays(1);
        createdEvents[0].ActivityDateTime = createdEvents[0].ActivityDateTime.addDays(1);
        update createdEvents;

        // get updated tasks and assert due dates match new event date, and a completed, reschedulable task is set to open
        List<Task> updatedTasks = [SELECT Id, Subject, ActivityDate, Status, Reschedulable__c FROM Task WHERE Meeting__r.Id IN :createdMeetings];
        for (Task tsk : updatedTasks) {
            // system.debug('task name: ' + tsk.Id + ' new date: ' + tsk.ActivityDate);
            if (tsk.Reschedulable__c == true) {
                system.assertEquals('Open', tsk.Status, 'Completed, reschedulable task status not set to \'Open\'');
            }
            if (tsk.Subject == 'Prepare Notice and Agenda') {
                system.assertEquals(Date.today(), tsk.ActivityDate, 'Task due date with not enough time to complete before event date was not set to today');
            } else {
                system.assertEquals(createdTasks.get(tsk.Id).ActivityDate.addDays(1), tsk.ActivityDate, 'Task due date did not change with new event date');
            }  
        }
    }

    // test tasks were cancelled
    @isTest static void tasksCancelledUncancelled() {
        List<Meeting__c> createdMeetings = [SELECT Id FROM Meeting__c WHERE Name = 'testMeeting1'];
        List<Event> createdEvents = [SELECT Id, Cancelled__c FROM Event WHERE Meeting__r.Id in :createdMeetings];
    
        // cancel event
        createdEvents[0].Cancelled__c = true;
        createdEvents[0].Cancel_Confirmation__c = true;
        update createdEvents;

        // assert all tasks cancelled
        List<Task> updatedTasks = [SELECT Id, Status FROM Task WHERE Meeting__r.Id IN :createdMeetings];
        for (Task tsk: updatedTasks) {
            system.assertEquals('Canceled', tsk.Status, 'Task not cancelled');
        }
    }
}