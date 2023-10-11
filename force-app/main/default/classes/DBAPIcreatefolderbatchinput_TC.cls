/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API createfolder batch input test

@History:
*/
@IsTest
public class DBAPIcreatefolderbatchinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'    \"paths\": ['+
		'        \"/thg_customers/test_customer4\"'+
		'    ],'+
		'    \"autorename\": false,'+
		'    \"force_async\": false'+
		'}';
		DBAPIcreatefolderbatchinput obj = new DBAPIcreatefolderbatchinput();
		System.assert(obj != null);
	}
}