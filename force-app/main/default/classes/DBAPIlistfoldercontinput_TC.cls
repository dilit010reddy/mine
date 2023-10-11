/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API list folder continue input test

@History:
*/
@IsTest
public class DBAPIlistfoldercontinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'    "cursor": "testaddddddddddd0000000000000000000000111111111111111111111"'+
		'}';
		DBAPIlistfoldercontinput obj = new DBAPIlistfoldercontinput();
        System.assert(obj != null);
        obj = new DBAPIlistfoldercontinput('testaddddddddddd0000000000000000000000111111111111111111111');
        System.assert(obj != null);
	}
}