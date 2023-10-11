/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   Drop Box API get temporary link input JSON class test

@History:
*/
@IsTest
public class DBAPIgettemporarylink_TC {
	
	static testMethod void testParse() {
		String json = '{'+
		'  "metadata": {'+
		'    "name": "sample.txt",'+
		'    "path_lower": "/thg_customers/test_customer/sample.txt",'+
		'    "path_display": "/THG_Customers/Test_Customer/sample.txt",'+
		'    "parent_shared_folder_id": "8593825504",'+
		'    "id": "id:CBh9W4LXJYIAAAAAAAAO1w",'+
		'    "client_modified": "2020-11-02T21:25:09Z",'+
		'    "server_modified": "2020-11-03T17:56:09Z",'+
		'    "rev": "015b33793ed126a00000002003b5ee0",'+
		'    "size": 1091,'+
		'    "sharing_info": {'+
		'      "read_only": false,'+
		'      "parent_shared_folder_id": "8593825504",'+
		'      "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
		'    },'+
		'    "is_downloadable": true,'+
		'    "content_hash": "1f9cf9b7b1c9376f9abc77959d28745dc49d983a4731ca6e8a24c22ef8d954e9"'+
		'  },'+
		'  "link": "https://content.dropboxapi.com/apitl/1/Al6BW8hvXbcMSlCVnB-fUlhH35rulZt4dgbH5uGOpoJx6K7wJOH7rIzZKMdCmZAbviWuDpsaOQN6_1lzh3m-KnoUyAAU9AMPXXwnLYBY9cdscmc9176QXysXRYVTeNyPI3ZOBDvAEhMmC3yBAeUcjbP1Ka930b7q-qU7VDmu-iu9Pl6SORcoyYCTiayzOJP9y8jVdQcx5PzCcXlWxHHAFO0GfZ03KufnQJn21BLGqZr_DaC7suT8KpYTEXDCaJPmDrdby8GCPzCCVxfUy9MbCElp0hPuxDyIri3aMq4R8f11UKm8LOYT3NftB3lmnBB9FcO52FoXkNn3irs_mutGQUrFQwZM0aB57-KpRXLH7Pyk9g6ar_r1fh8_TJRpglZ62H3KerCHQ2xAboH5y-MZm3iS39SEc58GUlmjIY6OS2RpuGDMAtF9ZOQBJvb4kkvqfV6i07LnltOwVH3cWp7IU--XnfKKvZFqXbqqD4MWWkkSHC6izeb1S5Q8b1eJswMH-mU"'+
        '}';
        DBAPIgettemporarylink obj = new DBAPIgettemporarylink();
        DBAPIgettemporarylink.Metadata tmpmetadata = new DBAPIgettemporarylink.Metadata();
        DBAPIgettemporarylink.Sharing_info tmpsharinginfo = new DBAPIgettemporarylink.Sharing_info();
        obj = DBAPIgettemporarylink.parse(json);
		System.assert(obj != null);
	}
}