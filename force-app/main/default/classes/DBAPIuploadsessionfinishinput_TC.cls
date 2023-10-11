/*
@Author: N. Larkin, Admins on Call
@Date: 1-18-2021
@Description: Test Class for DBAPIuploadsessionfinishinput

@History:
*/
@isTest
public with sharing class DBAPIuploadsessionfinishinput_TC {
    static testMethod void testmeth() {
        DBAPIuploadsessionfinishinput.Property_groups constructedPG = new DBAPIuploadsessionfinishinput.Property_groups();
        DBAPIuploadsessionfinishinput.Fields constructedFields = new DBAPIuploadsessionfinishinput.Fields();
        constructedFields.name = 'testname';
        constructedFields.value = 'testvalue';
        constructedPG.fields.add(constructedFields);

        DBAPIuploadsessionfinishinput finishInput = new DBAPIuploadsessionfinishinput();
        finishInput.cursor.session_id = 'notnull';
        finishInput.commit_Z.mute = false;
        finishInput.commit_Z.autorename = false;
        finishInput.commit_Z.strict_conflict = false;
        finishInput.commit_Z.mode.x_tag = 'xtag';
        finishInput.commit_Z.property_groups.add(constructedPG);
        finishInput.commit_Z.mode.update_Z = 'testz';
        
        String resultJson = DBAPIuploadsessionfinishinput.genuploadsessionfinishJSONString(finishInput);

        DBAPIuploadsessionfinishinput emptyfinishInput = new DBAPIuploadsessionfinishinput();

        String resultJson2 = DBAPIuploadsessionfinishinput.genuploadsessionfinishJSONString(emptyfinishInput);

        
	}
}