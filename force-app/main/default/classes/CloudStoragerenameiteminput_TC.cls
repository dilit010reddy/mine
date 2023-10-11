/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage rename item input test

@History:
*/
@IsTest
public class CloudStoragerenameiteminput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'	\"recordId\": \"123456789012345678\",'+
		'	\"src\": \"from\",'+
		'	\"dest\": \"to\"'+
		'}';
		CloudStoragerenameiteminput obj = new CloudStoragerenameiteminput();
        System.assert(obj != null);
        obj = new CloudStoragerenameiteminput('123456789012345678','from','to');
        System.assert(obj != null);
	}
}