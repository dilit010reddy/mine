/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class for Dropbox API delete input test

@History:
*/
@IsTest
public class DBAPIdeleteinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'    \"path\": \"/thg_customers/test_customer4\",'+
		'    \"autorename\": false'+
		'}';
		DBAPIdeleteinput obj = new DBAPIdeleteinput();
		System.assert(obj != null);
	}
}