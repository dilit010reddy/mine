/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   API Class for CloudStorage get temporary link input test

@History:
*/
@IsTest
public with sharing class CloudStoragegettemporarylinkinput_TC {
    static testMethod void testMeth() {
		String json = '{'+
		'	\"recordId\": \"123456789012345678\",'+
		'	\"path\": \"/temppath/\"'+
		'}';
		CloudStoragegettemporarylinkinput obj = new CloudStoragegettemporarylinkinput();
        System.assert(obj != null);
        obj = new CloudStoragegettemporarylinkinput('123456789012345678','/tmppath/');
        System.assert(obj != null);
	}
}