/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API list folder input test

@History:
*/

@IsTest
public class DBAPIlistfolderinput_TC {
	
	// This test method should give 100% coverage
	static testMethod void testMeth() {
		String json = '{'+
		'    "path": "/thg_customers/test_customer4",'+
		'    "recursive": false,'+
		'    "include_media_info": false,'+
		'    "include_deleted": false,'+
		'    "include_has_explicit_shared_members": false,'+
		'    "include_mounted_folders": false,'+
		'    "limit": 1000,'+
		'    "shared_link": {'+
		'        "url": "https://testlink.com",'+
		'        "password": "test"'+
		'    },'+
		'    "include_property_groups": {'+
		'        ".tag": "filter_some",'+
		'        "filter_some": ['+
		'            "test1"'+
		'        ]'+
		'    },'+
		'    "include_non_downloadable_files": false'+
		'}';
		DBAPIlistfolderinput r = new DBAPIlistfolderinput();
		System.assert(r != null);
        r.path = '/thg_customers/test_customer4';
        r.recursive = false;
        r.include_media_info = false;
        r.include_deleted = false;
        r.include_has_explicit_shared_members = false;
		r.include_mounted_folders = false;
		r.include_non_downloadable_files = false;
        r.limit_Z = 1000;
        r.include_property_groups.x_tag = 'filter_some';
        r.include_property_groups.filter_some = new list<String>{'test1','test2'};
        r.shared_link.url = 'https:/tryme.com/testalink';
        r.shared_link.password = 'test';
        String jsonoutput = DBAPIlistfolderinput.genlistfolderJSONString(r);
		System.assert(jsonoutput != null);
		
		DBAPIlistfolderinput.Shared_link constructedSharedLink = new DBAPIlistfolderinput.Shared_link('testurl', 'testpassword');
		System.assert(constructedSharedLink.url == 'testurl');
		System.assert(constructedSharedLink.password == 'testpassword');
	}
}