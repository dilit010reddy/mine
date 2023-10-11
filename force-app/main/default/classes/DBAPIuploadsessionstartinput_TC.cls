/*
@Author: N. Larkin, Admins on Call
@Date: 1-18-2021
@Description: Test Class for DBAPIuploadsessionstartinput

@History:
*/
@isTest
public with sharing class DBAPIuploadsessionstartinput_TC {
    static testMethod void testmeth() {
        DBAPIuploadsessionstartinput startInput = new DBAPIuploadsessionstartinput();
        startInput.close = false;
        startInput.session_type.x_tag = 'testtag';
        
        String resultJson = DBAPIuploadsessionstartinput.genUploadsessionstartJSONString(startInput);
	}
}