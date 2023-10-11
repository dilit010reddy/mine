/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   Drop Box API get metadata response JSON class test

@History:
*/
@IsTest
public class DBAPIgetmetadata_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    ".tag": "file",'+
		'    "name": "Prime_Numbers.txt",'+
		'    "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
		'    "client_modified": "2015-05-12T15:50:38Z",'+
		'    "server_modified": "2015-05-12T15:50:38Z",'+
		'    "rev": "a1c10ce0dd78",'+
		'    "size": 7212,'+
		'    "path_lower": "/homework/math/prime_numbers.txt",'+
		'    "path_display": "/Homework/math/Prime_Numbers.txt",'+
		'    "sharing_info": {'+
		'        "read_only": true,'+
		'        "parent_shared_folder_id": "84528192421",'+
		'        "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"'+
		'    },'+
		'    "is_downloadable": true,'+
		'    "property_groups": ['+
		'        {'+
		'            "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
		'            "fields": ['+
		'                {'+
		'                    "name": "Security Policy",'+
		'                    "value": "Confidential"'+
		'                }'+
		'            ]'+
		'        }'+
		'    ],'+
		'    "has_explicit_shared_members": false,'+
		'    "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",'+
		'    "file_lock_info": {'+
		'        "is_lockholder": true,'+
		'        "lockholder_name": "Imaginary User",'+
		'        "created": "2015-05-12T15:50:38Z"'+
		'    }'+
        '}';
        DBAPIgetmetadata r = new DBAPIgetmetadata();
        DBAPIgetmetadata.Fields tmpfields = new DBAPIgetmetadata.Fields();
        DBAPIgetmetadata.File_lock_info tmpfilelockinfo = new DBAPIgetmetadata.File_lock_info();
        DBAPIgetmetadata.Property_groups tmppropertygroups = new DBAPIgetmetadata.Property_groups();
        DBAPIgetmetadata.Sharing_info tmpsharinginfo = new DBAPIgetmetadata.Sharing_info();

		r = DBAPIgetmetadata.parse(json);
		System.assert(r != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIgetmetadata objDBAPIgetmetadata = new DBAPIgetmetadata(System.JSON.createParser(json));
		System.assert(objDBAPIgetmetadata != null);
		System.assert(objDBAPIgetmetadata.x_tag == null);
		System.assert(objDBAPIgetmetadata.name == null);
		System.assert(objDBAPIgetmetadata.id == null);
		System.assert(objDBAPIgetmetadata.client_modified == null);
		System.assert(objDBAPIgetmetadata.server_modified == null);
		System.assert(objDBAPIgetmetadata.rev == null);
		System.assert(objDBAPIgetmetadata.size == null);
		System.assert(objDBAPIgetmetadata.path_lower == null);
		System.assert(objDBAPIgetmetadata.path_display == null);
		System.assert(objDBAPIgetmetadata.sharing_info == null);
		System.assert(objDBAPIgetmetadata.is_downloadable == null);
		System.assert(objDBAPIgetmetadata.property_groups == null);
		System.assert(objDBAPIgetmetadata.has_explicit_shared_members == null);
		System.assert(objDBAPIgetmetadata.content_hash == null);
		System.assert(objDBAPIgetmetadata.file_lock_info == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIgetmetadata.Fields objFields = new DBAPIgetmetadata.Fields(System.JSON.createParser(json));
		System.assert(objFields != null);
		System.assert(objFields.name == null);
		System.assert(objFields.value == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIgetmetadata.File_lock_info objFile_lock_info = new DBAPIgetmetadata.File_lock_info(System.JSON.createParser(json));
		System.assert(objFile_lock_info != null);
		System.assert(objFile_lock_info.is_lockholder == null);
		System.assert(objFile_lock_info.lockholder_name == null);
		System.assert(objFile_lock_info.created == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIgetmetadata.Property_groups objProperty_groups = new DBAPIgetmetadata.Property_groups(System.JSON.createParser(json));
		System.assert(objProperty_groups != null);
		System.assert(objProperty_groups.template_id == null);
		System.assert(objProperty_groups.fields == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIgetmetadata.Sharing_info objSharing_info = new DBAPIgetmetadata.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.modified_by == null);
	}
}