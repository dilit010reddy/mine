/*
@Author: N. Larkin
@Date: 12-10-2020
@Description:  API Class for searching when you continue through the batches.
@History:
*/
@IsTest
public class DBAPIsearchcontinueinput_TC {
    
    static testMethod void testMeth() {
        DBAPIsearchcontinueinput basicContinueInput = new DBAPIsearchcontinueinput();
        System.assert(basicContinueInput.cursor == '');
        DBAPIsearchcontinueinput parameterContinueInput = new DBAPIsearchcontinueinput('cursor');
        System.assert(parameterContinueInput.cursor == 'cursor');


    }
}