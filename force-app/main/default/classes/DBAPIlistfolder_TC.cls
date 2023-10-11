/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API listfolder response.

@History:
*/
@IsTest
public class DBAPIlistfolder_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  "entries": ['+
		'    {'+
		'      ".tag": "folder",'+
		'      "name": "Invoices",'+
		'      "path_lower": "/thg_customers/test_customer/invoices",'+
		'      "path_display": "/THG_Customers/Test_Customer/Invoices",'+
		'      "parent_shared_folder_id": "8593825504",'+
		'      "id": "id:CBh9W4LXJYIAAAAAAAAO2A",'+
		'      "sharing_info": {'+
		'        "read_only": false,'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "traverse_only": false,'+
		'        "no_access": false'+
		'      }'+
		'    },'+
		'    {'+
		'      ".tag": "file",'+
		'      "name": "requirements.txt",'+
		'      "path_lower": "/thg_customers/test_customer/requirements.txt",'+
		'      "path_display": "/THG_Customers/Test_Customer/requirements.txt",'+
		'      "parent_shared_folder_id": "8593825504",'+
		'      "id": "id:CBh9W4LXJYIAAAAAAAAO1w",'+
		'      "client_modified": "2020-11-02T21:25:09Z",'+
		'      "server_modified": "2020-11-02T21:25:09Z",'+
		'      "rev": "015b32661800c2600000002003b5ee0",'+
		'      "size": 1091,'+
		'      "sharing_info": {'+
		'        "read_only": false,'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
		'      },'+
		'      "is_downloadable": true,'+
		'      "content_hash": "1f9cf9b7b1c9376f9abc77959d28745dc49d983a4731ca6e8a24c22ef8d954e9"'+
		'    }'+
		'  ],'+
		'  "cursor": "AAHoThz4Kpo8F15eOKa8yEgH71QmLNTDEhT-OpYOuGGLuXuH6j9ndAnq9HFOnzxb8UI3VH9-_HefY5Bqje2zqAcDVdmTy5_hLee205tTyDdv81Rb11ZVObpQP883TiB9oNl-zxQ3yDzpNUMZVF_fNF0bJ29SZGZJgFu7sod7h3Zk8PZesO0UT5eUu4ICYeMPIyvCAFt1Z6gpfJUD85peApuvwybWG0i-MPzqfVLUsGja1chV4ovN9LZ68rrRjvarkcvRFQNIIXPDD0Is7b00jhDZJ7yKVSHdRAcYibQtQe6-N09e-FUspGDwbsdL0BXpHek",'+
		'  "has_more": false'+
		'}';
		DBAPIlistfolder r = new DBAPIlistfolder();
		r = DBAPIlistfolder.parse(json);
		System.assert(r != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIlistfolder objDBAPIlistfolder = new DBAPIlistfolder(System.JSON.createParser(json));
		System.assert(objDBAPIlistfolder != null);
		System.assert(objDBAPIlistfolder.entries == null);
		System.assert(objDBAPIlistfolder.cursor == null);
		System.assert(objDBAPIlistfolder.has_more == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIlistfolder.Sharing_info objSharing_info = new DBAPIlistfolder.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.traverse_only == null);
		System.assert(objSharing_info.no_access == null);

		/*
		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIlistfolder.Sharing_info_Z objSharing_info_Z = new DBAPIlistfolder.Sharing_info_Z(System.JSON.createParser(json));
		System.assert(objSharing_info_Z != null);
		System.assert(objSharing_info_Z.read_only == null);
		System.assert(objSharing_info_Z.parent_shared_folder_id == null);
		System.assert(objSharing_info_Z.modified_by == null);
		*/ 

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIlistfolder.Entries objEntries = new DBAPIlistfolder.Entries(System.JSON.createParser(json));
		System.assert(objEntries != null);
		System.assert(objEntries.x_tag == null);
		System.assert(objEntries.name == null);
		System.assert(objEntries.path_lower == null);
		System.assert(objEntries.path_display == null);
		System.assert(objEntries.parent_shared_folder_id == null);
		System.assert(objEntries.id == null);
		System.assert(objEntries.sharing_info == null);
		System.assert(objEntries.client_modified == null);
		System.assert(objEntries.server_modified == null);
		System.assert(objEntries.rev == null);
		System.assert(objEntries.size == null);
		System.assert(objEntries.is_downloadable == null);
		System.assert(objEntries.content_hash == null);

		DBAPIlistfolder.Entries objEntries2 = new DBAPIlistfolder.Entries();
		System.assert(objEntries2.x_tag == '');
		System.assert(objEntries2.name == '');
		System.assert(objEntries2.path_lower == '');
		System.assert(objEntries2.path_display == '');
		System.assert(objEntries2.parent_shared_folder_id == '');
		System.assert(objEntries2.id == '');
		System.assert(objEntries2.sharing_info != null);
		System.assert(objEntries2.client_modified == '');
		System.assert(objEntries2.server_modified == '');
		System.assert(objEntries2.rev == '');
		System.assert(objEntries2.size == 0);
		System.assert(objEntries2.is_downloadable == false);
		System.assert(objEntries2.content_hash == '');

	}
}