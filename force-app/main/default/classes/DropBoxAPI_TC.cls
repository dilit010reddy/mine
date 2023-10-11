/*
@Author: P. Sutherland and N. Larkin, Admins on Call
@Date: 11-25-2020
@Description:   Class for Dropbox API testing

@History:
*/
@isTest
public with sharing class DropBoxAPI_TC {

static testMethod void testdeletebatchSuccess() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_DELETE_BATCH(), dbapi.getDROP_BOX_DELETE_BATCH(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdeletebatchinput inputparms = new DBAPIdeletebatchinput();
    inputparms.entries.add(new DBAPIdeletebatchinput.Entries('test/path', ''));

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatch(inputparms);

    // to do add meaningful asserts
    DBAPIdeletebatch respobj = new DBAPIdeletebatch();
    respobj = (DBAPIdeletebatch) response.response;

    //meaningful asserts
    System.assert(respobj.entries.size() == 2);
    System.assert(respobj.async_job_id != null);

    Test.stopTest(); 
}

static testMethod void testdeletebatchFail1() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_DELETE_BATCH(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdeletebatchinput inputparms = new DBAPIdeletebatchinput();
    inputparms.entries.add(new DBAPIdeletebatchinput.Entries('test/path', ''));

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatch(inputparms);

    //meaningful asserts
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');

    Test.stopTest(); 
}

static testMethod void testdeletebatchFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_DELETE_BATCH(), 201, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdeletebatchinput inputparms = new DBAPIdeletebatchinput();
    inputparms.entries.add(new DBAPIdeletebatchinput.Entries('test/path', ''));

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatch(inputparms);

    //meaningful asserts
    System.assert(response.error_message == 'path/conflict/folder/..');

    Test.stopTest(); 
}

static testMethod void testdeletebatchFail3() {  //forcing 500
        
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_DELETE_BATCH(), dbapi.getDROP_BOX_DELETE_BATCH(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdeletebatchinput inputparms = new DBAPIdeletebatchinput();
    inputparms.entries.add(new DBAPIdeletebatchinput.Entries('test/path', ''));

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatch(inputparms);

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest(); 
}

static testMethod void testdeletebatchFail4() { //metadata error
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_DELETE_BATCH(), dbapi.getDROP_BOX_DELETE_BATCH(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //clear cloud storage
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIdeletebatchinput inputparms = new DBAPIdeletebatchinput();
    inputparms.entries.add(new DBAPIdeletebatchinput.Entries('test/path', ''));

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatch(inputparms);

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');

    Test.stopTest(); 
}

static testMethod void testdeletebatchcheckSuccess() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdeletebatchcheckinput inputparms = new DBAPIdeletebatchcheckinput();
    inputparms.async_job_id = 'test id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatchcheck(inputparms); 
    DBAPIdeletebatch respobj = new DBAPIdeletebatch();
    respobj = (DBAPIdeletebatch) response.response;

    //meaningful asserts
    System.assert(respobj.entries[0].metadata.path_lower == '/homework/math/prime_numbers.txt');
    System.assert(respobj.x_tag == 'complete');

    Test.stopTest(); 
}

static testMethod void testdeletebatchcheckFail1() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdeletebatchcheckinput inputparms = new DBAPIdeletebatchcheckinput();
    inputparms.async_job_id = 'test id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatchcheck(inputparms); 

    //meaningful asserts
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');

    Test.stopTest(); 
}

static testMethod void testdeletebatchcheckFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), 201, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    
    //Setup the input class values.
    DBAPIdeletebatchcheckinput inputparms = new DBAPIdeletebatchcheckinput();
    inputparms.async_job_id = 'test id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatchcheck(inputparms); 

    //meaningful asserts
    System.assert(response.error_message == 'path/conflict/folder/..');

    Test.stopTest(); 
}

static testMethod void testdeletebatchcheckFail3() { //forces 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdeletebatchcheckinput inputparms = new DBAPIdeletebatchcheckinput();
    inputparms.async_job_id = 'test id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatchcheck(inputparms); 

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest(); 
}
    
static testMethod void testdeletebatchcheckFail4() { //checks metadata error
        //Start the Testing
        Test.startTest();
    
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIdeletebatchcheckinput inputparms = new DBAPIdeletebatchcheckinput();
    inputparms.async_job_id = 'test id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdeletebatchcheck(inputparms); 

    //asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');

    Test.stopTest(); 
}
static testMethod void testgetlistfolderSuccess() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER(), dbapi.getDROP_BOX_LIST_FOLDER(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIlistfolderinput input = new DBAPIlistfolderinput();
    input.path = '/test_root/test_customer';
    input.recursive = true;
    input.limit_Z = 1000;

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfolder(input);
    DBAPIlistfolder respobj = new DBAPIlistfolder();
    respobj = (DBAPIlistfolder) response.response;

    //meaningful asserts
    System.assert(respobj != null);
    System.assert(respobj.entries[0].path_lower == '/thg_customers/test_customer/invoices');
    System.assert(respobj.entries[1].path_lower == '/thg_customers/test_customer/requirements.txt');
    System.assert(respobj.has_more == true);
    
    Test.stopTest(); 
}
    // test a 400 failure in the first callout
static testMethod void testgetlistfolderFail1() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_LIST_FOLDER(), 400, 'Bad Request'));
    
    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIlistfolderinput input = new DBAPIlistfolderinput();
    input.path = '/test_root/test_customer';
    input.recursive = true;
    input.limit_Z = 1000;

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfolder(input);

    //meaningful asserts
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');
    System.assert(response.response != null);

    Test.stopTest(); 
}

    // test a Dropbox failure in the first callout
static testMethod void testgetlistfolderFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_LIST_FOLDER(), 201, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIlistfolderinput input = new DBAPIlistfolderinput();
    input.path = '/test_root/test_customer';
    input.recursive = true;
    input.limit_Z = 1000;

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfolder(input);
    DBAPIlistfolder respobj = new DBAPIlistfolder();
    respobj = (DBAPIlistfolder) response.response;

    //meaningful asserts
    System.assert(respobj.entries.size() == 0);
    System.assert(response.error_message == 'path/conflict/folder/..');

    Test.stopTest(); 
}

static testMethod void testgetlistfolderFail3() { //fails to 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER(), dbapi.getDROP_BOX_LIST_FOLDER(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIlistfolderinput input = new DBAPIlistfolderinput();
    input.path = '/test_root/test_customer';
    input.recursive = true;
    input.limit_Z = 1000;

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfolder(input);

    //meaningful asserts
    System.assert(response.response != null);
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest(); 
}

