/*
@Author: P. Sutherland, Admins on Call
@Date: 11-04-2020
@Description:   API Class for Dropbox API upload return.

@History:
*/
@IsTest
public class DBAPIupload_TC {
	
	static testMethod void testParse() {
		String json = '{'+
		'    "name": "sample2.xlsx",'+
		'    "path_lower": "/thg_customers/test_customer/sample2.xlsx",'+
		'    "path_display": "/THG_Customers/Test_Customer/sample2.xlsx",'+
		'    "parent_shared_folder_id": "8593825504",'+
		'    "id": "id:CBh9W4LXJYIAAAAAAAAQEA",'+
		'    "client_modified": "2020-11-04T20:50:55Z",'+
		'    "server_modified": "2020-11-04T20:50:55Z",'+
		'    "rev": "015b34e22c87efe00000002003b5ee0",'+
		'    "size": 10012,'+
		'    "sharing_info": {'+
		'        "read_only": false,'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
		'    },'+
		'    "is_downloadable": true,'+
		'    "content_hash": "a3fda19decfed5996a3e758825157a5b0d16a8d1a14617762e5c2614a490c2bf"'+
        '}';
        DBAPIupload obj = new DBAPIupload();
		obj = DBAPIupload.parse(json);
		System.assert(obj != null);
	}
}