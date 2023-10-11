/*
@Author: P. Sutherland, Admins on Call
@Date: 11-13-2020
@Description:   Cloud Storage Utilties class

@History:
*/
public without sharing class CloudStorageUtilities {
    // determine if sandbox or production
    public static Boolean inaSandbox() {
        return [SELECT Id,IsSandbox FROM Organization].IsSandbox;
    }
    // Use a Cache map to get the metadata you need
    private static map<String,CloudStorage__mdt> mdtCloudStorageCache;
    static { mdtCloudStorageCache = new map<String,CloudStorage__mdt>(); } 
    // Use a Cache map to get the callout metadata you need
    public static CloudStorage__mdt getCloudStorageMeta(String metadatalabel) {
        CloudStorage__mdt mdt = new CloudStorage__mdt();
        mdt = getCloudStorageMeta(metadatalabel, true);
        return mdt;
    }

    // Returns the cachemap if found, else it looksup the key value and returns the cachemap
    public static CloudStorage__mdt getCloudStorageMeta(String metadatalabel, Boolean b){
        // Cache Found
        if (mdtCloudStorageCache.containsKey(metadatalabel)) {
            return mdtCloudStorageCache.get(metadatalabel);
        }
        // Load the cache map and return from metadata query
        list<CloudStorage__mdt> metadata = new list<CloudStorage__mdt>();
        try{metadata = [SELECT Id,Client_Id__c,Client_Secret__c,Redirect_URI__c,Refresh_Token__c,Endpoint__c,Token__c,Connected_App__c,
                               Dropbox_Api_Path_Root__c,Dropbox_Api_Select_Admin__c,Api_Path_Root_Name__c,
                               Api_Select_Admin_Name__c,Root_Folder__c,Content_Endpoint__c,Mock_Response__c,
                               Use_Name__c,Label,DeveloperName,MasterLabel,DropBoxTeam__c,Default_Folder_Path__c,
                               (SELECT ID,Label,Is_Admin__c FROM CloudStorage_Profile_Security__r),
                               (SELECT ID,Label,isActive__c,Multiple_Path_Constructor__c,Object_Name__c, 
                                       Path_Constructor__c,Type__c,Object_Fields__c,Path_Rule__c,Profiles__c,RegEx__c,
                                       DisplayName__c,ExecuteFrom__c,Is_Displayable__c
                                FROM CloudStorage_WorkFlow_Rule__r)
                        FROM CloudStorage__mdt
                        WHERE Label =:metadatalabel];
        } catch(Exception e){metadata = new list<CloudStorage__mdt>();}

        // Create Cache
        for(CloudStorage__mdt meta:metadata){
            if(!mdtCloudStorageCache.containsKey(metadatalabel)){
                mdtCloudStorageCache.put(metadatalabel,meta);
                return meta;
            }
        }        
        return null;
    }

    public static void clearCloudStorageMeta(String metadatalabel){ // testing purposes only
        // Cache Found
        if (mdtCloudStorageCache.containsKey(metadatalabel)) {
            mdtCloudStorageCache.put(metadatalabel, null);
        }        
    }

    public static void updateCloudStorageMetaCache(CloudStorage__mdt meta) {
        mdtCloudStorageCache.put(meta.Label,meta);
    }
}