static testMethod void testgetlistfolderFail4() { // fails due to cleared metadata #316
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER(), dbapi.getDROP_BOX_LIST_FOLDER(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIlistfolderinput input = new DBAPIlistfolderinput();
    input.path = '/test_root/test_customer';
    input.recursive = true;
    input.limit_Z = 1000;

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfolder(input);

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');
    
    Test.stopTest(); 
}

static testMethod void testgetlistfolderFail5() { //tests 401 in try send
    //Start the Testing
    Test.startTest();
    
    // create a map to hold responses for testing
    map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    DropBoxAPI dbapi = new DropboxAPI();

//Setup request response map for HTTPCalloutMock
mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_LIST_FOLDER(), 401, 'Bad Request'));

// Verify the Callout
Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

//Setup the input class values.
DBAPIlistfolderinput input = new DBAPIlistfolderinput();
input.path = '/test_root/test_customer';
input.recursive = true;
input.limit_Z = 1000;

// Create the response object.
CloudStorageUIResponse response = new CloudStorageUIResponse();

// Execute the Callout
response = DropboxAPI.postlistfolder(input);

//meaningful asserts
System.debug('Actual Message: ' + response.error_message);
System.assert(response.error_message == 'SFDC Details: An unexpected error occurred when trying to make a callout to the DropBox API. Metadata cannot be deployed from within a test');
System.assert(response.response != null);

Test.stopTest(); 
}

static testMethod void testgetlistfoldercheckSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIlistfoldercontinput input = new DBAPIlistfoldercontinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfoldercontinue(input);
    DBAPIlistfolder respobj = new DBAPIlistfolder();
    respobj = (DBAPIlistfolder) response.response;
    
    //meaningful asserts
    System.assert(respobj != null);
    System.assert(respobj.entries[0].path_lower == '/thg_customers/test_customer/invoices/1999');
    System.assert(respobj.entries[1].path_lower == '/thg_customers/test_customer/invoices/1999/requirements.txt');
    System.assert(respobj.has_more == false);

    Test.stopTest(); 
}

static testMethod void testgetlistfoldercheckFail1() { 
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIlistfoldercontinput input = new DBAPIlistfoldercontinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfoldercontinue(input);

    //meaningful asserts
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');
    Test.stopTest(); 
}

static testMethod void testgetlistfoldercheckFail2() {  //checkfail2
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), 201, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIlistfoldercontinput input = new DBAPIlistfoldercontinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfoldercontinue(input);
    DBAPIlistfolder respobj = new DBAPIlistfolder();
    respobj = (DBAPIlistfolder) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'path/conflict/folder/..');

    
    Test.stopTest(); 
}

static testMethod void testgetlistfoldercheckFail3() { //fails to 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIlistfoldercontinput input = new DBAPIlistfoldercontinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfoldercontinue(input);

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest(); 
}

static testMethod void testgetlistfoldercheckFail4() { // fails due to cleared metadata #316
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIlistfoldercontinput input = new DBAPIlistfoldercontinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postlistfoldercontinue(input);

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');
    
    Test.stopTest(); 
}

static testMethod void testcreatefolderbatchcheckSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderbatchcheckinput input = new DBAPIcreatefolderbatchcheckinput();
    input.async_job_id = 'test async job id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatchcheck(input);
    DBAPIcreatefolderbatch respobj = new DBAPIcreatefolderbatch();
    respobj = (DBAPIcreatefolderbatch) response.response;

    //meaningful asserts
    System.assert(respobj.async_job_id == null);
    System.assert(respobj.entries.size() == 5);
    //System.assert(respobj.x_tag == 'complete');
    //System.assert(respobj.entries[0].metadata.path_lower == '/thg_customers/test_customer2');
    //System.assert(respobj.entries[1].metadata.path_lower == '/thg_customers/test_customer2/invoices');

    Test.stopTest(); 
}

static testMethod void testcreatefolderbatchcheckFail1() { 
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderbatchcheckinput input = new DBAPIcreatefolderbatchcheckinput();
    input.async_job_id = 'test async job id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatchcheck(input);

    //meaningful asserts
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');
    Test.stopTest(); 
}

static testMethod void testcreatefolderbatchcheckFail2() {  //checkfail2
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), 201, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderbatchcheckinput input = new DBAPIcreatefolderbatchcheckinput();
    input.async_job_id = 'test async job id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatchcheck(input);
    DBAPIcreatefolderbatch respobj = new DBAPIcreatefolderbatch();
    respobj = (DBAPIcreatefolderbatch) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'path/conflict/folder/..');


    Test.stopTest(); 
}

static testMethod void testcreatefolderbatchcheckFail3() { //fails to 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderbatchcheckinput input = new DBAPIcreatefolderbatchcheckinput();
    input.async_job_id = 'test async job id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatchcheck(input);

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest(); 
}

static testMethod void testcreatefolderbatchcheckFail4() { // fails due to cleared metadata #316
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIcreatefolderbatchcheckinput input = new DBAPIcreatefolderbatchcheckinput();
    input.async_job_id = 'test async job id';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatchcheck(input);

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');

    Test.stopTest(); 
}
    
/*static testMethod void testcreatefolderSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
        
        
        
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_V2(), dbapi.getDROP_BOX_CREATE_FOLDER_V2(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderinput inputparms = new DBAPIcreatefolderinput();
    inputparms.path = '/test_root/test_folder';
    System.assert(inputparms.path == '/test_root/test_folder');
    System.assert(inputparms.autorename == null);

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolder(inputparms);
    DBAPIcreatefolder respobj = new DBAPIcreatefolder();
    respobj = (DBAPIcreatefolder) response.response;

    //meaningful asserts
    System.assert(response != null);
    System.assert(respobj != null);
    System.assert(respobj.metadata.path_lower == '/thg_customers');
    System.assert(respobj.metadata.name == 'THG_Customers');

    Test.stopTest(); 
}

static testMethod void testcreatefolderFail1() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
        
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_CREATE_FOLDER_V2(), 201, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderinput inputparms = new DBAPIcreatefolderinput();
    inputparms.path = '/test_root/test_folder';
    System.assert(inputparms.path == '/test_root/test_folder');
    System.assert(inputparms.autorename == null);

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolder(inputparms);
    DBAPIcreatefolder respobj = new DBAPIcreatefolder();
    respobj = (DBAPIcreatefolder) response.response;

    //meaningful asserts
    System.debug('respobj in foldercreationfail =' + respobj);
    System.assert(respobj != null);
    System.assert(response.error_message != 'This is an error that is not trapped by http response code');
    System.assert(response.response != null);

    Test.stopTest(); 
}

static testMethod void testcreatefolderFail2() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
        
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_CREATE_FOLDER_V2(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderinput inputparms = new DBAPIcreatefolderinput();
    inputparms.path = '/test_root/test_folder';
    System.assert(inputparms.path == '/test_root/test_folder');
    System.assert(inputparms.autorename == null);

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolder(inputparms);
    DBAPIcreatefolder respobj = new DBAPIcreatefolder();
    respobj = (DBAPIcreatefolder) response.response;

    //meaningful asserts
    System.debug('respobj in foldercreationfail =' + respobj);
    System.assert(respobj != null);
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');
    System.assert(response.response != null);

    Test.stopTest(); 
}*/

