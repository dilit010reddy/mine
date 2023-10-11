/*
@Author: P. Sutherland, Admins on Call
@Date: 11-20-2020
@Description:   API Class move batch check input

@History:
*/

@IsTest
public class DBAPImovebatchcheck_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    ".tag": "complete",'+
		'    "entries": ['+
		'        {'+
		'            ".tag": "success",'+
		'            "success": {'+
		'                ".tag": "file",'+
		'                "name": "Prime_Numbers.txt",'+
		'                "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
		'                "client_modified": "2015-05-12T15:50:38Z",'+
		'                "server_modified": "2015-05-12T15:50:38Z",'+
		'                "rev": "a1c10ce0dd78",'+
		'                "size": 7212,'+
		'                "path_lower": "/homework/math/prime_numbers.txt",'+
		'                "path_display": "/Homework/math/Prime_Numbers.txt",'+
		'                "sharing_info": {'+
		'                    "read_only": true,'+
		'                    "parent_shared_folder_id": "84528192421",'+
		'                    "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"'+
		'                },'+
		'                "is_downloadable": true,'+
		'                "property_groups": ['+
		'                    {'+
		'                        "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
		'                        "fields": ['+
		'                            {'+
		'                                "name": "Security Policy",'+
		'                                "value": "Confidential"'+
		'                            }'+
		'                        ]'+
		'                    }'+
		'                ],'+
		'                "has_explicit_shared_members": false,'+
		'                "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",'+
		'                "file_lock_info": {'+
		'                    "is_lockholder": true,'+
		'                    "lockholder_name": "Imaginary User",'+
		'                    "created": "2015-05-12T15:50:38Z"'+
		'                }'+
		'            }'+
		'        }'+
		'    ]'+
		'}';
		DBAPImovebatchcheck r = new DBAPImovebatchcheck(); 
		r = DBAPImovebatchcheck.parse(json);
		System.assert(r != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatchcheck objDBAPImovebatchcheck = new DBAPImovebatchcheck(System.JSON.createParser(json));
		System.assert(objDBAPImovebatchcheck != null);
		System.assert(objDBAPImovebatchcheck.x_tag == null);
		System.assert(objDBAPImovebatchcheck.entries == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatchcheck.Fields objFields = new DBAPImovebatchcheck.Fields(System.JSON.createParser(json));
		System.assert(objFields != null);
		System.assert(objFields.name == null);
		System.assert(objFields.value == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatchcheck.File_lock_info objFile_lock_info = new DBAPImovebatchcheck.File_lock_info(System.JSON.createParser(json));
		System.assert(objFile_lock_info != null);
		System.assert(objFile_lock_info.is_lockholder == null);
		System.assert(objFile_lock_info.lockholder_name == null);
		System.assert(objFile_lock_info.created == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatchcheck.Property_groups objProperty_groups = new DBAPImovebatchcheck.Property_groups(System.JSON.createParser(json));
		System.assert(objProperty_groups != null);
		System.assert(objProperty_groups.template_id == null);
		System.assert(objProperty_groups.fields == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatchcheck.Sharing_info objSharing_info = new DBAPImovebatchcheck.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.modified_by == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatchcheck.Entries objEntries = new DBAPImovebatchcheck.Entries(System.JSON.createParser(json));
		System.assert(objEntries != null);
		System.assert(objEntries.x_tag == null);
		System.assert(objEntries.success == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatchcheck.Success objSuccess = new DBAPImovebatchcheck.Success(System.JSON.createParser(json));
		System.assert(objSuccess != null);
		System.assert(objSuccess.x_tag == null);
		System.assert(objSuccess.name == null);
		System.assert(objSuccess.id == null);
		System.assert(objSuccess.client_modified == null);
		System.assert(objSuccess.server_modified == null);
		System.assert(objSuccess.rev == null);
		System.assert(objSuccess.size == null);
		System.assert(objSuccess.path_lower == null);
		System.assert(objSuccess.path_display == null);
		System.assert(objSuccess.sharing_info == null);
		System.assert(objSuccess.is_downloadable == null);
		System.assert(objSuccess.property_groups == null);
		System.assert(objSuccess.has_explicit_shared_members == null);
		System.assert(objSuccess.content_hash == null);
		System.assert(objSuccess.file_lock_info == null);
	}

	static testMethod void testConstructors() { //tests constructors for CursorInput, APIPathRoot, AsyncoutputInput and the functions setOtherError() and generatecursor()
		//Start the Testing
		Test.startTest();
		
		DBAPImovebatchcheck.Fields constructedFields = new DBAPImovebatchcheck.Fields();

		DBAPImovebatchcheck.File_lock_info constructedFile_lock_info = new DBAPImovebatchcheck.File_lock_info();

		DBAPImovebatchcheck.Property_groups constructedProperty_groups = new DBAPImovebatchcheck.Property_groups();

		DBAPImovebatchcheck.Sharing_info constructedSharing_info = new DBAPImovebatchcheck.Sharing_info();

		DBAPImovebatchcheck.Entries constructedEntries = new DBAPImovebatchcheck.Entries();

		DBAPImovebatchcheck.Success constructedSuccess = new DBAPImovebatchcheck.Success();

		//DBAPImovebatchcheck.CustomFailure constructedfailure = new DBAPImovebatchcheck.CustomFailure();

		Test.stopTest(); 
	}
}