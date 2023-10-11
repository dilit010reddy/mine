/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage folder list input test

@History:
*/
@IsTest
public class CloudStoragefolderinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'	\"recordId\": \"123456789012345678\",'+
		'	\"path\": \"test\",'+
		'	\"recursive\": false,'+
		'	\"limit_Z\": 1000'+
		'}';
		CloudStoragefolderinput obj = new CloudStoragefolderinput();
        System.assert(obj != null);
        obj = new CloudStoragefolderinput('123456789012345678','test',false,1000);
        System.assert(obj != null); 
	}
}