static testMethod void testuploadSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
        
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD(), dbapi.getDROP_BOX_UPLOAD(), 200, 'Ok', null));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    CloudStoragecreateiteminput cloudInput = new CloudStoragecreateiteminput();
    cloudInput.data = Blob.valueof('data in CloudInput');
    DBAPIuploadinput inputparms = new DBAPIuploadinput();
    inputparms.path = '/test_root/test_upload.txt';
    System.assert(inputparms.path == '/test_root/test_upload.txt');
    System.assert(inputparms.autorename == null);

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postupload(inputparms, cloudInput.data);
    DBAPIupload respobj = new DBAPIupload();
    respobj = (DBAPIupload) response.response;

    //meaningful asserts
    System.assert(respobj != null);
    System.assert(response.error_message != 'This is an error that is not trapped by http response code');
    System.assert(response.response != null);
    System.assert(respobj.path_lower == '/thg_customers/test_customer/sample2.xlsx');

    Test.stopTest(); 
}

static testMethod void testuploadFail1() { // causing the 500 error
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
        
        //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_UPLOAD(), 201, 'Ok', null));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    CloudStoragecreateiteminput cloudInput = new CloudStoragecreateiteminput();
    cloudInput.data = Blob.valueof('data in CloudInput');
    DBAPIuploadinput inputparms = new DBAPIuploadinput();
    inputparms.path = '/test_root/test_upload.txt';
    System.assert(inputparms.path == '/test_root/test_upload.txt');
    System.assert(inputparms.autorename == null);

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postupload(inputparms, cloudInput.data); 
    DBAPIupload respobj = new DBAPIupload();
    respobj = (DBAPIupload) response.response;

    //meaningful asserts
    System.assert(respobj != null);
    System.assert(response.error_message != 'This is an error that is not trapped by http response code');
    System.assert(response.response != null);

    Test.stopTest(); 
}

static testMethod void testuploadFail2() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
        
        
        
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_UPLOAD(), 400, 'Bad Request', null));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    CloudStoragecreateiteminput cloudInput = new CloudStoragecreateiteminput();
    cloudInput.data = Blob.valueof('data in CloudInput');
    DBAPIuploadinput inputparms = new DBAPIuploadinput();
    inputparms.path = '/test_root/test_upload.txt';
    System.assert(inputparms.path == '/test_root/test_upload.txt');
    System.assert(inputparms.autorename == null);

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postupload(inputparms, cloudInput.data);
    DBAPIupload respobj = new DBAPIupload();
    respobj = (DBAPIupload) response.response;

    //meaningful asserts
    System.assert(respobj != null);
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');
    System.assert(response.response != null);

    Test.stopTest(); 
}

static testMethod void testuploadFail3() { // tests 500 error
    //Start the Testing
    Test.startTest();
    Account acct = new Account();
    acct = CloudStorageController_TC.createtestdata();


    // create a map to hold responses for testing
    map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    DropBoxAPI dbapi = new DropboxAPI();
    
//Setup request response map for HTTPCalloutMock
mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD(), dbapi.getDROP_BOX_UPLOAD(), 200, 'Ok', null));

// Verify the Callout
Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

//Setup the input class values.
CloudStoragecreateiteminput cloudInput = new CloudStoragecreateiteminput();
cloudInput.data = Blob.valueof('data in CloudInput');
DBAPIuploadinput inputparms = new DBAPIuploadinput();
inputparms.path = '/test_root/test_upload.txt';
System.assert(inputparms.path == '/test_root/test_upload.txt');
System.assert(inputparms.autorename == null);

// Create the response object.
CloudStorageUIResponse response = new CloudStorageUIResponse();

// Execute the Callout
response = DropboxAPI.postupload(inputparms, cloudInput.data);

//meaningful asserts
System.assert(response.error_message.contains('SFDC Details:'));

Test.stopTest(); 
}

static testMethod void testuploadFail4() { 
    //Start the Testing
    Test.startTest();

    // create a map to hold responses for testing
    map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    DropBoxAPI dbapi = new DropboxAPI();
    
//Setup request response map for HTTPCalloutMock
mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD(), dbapi.getDROP_BOX_UPLOAD(), 200, 'Ok', null));

// Verify the Callout
Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

//Setup the input class values.
CloudStoragecreateiteminput cloudInput = new CloudStoragecreateiteminput();
cloudInput.data = Blob.valueof('data in CloudInput');
DBAPIuploadinput inputparms = new DBAPIuploadinput();
inputparms.path = '/test_root/test_upload.txt';
System.assert(inputparms.path == '/test_root/test_upload.txt');
System.assert(inputparms.autorename == null);

// Create the response object.
CloudStorageUIResponse response = new CloudStorageUIResponse();

// Execute the Callout
response = DropboxAPI.postupload(inputparms, cloudInput.data);

//meaningful asserts
System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');

Test.stopTest(); 
}

static testMethod void testuploadSessionSuccess() {
    //Start the Testing
    Test.startTest();

    // create a map to hold responses for testing
    map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    DropBoxAPI dbapi = new DropboxAPI();
    
//Setup request response map for HTTPCalloutMock
mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD_SESSION_START(), dbapi.getDROP_BOX_UPLOAD_SESSION_START(), 200, 'Ok', null));

// Verify the Callout
Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

//Setup the input class values.
CloudStoragecreateiteminput cloudInput = new CloudStoragecreateiteminput();
cloudInput.data = Blob.valueof('data in CloudInput');
DBAPIuploadsessionstartinput inputparms = new DBAPIuploadsessionstartinput();

// Create the response object.
CloudStorageUIResponse response = new CloudStorageUIResponse();

// Execute the Callout
response = DropboxAPI.postuploadsessionstart(inputparms, cloudInput.data);
DBAPIuploadsession respobj = new DBAPIuploadsession();
respobj = (DBAPIuploadsession) response.response;

//meaningful asserts
System.assert(respobj.offset == 18);
System.assert(respobj.session_id != null);

Test.stopTest(); 
}

