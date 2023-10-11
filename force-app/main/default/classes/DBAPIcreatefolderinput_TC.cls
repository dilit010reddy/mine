/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class for Dropbox API createfolder input test.

@History:
*/
@IsTest
public class DBAPIcreatefolderinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'    \"path\": \"/thg_customers/test_customer4\",'+
		'    \"autorename\": false'+
		'}';
		DBAPIcreatefolderinput obj = new DBAPIcreatefolderinput();
		System.assert(obj != null);
		System.assert(obj.path == '');
		System.assert(obj.autorename == null);
	}
}