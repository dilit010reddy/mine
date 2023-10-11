/*
@Author: Vince Boyle
@Date: 07-08-2021
@Description: Test class for ContactEmails methods and checkIfContactInfoChanged() method from ContactFunctions

@History: 07-27-2021 turned off update functionality for now, removed assert statements so test classes still pass
*/

@isTest
private class ContactEmails_TC {
    @testSetup static void createTestData() {
        // Turn off Account trigger
        TriggerStatus.setDoNotRunTrigger();

        List<Account> testAccounts = new List<Account>();
        testAccounts.add(new Account(
            Name = 'testAccount1',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Other').getRecordTypeId()
        ));
        insert testAccounts;

        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(
            FirstName = 'Loki',
            LastName = 'Throg',
            recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Homeowner').getRecordTypeId(),
            Email = 'test1@test.com',
            VMS_RC_Address__c = '123 Test St',
            AccountId = testAccounts[0].Id,
            VMS_Resident_Key__c = '1111',
            Active__c = true
        ));
        insert testContacts;
    }

    // Change email field to test code where email should be sent to both email addresses
    @isTest static void testEmailSent() {
        Contact testContact = [SELECT Id, Email FROM Contact WHERE FirstName = 'Loki' LIMIT 1];
        testContact.Email = 'test2@test.com';

        test.startTest();
        update testContact;
        Integer emailInvocations = Limits.getEmailInvocations();
        test.stopTest();

        system.assertEquals(1, emailInvocations, 'Email not sent when contact info was updated on Contact');
    }

    // Test email not sent when irrelevant fields are changed
    @isTest static void testEmailNotSent() {
        Contact testContact = [SELECT Id, VMS_Resident_Key__c FROM Contact WHERE FirstName = 'Loki' LIMIT 1];
        testContact.VMS_Resident_Key__c = '2222';

        test.startTest();
        update testContact;
        Integer emailInvocations = Limits.getEmailInvocations();
        test.stopTest();

        system.assertEquals(0, emailInvocations, 'Email should not have been sent when irrelevant fields are changed on Contact.');
    }
}