static testMethod void testuploadAppendSuccess() {
    //Start the Testing
    Test.startTest();

    // create a map to hold responses for testing
    map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    DropBoxAPI dbapi = new DropboxAPI();
    
//Setup request response map for HTTPCalloutMock
mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD_SESSION_APPEND_V2(), dbapi.getDROP_BOX_UPLOAD_SESSION_APPEND_V2(), 200, 'Ok', null));

// Verify the Callout
Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

//Setup the input class values.
CloudStoragecreateiteminput cloudInput = new CloudStoragecreateiteminput();
cloudInput.data = Blob.valueof('data in CloudInput');
DBAPIuploadsessionappendinput inputparms = new DBAPIuploadsessionappendinput();

// Create the response object.
CloudStorageUIResponse response = new CloudStorageUIResponse();

// Execute the Callout
response = DropboxAPI.postuploadsessionappend(inputparms, cloudInput.data);
DBAPIuploadsession respobj = new DBAPIuploadsession();
respobj = (DBAPIuploadsession) response.response;

//meaningful asserts
System.assert(respobj.id != null);
System.assert(respobj.offset == 18);

Test.stopTest(); 
}

static testMethod void testuploadFinishSuccess() {
    //Start the Testing
    Test.startTest();

    // create a map to hold responses for testing
    map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    DropBoxAPI dbapi = new DropboxAPI();
    
//Setup request response map for HTTPCalloutMock
mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD_SESSION_FINISH(), dbapi.getDROP_BOX_UPLOAD_SESSION_FINISH(), 200, 'Ok', null));

// Verify the Callout
Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

//Setup the input class values.
CloudStoragecreateiteminput cloudInput = new CloudStoragecreateiteminput();
cloudInput.data = Blob.valueof('data in CloudInput');
DBAPIuploadsessionfinishinput inputparms = new DBAPIuploadsessionfinishinput();

// Create the response object.
CloudStorageUIResponse response = new CloudStorageUIResponse();

// Execute the Callout
response = DropboxAPI.postuploadsessionfinish(inputparms, cloudInput.data);
DBAPIuploadsession respobj = new DBAPIuploadsession();
respobj = (DBAPIuploadsession) response.response;

//meaningful asserts
System.assert(respobj.id != null);
System.assert(respobj.offset == null);

Test.stopTest(); 
}

static testMethod void testmovebatchSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();   

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_V2(), dbapi.getDROP_BOX_MOVE_BATCH_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPImovebatchinput inputparms = new DBAPImovebatchinput();
    inputparms.entries.add(new DBAPImovebatchinput.Entries('/test_root/test_movebatch.txt', '/test_root2/test_movebatch.txt'));
  
    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatch(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(respobj.async_job_id != null);
    
    Test.stopTest();
}

static testMethod void testmovebatchFail1() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();  

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_MOVE_BATCH_V2(), 201, 'Ok'));
    //mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPImovebatchinput inputparms = new DBAPImovebatchinput();
    inputparms.entries.add(new DBAPImovebatchinput.Entries('/test_root/test_movebatch.txt', '/test_root2/test_movebatch.txt'));
    System.assert(inputparms.entries[0].to_path == '/test_root2/test_movebatch.txt');
    System.assert(inputparms.entries[0].from_path == '/test_root/test_movebatch.txt');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatch(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(response.response != null);
    System.assert(respobj.entries.isEmpty());
    System.assert(respobj.x_tag == '');
    System.assert(response.error_message == 'path/conflict/folder/..');

    Test.stopTest();
}


static testMethod void testmovebatchFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();    

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_MOVE_BATCH_V2(), 400, 'Bad Request'));
    //mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPImovebatchinput inputparms = new DBAPImovebatchinput();
    inputparms.entries.add(new DBAPImovebatchinput.Entries('/test_root/test_movebatch.txt', '/test_root2/test_movebatch.txt'));
    System.assert(inputparms.entries[0].to_path == '/test_root2/test_movebatch.txt');
    System.assert(inputparms.entries[0].from_path == '/test_root/test_movebatch.txt');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatch(inputparms); //inputparms.data is blobz.
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(response.response != null);
    System.assert(respobj.entries.isEmpty());
    System.assert(respobj.x_tag == '');
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');

    Test.stopTest();
}

static testMethod void testmovebatchFail3() { // 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();   

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_V2(), dbapi.getDROP_BOX_MOVE_BATCH_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPImovebatchinput inputparms = new DBAPImovebatchinput();
    inputparms.entries.add(new DBAPImovebatchinput.Entries('/test_root/test_movebatch.txt', '/test_root2/test_movebatch.txt'));

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatch(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest();
}

static testMethod void testmovebatchFail4() { // Metadata error
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();   

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_V2(), dbapi.getDROP_BOX_MOVE_BATCH_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPImovebatchinput inputparms = new DBAPImovebatchinput();
    inputparms.entries.add(new DBAPImovebatchinput.Entries('/test_root/test_movebatch.txt', '/test_root2/test_movebatch.txt'));

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatch(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');

    Test.stopTest();
}

static testMethod void testcreatefolderbatchSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();   

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderbatchinput inputparms = new DBAPIcreatefolderbatchinput();
    inputparms.paths.add('/test_root/test_createbatch');
    inputparms.paths.add('/test_root2/test_createbatch');
    
    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatch(inputparms);
    DBAPIcreatefolderbatch respobj = new DBAPIcreatefolderbatch();
    respobj = (DBAPIcreatefolderbatch) response.response;

    //meaningful asserts
    System.assert(respobj.async_job_id != null);

    Test.stopTest();
}

static testMethod void testcreatefolderbatchFail1() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();  

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), 201, 'Ok'));
    //mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderbatchinput inputparms = new DBAPIcreatefolderbatchinput();
    inputparms.paths.add('/test_root/test_createbatch');
    inputparms.paths.add('/test_root2/test_createbatch');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatch(inputparms);
    DBAPIcreatefolderbatch respobj = new DBAPIcreatefolderbatch();
    respobj = (DBAPIcreatefolderbatch) response.response;

    //meaningful asserts
    System.assert(response.response != null);
    System.assert(respobj.entries.isEmpty());
    System.assert(respobj.x_tag == '');
    System.assert(response.error_message == 'path/conflict/folder/..');

    Test.stopTest();
}


static testMethod void testcreatefolderbatchFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();    

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), 400, 'Bad Request'));
    //mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderbatchinput inputparms = new DBAPIcreatefolderbatchinput();
    inputparms.paths.add('/test_root/test_createbatch');
    inputparms.paths.add('/test_root2/test_createbatch');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatch(inputparms); //inputparms.data is blobz.
    DBAPIcreatefolderbatch respobj = new DBAPIcreatefolderbatch();
    respobj = (DBAPIcreatefolderbatch) response.response;

    //meaningful asserts
    System.assert(response.response != null);
    System.assert(respobj.entries.isEmpty());
    System.assert(respobj.x_tag == '');
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');

    Test.stopTest();
}

