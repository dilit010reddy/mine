/*
@Author: N. Larkin
@Date: 12-10-2020
@Description:   API test Class for the input of move batch

@History:
*/
@isTest
public with sharing class CloudStoragemoveitemscheckinput_TC {
    static testMethod void testMeth() {
        CloudStoragemoveitemscheckinput basicmovecheckInput = new CloudStoragemoveitemscheckinput();
        System.assert(basicmovecheckInput.async_job_id == '');
        CloudStoragemoveitemscheckinput parametermovecheckInput = new CloudStoragemoveitemscheckinput('async ID');
        System.assert(parametermovecheckInput.async_job_id == 'async ID');

    }
}