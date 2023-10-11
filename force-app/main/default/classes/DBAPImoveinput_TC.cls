/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API move input test

@History:
*/
@IsTest
public class DBAPImoveinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'    \"from_path\": \"/thg_customers/test_customer4\",'+
		'    \"to_path\": \"/thg_customers/test_customer5\",'+
		'    \"allow_shared_folder\": false,'+
		'    \"autorename\": false,'+
		'    \"allow_ownership_transfer\": false'+
		'}';
		DBAPImoveinput obj = new DBAPImoveinput();
		System.assert(obj != null);
	}
}