static testMethod void testcreatefolderbatchFail3() { // 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();   

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIcreatefolderbatchinput inputparms = new DBAPIcreatefolderbatchinput();
    inputparms.paths.add('/test_root/test_createbatch');
    inputparms.paths.add('/test_root2/test_createbatch');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatch(inputparms);
    DBAPIcreatefolderbatch respobj = new DBAPIcreatefolderbatch();
    respobj = (DBAPIcreatefolderbatch) response.response;

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest();
}

static testMethod void testcreatefolderbatchFail4() { // Metadata error
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();   

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIcreatefolderbatchinput inputparms = new DBAPIcreatefolderbatchinput();
    inputparms.paths.add('/test_root/test_createbatch');
    inputparms.paths.add('/test_root2/test_createbatch');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postcreatefolderbatch(inputparms);
    DBAPIcreatefolderbatch respobj = new DBAPIcreatefolderbatch();
    respobj = (DBAPIcreatefolderbatch) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');

    Test.stopTest();
}


static testMethod void testmovebatchcheckSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();  

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPImovebatchcheckinput inputparms = new DBAPImovebatchcheckinput();
    inputparms.async_job_id = 'test job';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatchcheck(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(respobj.async_job_id == null);
    System.assert(respobj.entries.size() == 3);
    //System.assert(respobj.x_tag == 'complete');
    //System.assert(respobj.entries[0].success.path_lower == '/homework/math/prime_numbers.txt');
    //System.assert(respobj.entries[0].success.name == 'Prime_Numbers.txt');

    Test.stopTest();
}

static testMethod void testmovebatchcheckFail1() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();  

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPImovebatchcheckinput inputparms = new DBAPImovebatchcheckinput();
    inputparms.async_job_id = 'test job';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatchcheck(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');

    Test.stopTest();
}

static testMethod void testmovebatchcheckFail2() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();  

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 201, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPImovebatchcheckinput inputparms = new DBAPImovebatchcheckinput();
    inputparms.async_job_id = 'test job';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatchcheck(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'path/conflict/folder/..');

    Test.stopTest();
}

static testMethod void testmovebatchcheckFail3() { //500
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();  

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPImovebatchcheckinput inputparms = new DBAPImovebatchcheckinput();
    inputparms.async_job_id = 'test job';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatchcheck(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest();
}

static testMethod void testmovebatchcheckFail4() { //metadata
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();  

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPImovebatchcheckinput inputparms = new DBAPImovebatchcheckinput();
    inputparms.async_job_id = 'test job';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postmovebatchcheck(inputparms);
    DBAPImovebatch respobj = new DBAPImovebatch();
    respobj = (DBAPImovebatch) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');

    Test.stopTest();
} 

static testMethod void testdownloadSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/octet-stream'}, dbapi.getDROP_BOX_DOWNLOAD(), dbapi.getDROP_BOX_DOWNLOAD(), 200, 'Ok', Blob.valueOf('Blob Param')));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdownloadinput inputparms = new DBAPIdownloadinput();
    inputparms.path = '/test_root/test_download.txt';
    System.assert(inputparms.path == '/test_root/test_download.txt');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdownload(inputparms);
    DBAPIdownload respobj = new DBAPIdownload();
    respobj = (DBAPIdownload) response.response;

    //meaningful asserts
    System.assert(respobj != null);
    System.assert(response.error_message != 'This is an error that is not trapped by http response code');
    System.assert(respobj.filedata != null);

    Test.stopTest(); 
    }

static testMethod void testdownloadFail1() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();
        
        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/octet-stream'}, 'DBerror', dbapi.getDROP_BOX_DOWNLOAD(), 201, 'Ok', null));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdownloadinput inputparms = new DBAPIdownloadinput();
    inputparms.path = '/test_root/test_download.txt';
    System.assert(inputparms.path == '/test_root/test_download.txt');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdownload(inputparms);
    DBAPIdownload respobj = new DBAPIdownload();
    respobj = (DBAPIdownload) response.response;

    //meaningful asserts
    System.assert(respobj.filedata == null);
    System.assert(response.error_message != 'This is an error that is not trapped by http response code');
    System.assert(response.response != null);

    Test.stopTest(); 
}

static testMethod void testdownloadFail2() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
    
    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/octet-stream'}, 'err', dbapi.getDROP_BOX_DOWNLOAD(), 400, 'Bad Request', null));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdownloadinput inputparms = new DBAPIdownloadinput();
    inputparms.path = '/test_root/test_download.txt';
    System.assert(inputparms.path == '/test_root/test_download.txt');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdownload(inputparms);
    DBAPIdownload respobj = new DBAPIdownload();
    respobj = (DBAPIdownload) response.response;

    //meaningful asserts
    System.assert(respobj.filedata == null);
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');
    System.assert(response.response != null);

    Test.stopTest(); 
}

static testMethod void testdownloadFail3() { // 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();


        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/octet-stream'}, dbapi.getDROP_BOX_DOWNLOAD(), dbapi.getDROP_BOX_DOWNLOAD(), 200, 'Ok', Blob.valueOf('Blob Param')));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIdownloadinput inputparms = new DBAPIdownloadinput();
    inputparms.path = '/test_root/test_download.txt';
    System.assert(inputparms.path == '/test_root/test_download.txt');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdownload(inputparms);

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest(); 
}

static testMethod void testdownloadFail4() { // Metadata error
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createContentMock(new map<String, String>{'Content-Type' => 'application/octet-stream'}, dbapi.getDROP_BOX_DOWNLOAD(), dbapi.getDROP_BOX_DOWNLOAD(), 200, 'Ok', Blob.valueOf('Blob Param')));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIdownloadinput inputparms = new DBAPIdownloadinput();
    inputparms.path = '/test_root/test_download.txt';
    System.assert(inputparms.path == '/test_root/test_download.txt');

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postdownload(inputparms);

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');

    Test.stopTest(); 
}

