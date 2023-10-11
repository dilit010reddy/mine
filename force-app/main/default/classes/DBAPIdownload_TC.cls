/*
@Author: P. Sutherland, Admins on Call
@Date: 11-10-2020
@Description:   API Class for Dropbox API download return.

@History:
*/

@IsTest
public class DBAPIdownload_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{"name": "sample.xlsx", "path_lower": "/thg_customers/test_customer/sample.xlsx", "path_display": "/THG_Customers/Test_Customer/sample.xlsx", "parent_shared_folder_id": "8593825504", "id": "id:CBh9W4LXJYIAAAAAAAAQDw", "client_modified": "2020-11-04T20:17:31Z", "server_modified": "2020-11-04T20:17:31Z", "rev": "015b34dab534b3900000002003b5ee0", "size": 10012, "sharing_info": {"read_only": false, "parent_shared_folder_id": "8593825504", "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"}, "is_downloadable": true, "content_hash": "a3fda19decfed5996a3e758825157a5b0d16a8d1a14617762e5c2614a490c2bf"}';
        DBAPIdownload r = new DBAPIdownload();
		r = DBAPIdownload.parse(json);
		r.filedata = Blob.valueOf('this is a blob');
		System.assert(r != null);



		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIdownload.Sharing_info objSharing_info = new DBAPIdownload.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.modified_by == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIdownload objDBAPIdownload = new DBAPIdownload(System.JSON.createParser(json));
		System.assert(objDBAPIdownload != null);
		System.assert(objDBAPIdownload.name == null);
		System.assert(objDBAPIdownload.path_lower == null);
		System.assert(objDBAPIdownload.path_display == null);
		System.assert(objDBAPIdownload.parent_shared_folder_id == null);
		System.assert(objDBAPIdownload.id == null);
		System.assert(objDBAPIdownload.client_modified == null);
		System.assert(objDBAPIdownload.server_modified == null);
		System.assert(objDBAPIdownload.rev == null);
		System.assert(objDBAPIdownload.size == null);
		System.assert(objDBAPIdownload.sharing_info == null);
		System.assert(objDBAPIdownload.is_downloadable == null);
		System.assert(objDBAPIdownload.content_hash == null);
	}
}