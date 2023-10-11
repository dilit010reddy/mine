/*
@Author: N. Larkin
@Date: 12-10-2020
@Description:  API Class for searching when you continue through the batches.
@History:
*/
@isTest
public class CloudStoragefoldercontinueinput_TC {

    static testMethod void testMeth() {
        CloudStoragefoldercontinueinput basicContinueInput = new CloudStoragefoldercontinueinput();
        System.assert(basicContinueInput.cursor == '');
        System.assert(basicContinueInput.recordId == '');
        CloudStoragefoldercontinueinput parameterContinueInput = new CloudStoragefoldercontinueinput('ID', 'cursor');
        System.assert(parameterContinueInput.cursor == 'cursor');
        System.assert(parameterContinueInput.recordId == 'ID');


    }
}