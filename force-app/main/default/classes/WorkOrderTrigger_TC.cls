/*
@Author: N. Larkin, QuantumRhino
@Date: 9/08/2021
@Description: test class for Work Order Trigger

@History:
*/
@isTest
public class WorkOrderTrigger_TC {
    @isTest
    static void WorkOrder_test1() {
        TriggerStatus.setDoNotRunTrigger();
        //Insert Test User
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        List<User> testUsers = new List<User>();
        testUsers.add(new User(
            FirstName = 'testHelsing12',
            Alias = 'testA',
            Email = 'test2@test.com',
            ProfileId = profile.Id,
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            TimeZoneSidKey='America/Los_Angeles', UserName='testHelsingMeeting1@test.com'
        ));
        insert testUsers;

        //Insert Test Account
        Account acct = new Account(Name = 'Test Account 7', CloudStorage_Filesystem_Path__c = 'Test_Account');
        acct.OwnerId = testUsers[0].Id;
        insert acct;

        //Insert Test Contact
        Contact c2 = new Contact(accountid = acct.Id, lastname = 'Contact2', firstname = 'Test', Email = 'nicholas.larkin@quantumrhino.com', HasOptedOutOfEmail = false, Active__c = true);
        insert c2;
        
        //Insert Test Case
        Case c3 = new Case();
        c3.AccountId = acct.Id;
        c3.Type = 'Work Order';

        //added parameters
        insert c3;

        TriggerStatus.doNotRunTrigger = false;

        WorkOrder w1 = new WorkOrder();
        w1.AccountId = acct.Id;
        w1.ContactId = c2.Id;
        w1.CaseId = c3.Id;
        w1.Vetting_Status__c = 'test Status';
        w1.Vendor_Street_1__c = 'test Street';
        w1.Vendor_State__c = 'AZ';
        w1.Vendor_City__c = 'test City';
        insert w1;


        /*CaseTriggerHelper caseHelper = new CaseTriggerHelper();
        String jobName = 'Send Email on Outside Vendor ' + c3.Id; */
        Test.startTest();
        c3 = [SELECT Id, WorkOrderContactEmailField__c, WorkOrderContactEmail__c FROM Case Where ID = :c3.Id];
        Test.stopTest();

        System.assert(c3.WorkOrderContactEmail__c == 'nicholas.larkin@quantumrhino.com');
        System.assert(c3.WorkOrderContactEmailField__c == 'nicholas.larkin@quantumrhino.com');

    }
}