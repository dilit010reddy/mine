/*
@Author: N. Larkin
@Date: 2-9-2021
@Description:   API Class for Dropbox API search when it continues searching through the batches

@History:
*/
@isTest
public with sharing class CloudStorageinitializefolderinput_TC {
    static testMethod void testMeth() {
        CloudStorageinitializefolderinput basicinitializefolderInput = new CloudStorageinitializefolderinput();
        System.assert(basicinitializefolderInput.path == '');
        System.assert(basicinitializefolderInput.recordId == '');
        CloudStorageinitializefolderinput parameterinitializefolderInput = new CloudStorageinitializefolderinput('testId', 'testPath');
        System.assert(parameterinitializefolderInput.path == 'testPath');
        System.assert(parameterinitializefolderInput.recordId == 'testId');


    }
}