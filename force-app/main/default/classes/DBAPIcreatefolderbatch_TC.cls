/*
@Author: P. Sutherland, Admins on Call
@Date: 11-03-2020
@Description:   API Class for Dropbox API create_folder_batch return.

@History:
*/

@IsTest
public class DBAPIcreatefolderbatch_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  "async_job_id": "this is the id",'+
		'  ".tag": "complete",'+
		'  "entries": ['+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        "name": "test_customer2",'+
		'        "path_lower": "/thg_customers/test_customer2",'+
		'        "path_display": "/THG_Customers/test_customer2",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAAPOA",'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "traverse_only": false,'+
		'          "no_access": false'+
		'        }'+
		'      }'+
		'    },'+
		'{'+
        '    ".tag": "failure",'+
        '    "failure": {'+
        '        ".tag": "path",'+
        '        "path": {'+
        '            ".tag": "conflict",'+
        '            "conflict": {'+
        '               ".tag": "file"'+
        '            }'+
        '       }'+
        '    }'+
		'    },'+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        "name": "Invoices",'+
		'        "path_lower": "/thg_customers/test_customer2/invoices",'+
		'        "path_display": "/THG_Customers/test_customer2/Invoices",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAAPPA",'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "traverse_only": false,'+
		'          "no_access": false'+
		'        }'+
		'      }'+
		'    },'+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        "name": "1999",'+
		'        "path_lower": "/thg_customers/test_customer2/invoices/1999",'+
		'        "path_display": "/THG_Customers/test_customer2/Invoices/1999",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAAPPQ",'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "traverse_only": false,'+
		'          "no_access": false'+
		'        }'+
		'      }'+
		'    },'+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        "name": "2000",'+
		'        "path_lower": "/thg_customers/test_customer2/invoices/2000",'+
		'        "path_display": "/THG_Customers/test_customer2/Invoices/2000",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAAPPg",'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "traverse_only": false,'+
		'          "no_access": false'+
		'        }'+
		'      }'+
		'    },'+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        "name": "2001",'+
		'        "path_lower": "/thg_customers/test_customer2/invoices/2001",'+
		'        "path_display": "/THG_Customers/test_customer2/Invoices/2001",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAAPPw",'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "traverse_only": false,'+
		'          "no_access": false'+
		'        }'+
		'      }'+
		'    },'+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        "name": "forms",'+
		'        "path_lower": "/thg_customers/test_customer2/forms",'+
		'        "path_display": "/THG_Customers/test_customer2/forms",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAAPOQ",'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "traverse_only": false,'+
		'          "no_access": false'+
		'        }'+
		'      }'+
		'    },'+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        "name": "Legal",'+
		'        "path_lower": "/thg_customers/test_customer2/forms/legal",'+
		'        "path_display": "/THG_Customers/test_customer2/forms/Legal",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAAPOw",'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "traverse_only": false,'+
		'          "no_access": false'+
		'        }'+
		'      }'+
		'    },'+
		'    {'+
		'      ".tag": "success",'+
		'      "metadata": {'+
		'        "name": "Formation",'+
		'        "path_lower": "/thg_customers/test_customer2/forms/formation",'+
		'        "path_display": "/THG_Customers/test_customer2/forms/Formation",'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "id": "id:CBh9W4LXJYIAAAAAAAAPOg",'+
		'        "sharing_info": {'+
		'          "read_only": false,'+
		'          "parent_shared_folder_id": "8593825504",'+
		'          "traverse_only": false,'+
		'          "no_access": false'+
		'        }'+
		'      }'+
		'    }'+
		'  ]'+
		'}';
		DBAPIcreatefolderbatch r = new DBAPIcreatefolderbatch();
		r = DBAPIcreatefolderbatch.parse(json);
		System.assert(r != null);
		System.debug('rs entries size: ' + r.entries.size());
		System.debug('rs entries: ' + r.entries);
		DBAPIcreatefolderbatch.Entries tstentries = new DBAPIcreatefolderbatch.Entries();
		DBAPIcreatefolderbatch.Metadata tstmetadata = new DBAPIcreatefolderbatch.Metadata();
		DBAPIcreatefolderbatch.Sharing_info tstshare = new DBAPIcreatefolderbatch.Sharing_info();
        
        String json2 = '{'+
		'    ".tag": "async_job_id",'+
		'    "async_job_id": "34g93hh34h04y384084"'+
		'}';
		DBAPIcreatefolderbatch r2 = DBAPIcreatefolderbatch.parse(json2);
        System.assert(r2 != null);
        
        String json3 = '{'+
		'    ".tag": "other"'+
		'}';
		DBAPIcreatefolderbatch r3 = DBAPIcreatefolderbatch.parse(json3);
		System.assert(r3 != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIcreatefolderbatch objDBAPIcreatefolderbatch = new DBAPIcreatefolderbatch(System.JSON.createParser(json));
		System.assert(objDBAPIcreatefolderbatch != null);
		System.assert(objDBAPIcreatefolderbatch.x_tag == null);
		System.assert(objDBAPIcreatefolderbatch.entries == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIcreatefolderbatch.Sharing_info objSharing_info = new DBAPIcreatefolderbatch.Sharing_info(System.JSON.createParser(json));
		System.assert(objSharing_info != null);
		System.assert(objSharing_info.read_only == null);
		System.assert(objSharing_info.parent_shared_folder_id == null);
		System.assert(objSharing_info.traverse_only == null);
		System.assert(objSharing_info.no_access == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIcreatefolderbatch.Metadata objMetadata = new DBAPIcreatefolderbatch.Metadata(System.JSON.createParser(json));
		System.assert(objMetadata != null);
		System.assert(objMetadata.name == null);
		System.assert(objMetadata.path_lower == null);
		System.assert(objMetadata.path_display == null);
		System.assert(objMetadata.parent_shared_folder_id == null);
		System.assert(objMetadata.id == null);
		System.assert(objMetadata.sharing_info == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPIcreatefolderbatch.Entries objEntries = new DBAPIcreatefolderbatch.Entries(System.JSON.createParser(json));
		System.assert(objEntries != null);
		System.assert(objEntries.x_tag == null);
		System.assert(objEntries.metadata == null);

		//testing constructor
		DBAPIcreatefolderbatch.CustomFailure constructedCustomFailure = new DBAPIcreatefolderbatch.CustomFailure();
	}
}