static testMethod void testsearchSuccess() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_SEARCH_V2(), dbapi.getDROP_BOX_SEARCH_V2(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIsearchinput input = new DBAPIsearchinput();
    input.options.path = '/test_root/test_customer';
    input.query = 'test query';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearch(input);
    DBAPIsearch respobj = new DBAPIsearch();
    respobj = (DBAPIsearch) response.response;
    
    //meaningful asserts
    System.assert(respobj.matches[0].metadata.metadata.path_lower == '/homework/math/prime_numbers2.txt');
    System.assert(respobj.has_more == true);

    Test.stopTest(); 
}
// test a 400 failure in the first callout
static testMethod void testsearchFail1() {
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_SEARCH_V2(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIsearchinput input = new DBAPIsearchinput();
    input.options.path = '/test_root/test_customer';
    input.query = 'test query';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearch(input);

    //meaningful asserts
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');
  

    Test.stopTest(); 
}

// test a Dropbox failure in the first callout
static testMethod void testsearchFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_SEARCH_V2(), 201, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIsearchinput input = new DBAPIsearchinput();
    input.options.path = '/test_root/test_customer';
    input.query = 'test query';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearch(input);
    DBAPIsearch respobj = (DBAPIsearch) response.response;

    // to do add meaningful asserts
    System.assert(respobj.matches.size() == 0);
    System.assert(response.error_message == 'path/conflict/folder/..');

    Test.stopTest(); 
}

static testMethod void testsearchFail3() { //fails to 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_SEARCH_V2(), dbapi.getDROP_BOX_SEARCH_V2(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIsearchinput input = new DBAPIsearchinput();
    input.options.path = '/test_root/test_customer';
    input.query = 'test query';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearch(input);
    DBAPIsearch respobj = (DBAPIsearch) response.response;

    //to do add meaningful asserts
    System.assert(response.response != null);
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest(); 
}

static testMethod void testsearchFail4() { // fails due to cleared metadata #316
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_SEARCH_V2(), dbapi.getDROP_BOX_SEARCH_V2(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIsearchinput input = new DBAPIsearchinput();
    input.options.path = '/test_root/test_customer';
    input.query = 'test query';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearch(input);
    DBAPIsearch respobj = (DBAPIsearch) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');
    
    Test.stopTest(); 
}

static testMethod void testsearchcontinueSuccess() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIsearchcontinueinput input = new DBAPIsearchcontinueinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearchcontinue(input);
    DBAPIsearch respobj = new DBAPIsearch();
    respobj = (DBAPIsearch) response.response;

    //meaningful asserts
    System.assert(respobj.matches[0].metadata.metadata.path_lower == '/homework/math/prime_numbers.txt');
    System.assert(respobj.has_more == false);

    Test.stopTest(); 
}

static testMethod void testsearchcontinueFail1() { 
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIsearchcontinueinput input = new DBAPIsearchcontinueinput();
    input.cursor = 'test cursor';
    
    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();
    // Execute the Callout
    response = DropboxAPI.postsearchcontinue(input);

    //meaningful asserts
    System.assert(response.error_message == 'This is an error that is not trapped by http response code');

    Test.stopTest(); 
}

static testMethod void testsearchcontinueFail2() {  
        //Start the Testing
        Test.startTest();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();
        
        //Setup request response map for HTTPCalloutMock
        mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), 201, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIsearchcontinueinput input = new DBAPIsearchcontinueinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearchcontinue(input);
    DBAPIsearch respobj = new DBAPIsearch();
    respobj = (DBAPIsearch) response.response;

    //meaningful asserts
    System.assert(response.error_message == 'path/conflict/folder/..');

   
    Test.stopTest(); 
}

static testMethod void testsearchcontinueFail3() { //fails to 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIsearchcontinueinput input = new DBAPIsearchcontinueinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearchcontinue(input);

    //meaningful asserts
    System.assert(response.error_message.contains('SFDC Details:'));

    Test.stopTest(); 
}

static testMethod void testsearchcontinueFail4() { // fails due to cleared metadata #316
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIsearchcontinueinput input = new DBAPIsearchcontinueinput();
    input.cursor = 'test cursor';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postsearchcontinue(input);

    //meaningful asserts
    System.assert(response.error_message == 'Custom Setting Metadata missing for DropBox API connection');
    
    Test.stopTest(); 
}

static testMethod void testpostnamespacelistSuccess() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_NAMESPACES_LIST(), dbapi.getDROP_BOX_NAMESPACES_LIST(), 200, 'Ok'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    // Create the response object.
    DBAPInamespaceslist response = new DBAPInamespaceslist();

    // Execute the Callout
    response = DropboxAPI.postnamespaceslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.cursor == 'AADJklTQH2sD4q-ZmzYcHPpC9zCQsaLCwGwrHRQ3e33zOWeV0HZWnGx8fETT2EwdpFbMFeNXhGIyM64K5eQ22hfRml0KLyFKm9YWXeoHNAyZDpD0zMIbTXXqGcN8JqcdUvzn_LJ9KPKZBYnSQh42wWpVJWpLhQNqu-hdPPapVar0yLHvpojXrak59FR4E5OjGlC9QcI_tkRYsjA7BlQG0V0DUUfRRWzOYlgUq4CxSgwi-RNWtyEfkRDyDZqfCoBHszSJ8LjEUNnV0dTTQf6gIoc89uwBfijl3czxXCSFV2iIxdRb4VJCpAm-rnrmtnq4PKVk-FFTlS43HlmvIrFxsJhG');
    System.assert(response.namespaces.size() == 5);

    Test.stopTest(); 
}

static testMethod void testpostnamespacelistFail1() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_NAMESPACES_LIST(), 201, 'Ok'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    // Create the response object.
    DBAPInamespaceslist response = new DBAPInamespaceslist();

    // Execute the Callout
    response = DropboxAPI.postnamespaceslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.namespaces.size() == 0);
    System.assert(response.cursor == '');

    Test.stopTest(); 
}

static testMethod void testpostnamespacelistFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_NAMESPACES_LIST(), 400, 'Bad Request'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    // Create the response object.
    DBAPInamespaceslist response = new DBAPInamespaceslist();

    // Execute the Callout
    response = DropboxAPI.postnamespaceslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.namespaces.size() == 0);
    System.assert(response.cursor == '');

    Test.stopTest(); 
}

static testMethod void testpostnamespacelistFail3() { // 500 error
    //Start the Testing
    Test.startTest();
    Account acct = new Account();
    acct = CloudStorageController_TC.createtestdata();

    
    // create a map to hold responses for testing
    map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    DropBoxAPI dbapi = new DropboxAPI();

//Setup request response map for HTTPCalloutMock
mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_NAMESPACES_LIST(), dbapi.getDROP_BOX_NAMESPACES_LIST(), 200, 'Ok'));
mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), 200, 'Ok'));

// Verify the Callout
Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));


// Create the response object.
DBAPInamespaceslist response = new DBAPInamespaceslist();

// Execute the Callout
response = DropboxAPI.postnamespaceslist();

//meaningful asserts
System.assert(response.has_more == false);

