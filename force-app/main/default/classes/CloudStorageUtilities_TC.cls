/**
* @Author Pat Sutherland 
* @Date 11/16/2020
* Description: Cloud Storage Utilities Test Class                    
History:

*/
@isTest
private class CloudStorageUtilities_TC {
    static testMethod void testUtilities() {
        //Start the Testing
        Test.startTest();
        // determine if running in sandbox or production
        boolean isSandbox = CloudStorageUtilities.inaSandbox();
        CloudStorage__mdt mdt = CloudStorageUtilities.getCloudStorageMeta('Sandbox');
        CloudStorage__mdt mdt2 = new CloudStorage__mdt();
        mdt2 = CloudStorageUtilities.getCloudStorageMeta('Sandbox');
        //verify the cache load
        system.assertEquals(mdt, mdt2);

        /*List<String> metadtaNameList = new list<String> {'CloudStorage.' + ''};
        List<Metadata.Metadata> components = Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata, metadtaNameList);
        Metadata.CustomMetadata customMetadataRecord = (Metadata.CustomMetadata) components.get(0);
        List<Metadata.CustomMetadataValue> values = customMetadataRecord.values;                  
        CloudStorage__mdt cacheMap;*/

        CloudStorage__mdt defaultMdt = CloudStorageUtilities.getCloudStorageMeta('default');
        CloudStorage__mdt defaultMdtCopy = CloudStorageUtilities.getCloudStorageMeta('default'); // tests if it has already gotten it.

        //CloudStorage__mdt mdtToUpdate = CloudStorageUtilities.getCloudStorageMeta('TestingMdt');
        CloudStorage__mdt mdtToUpdate = new CloudStorage__mdt();
        CloudStorageUtilities.updateCloudStorageMetaCache(mdtToUpdate);
        
        //CloudStorage__mdt exceptionMdt = CloudStorageUtilities.getCloudStorageMeta('TestingMdt2', true);
        //CloudStorage__mdt exceptionMdt = new CloudStorage__mdt();
        CloudStorageUtilities.getCloudStorageMeta('Nicholas');

        


        Test.stopTest();
    }
}