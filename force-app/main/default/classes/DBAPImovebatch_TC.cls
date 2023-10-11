/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   Move batch API response parse routine test

@History:
*/

@IsTest
public class DBAPImovebatch_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParseAsync() {
		String json = '{'+
		'  ".tag": "async_job_id",'+
		'  "async_job_id": "dbjid:AADjKDZ_lYuPZ9kGKJ1Ex2EwS9GH2Vfu5ItZgCVtOohFIRs_BO2SXzGunvkAIUH13VEB8Bv1f40IvvIRwvDukuDz"'+
        '}';
        DBAPImovebatch r2 = new DBAPImovebatch();
		r2 = DBAPImovebatch.parse(json);
		System.assert(r2 != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch objDBAPImovebatch = new DBAPImovebatch(System.JSON.createParser(json));
		System.assert(objDBAPImovebatch != null);
		System.assert(objDBAPImovebatch.x_tag == null);
		System.assert(objDBAPImovebatch.async_job_id == null);
	}
	
	static testMethod void testParseInProcess() {
		String json = '{'+
		'  ".tag": "in_progress" }';
        DBAPImovebatch r2 = new DBAPImovebatch();
		r2 = DBAPImovebatch.parse(json);
		System.assert(r2 != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch objDBAPImovebatch = new DBAPImovebatch(System.JSON.createParser(json));
		System.assert(objDBAPImovebatch != null);
		System.assert(objDBAPImovebatch.x_tag == null);
		System.assert(objDBAPImovebatch.async_job_id == null);
	}

	static testMethod void testParse() {
		String json = '{'+
		'    ".tag": "complete",'+
		'    "entries": ['+
		'   		{ '+
        '   		".tag": "failure", '+
        '    		"failure": { '+
        '       	".tag": "relocation_error", '+
        '   		 		"relocation_error": { '+
        '            		".tag": "duplicated_or_nested_paths" '+
        '        			} '+
        '          	} '+
		' 			},'+ 
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
		'        },'+
		'{'+
        '	".tag": "failure",'+
        '	"failure": {'+
        '		".tag": "relocation_error",'+
        '		"relocation_error": {'+
        '			".tag": "from_lookup",'+
        '			"from_lookup": { '+
        '				".tag": "not_found"'+
        '           	 }'+
        '       	 }'+
		'		}'+
		'}'+ 
		'    ]'+
		'}';
		DBAPImovebatch r2 = new DBAPImovebatch();
		r2 = DBAPImovebatch.parse(json);
		System.assert(r2 != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch.Fields objFields = new DBAPImovebatch.Fields(System.JSON.createParser(json));
		System.assert(objFields != null);
		System.assert(objFields.name == null);
		System.assert(objFields.value == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch.File_lock_info objFile_lock_info = new DBAPImovebatch.File_lock_info(System.JSON.createParser(json));
		System.assert(objFile_lock_info != null);
		System.assert(objFile_lock_info.is_lockholder == null);
		System.assert(objFile_lock_info.lockholder_name == null);
		System.assert(objFile_lock_info.created == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch.Property_groups objProperty_groups = new DBAPImovebatch.Property_groups(System.JSON.createParser(json));
		System.assert(objProperty_groups != null);
		System.assert(objProperty_groups.template_id == null);
		System.assert(objProperty_groups.fields == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch.Sharing_info objSharing_info = new DBAPImovebatch.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.modified_by == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch.Entries objEntries = new DBAPImovebatch.Entries(System.JSON.createParser(json));
		System.assert(objEntries != null);
		System.assert(objEntries.x_tag == null);
		System.assert(objEntries.success == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch objDBAPImovebatch = new DBAPImovebatch(System.JSON.createParser(json));
		System.assert(objDBAPImovebatch != null);
		System.assert(objDBAPImovebatch.x_tag == null);
		System.assert(objDBAPImovebatch.entries == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch.Success objSuccess = new DBAPImovebatch.Success(System.JSON.createParser(json));
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

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch.CustomFailure objFailure = new DBAPImovebatch.CustomFailure(System.JSON.createParser(json));

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImovebatch.Failure Failure = new DBAPImovebatch.Failure(System.JSON.createParser(json));

	}

	static testMethod void testConstructors() { //tests constructors for CursorInput, APIPathRoot, AsyncoutputInput and the functions setOtherError() and generatecursor()
		//Start the Testing
		Test.startTest();
		
		DBAPImovebatch.Fields constructedFields = new DBAPImovebatch.Fields();

		DBAPImovebatch.File_lock_info constructedFile_lock_info = new DBAPImovebatch.File_lock_info();

		DBAPImovebatch.Property_groups constructedProperty_groups = new DBAPImovebatch.Property_groups();

		DBAPImovebatch.Sharing_info constructedSharing_info = new DBAPImovebatch.Sharing_info();

		DBAPImovebatch.Entries constructedEntries = new DBAPImovebatch.Entries();

		DBAPImovebatch.Success constructedSuccess = new DBAPImovebatch.Success();

		DBAPImovebatch.CustomFailure constructedfailure = new DBAPImovebatch.CustomFailure();

		Test.stopTest(); 
	}
}