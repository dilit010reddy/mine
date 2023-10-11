/**
@Author: N. Larkin & P. Sutherland
@Date: 01/21/2021
@Description: Test class for Utility functions
@History:
*/
@isTest
public with sharing class Utils_TC {
    static testMethod void Utils_TC() {
        // Division insert to test objName lookup method
        //list<Division__c> divs = new list<Division__c>();
        //divs = TestDataUtil.divisionCreation(1);
        //insert divs;
        Account acct = CloudStorageController_TC.createtestdata();


        Test.startTest();
        //Load the SObject Cache;
        map<Schema.SObjectType,Schema.DescribeSobjectResult> retSObjSchema = Utils.getSObjectSchema( new list<Schema.SObjectType>{Contact.SObjectType, Account.SObjectType} );
        system.assertEquals(2, retSObjSchema.size());
        // Test the Cache routines by calling them twice
        // test the RecordTypeCache
        map<String,ID> recTypes = Utils.getRecordTypes(Account.SObjectType);
        map<String,ID> recTypes2 = new map<String,ID>();
        recTypes2.putAll(Utils.getRecordTypes(Account.SObjectType));
        //verify the cache load
        system.assertEquals(recTypes.size(), recTypes2.size());
        // Send an type with no record types
        recTypes = Utils.getRecordTypes(Approval.SObjectType);
        recTypes2 = new map<String,ID>();
        recTypes2.putAll(Utils.getRecordTypes(Approval.SObjectType));
        //verify the empty cache load
        system.assertEquals(recTypes.size(), recTypes2.size());
        // now process with the name and not the developername;
        recTypes = Utils.getRecordTypes(Account.SObjectType,false);
        recTypes2.putAll(Utils.getRecordTypes(Account.SObjectType,false));
        //verify the cache load from the alternate load still equals the same count
        system.assertEquals(recTypes.size(), recTypes2.size());
        //test the object name lookup
        String objname = Utils.getObjectTypeName(acct.Id);
        system.assertEquals('Account', objname);
        map<String, Portal_Profile_Map__mdt> portalProfileMap = Utils.getPortalMapMeta();


        /* //test the ERP metadata cache
        ERP_Integration_Default__mdt mdt = Utils.getERPIntegrationMeta('JDEIntegration');
        ERP_Integration_Default__mdt mdt2 = new ERP_Integration_Default__mdt();
        mdt2 = Utils.getERPIntegrationMeta('JDEIntegration');
        //verify the cache load
        system.assertEquals(mdt, mdt2);
        // Send any invalid mdt key
        mdt = Utils.getERPIntegrationMeta('InvalidTest');
        mdt2 = new ERP_Integration_Default__mdt();
        mdt2 = Utils.getERPIntegrationMeta('InvalidTest');
        //verify the error
        system.assertEquals(null, mdt);
        system.assertEquals(null, mdt2);
        system.assertEquals(mdt, mdt2); */

        /*
        //Test the Home Pro Functionality metadata cache
        Home_Pro_Functionality__mdt mdt5 = Utils.getHPSMeta('Default');
        Home_Pro_Functionality__mdt mdt6 = new Home_Pro_Functionality__mdt();
        mdt6 = Utils.getHPSMeta('Default');
        //verify the cache load
        system.assertEquals(mdt5, mdt6);
        // Send any invalid mdt key
        mdt5 = Utils.getHPSMeta('InvalidTest');
        mdt6 = new Home_Pro_Functionality__mdt();
        mdt6 = Utils.getHPSMeta('InvalidTest');
        //verify the error
        system.assertEquals(null, mdt5);
        system.assertEquals(null, mdt6);
        system.assertEquals(mdt5, mdt6);*/

        /*
        //test the Quote Commission Functionality metadata cache
        recTypes = Utils.getRecordTypes(Quote.SObjectType);
        Quote_Commission_Functionality__mdt mdt3 = Utils.getQCFunctionalityMeta((new list<String>(recTypes.keySet()))[0]);
        Quote_Commission_Functionality__mdt mdt4 = new Quote_Commission_Functionality__mdt();
        mdt4 = Utils.getQCFunctionalityMeta((new list<String>(recTypes.keySet()))[0]);
        //verify the cache load
        system.assertEquals(mdt3, mdt4);
        // Send any invalid mdt key
        mdt3 = Utils.getQCFunctionalityMeta('InvalidTest');
        mdt4 = new Quote_Commission_Functionality__mdt();
        mdt4 = Utils.getQCFunctionalityMeta('InvalidTest');
        //verify the error
        system.assertEquals(null, mdt3);
        system.assertEquals(null, mdt4);
        system.assertEquals(mdt3, mdt4);
        */

        /*
        // Test Integration Field Metadata
        map<String,ERP_Integration_Field__mdt> fieldmap = Utils.getERPFieldMeta('QuoteLineItem');
        //Make sure cache is working
        map<String,ERP_Integration_Field__mdt> fieldmapCache = Utils.getERPFieldMeta('QuoteLineItem');
        system.assertEquals(fieldmap.size(),fieldmapCache.size());
        */
        Test.stopTest();
    }
    
}