/*
@Author: N. Larkin, Admins on Call
@Date: 1-18-2021
@Description: Test Class for DBAPIuploadsession

@History:
*/
@isTest
public with sharing class DBAPIuploadsession_TC {
    static testMethod void testmeth() {
        DBAPIuploadsession constructedSession = new DBAPIuploadsession();
        
        String json = '{'+
		'  "session_id": "AAAAAAAAAKw6SCnjShy_tA",'+
		'  "name": "test.txt",'+
		'  "path_lower": "/thg_customers/test_customer/test.txt",'+
		'  "path_display": "/THG_Customers/Test_Customer/test.txt",'+
		'  "parent_shared_folder_id": "8593825504",'+
		'  "id": "id:CBh9W4LXJYIAAAAAAABv4w",'+
		'  "client_modified": "2021-01-12T15:49:10Z",'+
		'  "server_modified": "2021-01-12T15:49:11Z",'+
		'  "rev": "015b8b5f6b25d6100000002003b5ee0",'+
		'  "size": 1386,'+
		'  "sharing_info": {'+
		'    "read_only": false,'+
		'    "parent_shared_folder_id": "8593825504",'+
		'    "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
		'  },'+
		'  "is_downloadable": true,'+
		'  "content_hash": "f7510d761f7c4b1a8fc2129ab333ae18425da518723a5d73a396b049a077576a"'+
		'}';
        DBAPIuploadsession parsedSession = DBAPIuploadsession.parse(json);
	}
}