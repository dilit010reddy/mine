/*
@Author: N. Larkin
@Date: 12-14-2020
@Description:  test class for DBAPIcreatefolderbatchcheckinput
@History:
*/
@isTest
public class DBAPIcreatefolderbatchcheckinput_TC {
    static testMethod void testMeth() {
        DBAPIcreatefolderbatchcheckinput basiccreatefolderbatchcheckInput = new DBAPIcreatefolderbatchcheckinput();
        System.assert(basiccreatefolderbatchcheckInput.async_job_id == '');
        DBAPIcreatefolderbatchcheckinput parametercreatefolderbatchcheckInput = new DBAPIcreatefolderbatchcheckinput('async ID');
        System.assert(parametercreatefolderbatchcheckInput.async_job_id == 'async ID');

    }
}