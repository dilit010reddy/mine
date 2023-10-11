/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
/* @History:
1/26/2021
N. Larkin and P.Sutherland fixed deployment bug hitting validation rule when making Contact w/ BOD 
1/27/2021
N. Larkin and P.Sutherland added createHomeownerAddressFolderTest to test ContactFunctions.CloudStorage_addHomeownerFolders()*/

@isTest(seeAllData=true)
private class ContactTriggerHandler_TC {

    static testMethod void ContactTriggerHandlerTest() {
        TriggerStatus.setDoNotRunTrigger();
        Id associationAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId();
        set<ID> setcon = new set<ID>();
        map<ID,Contact> mapcon = new map<ID,Contact>();
        account acc = new Account(RecordTypeId = associationAccountRecordTypeId, Name = 'Test Association', HG_Self_Managed__c = false, Inactive__c = false, VMS_Company_Key__c = 999);
        insert acc;
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        Test.startTest();
        list<Contact> lstcon = new list<Contact>();
        //Insert with BOD
        Contact c1 = new Contact(accountid = acc.Id, lastname = 'Contact1', firstname = 'Test', Email = 'testContact1@test.com', HasOptedOutOfEmail = false, Active__c = true, Signing_Order__c = '1', BOD_Term__c = Date.today(), Title = 'test', BOD__c = true);
        //Update to BOD
        Contact c2 = new Contact(accountid = acc.Id, lastname = 'Contact2', firstname = 'Test', Email = 'testContact2@test.com', HasOptedOutOfEmail = false, Active__c = true);
        Contact c3 = new Contact(accountid = acc.Id, lastname = 'Contact3', firstname = 'Test', Email = 'testContact3@test.com', HasOptedOutOfEmail = false, Active__c = true);
        Contact c4 = new Contact(accountid = acc.Id, lastname = 'Contact4', firstname = 'Test', Email = 'testContact4@test.com', HasOptedOutOfEmail = false, Active__c = true);
        lstcon.add(c1);
        lstcon.add(c2);
        lstcon.add(c3);
        lstcon.add(c4);
        insert lstcon;
        for(Contact con : lstcon){
            mapcon.put(con.Id,con);
            setcon.add(con.Id);
        }
        ContactTriggerHandler.OnAfterDeleteAsync(setcon);
        ContactTriggerHandler.OnAfterInsertAsync(setcon);
        ContactTriggerHandler.OnAfterUpdateAsync(setcon);
        ContactTriggerHandler ath = new ContactTriggerHandler(true,0);
        Boolean context = ath.IsExecuteAnonymousContext;
        Boolean boo = ath.IsTriggerContext;
        boo = ath.IsVisualforcePageContext;
        boo = ath.IsWebServiceContext;
        ath.OnBeforeDelete(lstcon, mapcon);
        ath.OnAfterDelete(lstcon, mapcon);
        ath.OnUndelete(lstcon, mapcon);
        ath.OnAfterInsert(lstcon, mapcon);
        ath.OnAfterUpdate(lstcon, lstcon, mapcon, mapcon);
        
        c2.BOD__c = TRUE;
        c2.Signing_Order__c = '1';
        c2.BOD_Term__c = Date.today();
        c2.Title = 'test';
        update c2;
        c2.BOD__c = FALSE;
        update c2;
        c2.BOD__c = TRUE;
        update c2;
        c1.Active__c = FALSE;
        update c1;
        delete c4;
        undelete c4;
        Test.stopTest();
    }

    static testMethod void createHomeownerAddressFolderTest() {
     TriggerStatus.setDoNotRunTrigger();
     Contact con = new Contact();
     Id associationAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId();
     account acc = new Account(RecordTypeId = associationAccountRecordTypeId, Name = 'Test Association', HG_Self_Managed__c = false, Inactive__c = false, VMS_Company_Key__c = 999);
     insert acc;
     map<String, Id> contactRecordTypeMap = Utils.getRecordTypes(Contact.SObjectType);
     con.RecordTypeId = contactRecordTypeMap.get('Homeowner');
     con.FirstName = 'First Name Test';
     con.LastName = 'Last Name Test';
     con.AccountId = acc.Id;
     con.VMS_RC_Address__c = 'Test Address';
     test.startTest();
     CloudStorage__mdt meta = DropBoxAPI.getDropboxMeta();
      // create a map to hold responses for testing
      map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
      //Setup request response map for HTTPCalloutMock process
      mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('createitem_success',meta));
      insert con;
      test.stopTest();


    }

}