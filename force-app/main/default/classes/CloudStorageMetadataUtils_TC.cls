/*
@Author: N. Larkin, Admins on Call
@Date: 01/25/2021
@Description: Test Class for CloudStorageMetadataUtils

@History:
*/
@isTest
public with sharing class CloudStorageMetadataUtils_TC {
    static testMethod void Methodtest() { 
		//Start the Testing
        Test.startTest();
        Account acct = CloudStorageController_TC.createtestdata();
        //CloudStorage_Profile_Security__mdt pmdt = new CloudStorage_Profile_Security__mdt();
        //CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        String mdt_key = 'Default';
        CloudStorage__mdt mdt = [SELECT Id,Client_Id__c,Client_Secret__c,Endpoint__c,Token__c,Connected_App__c,
            Dropbox_Api_Path_Root__c,Dropbox_Api_Select_Admin__c,Api_Path_Root_Name__c,
            Api_Select_Admin_Name__c,Root_Folder__c,Content_Endpoint__c,Mock_Response__c,
            Use_Name__c,Label,DeveloperName,MasterLabel 
        FROM CloudStorage__mdt
        WHERE Label =:mdt_key];
        //DropBoxAPI.getAPISelectAdmin(mdt);
        //CloudStorage__mdt mdt = new CloudStorage__mdt();
        //String pathRoot = DropBoxAPI.getAPIPathRoot(mdt);
        //mdt.DeveloperName = 'Nicholas';
        //mdt.MasterLabel = 'Nicholas';
        //mdt.CloudStorage_Profile_Security__r = pmdt;
        //pmdt.Is_Admin__c = true;
        //pmdt.CloudStorage__r = mdt;
        CloudStorageUtilities.updateCloudStorageMetaCache(mdt);
        String result = CloudStorageMetadataUtils.CloudStorageupsertMetadata(mdt);

		Test.stopTest(); 
	}
}