System.assert(response.namespaces.size() == 0);
System.assert(response.cursor == '');

Test.stopTest(); 
}
static testMethod void testpostnamespacelistFail4() { //missing metadata
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_NAMESPACES_LIST(), dbapi.getDROP_BOX_NAMESPACES_LIST(), 200, 'Ok'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    // Create the response object.
    DBAPInamespaceslist response = new DBAPInamespaceslist();

    // Execute the Callout
    response = DropboxAPI.postnamespaceslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.namespaces.size() == 0);
    System.assert(response.cursor == '');

    Test.stopTest(); 
}

static testMethod void testpostmemberslistSuccess() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MEMBERS_LIST(), dbapi.getDROP_BOX_MEMBERS_LIST(), 200, 'Ok'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    // Create the response object.
    DBAPImemberslist response = new DBAPImemberslist();

    // Execute the Callout
    response = DropboxAPI.postmemberslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.cursor == 'AADqUnHgnUIH0_hhHh7rIw06YJCJzwBA35vQ6aurRON3C-Bs2pt1CtTtqWhHn-uzXrl1XtMDVi4nDZ1P-eJosxWw3oI4pE3dZjnzy2QodBbhAA');
    System.assert(response.members.size() == 4);

    Test.stopTest(); 
}

static testMethod void testpostmemberslistFail1() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_MEMBERS_LIST(), 201, 'Ok'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    // Create the response object.
    DBAPImemberslist response = new DBAPImemberslist();

    // Execute the Callout
    response = DropboxAPI.postmemberslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.members.size() == 0);
    System.assert(response.cursor == '');

    Test.stopTest(); 
}

static testMethod void testpostmemberslistFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_MEMBERS_LIST(), 400, 'Bad Request'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    // Create the response object.
    DBAPImemberslist response = new DBAPImemberslist();

    // Execute the Callout
    response = DropboxAPI.postmemberslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.members.size() == 0);
    System.assert(response.cursor == '');

    Test.stopTest(); 
}

static testMethod void testpostmemberslistFail3() { //test 500
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_MEMBERS_LIST(), 400, 'Bad Request'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    // Create the response object.
    DBAPImemberslist response = new DBAPImemberslist();

    // Execute the Callout
    response = DropboxAPI.postmemberslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.members.size() == 0);
    System.assert(response.cursor == '');

    Test.stopTest(); 
}

static testMethod void testpostmemberslistFail4() { //tests metadata
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MEMBERS_LIST(), dbapi.getDROP_BOX_MEMBERS_LIST(), 200, 'Ok'));
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    // Create the response object.
    DBAPImemberslist response = new DBAPImemberslist();

    // Execute the Callout
    response = DropboxAPI.postmemberslist();

    //meaningful asserts
    System.assert(response.has_more == false);
    System.assert(response.members.size() == 0);
    System.assert(response.cursor == '');

    Test.stopTest(); 
}

static testMethod void testpostgetmetadataSuccess() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_GET_METADATA(), dbapi.getDROP_BOX_GET_METADATA(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIgetmetadatainput input = new DBAPIgetmetadatainput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgetmetadata(input);
    DBAPIgetmetadata respobj = new DBAPIgetmetadata();
    respobj = (DBAPIgetmetadata) response.response;

    //meaningful asserts
    System.assert(respobj.x_tag == 'file');
    System.assert(respobj.path_lower == '/homework/math/prime_numbers.txt');
    
    Test.stopTest(); 
}

static testMethod void testpostgetmetadataFail1() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_GET_METADATA(), 201, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIgetmetadatainput input = new DBAPIgetmetadatainput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgetmetadata(input);
    DBAPIgetmetadata respobj = new DBAPIgetmetadata();
    respobj = (DBAPIgetmetadata) response.response;

    //meaningful asserts
    System.assert(respobj.x_tag == '');
    System.assert(respobj.path_lower == '');

    Test.stopTest(); 
}

static testMethod void testpostgetmetadataFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_GET_METADATA(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIgetmetadatainput input = new DBAPIgetmetadatainput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgetmetadata(input);
    DBAPIgetmetadata respobj = new DBAPIgetmetadata();
    respobj = (DBAPIgetmetadata) response.response;

    //meaningful asserts
    System.assert(respobj.x_tag == '');
    System.assert(respobj.path_lower == '');

    Test.stopTest(); 
}

static testMethod void testpostgetmetadataFail3() { // 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_GET_METADATA(), dbapi.getDROP_BOX_GET_METADATA(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIgetmetadatainput input = new DBAPIgetmetadatainput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgetmetadata(input);
    DBAPIgetmetadata respobj = new DBAPIgetmetadata();
    respobj = (DBAPIgetmetadata) response.response;

    //meaningful asserts
    System.assert(respobj.x_tag == '');
    System.assert(respobj.path_lower == '');

    Test.stopTest(); 
}

static testMethod void testpostgetmetadataFail4() { // metadata
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_GET_METADATA(), dbapi.getDROP_BOX_GET_METADATA(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIgetmetadatainput input = new DBAPIgetmetadatainput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgetmetadata(input);
    DBAPIgetmetadata respobj = new DBAPIgetmetadata();
    respobj = (DBAPIgetmetadata) response.response;

    //meaningful asserts
    System.assert(respobj.x_tag == '');
    System.assert(respobj.path_lower == '');

Test.stopTest(); 
}

static testMethod void testpostgettemporarylinkSuccess() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), 200, 'Ok'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIgettemporarylinkinput input = new DBAPIgettemporarylinkinput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgettemporarylink(input);
    DBAPIgettemporarylink respobj = new DBAPIgettemporarylink();
    respobj = (DBAPIgettemporarylink) response.response;

    //meaningful asserts
    System.assert(respobj.metadata.name == 'sample.txt');
    System.assert(respobj.link == 'https://content.dropboxapi.com/apitl/1/Al6BW8hvXbcMSlCVnB-fUlhH35rulZt4dgbH5uGOpoJx6K7wJOH7rIzZKMdCmZAbviWuDpsaOQN6_1lzh3m-KnoUyAAU9AMPXXwnLYBY9cdscmc9176QXysXRYVTeNyPI3ZOBDvAEhMmC3yBAeUcjbP1Ka930b7q-qU7VDmu-iu9Pl6SORcoyYCTiayzOJP9y8jVdQcx5PzCcXlWxHHAFO0GfZ03KufnQJn21BLGqZr_DaC7suT8KpYTEXDCaJPmDrdby8GCPzCCVxfUy9MbCElp0hPuxDyIri3aMq4R8f11UKm8LOYT3NftB3lmnBB9FcO52FoXkNn3irs_mutGQUrFQwZM0aB57-KpRXLH7Pyk9g6ar_r1fh8_TJRpglZ62H3KerCHQ2xAboH5y-MZm3iS39SEc58GUlmjIY6OS2RpuGDMAtF9ZOQBJvb4kkvqfV6i07LnltOwVH3cWp7IU--XnfKKvZFqXbqqD4MWWkkSHC6izeb1S5Q8b1eJswMH-mU');

    Test.stopTest(); 
}

