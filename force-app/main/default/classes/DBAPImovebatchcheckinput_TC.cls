/*
@Author: N. Larkin
@Date: 12-10-2020
@Description:  API test Class for input when you're checking the move batch DBAPI request
@History:
*/
@isTest
public with sharing class DBAPImovebatchcheckinput_TC {

    static testMethod void testMeth() {
        DBAPImovebatchcheckinput basicmovecheckInput = new DBAPImovebatchcheckinput();
        System.assert(basicmovecheckInput.async_job_id == '');
        DBAPImovebatchcheckinput parametermovecheckInput = new DBAPImovebatchcheckinput('async ID');
        System.assert(parametermovecheckInput.async_job_id == 'async ID');


    }
}