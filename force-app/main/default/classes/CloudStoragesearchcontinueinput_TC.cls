/*
@Author: N. Larkin
@Date: 12-10-2020
@Description:  API Class for searching when you continue through the batches.
@History:
*/

@isTest
public class CloudStoragesearchcontinueinput_TC {

    static testMethod void testMeth() {
        CloudStoragesearchcontinueinput basicContinueInput = new CloudStoragesearchcontinueinput();
        System.assert(basicContinueInput.cursor == '');
        CloudStoragesearchcontinueinput parameterContinueInput = new CloudStoragesearchcontinueinput('cursor');
        System.assert(parameterContinueInput.cursor == 'cursor');


    }

}