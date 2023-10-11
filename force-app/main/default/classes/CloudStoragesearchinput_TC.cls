/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   API Class for CloudStorage get link input test

@History:
*/
@IsTest
public with sharing class CloudStoragesearchinput_TC {
    static testMethod void testMeth() {
		String json = '{'+
        '	\"recordId\": \"123456789012345678\",'+
        '	\"search\": \"test\",'+
		'	\"path\": \"/temppath\"'+
		'}';
		CloudStoragesearchinput obj = new CloudStoragesearchinput();
        System.assert(obj != null);
        obj = new CloudStoragesearchinput('123456789012345678','test','/tmppath');
        System.assert(obj != null);
	}
}