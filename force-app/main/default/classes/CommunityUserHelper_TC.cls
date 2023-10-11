/*
@Author: N. Larkin, QuantumRhino
@Date: 4/19/2021
@Description: Test Class for Community User Helper_TC

@History:
*/
@isTest(seeAllData=true)
public with sharing class CommunityUserHelper_TC {
    static testMethod void CommunityUserHelper_TC() {
        TriggerStatus.setDoNotRunTrigger();
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        Id associationAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId();
        list<Contact> lstcon = new list<Contact>();
        list<Id> lstconids = new list<Id>();
        account acc = new Account(RecordTypeId = associationAccountRecordTypeId, Name = 'Test Association', HG_Self_Managed__c = false, Inactive__c = false, VMS_Company_Key__c = 999);
        insert acc;
        Contact c2 = new Contact(accountid = acc.Id, lastname = 'Contact2', firstname = 'Test', Email = 'testContact2@test.com', HasOptedOutOfEmail = false, Active__c = true);
        Contact c3 = new Contact(accountid = acc.Id, lastname = 'Contact3', firstname = 'Test', Email = 'testContact3@test.com', HasOptedOutOfEmail = false, Active__c = true);
        Contact dc3 = new Contact(accountid = acc.Id, lastname = 'Contact3', firstname = 'Test', Email = 'testContact3@test.com', HasOptedOutOfEmail = false, Active__c = true);
        lstcon.add(c2);
        lstcon.add(c3);
        lstcon.add(dc3);
        /* lstconids.add(c2.Id);
        lstconids.add(c3.Id);
        lstconids.add(dc3.Id); */
        insert lstcon;
        Test.startTest();
        CommunityUserHelper.communityUserCreator(lstcon);
        /* CommunityUserHelper.communityUserRetire(lstconids); */

        Test.stopTest();

    }
    static testMethod void ContactsToRetire() {
        TriggerStatus.setDoNotRunTrigger();
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        Id associationAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId();
        list<Contact> lstcon = new list<Contact>();
        list<Id> lstconids = new list<Id>();
        account acc = new Account(RecordTypeId = associationAccountRecordTypeId, Name = 'Test Association', HG_Self_Managed__c = false, Inactive__c = false, VMS_Company_Key__c = 999);
        insert acc;
        Contact c2 = new Contact(accountid = acc.Id, lastname = 'Contact2', firstname = 'Test', Email = 'testContact2@test.com', HasOptedOutOfEmail = false, Active__c = true);
        Contact c3 = new Contact(accountid = acc.Id, lastname = 'Contact3', firstname = 'Test', Email = 'testContact3@test.com', HasOptedOutOfEmail = false, Active__c = true);
        Contact dc3 = new Contact(accountid = acc.Id, lastname = 'Contact3', firstname = 'Test', Email = 'testContact3@test.com', HasOptedOutOfEmail = false, Active__c = true);
        lstcon.add(c2);
        lstcon.add(c3);
        lstcon.add(dc3);
        lstconids.add(c2.Id);
        lstconids.add(c3.Id);
        lstconids.add(dc3.Id);
        insert lstcon;
        Test.startTest();
        CommunityUserHelper.communityUserRetire(lstconids);
        Test.stopTest();

    }
}