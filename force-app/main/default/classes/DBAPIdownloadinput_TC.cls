/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class for Dropbox API download input

@History:
*/

@IsTest
public class DBAPIdownloadinput_TC {
	
	static testMethod void testMeth() {
		String json = '{"path":"/thg_customers/test_customer4.txt","rev":"test"}';
		DBAPIdownloadinput obj = new DBAPIdownloadinput();
        System.assert(obj != null);
        obj = new DBAPIdownloadinput('/thg_customers/test_customer4.txt','test');
        System.assert(obj != null);
	}
}