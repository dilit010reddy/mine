/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   API Class for CloudStorage get metadata input test

@History:
*/
@IsTest
public with sharing class CloudStoragegetmetadatainput_TC {  	
	static testMethod void testMeth() {
		String json = '{'+
		'	\"recordId\": \"123456789012345678\",'+
		'	\"path\": \"/temppath/\"'+
		'}';
		CloudStoragegetmetadatainput obj = new CloudStoragegetmetadatainput();
        System.assert(obj != null);
        obj = new CloudStoragegetmetadatainput('123456789012345678','/tmppath/');
        System.assert(obj != null);
	}
}