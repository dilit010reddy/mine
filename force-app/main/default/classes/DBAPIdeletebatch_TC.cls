/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class delete batch test

@History:
*/
@IsTest
public class DBAPIdeletebatch_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  ".tag": "async_job_id",'+
		'  "async_job_id": "dbjid:AADjhFP1iVehathQQMzwfoBKETWcaUqjGHoJ2yuxJVXLoM6AW-sctEKYSCVLT3c7GaSb4Rk59Z2qWh7_BCr_2_RA",'+
		'  "entries": ['+
		'{'+
		'            ".tag": "failure",'+
		'            "failure": {'+
		'                ".tag": "path_lookup",'+
		'                "path_lookup": {'+
		'                    ".tag": "not_found"'+
		'                }'+
		'            }'+
		'        },'+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        ".tag": "file",'+
		'        "name": "deleteme.txt",'+
		'        "path_lower": "/thg_customers/test_customer2/forms/formation/deleteme.txt",'+
		'        "path_display": "/THG_Customers/test_customer2/forms/Formation/deleteme.txt",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAATUg",'+
		'        "client_modified": "2020-11-16T20:17:22Z",'+
		'        "server_modified": "2020-11-16T20:18:01Z",'+
		'        "rev": "015b43f1337151e00000002003b5ee0",'+
		'        "size": 37,'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
		'        },'+
		'        "is_downloadable": true,'+
		'        "content_hash": "5bd83a7b93b9139208e6f06a52a0a42b4aa55cd8c8e604c28f6fc6e8780921c6"'+
		'      }'+
		'    }'+
		'  ]'+
		'}';
		DBAPIdeletebatch r = DBAPIdeletebatch.parse(json);
		System.assert(r != null);
		//System.debug('rs entries size: ' + r.entries.size());
		//System.debug('rs entries: ' + r.entries);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIdeletebatch.Sharing_info objSharing_info = new DBAPIdeletebatch.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.modified_by == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIdeletebatch.Metadata objMetadata = new DBAPIdeletebatch.Metadata(System.JSON.createParser(json));
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

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIdeletebatch.Entries objEntries = new DBAPIdeletebatch.Entries(System.JSON.createParser(json));
		System.assert(objEntries != null);
		System.assert(objEntries.x_tag == null);
		System.assert(objEntries.metadata == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIdeletebatch objDBAPIdeletebatch = new DBAPIdeletebatch(System.JSON.createParser(json));
		System.assert(objDBAPIdeletebatch != null);
		System.assert(objDBAPIdeletebatch.x_tag == null);
		System.assert(objDBAPIdeletebatch.async_job_id == null);
		System.assert(objDBAPIdeletebatch.entries == null);

		DBAPIdeletebatch constructedDeleteBatch = new DBAPIdeletebatch();
		System.assert(constructedDeleteBatch.x_tag == '');
		System.assert(constructedDeleteBatch.async_job_id == '');
		System.assert(constructedDeleteBatch.entries != null);

		DBAPIdeletebatch.Sharing_info constructedSharingInfo = new DBAPIdeletebatch.Sharing_info();
		System.assert(constructedSharingInfo.read_only == false);
		System.assert(constructedSharingInfo.parent_shared_folder_id == '');
		System.assert(constructedSharingInfo.modified_by == '');

		DBAPIdeletebatch.Metadata constructedMetadata = new DBAPIdeletebatch.Metadata();
		System.assert(constructedMetadata.x_tag == '');
		System.assert(constructedMetadata.name == '');
		System.assert(constructedMetadata.path_lower == '');
		System.assert(constructedMetadata.path_display == '');
		System.assert(constructedMetadata.parent_shared_folder_id == '');
		System.assert(constructedMetadata.id == '');
		System.assert(constructedMetadata.client_modified == '');
		System.assert(constructedMetadata.server_modified == '');
		System.assert(constructedMetadata.rev == '');
		System.assert(constructedMetadata.size == 0);
		System.assert(constructedMetadata.sharing_info != null);
		System.assert(constructedMetadata.is_downloadable == false);
		System.assert(constructedMetadata.content_hash == '');

		DBAPIdeletebatch.Entries constructedEntries = new DBAPIdeletebatch.Entries();
		System.assert(constructedEntries.x_tag == '');
		System.assert(constructedEntries.metadata != null);

		//testing constructor
		DBAPIdeletebatch.CustomFailure constructedfailure = new DBAPIdeletebatch.CustomFailure();



	}
}