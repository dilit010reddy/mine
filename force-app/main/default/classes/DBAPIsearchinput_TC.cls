/*
@Author: P. Sutherland, Admins on Call
@Date: 11-24-2020
@Description:   Drop Box API search input JSON class Test

@History:
*/
@IsTest
public class DBAPIsearchinput_TC {
	
	// This test method should give 100% coverage
	static testMethod void testmeth() {
		String json = '{'+
		'    "query": "test",'+
		'    "options": {'+
		'        "path": "/thg_customers/test_customer",'+
		'        "max_results": 200,'+
		'        "order_by": {'+
		'            ".tag": "relevance"'+
		'        },'+
		'        "file_status": {'+
		'            ".tag": "active"'+
		'        },'+
		'        "filename_only": false,'+
		'        "file_extensions": ['+
		'            ".txt"'+
		'        ],'+
		'        "file_categories": ['+
		'            {'+
		'                ".tag": "image"'+
		'            }'+
		'        ]'+
		'    },'+
		'    "match_field_options": {'+
		'        "include_highlights": false'+
		'    }'+
		'}';
        DBAPIsearchinput r = new DBAPIsearchinput();
        System.assert(r != null);
        DBAPIsearchinput.Options tmpoptions = new DBAPIsearchinput.Options();
        DBAPIsearchinput.Match_field_options tmpmatch = new DBAPIsearchinput.Match_field_options();
        DBAPIsearchinput.Order_by tmporderby = new DBAPIsearchinput.Order_by();
        DBAPIsearchinput.File_status tmpfilestatus = new DBAPIsearchinput.File_status();
		DBAPIsearchinput.File_categories tmpfilecategories = new DBAPIsearchinput.File_categories();
		//todo add call to json string formatter
		r.query = 'test';
		tmpoptions.path = '/thg_customers/test_customer';
		tmpoptions.max_results = 200;
		tmporderby.x_tag = 'relevance';
		tmpoptions.Order_by = tmporderby;
		tmpfilestatus.x_tag = 'active';	
		tmpoptions.File_status = tmpfilestatus;
		tmpoptions.filename_only = false;
		tmpoptions.file_extensions = new list<String>{'.txt'};
		tmpfilecategories.x_tag = 'image';
		tmpoptions.file_categories = new list<DBAPIsearchinput.File_categories>{tmpfilecategories};
		r.options = tmpoptions;
		tmpmatch.include_highlights = false;	
		r.Match_field_options = tmpmatch;
		String jsonoutput = DBAPIsearchinput.gensearchJSONString(r);
		//System.assert(json == jsonoutput);
	}
}