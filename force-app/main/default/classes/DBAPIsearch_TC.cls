/*
@Author: P. Sutherland, Admins on Call
@Date: 11-24-2020
@Description:   Drop Box API search JSON class test

@History:
*/
@IsTest
public class DBAPIsearch_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    "matches": ['+
		'        {'+
		'      		 "match_type": {'+
		'        		 ".tag": "filename_and_content"'+
		'      		 },'+
		'            "metadata": {'+
		'                ".tag": "metadata",'+
		'                "metadata": {'+
		'                    ".tag": "file",'+
		'                    "name": "Prime_Numbers.txt",'+
		'                    "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
		'                    "client_modified": "2015-05-12T15:50:38Z",'+
		'                    "server_modified": "2015-05-12T15:50:38Z",'+
		'                    "rev": "a1c10ce0dd78",'+
		'                    "size": 7212,'+
		'                    "path_lower": "/homework/math/prime_numbers.txt",'+
		'                    "path_display": "/Homework/math/Prime_Numbers.txt",'+
		'                    "sharing_info": {'+
		'               		 "is_parent_shared_folder_read_only": false,'+
		'            			 "no_access": false,'+
		'                        "read_only": true,'+
		'                        "parent_shared_folder_id": "84528192421",'+
		'                        "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc",'+
		'            			 "traverse_only": false'+
		'                    },'+
		'                    "is_downloadable": true,'+
		'                    "property_groups": ['+
		'                        {'+
		'                            "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
		'                            "fields": ['+
		'                                {'+
		'                                    "name": "Security Policy",'+
		'                                    "value": "Confidential"'+
		'                                }'+
		'                            ]'+
		'                        }'+
		'                    ],'+
		'                    "has_explicit_shared_members": false,'+
		'                    "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",'+
		'                    "file_lock_info": {'+
		'                        "is_lockholder": true,'+
		'                        "lockholder_name": "Imaginary User",'+
		'                        "created": "2015-05-12T15:50:38Z"'+
		'                    }'+
		'                }'+
		'            }'+
		'        }'+
		'    ],'+
		'    "cursor": "ZtkX9_EHj3x7PMkVuFIhwKYXEpwpLwyxp9vMKomUhllil9q7eWiAu",'+
		'    "has_more": false'+
        '}';
        DBAPIsearch r = new DBAPIsearch();
		r = DBAPIsearch.parse(json);
		System.assert(r != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch.Fields objFields = new DBAPIsearch.Fields(System.JSON.createParser(json));
		System.assert(objFields != null);
		System.assert(objFields.name == null);
		System.assert(objFields.value == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch.File_lock_info objFile_lock_info = new DBAPIsearch.File_lock_info(System.JSON.createParser(json));
		System.assert(objFile_lock_info != null);
		System.assert(objFile_lock_info.is_lockholder == null);
		System.assert(objFile_lock_info.lockholder_name == null);
		System.assert(objFile_lock_info.created == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch.Property_groups objProperty_groups = new DBAPIsearch.Property_groups(System.JSON.createParser(json));
		System.assert(objProperty_groups != null);
		System.assert(objProperty_groups.template_id == null);
		System.assert(objProperty_groups.fields == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch.Matches objMatches = new DBAPIsearch.Matches(System.JSON.createParser(json));
		System.assert(objMatches != null);
		System.assert(objMatches.metadata == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch.Sharing_info objSharing_info = new DBAPIsearch.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.modified_by == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch.Metadata_Z objMetadata_Z = new DBAPIsearch.Metadata_Z(System.JSON.createParser(json));
		System.assert(objMetadata_Z != null);
		System.assert(objMetadata_Z.x_tag == null);
		System.assert(objMetadata_Z.metadata == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch.Metadata objMetadata = new DBAPIsearch.Metadata(System.JSON.createParser(json));
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

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch objDBAPIsearch = new DBAPIsearch(System.JSON.createParser(json));
		System.assert(objDBAPIsearch != null);
		System.assert(objDBAPIsearch.matches == null);
		System.assert(objDBAPIsearch.cursor == null);
		System.assert(objDBAPIsearch.has_more == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIsearch.Match_type objMatch_type = new DBAPIsearch.Match_type(System.JSON.createParser(json));
		System.assert(objMatch_type != null);
		System.assert(objMatch_type.x_tag == null);

		DBAPIsearch.Match_type constructedMatch_type = new DBAPIsearch.Match_type();
		System.assert(constructedMatch_type.x_tag == '');

		DBAPIsearch.Fields constructedFields = new DBAPIsearch.Fields();
		System.assert(constructedFields.name == '');
		System.assert(constructedFields.value == '');

		DBAPIsearch.File_lock_info constructedFile_lock_info = new DBAPIsearch.File_lock_info();
		System.assert(constructedFile_lock_info.lockholder_name == '');
		System.assert(constructedFile_lock_info.created == '');
		System.assert(constructedFile_lock_info.is_lockholder == false);

		DBAPIsearch.Property_groups constructedProperty_groups = new DBAPIsearch.Property_groups();
		System.assert(constructedProperty_groups.template_id == '');
		System.assert(constructedProperty_groups.fields != null);
		
		DBAPIsearch.Matches constructedMatches = new DBAPIsearch.Matches();
		System.assert(constructedMatches.match_type != null);
		System.assert(constructedMatches.metadata != null);

		DBAPIsearch.Sharing_info constructedSharing_info = new DBAPIsearch.Sharing_info();
		System.assert(constructedSharing_info.modified_by == '');
		System.assert(constructedSharing_info.parent_shared_folder_id == '');
		System.assert(constructedSharing_info.is_parent_shared_folder_read_only == false);
		System.assert(constructedSharing_info.traverse_only == false);
		System.assert(constructedSharing_info.read_only == false);
		System.assert(constructedSharing_info.no_access == false);

		DBAPIsearch.Metadata constructedMetadata = new DBAPIsearch.Metadata();
		System.assert(constructedMetadata.x_tag == '');
		System.assert(constructedMetadata.name == '');
		System.assert(constructedMetadata.id == '');
		System.assert(constructedMetadata.client_modified == '');
		System.assert(constructedMetadata.server_modified == '');
		System.assert(constructedMetadata.rev == '');
		System.assert(constructedMetadata.size == 0);
		System.assert(constructedMetadata.path_lower == '');
		System.assert(constructedMetadata.path_display == '');
		System.assert(constructedMetadata.sharing_info != null);
		System.assert(constructedMetadata.is_downloadable == false);
		System.assert(constructedMetadata.property_groups != null);
		System.assert(constructedMetadata.has_explicit_shared_members == false);
		System.assert(constructedMetadata.content_hash == '');
		System.assert(constructedMetadata.file_lock_info != null);

		DBAPIsearch.Metadata_Z constructedMetadata_Z = new DBAPIsearch.Metadata_Z();
		System.assert(constructedMetadata_Z.x_tag == '');
		System.assert(constructedMetadata_Z.metadata != null);
	}
}