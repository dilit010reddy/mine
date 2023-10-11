/*
@Author: P. Sutherland, Admins on Call
@Date: 11-05-2020
@Description:   API Class for Dropbox API download return.

@History:
*/

@IsTest
public class DBAPIdelete_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"metadata\": {'+
		'        \".tag\": \"file\",'+
		'        \"name\": \"Prime_Numbers.txt\",'+
		'        \"id\": \"id:a4ayc_80_OEAAAAAAAAAXw\",'+
		'        \"client_modified\": \"2015-05-12T15:50:38Z\",'+
		'        \"server_modified\": \"2015-05-12T15:50:38Z\",'+
		'        \"rev\": \"a1c10ce0dd78\",'+
		'        \"size\": 7212,'+
		'        \"path_lower\": \"/homework/math/prime_numbers.txt\",'+
		'        \"path_display\": \"/Homework/math/Prime_Numbers.txt\",'+
		'        \"sharing_info\": {'+
		'            \"read_only\": true,'+
		'            \"parent_shared_folder_id\": \"84528192421\",'+
		'            \"modified_by\": \"dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc\"'+
		'        },'+
		'        \"is_downloadable\": true,'+
		'        \"property_groups\": ['+
		'            {'+
		'                \"template_id\": \"ptid:1a5n2i6d3OYEAAAAAAAAAYa\",'+
		'                \"fields\": ['+
		'                    {'+
		'                        \"name\": \"Security Policy\",'+
		'                        \"value\": \"Confidential\"'+
		'                    }'+
		'                ]'+
		'            }'+
		'        ],'+
		'        \"has_explicit_shared_members\": false,'+
		'        \"content_hash\": \"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\",'+
		'        \"file_lock_info\": {'+
		'            \"is_lockholder\": true,'+
		'            \"lockholder_name\": \"Imaginary User\",'+
		'            \"created\": \"2015-05-12T15:50:38Z\"'+
		'        }'+
		'    }'+
        '}';
        DBAPIdelete r = new DBAPIdelete();
		r = DBAPIdelete.parse(json);
		System.assert(r != null);
		DBAPIDelete.Fields tstfields = new DBAPIDelete.Fields();

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPIdelete.Fields objFields = new DBAPIdelete.Fields(System.JSON.createParser(json));
		System.assert(objFields != null);
		System.assert(objFields.name == null);
		System.assert(objFields.value == null);

		/*json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPIdelete.Property_groups objProperty_groups = new DBAPIdelete.Property_groups(System.JSON.createParser(json));
		System.assert(objProperty_groups.template_id != '');
		System.assert(objProperty_groups.fields == null);*/
		
		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPIdelete.File_lock_info objFile_lock_info = new DBAPIdelete.File_lock_info(System.JSON.createParser(json));
		System.assert(objFile_lock_info != null);
		System.assert(objFile_lock_info.is_lockholder == null);
		System.assert(objFile_lock_info.lockholder_name == null);
		System.assert(objFile_lock_info.created == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPIdelete.Property_groups objProperty_groups = new DBAPIdelete.Property_groups(System.JSON.createParser(json));
		System.assert(objProperty_groups != null);
		System.assert(objProperty_groups.template_id == null);
		System.assert(objProperty_groups.fields == null);

		DBAPIdelete.Property_groups constructedPropertyGroup = new DBAPIdelete.Property_groups();

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPIdelete.Sharing_info objSharing_info = new DBAPIdelete.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.modified_by == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPIdelete.Metadata objMetadata = new DBAPIdelete.Metadata(System.JSON.createParser(json));
		System.assert(objMetadata != null);
		System.assert(objMetadata.x_tag == null);
		System.assert(objMetadata.name == null);
		System.assert(objMetadata.id == null);
		System.assert(objMetadata.client_modified == null);
		System.assert(objMetadata.server_modified == null);
		System.assert(objMetadata.rev == null);
		System.assert(objMetadata.size == null);
		System.assert(objMetadata.path_lower == null);
		System.assert(objMetadata.path_display == null);
		System.assert(objMetadata.sharing_info == null);
		System.assert(objMetadata.is_downloadable == null);
		System.assert(objMetadata.property_groups == null);
		System.assert(objMetadata.has_explicit_shared_members == null);
		System.assert(objMetadata.content_hash == null);
		System.assert(objMetadata.file_lock_info == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		DBAPIdelete objDBAPIdelete = new DBAPIdelete(System.JSON.createParser(json));
		System.assert(objDBAPIdelete != null);
		System.assert(objDBAPIdelete.metadata == null);
	}
}