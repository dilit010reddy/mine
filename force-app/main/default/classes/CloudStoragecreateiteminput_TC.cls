/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage create item input

@History:
updated - N. Larkin 1/18/2021
*/
@IsTest
public class CloudStoragecreateiteminput_TC {
	
	static testMethod void testmeth() {
		String json = '{'+
		'	"recordId": "123456789012345678",'+
		'	"path": "test",'+
		'	"data": "blobdata"'+
		'}';
		CloudStoragecreateiteminput obj = new CloudStoragecreateiteminput();
		System.assert(obj != null);
		List<String> paths = new List<String>();
		paths.add('test');
        obj = new CloudStoragecreateiteminput('123456789012345678',paths , null, 'single', 0, Blob.valueOf('Test me!!!!!'));
		System.assert(obj != null);
	}
}