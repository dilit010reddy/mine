/*
@Author: P. Sutherland and N. Larkin, Admins on Call
@Date: 12-07-2020
@Description:   Class for CloudStorageController testing

@History:
*/
@isTest
public with sharing class CloudStorageController_TC {
    public static Account createtestdata(){
        TriggerStatus.setDoNotRunTrigger();
        Account acct = new Account(Name = 'Test Account', CloudStorage_Filesystem_Path__c = 'Test_Account');
        insert acct;
        return acct;
    }
    public static Case createcasetestdata(Account acct){
        Case testcase = new Case();
        testcase.AccountId = acct.Id;

        insert testcase;
        return testcase;
    }
    static testMethod void testAsAdmin(){
        Account acct = createtestdata();
        String path = 'testpath';
        String recordId = acct.Id; //need another with the id of any obj that is not case or account.
        Test.startTest();
        
        CloudStorageController.Initdata retdata = new CloudStorageController.Initdata();
        retdata = (CloudStorageController.Initdata) CloudStorageController.getinit(recordId, path);

        Test.stopTest();
        System.assert(retdata.isadmin == true);
    }

    static testMethod void testInitialize(){
        Account acct = createtestdata();
        String path = 'testpath';
        String recordId = acct.Id;
        Test.startTest();
        
        CloudStorageController.Initdata retdata = new CloudStorageController.Initdata();
        retdata = (CloudStorageController.Initdata) CloudStorageController.getinit(recordId, path);
        CloudStorageController.initializeFolder(recordId, path);

        Test.stopTest();
        System.assert(retdata.isadmin == true);
    }

    static testMethod void testAsAdminOnCase(){
        Account acct = createtestdata();
        Case testcase = new Case();
        testcase = createcasetestdata(acct);
        String path = 'testpath';
        String recordId = testcase.Id;
        Test.startTest();
        
        CloudStorageController.Initdata retdata = new CloudStorageController.Initdata();
        retdata = (CloudStorageController.Initdata) CloudStorageController.getinit(recordId, path);

        Test.stopTest();
        System.assert(retdata.isadmin == true);
    }

    static testMethod void testAsNotAdmin(){
        Account acct = createtestdata();
        Profile testProfile = [SELECT Id from Profile WHERE Name='Standard User'];
        User testUser = new User(
					Alias='Testa',
					Email='testa@testorg.com',
					EmailEncodingKey='UTF-8',
					LastName='Testerina',
					LanguageLocaleKey='en_US',
					LocaleSidKey='en_US',
					ProfileId=testProfile.Id,
					TimezonesIdKey='America/Los_Angeles',
					Username='testa@testorg.com'
                );
        insert testUser;
        String path = 'testpath';
        String recordId = acct.Id;

        CloudStorageController.Initdata retdata = new CloudStorageController.Initdata();

        Test.startTest();
        System.runAs(testUser) {
        retdata = (CloudStorageController.Initdata) CloudStorageController.getinit(recordId, path);}

        Test.stopTest();

        System.assert(retdata.isadmin == false);
    }

    // This will test the callout mock data w/o making a real callout attempt
    static testMethod void testgetListDirectory() {
        //Start the Testing        
        Account acct = new Account();
        acct = createtestdata();
        Test.startTest();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we activate the Mock Response code.
        mdt.Mock_Response__c = true;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('folderlist_success',mdt));
        // Verify the Callout
        //Setup the input class values.
        CloudStorageController.Entries response = new CloudStorageController.Entries();
        // Execute the Callout
        response = (CloudStorageController.Entries) CloudStorageController.getListDirectory(acct.Id, '/test_root/test_customer', false, null);
        System.assert(response.entries[0].path == '/thg_customers/test_customer/invoices');
        System.assert(response.entries[1].path == '/thg_customers/test_customer/requirements.txt');
        System.assert(response.has_more == true);
        String tmpcursor = response.cursor;
        response = new CloudStorageController.Entries();
        response = (CloudStorageController.Entries) CloudStorageController.getListDirectory(acct.Id, '/test_root/test_customer', false, tmpcursor);
        system.assert(response.entries[0].path == '/thg_customers/test_customer/invoices/1999');
        System.assert(response.entries[1].path == '/thg_customers/test_customer/invoices/1999/requirements.txt');
        Test.stopTest(); 
    }
    //This will test the callout all the way to the DropboxAPI class
    static testMethod void testgetListDirectoryB(){
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('folderlist_success',mdt));
        // Verify the Callout
        CloudStorageController.Entries response = new CloudStorageController.Entries();
        // Execute the Callout
        //Start the Testing
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.Entries) CloudStorageController.getListDirectory(acct.Id, '/', false, null);
        System.assert(response.entries[0].path == '/thg_customers/test_customer/invoices');
        System.assert(response.entries[1].path == '/thg_customers/test_customer/requirements.txt');
        System.assert(response.has_more == true);
        String tmpcursor = response.cursor;
        response = new CloudStorageController.Entries();
        response = (CloudStorageController.Entries) CloudStorageController.getListDirectory(acct.Id, '/test_root/test_customer', false, tmpcursor);
        System.assert(response.entries[0].path == '/thg_customers/test_customer/invoices/1999');
        System.assert(response.entries[1].path == '/thg_customers/test_customer/invoices/1999/requirements.txt');
        System.assert(response.has_more == false);
        Test.stopTest(); 
    }

    static testMethod void testgetListDirectoryFailure(){//failing on the first call
        Test.startTest();
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('folderlist_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.ErrorResponse) CloudStorageController.getListDirectory(acct.Id, '/test_root/test_customer', false, null);
        System.assert(response.error_code == 'folderlist001');
        Test.stopTest(); 
    }

    static testMethod void testgetListDirectoryFailureB(){ //failing from the check 
        Test.startTest();

        Account acct = new Account();
        acct = createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('folderlist_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        //Start the Testing
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

        response = (CloudStorageController.ErrorResponse) CloudStorageController.getListDirectory(acct.Id, '/test_root/test_customer', false, 'cursor');
        System.assert(response.error_code == 'folderlistcontinue001');
        Test.stopTest(); 
    }

    //test get metadata functions
    static testMethod void testgetmetadata() { //test through mock responses
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we activate the Mock Response code.
        mdt.Mock_Response__c = true;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('getmetadata_success',mdt));
        // Verify the Callout
        //Setup the input class values.
        CloudStorageController.Metadata response = new CloudStorageController.Metadata();
        // Execute the Callout
        response = (CloudStorageController.Metadata) CloudStorageController.getmetadata(acct.Id, '/test_root/test_customer/text.txt');
        System.assert(response.path == '/homework/math/prime_numbers.txt');
        Test.stopTest(); 
    } 
    static testMethod void testgetmetadataB(){ //test without mock responses
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('getmetadata_success',mdt));
        // Verify the Callout
        CloudStorageController.Metadata response = new CloudStorageController.Metadata();
        // Execute the Callout
        //Start the Testing
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.Metadata) CloudStorageController.getmetadata(acct.Id, '/test_root/test_customer/text.txt');
        System.assert(response.path == '/homework/math/prime_numbers.txt');
        Test.stopTest(); 
    }    
    static testMethod void testgetmetadatafailure(){
        Test.startTest();
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('getmetadata_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.ErrorResponse) CloudStorageController.getmetadata(acct.Id, '/test_root/test_customer/text.txt');
        System.assert(response.error_code == 'getmetadata001');
        Test.stopTest();
    }
    // test the get link functionality
    static testMethod void testgetlink() { //test with mock responses
        Account acct = new Account();
        acct = createtestdata();
        //Start the Testing
        Test.startTest();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we activate the Mock Response code.
        mdt.Mock_Response__c = true;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('getlink_success',mdt));
        // Verify the Callout
        //Setup the input class values.
        CloudStorageController.Metadata response = new CloudStorageController.Metadata();
        // Execute the Callout
        response = (CloudStorageController.Metadata) CloudStorageController.getlink(acct.Id, '/test_root/test_customer/text.txt');
        System.assert(response.path == '/thg_customers/test_customer/sample.txt');
        Test.stopTest(); 
    } 
    static testMethod void testgetlinkB(){ //test without mock responses
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('getlink_success',mdt));
        // Verify the Callout
        CloudStorageController.Metadata response = new CloudStorageController.Metadata();
        // Execute the Callout
        //Start the Testing
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.Metadata) CloudStorageController.getlink(acct.Id, '/test_root/test_customer/text.txt');
        System.assert(response.path == '/thg_customers/test_customer/sample.txt');
        Test.stopTest(); 
    }    
    static testMethod void testgetlinkfailure(){ //test without mock responses
        Test.startTest();
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('getlink_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.ErrorResponse) CloudStorageController.getlink(acct.Id, '/test_root/test_customer/text.txt');
        System.assert(response.error_code == 'getlink001');
        Test.stopTest(); 
    }
    // test search
    static testMethod void testsearch() { //test with mock responses
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we activate the Mock Response code.
        mdt.Mock_Response__c = true;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('search_success',mdt));
        // Verify the Callout
        //Setup the input class values.
        CloudStorageController.Entries response = new CloudStorageController.Entries();
        // Execute the Callout
        response = (CloudStorageController.Entries) CloudStorageController.searchitem(acct.Id, 'query string', '/test_root/test_customer/text.txt', null);
        String tmpcursor = response.cursor;
        System.assert(response.entries[0].path == '/homework/math/prime_numbers2.txt');
        response = new CloudStorageController.Entries();
        // Execute the Callout
        response = (CloudStorageController.Entries) CloudStorageController.searchitem(acct.Id, 'query string', '/test_root/test_customer/text.txt', tmpcursor);
        System.assert(response.entries[0].path == '/homework/math/prime_numbers.txt');
        Test.stopTest(); 
    } 
    static testMethod void testsearchB(){ //test with mock responses
        Account acct = new Account();
        acct = createtestdata();
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('search_success',mdt));
        // Verify the Callout
        CloudStorageController.Entries response = new CloudStorageController.Entries();
        // Execute the Callout
        //Start the Testing
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.Entries) CloudStorageController.searchitem(acct.Id, 'query string',  '/', null);
        System.assert(response.entries[0].path == '/homework/math/prime_numbers2.txt');
        String tmpcursor = response.cursor;
        response = new CloudStorageController.Entries();
        // Execute the Callout
        response = (CloudStorageController.Entries) CloudStorageController.searchitem(acct.Id, 'query string', '/test_root/test_customer/text.txt', tmpcursor);
        System.assert(response.entries[0].path == '/homework/math/prime_numbers.txt');
        Test.stopTest(); 
    }    
    static testMethod void testsearchfailure(){
        Test.startTest();

        Account acct = new Account();
        acct = createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('search_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.ErrorResponse) CloudStorageController.searchitem(acct.Id, 'test','/test_root/test_customer/text.txt', null);
        System.assert(response.error_code == 'search001');

        response = (CloudStorageController.ErrorResponse) CloudStorageController.searchitem(acct.Id, 'test','/test_root/test_customer/text.txt', 'async_job_id');
        System.assert(response.error_code == 'searchcontinue001');

        Test.stopTest(); 
    }

    static testMethod void testcreateItem(){  // Single File Creation (Blob/file creation type: ‘single’) no async ID 
        //TriggerStatus.setDoNotRunTrigger();
        
        Account acct = new Account();
        acct = createtestdata();
        Test.startTest(); 
        

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('upload_success',mdt));
        // Verify the Callout
        CloudStorageController.Metadata response = new CloudStorageController.Metadata(); 
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses)); 
        
        list<String> inputPaths = new list<String>();  
        inputPaths.add('/test_root/test_customer/text.txt');
        response = (CloudStorageController.Metadata) CloudStorageController.createItem(null,acct.Id, inputPaths, null, 'single', null, EncodingUtil.base64Encode(Blob.valueOf('blob')));
        System.assert(response.display_path == '/THG_Customers/Test_Customer/sample2.xlsx');
        System.assert(response.node_type == 'file');

        Test.stopTest(); 
    }

    static testMethod void testcreateItemB(){  //Folder Creation no async ID 
        Account acct = new Account();
        acct = createtestdata();

        Test.startTest(); 

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('createitem_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        list<String> inputPaths = new list<String>{'/test_root/test_customer'};
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.createItem(null,acct.Id, inputPaths, null, null, 0, null); //would need to add conditional for upload endpoint
        
        System.assert(response.status == 'async_job_id');
        System.assert(response.success == true);

        Test.stopTest(); 
    }

    static testMethod void testcreateItemC(){  // Single Folder Creation (no Blob/file creation type: ‘null’) with async ID 
        Account acct = new Account();
        acct = createtestdata();

        Test.startTest(); 

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('createitem_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        list<String> inputPaths = new list<String>{'/test_root/test_customer'};
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.createItem(null,acct.Id, inputPaths, 'async ID', null, 0, null); //would need to add conditional for upload endpoint
        
        System.assert(response.status == 'complete');
        System.assert(response.completionList.size() == 5);

        Test.stopTest(); 
    }

    static testMethod void testcreateItemD(){ //testing start upload session
        Account acct = new Account();
        acct = createtestdata();
        
        Test.startTest(); 
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('upload_session_start_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete(); //changed from resposetomovedelete
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses)); 
        list<String> inputPaths = new list<String>();  ///thg_customers/test_customer/invoices/1999/requirements.txt
        inputPaths.add('/test_root/test_customer/text.txt');
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.createItem(null,acct.Id, inputPaths, null, 'start', null, EncodingUtil.base64Encode(Blob.valueOf('blob')));
        
        System.assert(response.async_job_id != null);
        System.assert(response.status == 'start');

        Test.stopTest(); 
    }

    static testMethod void testcreateItemE(){ //testing upload session append
        Account acct = new Account();
        acct = createtestdata();
        
        Test.startTest(); 
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('upload_session_append',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete(); //changed from resposetomovedelete
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses)); 
        list<String> inputPaths = new list<String>();  ///thg_customers/test_customer/invoices/1999/requirements.txt
        inputPaths.add('/test_root/test_customer/text.txt');
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.createItem(null,acct.Id, inputPaths, 'async', 'append', null, EncodingUtil.base64Encode(Blob.valueOf('blob')));
      
        System.assert(response.async_job_id != null);
        System.assert(response.status == 'append');

        Test.stopTest(); 
    }

    static testMethod void testcreateItemF(){ //testing upload session finish
        Account acct = new Account();
        acct = createtestdata();
        
        Test.startTest(); 
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('upload_session_finish',mdt));
        // Verify the Callout
        CloudStorageController.Metadata response = new CloudStorageController.Metadata(); //changed from resposetomovedelete
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses)); 
        list<String> inputPaths = new list<String>();  ///thg_customers/test_customer/invoices/1999/requirements.txt
        inputPaths.add('/test_root/test_customer/text.txt');
        response = (CloudStorageController.Metadata) CloudStorageController.createItem(null, acct.Id, inputPaths, '1234faaf0678bcde', 'finish', 0, EncodingUtil.base64Encode(Blob.valueOf('blob'))); 
        
        System.assert(response.id != null);
        System.assert(response.display_path == '/Homework/math/Prime_Numbers.txt');

        Test.stopTest(); 
    }

    static testMethod void testcreateItemFailure(){ //bad create item error_code : createitem001
        Test.startTest(); 
        
        Account acct = new Account();
        acct = createtestdata();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('createitem_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        list<String> inputPaths = new list<String>{'/test_root/test_customer/text.txt'};
        response = (CloudStorageController.ErrorResponse) CloudStorageController.createItem(null, acct.Id, inputPaths,'async id', 'start', 0, null);
        
        System.assert(response.error_code == 'createitem001');

        Test.stopTest();  
    }

    static testMethod void testcreateItemFailure2(){  // input type is null error_code : UploadSession001
        Account acct = new Account();
        acct = createtestdata();
        
        Test.startTest(); 
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('upload_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse(); //changed from resposetomovedelete
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses)); 
        list<String> inputPaths = new list<String>();  ///thg_customers/test_customer/invoices/1999/requirements.txt
        inputPaths.add('/test_root/test_customer/text.txt');
        response = (CloudStorageController.ErrorResponse) CloudStorageController.createItem(null, acct.Id, inputPaths, null, null, null, EncodingUtil.base64Encode(Blob.valueOf('blob')));
        
        System.assert(response.error_code == 'UploadSession001');

        Test.stopTest(); 
    }

    static testMethod void testdeleteItem(){ //test without mock responses
        Account acct = new Account();
        acct = createtestdata();

        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        list<String> items = new list<String>();
        items.add('delete string');
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('deleteitem_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.deleteItems(acct.Id, items, null);

        System.assert(response.status == 'async_job_id');
        System.assert(response.success == true);
        
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.deleteItems(acct.Id, items, 'async_job_id');

        System.assert(response.status == 'complete');
        System.assert(response.success == true);

        Test.stopTest(); 
    }

    static testMethod void testdeleteItemB(){ //test with mock responses
        Account acct = new Account();
        acct = createtestdata();

        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        list<String> items = new list<String>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = true;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('deleteitem_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.deleteItems(acct.Id, items, null);

        System.assert(response.status == 'async_job_id');
        System.assert(response.success == true);
        
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.deleteItems(acct.Id, items, 'async_job_id');

        System.assert(response.status == 'complete');
        System.assert(response.success == true);

        Test.stopTest(); 
    }

    static testMethod void testdeleteItemFailure(){
        Test.startTest();

        Account acct = new Account();
        acct = createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        list<String> items = new list<String>();
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('deleteitem_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.ErrorResponse) CloudStorageController.deleteItems(acct.Id, items, null);
        System.assert(response.error_code == 'deletebatch001');

        response = (CloudStorageController.ErrorResponse) CloudStorageController.deleteItems(acct.Id, items, 'async_job_id');
        System.assert(response.error_code == 'deletebatchcheck001');
        Test.stopTest(); 
    }
    
        static testMethod void testmoveitems(){ //testing for successful completion of DBmoveitems() //test without mock responses
        Account acct = new Account();
        acct = createtestdata();

        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        CloudStorageController.Moves inputmoves = new CloudStorageController.Moves();
        CloudStorageController.Move inputmove = new CloudStorageController.Move();
        inputmove.dest = 'testpath/path2';
        inputmove.src = 'testpath/path';
        inputmoves.moves.add(inputmove);
        String inputjson = JSON.serialize(inputmoves);

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('moveitems_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.moveItems(acct.Id, inputjson, null);
        
        System.assert(response.success == true);
        System.assert(response.status == 'async_job_id');

        String async_job_id = response.async_job_id;
        response = new CloudStorageController.Responsetomovedelete();
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.moveItems(acct.Id, inputjson, async_job_id);

        System.assert(response.completionList.size() == 3);
        System.assert(response.status == 'complete');
        

        Test.stopTest(); 
    }

    static testMethod void testmoveitemsB(){ //testing the mock responses 
        Account acct = new Account();
        acct = createtestdata();

        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        CloudStorageController.Moves inputmoves = new CloudStorageController.Moves();
        CloudStorageController.Move inputmove = new CloudStorageController.Move();
        inputmove.dest = 'testpath/path2';
        inputmove.src = 'testpath/path';
        inputmoves.moves.add(inputmove);
        String inputjson = JSON.serialize(inputmoves);

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = true;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('moveitems_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.moveItems(acct.Id, inputjson, null);
        
        System.assert(response.success == true);
        System.assert(response.status == 'async_job_id');

        String async_job_id = response.async_job_id;
        response = new CloudStorageController.Responsetomovedelete();
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.moveItems(acct.Id, inputjson, async_job_id);

        System.assert(response.completionList.size() == 3);
        System.assert(response.status == 'complete');
        

        Test.stopTest();  
    }

    static testMethod void testmoveitemsFailure(){
        Test.startTest();

        Account acct = new Account();
        acct = createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        //instansiate the inputjson with a MOVE in its moves.
        //CloudStorageController.Moves inputjson = new CloudStorageController.Moves();
        CloudStorageController.Moves inputmoves = new CloudStorageController.Moves();
        CloudStorageController.Move inputmove = new CloudStorageController.Move();
        inputmove.dest = 'testpath/path2';
        inputmove.src = 'testpath/path';
        inputmoves.moves.add(inputmove);
        String inputjson = JSON.serialize(inputmoves);
        //inputjson.moves.add(new CloudStorageController.Move());
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('moveitems_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
        response = (CloudStorageController.ErrorResponse) CloudStorageController.moveItems(acct.Id, inputjson, null);

        System.assert(response.error_code == 'movebatch001');

        response = (CloudStorageController.ErrorResponse) CloudStorageController.moveItems(acct.Id, inputjson, 'async_job_id');

        System.assert(response.error_code == 'movebatchcheck001');

        Test.stopTest(); 
    }

    static testMethod void testmodifyitems(){ //test without mock responses
        Account acct = new Account();
        acct = createtestdata();

        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        //CloudStorageController.Moves inputjson = new CloudStorageController.Moves();
        CloudStorageController.Moves inputmoves = new CloudStorageController.Moves();
        CloudStorageController.Move inputmove = new CloudStorageController.Move();
        inputmove.dest = 'testpath/path2';
        inputmove.src = 'testpath/path';
        inputmoves.moves.add(inputmove);
        String inputjson = JSON.serialize(inputmoves);
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('modifyitems_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.modifyItems(acct.Id, inputjson, null);
    
        System.assert(response.success == true);
        System.assert(response.status == 'async_job_id');

        String async_job_id = response.async_job_id;
        response = new CloudStorageController.Responsetomovedelete();
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.modifyItems(acct.Id, inputjson, async_job_id);

        System.assert(response.success == true);
        System.assert(response.status == 'complete');

        Test.stopTest(); 
    }

    static testMethod void testmodifyitemsB(){ //test with mock responses
        Account acct = new Account();
        acct = createtestdata();

        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        //CloudStorageController.Moves inputjson = new CloudStorageController.Moves();
        CloudStorageController.Moves inputmoves = new CloudStorageController.Moves();
        CloudStorageController.Move inputmove = new CloudStorageController.Move();
        inputmove.dest = 'testpath/path2';
        inputmove.src = 'testpath/path';
        inputmoves.moves.add(inputmove);
        String inputjson = JSON.serialize(inputmoves);
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = true;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('modifyitems_success',mdt));
        // Verify the Callout
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.modifyItems(acct.Id, inputjson, null);
    
        System.assert(response.success == true);
        System.assert(response.status == 'async_job_id');

        String async_job_id = response.async_job_id;
        response = new CloudStorageController.Responsetomovedelete();
        response = (CloudStorageController.Responsetomovedelete) CloudStorageController.modifyItems(acct.Id, inputjson, async_job_id);

        System.assert(response.success == true);
        System.assert(response.status == 'complete');


        Test.stopTest(); 
    }

    static testMethod void testmodifyitemsFailure(){
        Test.startTest();

        Account acct = new Account();
        acct = createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        //instansiate the inputjson with a MOVE in its moves.
        //CloudStorageController.Moves inputjson = new CloudStorageController.Moves();
        CloudStorageController.Moves inputmoves = new CloudStorageController.Moves();
        CloudStorageController.Move inputmove = new CloudStorageController.Move();
        inputmove.dest = 'testpath/path2';
        inputmove.src = 'testpath/path';
        inputmoves.moves.add(inputmove);
        String inputjson = JSON.serialize(inputmoves);
        //inputjson.moves.add(new CloudStorageController.Move());
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        //test if we de-activate the Mock Response code.
        mdt.Mock_Response__c = false;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        //Setup request response map for HTTPCalloutMock process
        mockresponses.putAll(CloudStorageMockResponseGenerator.CloudStorageMockResponseGen('modifyitems_success',mdt));
        // Verify the Callout
        CloudStorageController.ErrorResponse response = new CloudStorageController.ErrorResponse();
        // Execute the Callout
        Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

        response = (CloudStorageController.ErrorResponse) CloudStorageController.modifyItems(acct.Id, inputjson, null);

        System.assert(response.error_code == 'movebatch001');

        response = (CloudStorageController.ErrorResponse) CloudStorageController.modifyItems(acct.Id, inputjson, 'async_job_id');

        System.assert(response.error_code == 'movebatchcheck001');


        Test.stopTest(); 
    }

    static testMethod void testConstructors(){
        Test.startTest();
        list<CloudStorageController.StatusObj> completionList = new list<CloudStorageController.StatusObj>();
        CloudStorageController.Responsetomovedelete constructedtrtmd = new CloudStorageController.Responsetomovedelete(true, 'async id', '200', completionList);

        list<CloudStorageController.Entry> entries = new list<CloudStorageController.Entry>();
        CloudStorageController.Entries constructedEntries = new CloudStorageController.Entries('cursor', true, entries);

        CloudStorageMiddleware.CloudStorageMiddlewareinput constructedInput = new CloudStorageMiddleware.CloudStorageMiddlewareinput();

        CloudStorageController.Move constructedMove = new CloudStorageController.Move('src', 'dest');

        CloudStorageController.StatusObj constructedStatusObj = new CloudStorageController.StatusObj();


        Test.stopTest(); 
    }

    static testMethod void testMissingMetadata(){
            //Start the Testing
            Test.startTest();
        
            
            // Create the response object.
            CloudStorageController.ErrorResponse eResponse = new CloudStorageController.ErrorResponse();
            CloudStorageMiddleware.CloudStorageMiddlewareinput input = new CloudStorageMiddleware.CloudStorageMiddlewareinput();
            input.method_name = 'test';
            list<String> inputPaths = new list<String>{'test/path'};
            input.inputparms = new CloudStoragecreateiteminput('id', inputPaths, null, 'single', 0, null);
            //inputparms.path = 'test/path';
            CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
            eResponse = (CloudStorageController.ErrorResponse) CloudStorageMiddleware.execDropBoxAPIcallout(mdt, input);     
            System.assert(eResponse.error_code == 'Callout001');

            mdt.Connected_App__c = 'other';
            CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
            eResponse = (CloudStorageController.ErrorResponse) CloudStorageMiddleware.getCloudStorageRequest(input);

            System.assert(eResponse.error_code == 'Metadata002');

            CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);
            eResponse = (CloudStorageController.ErrorResponse) CloudStorageMiddleware.getCloudStorageRequest(input);

            System.assert(eResponse.error_code == 'Metadata001');

            String filetype = CloudStorageMiddleware.getfiletypeinfo('input', 'xtag');
            System.assert(filetype == 'doctype:unknown');
        
            Test.stopTest(); 
        
        
    }
}