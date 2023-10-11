/*
@Author: N. Larkin
@Date: 12-10-2020
@Description:  API Class for deleting when you continue through the batches.
@History:
*/

@isTest
public with sharing class CloudStoragedeleteitemscheckinput_TC {

    static testMethod void testMeth() {
        CloudStoragedeleteitemscheckinput basicContinueInput = new CloudStoragedeleteitemscheckinput();
        System.assert(basicContinueInput.async_job_id == '');
        CloudStoragedeleteitemscheckinput parameterContinueInput = new CloudStoragedeleteitemscheckinput('Job ID');
        System.assert(parameterContinueInput.async_job_id == 'Job ID');


    }

}