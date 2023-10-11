/*
@Author: N. Larkin
@Date: 12-10-2020
@Description:   API test Class for the input of delete batch check 

@History:
*/
@isTest
public with sharing class DBAPIdeletebatchcheckinput_TC {
    static testMethod void testMeth() {
        DBAPIdeletebatchcheckinput basicdeletecheckInput = new DBAPIdeletebatchcheckinput();
        System.assert(basicdeletecheckInput.async_job_id == '');
        DBAPIdeletebatchcheckinput parameterdeletecheckInput = new DBAPIdeletebatchcheckinput('async ID');
        System.assert(parameterdeletecheckInput.async_job_id == 'async ID');

    }
}