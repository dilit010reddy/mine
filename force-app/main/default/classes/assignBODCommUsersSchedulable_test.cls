/*
    Name: assignBODCommUsersSchedulable_test
    Author: Vincent Boyle
    Date: 6/22/2021
    Description: Tests that the schedulable class runs, 
                 and the functionality for batch class assignBODCommUsersBatch.cls
*/

@isTest
public class assignBODCommUsersSchedulable_test {

    // Create test users and contacts
    @testSetup static void createUsers() {
        // Turn off account trigger that looks for association accounts, this test class only has account types of 'other'
        TriggerStatus.setDoNotRunTrigger();        
        Profile bodPortalProfile = [SELECT Id FROM Profile WHERE Name='BOD Community User'];
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];

        // system.runAs to avoid mixed dml operation error
        // need to create Account associated with Contact so Salesforce can assign role to portal user on insert
        System.runAs(thisUser) {
            Account testAccount = new Account(
                Name = 'testAccount',
                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Other').getRecordTypeId());
            insert testAccount;

            List<Contact> testContacts = new List<Contact>();
            for (Integer i = 0; i < 200; i++) {
                testContacts.add(new Contact(
                    Lastname = 'BOD Contact' + i,
                    AccountId = testAccount.Id));
            }
            insert testContacts;

            UserRole testRole = new UserRole(
                DeveloperName = 'testRole',
                Name = 'test Role name'); 
            insert testRole;
            
            List<User> testUsers = new List<User>();
            for (Integer i = 0; i < 200; i++) {
                testUsers.add(new User(
                    Alias='Testa',
                    Email = 'testa@testorg.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'testBOD',
                    LanguageLocaleKey = 'en_US',
                    LocaleSidKey = 'en_US',
                    ProfileId = bodPortalProfile.Id,
                    TimezonesIdKey = 'America/Los_Angeles',
                    Username = 'testa@testorg.com' + i,
                    ContactId = testContacts[i].Id,
                    IsActive = true
                    //UserRoleId = testRole.Id
                ));
            }
            insert testUsers;
        }
    }

    // test that scheduled class is scheduled correctly
    @isTest static void runSchedulable() {

        // Dummy CRON expression: current month on the 15th at midnight, next year
        Integer currentMonth = Date.Today().Month();
        Integer nextYear = System.Today().year() + 1;
        string CRON_EXP = '0 0 0 15 ' + currentMonth + ' ? ' + nextYear;

        Test.startTest();
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new assignBODCommUsersSchedulable());
        CronTrigger cron = [SELECT Id, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        // assert the job has not run
        system.assertEquals(0, cron.TimesTriggered, 'Scheduled job should not fire yet');
        // assert the next time the job will run
        if(currentMonth >= 10){
            system.assertEquals(nextYear + '-' + currentMonth + '-15 00:00:00', String.valueOf(cron.NextFireTime), 'Scheduled job not set to run at correct time.');
        }
        else{
            system.assertEquals(nextYear + '-0' + currentMonth + '-15 00:00:00', String.valueOf(cron.NextFireTime), 'Scheduled job not set to run at correct time.');
        }
        Test.stopTest();
    }

    // test that all BOD community members are added to the public group
    // batch classes executed from a schedulable class are not run in startTest/stopTest context
    // need to call batch class directly
    @isTest static void membersAddedToGroup() {
        Test.startTest();
        assignBODCommUsersBatch b = new assignBODCommUsersBatch();
        Id batchId = database.executebatch(b);
        Test.stopTest();

        // get only test users we created since test methods can see all users
        // get only group members that correspond to test users since test method can see org data
        List<User> testUsers = [SELECT Id FROM User WHERE LastName = 'testBOD'];
        List<GroupMember> usersInGroup = [SELECT Id FROM GroupMember WHERE Group.Name = 'BOD Portal User List View' AND UserOrGroupId IN :testUsers];
        system.assertEquals(testUsers.size(), usersInGroup.size(), 'BOD Community users not accurately added to portal view group. \n' + 
                                                                   'Test users: ' + testUsers.size() + ' Users added to group: ' + usersInGroup.size());
    }

    // test when portal list view group is removed from org, for code coverage
    @isTest static void noPublicGroupInOrg() {
        Group portalGroup = [SELECT Id FROM Group WHERE DeveloperName = 'BOD_Portal_User_List_View' LIMIT 1];
        delete portalGroup;

        Test.startTest();
        assignBODCommUsersBatch b = new assignBODCommUsersBatch();
        Id batchId = database.executebatch(b);
        Test.stopTest();

        List<User> testUsers = [SELECT Id FROM User WHERE LastName = 'testBOD'];
        List<GroupMember> usersInGroup = [SELECT Id FROM GroupMember WHERE Group.Name = 'BOD Portal User List View' AND UserOrGroupId IN :testUsers];
        system.assertEquals(0, usersInGroup.size(), 'Users can\'t be added to a public group that doesn\'t exist.');
    }
}