/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   Drop Box API get metadata input JSON class test

@History:
*/
@IsTest
public class DBAPIgetmetadatainput_TC {
	
	// This test method should give 100% coverage
	static testMethod void testMeth() {
		String json = '{'+
		'    \"path\": \"/thg_customers/test_customer3\",'+
		'    \"include_media_info\": false,'+
		'    \"include_deleted\": false,'+
		'    \"include_has_explicit_shared_members\": false,'+
		'    \"include_property_groups\": {'+
		'        \".tag\": \"filter_some\",'+
		'        \"filter_some\": ['+
		'            \"id:123456789012345678\"'+
		'        ]'+
		'    }'+
        '}';
        DBAPIgetmetadatainput r = new DBAPIgetmetadatainput();
        DBAPIgetmetadatainput.Include_property_groups tmppropertygroups = new DBAPIgetmetadatainput.Include_property_groups();
		System.assert(r != null);

		String getJson = DBAPIgetmetadatainput.gengetmetadataJSONString(r);
		System.assert(r!=null);
		System.assert(getJson == '{"path":""}');

		DBAPIgetmetadatainput mdtInput = new DBAPIgetmetadatainput();
		mdtInput.path = 'path';
		mdtInput.include_media_info = true;
		mdtInput.include_deleted = true;
		mdtInput.include_has_explicit_shared_members = true;
		DBAPIgetmetadatainput.Include_property_groups propGroups = new DBAPIgetmetadatainput.Include_property_groups();
		propGroups.x_tag = 'xtag';
		propGroups.filter_some = new list<String>();
		propGroups.filter_some.add('String1');
		mdtInput.include_property_groups = propGroups;
		String getJson2 = DBAPIgetmetadatainput.gengetmetadataJSONString(mdtInput);
		System.assert(mdtInput.include_deleted == true);
		System.assert(mdtInput.include_media_info == true);
		System.assert(mdtInput.path == 'path');
		System.assert(mdtInput.include_property_groups.x_tag == 'xtag');
		System.assert(!mdtInput.include_property_groups.filter_some.isEmpty());

	}
}