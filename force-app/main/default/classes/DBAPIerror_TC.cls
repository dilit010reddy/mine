/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API generic error return.

@History:
1/12/2021 P Sutherland Added the correct_offest node for error trapping on upload session
*/

@IsTest
public class DBAPIerror_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  "error_summary": "path/conflict/folder/..",'+
		'  "error": {'+
		'    ".tag": "path",'+
		'    "correct_offset": 101,'+
		'    "path": {'+
		'      ".tag": "conflict",'+
		'      "conflict": {'+
		'        ".tag": "folder"'+
		'      }'+
		'    }'+
		'  }'+
		'}';
		DBAPIerror r = new DBAPIerror();
		r = DBAPIerror.parse(json);
		System.assert(r != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIerror.Path objPath = new DBAPIerror.Path(System.JSON.createParser(json));
		System.assert(objPath != null);
		System.assert(objPath.x_tag == null);
		System.assert(objPath.conflict == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIerror objDBAPIerror = new DBAPIerror(System.JSON.createParser(json));
		System.assert(objDBAPIerror != null);
		System.assert(objDBAPIerror.error_summary == null);
		System.assert(objDBAPIerror.error == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIerror.Conflict objConflict = new DBAPIerror.Conflict(System.JSON.createParser(json));
		System.assert(objConflict != null);
		System.assert(objConflict.x_tag == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIerror.Error objError = new DBAPIerror.Error(System.JSON.createParser(json));
		System.assert(objError != null);
		System.assert(objError.x_tag == null);
		System.assert(objError.path == null);
	}
}