/*
@Author: N. Larkin, QuantumRhino
@Date: 3/15/2021
@Description: Testing the queable DB folder initialization. 

@History:
*/
@isTest //(SeeAllData=true)
public class AccountTriggerHandler_TC {
    
    static testMethod void testAccountInitialization() {
    
    //Start the Testing
    Test.startTest();
    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();    
    map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
    //test if we de-activate the Mock Response code.
    mdt.Mock_Response__c = false;
    CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
    //Setup request response map for HTTPCalloutMock process
    mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('createitem_success',mdt));
    mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('folderlist_success',mdt));
    // Verify the Callout
    CloudStorageController.Metadata response = new CloudStorageController.Metadata();
    // Execute the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses)); 
    
    Account testAccount = new Account();
    testAccount.Name = 'testName';
    Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Association').getRecordTypeId(); 
    testAccount.RecordTypeId = devRecordTypeId;
    testAccount.VMS_Company_Key__c = 1;
    /* system.debug('test account inserted: ' + testAccount);
    system.debug('devRecordTypeId: ' + devRecordTypeId); */
    insert testAccount;
    

    Test.stopTest();
    }
}