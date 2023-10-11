/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage delete items input test

@History:
*/
@IsTest
public class CloudStoragedeleteitemsinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'	\"recordId\": \"123456789012345678\",'+
		'	\"deletes\": ['+
		'		\"one\", \"two\"'+
		']'+
		'}';
		CloudStoragedeleteitemsinput obj = new CloudStoragedeleteitemsinput();
        System.assert(obj != null);
        obj = new CloudStoragedeleteitemsinput('123456789012345678',new list<String>{'one','two'});
		System.assert(obj != null);
	}
}