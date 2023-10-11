/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class move batch input test

@History:
*/
@IsTest
public class DBAPImovebatchinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'    \"entries\": ['+
		'        {'+
		'            \"from_path\": \"/thg_customers/test_customer2/forms/formation\",'+
		'            \"to_path\": \"/thg_customers/test_customer2/forms/formation\"'+
		'        }'+
		'    ],'+
		'    \"autorename\": false,'+
		'    \"allow_ownership_transfer\": false'+
		'}';
		DBAPImovebatchinput obj = new DBAPImovebatchinput();
		System.assert(obj != null);

		DBAPImovebatchinput.Entries constructedEntries = new DBAPImovebatchinput.Entries();
		System.assert(constructedEntries.from_path == '');
		System.assert(constructedEntries.to_path == '');


		String toPath = 'toPath';
		String fromPath = 'fromPath';
		DBAPImovebatchinput.Entries constructedEntries2 = new DBAPImovebatchinput.Entries(fromPath, toPath);
		System.assert(constructedEntries2.to_path == 'toPath');
		System.assert(constructedEntries2.from_path == 'fromPath');
	}
}