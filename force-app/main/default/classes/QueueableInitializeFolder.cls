/*
@Author: N. Larkin, QuantumRhino
@Date: 3/12/2021
@Description: Queable class to initialize the DB folder structure whenever a new account is inserted.

@History:
*/
public class QueueableInitializeFolder implements Queueable, Database.AllowsCallouts {
    private list<Account> listOfAccounts = new list<Account>();
    private list<Id> accountIdList = new list<Id>();
    public QueueableInitializeFolder(list<Account> inputAccounts) {
        listOfAccounts.addAll(inputAccounts);
        for(Account acc : listOfAccounts){
            accountIdList.add(acc.Id);
        }
    }

    public void execute(QueueableContext context) {
        if(TriggerStatus.shouldRunTrigger()){
            DBinitializefolder(accountIdList);
        }    
    }

    private static void DBinitializefolder(list<Id> accountIds) {
        list<Account> LOA = new list<Account>();
        //
        map<String, Id> accountRecordTypeMap = Utils.getRecordTypes(Account.SObjectType);
        String associationRecordTypeId;
        for(String rt : accountRecordTypeMap.keySet()) { //change into get.
            if(rt == 'Association'){
                associationRecordTypeId = accountRecordTypeMap.get(rt);
                break;
            }
        }
        //
        LOA = [SELECT Id,Name,RecordTypeId FROM Account WHERE Id IN :accountIds AND RecordTypeId = :associationRecordTypeId];
        list<String> pathsToInitialize = new list<String>();
        CloudStorage__mdt meta = DropBoxAPI.getDropboxMeta();
        for(Account acc : LOA){
            Object defaultEntries; // list of entries
            String concatenatedPath = '/' + meta.Root_Folder__c + '/' + meta.Default_Folder_Path__c;
            String addedPath = '/' + meta.Root_Folder__c + '/' + acc.Name;
            defaultEntries = CloudStorageMiddleware.DBlistview(meta, new CloudStoragefolderinput(acc.Id, concatenatedPath, true, 2000));
            CloudStorageController.Entries defaultEntriesList = new CloudStorageController.Entries();
            try{
                defaultEntriesList = (CloudStorageController.Entries) defaultEntries;
            }
            catch(Exception e){
                System.debug('Exception - defaultEntries in QueueableInitializeFolder came back as an error: ' + e);
                continue;
            }
            for(CloudStorageController.Entry e : defaultEntriesList.entries){
                String replacementEntry;
                replacementEntry = e.display_path.replace(concatenatedPath, addedPath);
                pathsToInitialize.add(replacementEntry);
                System.debug('paths to replace and initialize: ' + e.display_path.replace(concatenatedPath, addedPath));
            }
            while(defaultEntriesList.has_more == true){ // dealing with has more
                CloudStoragefoldercontinueinput listcontinueresponse = new CloudStoragefoldercontinueinput(acc.Id, defaultEntriesList.cursor);
                Object NextResponse = CloudStorageMiddleware.DBlistviewcontinue(meta, listcontinueresponse);
                try{
                    defaultEntriesList = (CloudStorageController.Entries) NextResponse;
                    for(CloudStorageController.Entry e : defaultEntriesList.entries){
                        pathsToInitialize.add(e.display_path.replace(concatenatedpath, addedPath));
                        System.debug('addedpath: ' + addedPath);
                    }
                }
                catch(Exception e){
                    System.debug('Exception - defaultEntries in QueueableInitializeFolder came back as an error on continue: ' + e);
                    continue;
                }
            }
        }
        CloudStoragecreateiteminput createinput = new CloudStoragecreateiteminput();
        if(!LOA.isEmpty()){
            createinput.recordId = LOA[0].Id;
            createinput.paths.addAll(pathsToInitialize);
            createinput.async_job_id = null;
            createinput.data = null;
    
            CloudStorageMiddleware.DBcreateitem(meta, createinput); 
       }
    }
}