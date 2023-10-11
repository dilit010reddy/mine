/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   API Class for CloudStorage get link input test

@History:
*/
@IsTest
public with sharing class CloudStoragegetlinkinput_TC {
    static testMethod void testMeth() {
		String json = '{'+
		'	\"recordId\": \"123456789012345678\",'+
		'	\"path\": \"/temppath/test.txt\"'+
		'}';
		CloudStoragegetlinkinput obj = new CloudStoragegetlinkinput();
        System.assert(obj != null);
        obj = new CloudStoragegetlinkinput('123456789012345678','/tmppath/test.txt');
        System.assert(obj != null);
	}
}