static testMethod void testpostgettemporarylinkFail1() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'DBerror', dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), 201, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIgettemporarylinkinput input = new DBAPIgettemporarylinkinput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgettemporarylink(input);
    DBAPIgettemporarylink respobj = new DBAPIgettemporarylink();
    respobj = (DBAPIgettemporarylink) response.response;

    //meaningful asserts
    System.assert(respobj.link == '');
    System.assert(respobj.metadata.path_lower == '');

    Test.stopTest(); 
}

static testMethod void testpostgettemporarylinkFail2() {
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, 'err', dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), 400, 'Bad Request'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIgettemporarylinkinput input = new DBAPIgettemporarylinkinput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgettemporarylink(input);
    DBAPIgettemporarylink respobj = new DBAPIgettemporarylink();
    respobj = (DBAPIgettemporarylink) response.response;

    //meaningful asserts
    System.assert(respobj.link == '');
    System.assert(respobj.metadata.path_lower == '');

    Test.stopTest(); 
}

static testMethod void testpostgettemporarylinkFail3() { // 500 error
        //Start the Testing
        Test.startTest();
        Account acct = new Account();
        acct = CloudStorageController_TC.createtestdata();

        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));

    //Setup the input class values.
    DBAPIgettemporarylinkinput input = new DBAPIgettemporarylinkinput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgettemporarylink(input);
    DBAPIgettemporarylink respobj = new DBAPIgettemporarylink();
    respobj = (DBAPIgettemporarylink) response.response;

    //meaningful asserts
    System.assert(respobj.link == '');
    System.assert(respobj.metadata.path_lower == '');

    Test.stopTest(); 
}

static testMethod void testpostgettemporarylinkFail4() { // metadata
        //Start the Testing
        Test.startTest();
        
        // create a map to hold responses for testing
        map<String, HttpResponse> mockresponses = new map<String, HttpResponse>();

        // determine if running in sandbox or production
        CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        DropBoxAPI dbapi = new DropboxAPI();

    //Setup request response map for HTTPCalloutMock
    mockresponses.putAll(createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), 200, 'OK'));

    // Verify the Callout
    Test.setMock(HttpCalloutMock.class, new CloudStorageMockHttpResponseGenerator(mockresponses));
    CloudStorageUtilities.clearCloudStorageMeta(mdt.Label);

    //Setup the input class values.
    DBAPIgettemporarylinkinput input = new DBAPIgettemporarylinkinput();
    input.path = '/test_root/test_metadata';

    // Create the response object.
    CloudStorageUIResponse response = new CloudStorageUIResponse();

    // Execute the Callout
    response = DropboxAPI.postgettemporarylink(input);
    DBAPIgettemporarylink respobj = new DBAPIgettemporarylink();
    respobj = (DBAPIgettemporarylink) response.response;

    //meaningful asserts
    System.assert(respobj.link == '');
    System.assert(respobj.metadata.path_lower == '');

    Test.stopTest(); 
}

static testMethod void testConstructors() { //tests constructors for CursorInput, APIPathRoot, AsyncoutputInput and the functions setOtherError() and generatecursor()
    //Start the Testing
    Test.startTest();

    DropBoxAPI.Cursorinput basicCursorInput = new DropBoxAPI.Cursorinput();
    System.assert(basicCursorInput.cursor == '');
    DropBoxAPI.Cursorinput constructedCursorInput = new DropBoxAPI.Cursorinput('cursor');
    System.assert(constructedCursorInput.cursor == 'cursor');

    String generatedCursorInput = DropBoxAPI.generatecursor('cursor');
    System.assert(generatedCursorInput == '{"cursor":"cursor"}');

    DropBoxAPI.APIPathRoot basicAPIPathRoot = new DropBoxAPI.APIPathRoot();
    System.assert(basicAPIPathRoot.x_tag == 'namespace_id');
    System.assert(basicAPIPathRoot.namespace_id == '');

    DropBoxAPI.Asyncoutput basicAsyncoutputInput = new DropBoxAPI.Asyncoutput();
    System.assert(basicAsyncoutputInput.async_job_id == '');
    DropBoxAPI.Asyncoutput constructedAsyncoutputInput = new DropBoxAPI.Asyncoutput('Asyncoutput');
    System.assert(constructedAsyncoutputInput.async_job_id == 'Asyncoutput');

    DBAPIerror responseerror = new DBAPIerror();
    HttpResponse dropboxresp = new HttpResponse();
    String error = 'this is error';
    DropBoxAPI.setOtherError(responseerror, dropboxresp, error);
    System.assert(responseerror.error_summary == 'this is error');
    System.assert(dropboxresp.getStatusCode() == 500);


    Test.stopTest(); 
}

public static map<String, HttpResponse> createMock(map<String, String> headers, String action, String endpoint, Integer statusCode, String status){
    map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();
    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    //Setup request response map for HTTPCalloutMock
    mockresponses.put(DropBoxAPI.getDropBoxEndpoint(mdt,endpoint),
                    CloudStorageMockHttpResponseGenerator.constructMockResponse(headers,
                                                                                DBAPIMockResponseGenerator.createJsonResponse(mdt.Connected_App__c,action),
                                                                                status,
                                                                                statusCode));
    return mockresponses;
}

public static map<String, HttpResponse> createContentMock(map<String, String> headers, String action, String endpoint, Integer statusCode, String status, Blob blobFile){
    
    map<String, HttpResponse> mockresponses = new map<String,HttpResponse>();
    // determine if running in sandbox or production
    CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
    if(blobFile != null){
        headers.put('Dropbox-Api-Result', DBAPIMockResponseGenerator.createJsonResponse(mdt.Connected_App__c,action));
    }
    //Setup request response map for HTTPCalloutMock
    mockresponses.put(DropBoxAPI.getDropBoxContentEndpoint(mdt,endpoint),
                 CloudStorageMockHttpResponseGenerator.constructMockResponse(headers,
                                                                             (blobFile == null) ? DBAPIMockResponseGenerator.createJsonResponse(mdt.Connected_App__c,action): null,
                                                                             status,
                                                                             statusCode,
                                                                             (blobFile == null) ? null: blobFile));
    return mockresponses;
}
}