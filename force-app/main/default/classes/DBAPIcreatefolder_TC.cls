/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API createfolder response.

@History:
*/
@IsTest
public class DBAPIcreatefolder_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  "metadata": {'+
		'    "name": "THG_Customers",'+
		'    "path_lower": "/thg_customers",'+
		'    "path_display": "/THG_Customers",'+
		'    "parent_shared_folder_id": "8206105904",'+
		'    "id": "id:CBh9W4LXJYIAAAAAAAAOyA",'+
		'    "sharing_info": {'+
		'      "read_only": false,'+
		'      "parent_shared_folder_id": "8206105904",'+
		'      "traverse_only": false,'+
		'      "no_access": false'+
		'    }'+
		'  }'+
		'}';
		DBAPIcreatefolder r = new DBAPIcreatefolder();
		r = DBAPIcreatefolder.parse(json);
		System.assert(r != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIcreatefolder.Sharing_info objSharing_info = new DBAPIcreatefolder.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.traverse_only == null);
		System.assert(objSharing_info.no_access == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIcreatefolder.Metadata objMetadata = new DBAPIcreatefolder.Metadata(System.JSON.createParser(json));
		System.assert(objMetadata != null);
		System.assert(objMetadata.name == null);
		System.assert(objMetadata.path_lower == null);
		System.assert(objMetadata.path_display == null);
		System.assert(objMetadata.parent_shared_folder_id == null);
		System.assert(objMetadata.id == null);
		System.assert(objMetadata.sharing_info == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIcreatefolder objDBAPIcreatefolder = new DBAPIcreatefolder(System.JSON.createParser(json));
		System.assert(objDBAPIcreatefolder != null);
		System.assert(objDBAPIcreatefolder.metadata == null);
	}
}