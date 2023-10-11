/*
@Author: P. Sutherland, Admins on Call
@Date: 11-03-2020
@Description:   API Class for Dropbox API generic move return json.

@History:
*/

@IsTest
public class DBAPImove_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = //DBAPIMockResponseGenerator.createJsonResponse('move');
		'{'+
		'  \"metadata\": {'+
		'    \".tag\": \"file\",'+
		'    \"name\": \"sample.txt\",'+
		'    \"path_lower\": \"/thg_customers/test_customer/sample.txt\",'+
		'    \"path_display\": \"/THG_Customers/Test_Customer/sample.txt\",'+
		'    \"parent_shared_folder_id\": \"8593825504\",'+
		'    \"id\": \"id:CBh9W4LXJYIAAAAAAAAO1w\",'+
		'    \"client_modified\": \"2020-11-02T21:25:09Z\",'+
		'    \"server_modified\": \"2020-11-03T17:56:09Z\",'+
		'    \"rev\": \"015b33793ed126a00000002003b5ee0\",'+
		'    \"size\": 1091,'+
		'    \"sharing_info\": {'+
		'      \"read_only\": false,'+
		'      \"parent_shared_folder_id\": \"8593825504\",'+
		'      \"modified_by\": \"dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA\"'+
		'    },'+
		'    \"is_downloadable\": true,'+
		'    \"content_hash\": \"1f9cf9b7b1c9376f9abc77959d28745dc49d983a4731ca6e8a24c22ef8d954e9\"'+
		'  }'+
		'}'; 
		DBAPImove r = new DBAPImove();
		r = DBAPImove.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPImove objDBAPImove = new DBAPImove(System.JSON.createParser(json));
		System.assert(objDBAPImove != null);
		System.assert(objDBAPImove.metadata == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPImove.Sharing_info objSharing_info = new DBAPImove.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.modified_by == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPImove.Metadata objMetadata = new DBAPImove.Metadata(System.JSON.createParser(json));
		System.assert(objMetadata != null);
		System.assert(objMetadata.x_tag == null);
		System.assert(objMetadata.name == null);
		System.assert(objMetadata.path_lower == null);
		System.assert(objMetadata.path_display == null);
		System.assert(objMetadata.parent_shared_folder_id == null);
		System.assert(objMetadata.id == null);
		System.assert(objMetadata.client_modified == null);
		System.assert(objMetadata.server_modified == null);
		System.assert(objMetadata.rev == null);
		System.assert(objMetadata.size == null);
		System.assert(objMetadata.sharing_info == null);
		System.assert(objMetadata.is_downloadable == null);
		System.assert(objMetadata.content_hash == null);
	}
}