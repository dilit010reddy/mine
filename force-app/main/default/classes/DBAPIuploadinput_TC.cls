/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API upload input test 

@History:
*/
@IsTest
public class DBAPIuploadinput_TC {
	
	// This test method should give 100% coverage
	static testMethod void testMeth() {
		String json = '{\"path\":\"/thg_customers/test_customer4\",\"autorename\":false,\"client_modified\":\"test\",\"mute\":false,\"property_groups\":[{\"template_id\":\"testid:12345678\",\"fields\":[{\"name\":\"test_field\",\"value\":\"test_value\"}]}],\"strict_conflict\":false,\"mode\":{\".tag\":\"update\",\"update\":\"revID:12345678\"}}';
		DBAPIuploadinput r = new DBAPIuploadinput();
        System.assert(r != null);
        r.path = '/thg_customers/test_customer4';
        r.mode.x_tag = 'update';
        r.mode.update_Z = 'dbid:1234567890'; 
        r.autorename = false;
        r.mute = false;
        r.strict_conflict = false;

        
        /*r.property_groups.
        r.property_groups[0].template_id = 'id:1234567890';
        r.property_groups[0].fields[0].name = 'Security Policy'; //creating a property groups instance and then attaching an instance of fields and then relating them.
        r.property_groups[0].fields[0].value = 'HIPPA';*/
        String jsonoutput = DBAPIuploadinput.genuploadJSONString(r);
        System.assert(r != null);

        

        //json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
        //DBAPIuploadinput.Fields fields = new DBAPIuploadinput.Fields(System.JSON.createParser(json));
        

        DBAPIuploadinput.Fields constructedFields = new DBAPIuploadinput.Fields();
        System.assert(constructedFields.name == null);
        System.assert(constructedFields.value == null);

        DBAPIuploadinput.Property_groups constructedPGroups = new DBAPIuploadinput.Property_groups();
        System.assert(constructedPGroups.template_id == null);
        System.assert(constructedPGroups.fields != null);

        DBAPIuploadinput.Fields pgFields = new DBAPIuploadinput.Fields();
        pgFields.name = 'thisisaName';
        pgFields.value = 'thisisaValue';

        DBAPIuploadinput.Property_groups listPGroups = new DBAPIuploadinput.Property_groups();
        listPGroups.template_id = 'thisisanID';
        listPGroups.fields = new list<DBAPIuploadinput.Fields>{pgFields};

        DBAPIuploadinput r2 = new DBAPIuploadinput();
        System.assert(r2 != null);
        r2.path = '/thg_customers/test_customer4';
        r2.mode.x_tag = 'update';
        r2.mode.update_Z = 'dbid:1234567890'; 
        r2.autorename = false;
        r2.mute = false;
        r2.strict_conflict = false;
        r2.client_modified = 'client modified';
        
        r2.property_groups = new list<DBAPIuploadinput.Property_groups>{listPGroups};
        String jsonoutput2 = DBAPIuploadinput.genuploadJSONString(r2);
        System.assert(r2 != null);

        
    
	}
}