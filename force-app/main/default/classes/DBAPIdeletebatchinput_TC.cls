/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class delete batch input test

@History:
*/

@IsTest
public class DBAPIdeletebatchinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'    \"entries\": ['+
		'        {'+
		'            \"path\": \"/thg_customers/test_customer2/forms/formation/deleteme.txt\",'+
		'            \"parent_rev\": \"tmp\"'+
		'        }'+
		'    ]'+
        '}';
		DBAPIdeletebatchinput obj = new DBAPIdeletebatchinput();
		System.assert(obj != null);
		DBAPIdeletebatchinput.Entries tstentries = new DBAPIdeletebatchinput.Entries();

		String path = 'path';
		String parent_rev = 'parent_rev';
		DBAPIdeletebatchinput.Entries testEntries = new DBAPIdeletebatchinput.Entries(path, parent_rev);
	}
}