/*
@Author: P. Sutherland, Admins on Call
@Date: 11-12-2020
@Description:   LWC Apex controller and response class defintions

@History:
N. Larkin, Admins on Call
*/
public with sharing class CloudStorageController {
    
    @AuraEnabled
    public static List<String> getAddressNames(String ObjectId){
        System.debug('NICHOLAS ADDRESSES FOR ID: ' + ObjectId);
        String accountId;
        if(Id.valueof(ObjectId).getSObjectType().getDescribe().getName() == 'Account'){
            accountId = ObjectId;
        }
        else{ //id is a case Id
            Case selectedCase = [Select Id,AccountId FROM Case Where Id = :ObjectId Limit 1];
            accountId = selectedCase.AccountId;
        }
        list<String> addresses = new List<String>();
        list<Unit_Data__c> unitsRelatedToAccount = new list<Unit_Data__c>();
        unitsRelatedToAccount = [SELECT Id,Name FROM Unit_Data__c WHERE Account__c = :accountId ORDER BY Name ASC];
        for(Unit_Data__c unit : unitsRelatedToAccount){
            addresses.add(unit.Name);
        }
        return addresses;
    }
    
    @AuraEnabled
    public static Object getListDirectory(String recordId, String path, Boolean recursive, String cursor){ 
        if(cursor == null) { //the cursor lets you know where your process left off. If it is null you start instead of continue
            return listDirectory(recordId,path,recursive,2000);
        }
        else {
            return getListDirectoryContinue(recordId, cursor);
        }
    }

    public static Object listDirectory(String recordId, String path, Boolean recursive, Integer limitz){ // returns content list of given folder
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput('folderlist',
                                                                   new CloudStoragefolderinput(recordId,path,recursive,limitz)
                                                                  ));
    }

    public static Object getListDirectoryContinue(String recordId, String cursor){
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput('folderlistcontinue',
                                                                   new CloudStoragefoldercontinueinput(recordId,cursor)
                                                                  ));
    }

    @AuraEnabled
    public static Object createItem(String workflowLabel, String recordId, list<String> paths, String async_job_id, String type, Long offset, String data){ // data is base64 encoded 
        Object storageMiddleware = CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput('createitem',
                                                                   new CloudStoragecreateiteminput(recordId,paths,async_job_id,type,offset,(data == null) ? null : System.EncodingUtil.base64Decode(data))
                                                                  ));
        if(!(storageMiddleware instanceof CloudStorageController.ErrorResponse)){
            if(workflowLabel != null && (type == 'finish' || type == 'single')){ //changed from finish
                switch on workflowLabel {

                    when 'Reconciled_Accounting'{
                        startReconciledAccounting(recordId,paths[0]);
                    }

                }
            }
        } 
        return storageMiddleware;                                                      
        /* return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput('createitem',
                                                                   new CloudStoragecreateiteminput(recordId,paths,async_job_id,type,offset,(data == null) ? null : System.EncodingUtil.base64Decode(data))
                                                                  )); */
    }

    @AuraEnabled
    public static Object moveItems(String recordId, String paths, String async_job_id){ // string is a serialized JSON of class CloudStorageController.Moves
        if(async_job_id == null){
            // deserailize the json string into a local class
            CloudStorageController.Moves inputjson = (CloudStorageController.Moves) JSON.deserialize(paths,CloudStorageController.Moves.class);
            //transalte the local object from input to the input class
            list<CloudStoragemoveitemsinput.Move> tmpmoves = new list<CloudStoragemoveitemsinput.Move>();
            for(Move mv: inputjson.moves){
                tmpmoves.add(new CloudStoragemoveitemsinput.Move(mv.src,mv.dest));
            }
            return CloudStorageMiddleware.getCloudStorageRequest(
                new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                    'moveitems',
                    new CloudStoragemoveitemsinput(recordId,tmpmoves)));
        } else {
            return moveItemsCheck(recordId, async_job_id);
        }
    }

    public static Object moveItemsCheck(String recordId, String async_job_id){ //check for batch functionality
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                'moveitemscheck',
                new CloudStoragemoveitemscheckinput(async_job_id)));
    }

    @AuraEnabled
    public static Object modifyItems(String recordId, String paths, String async_job_id){ //same as move items on the backend
        if(async_job_id == null){
           // deserailize the json string into a local class
           CloudStorageController.Moves inputjson = (CloudStorageController.Moves) JSON.deserialize(paths,CloudStorageController.Moves.class);
           //transalte the local object from input to the input class
           list<CloudStoragemoveitemsinput.Move> tmpmoves = new list<CloudStoragemoveitemsinput.Move>();
           for(Move mv: inputjson.moves){
               tmpmoves.add(new CloudStoragemoveitemsinput.Move(mv.src,mv.dest));
           }
           return CloudStorageMiddleware.getCloudStorageRequest(
               new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                   'modifyitems',
                   new CloudStoragemoveitemsinput(recordId,tmpmoves)));
        } else {
            return modifyItemsCheck(recordId, async_job_id);
        }
    }

    public static Object modifyItemsCheck(String recordId, String async_job_id){ //check for batch functionality
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                'modifyitemscheck',
                new CloudStoragemoveitemscheckinput(async_job_id)));
    }

    @AuraEnabled
    public static Object deleteItems(String recordId, list<String> items, String async_job_id){
        if(async_job_id == null){
            return CloudStorageMiddleware.getCloudStorageRequest(
                new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                    'deleteitems',
                    new CloudStoragedeleteitemsinput(recordId,items)));
        } else {
            return deleteItemsCheck(recordId, async_job_id);
        }
    }

    public static Object deleteItemsCheck(String recordId, String async_job_id){ //check for batch functionality
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                'deleteitemscheck',
                new CloudStoragedeleteitemscheckinput(async_job_id)));
    }

    @AuraEnabled
    public static Object getmetadata(String recordId, String path){ //gets the DB metadata of the given path
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                'getmetadata',
                new CloudStoragegetmetadatainput(recordId,path)));
    }

    @AuraEnabled
    public static Object getlink(String recordId, String path){ //Get a temporary link to stream content of a file. This link will expire in four hours and afterwards you will get 410 Gone.
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                'getlink',
                new CloudStoragegetlinkinput(recordId,path)));
    }

    @AuraEnabled
    public static Object searchitem(String recordId, String search, String path, String cursor){
        if(cursor == null) {
            return CloudStorageMiddleware.getCloudStorageRequest(
                new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                    'searchitem',
                    new CloudStoragesearchinput(recordId,search,path)));
        } else {
            return searchitemcontinue(recordId, cursor);
        }
    }

    @AuraEnabled
    public static void createdefaultfolder(String acctid, String accountname){
        // add code here to go to middelware
    }

    public static Object searchitemcontinue(String recordId, String cursor){
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                'searchitemcontinue',
                new CloudStoragesearchcontinueinput(cursor)));
    }
    
    public static void getcustpath(String recordId, String path, Initdata data){ //finds path relative to the account or case you are opening the component from.
        String tmpId = '';
        ID describeId = (ID) recordId;
        String objectname = Utils.getObjectTypeName(describeId);
        if(objectname != 'Account'){
            if(objectname != 'Case'){
                    data.custpath = null;
            }
            else{
                list<Case> cases = new list<Case>();
                cases = [SELECT Id, AccountId 
                         FROM Case 
                         WHERE Id = :recordId LIMIT 1];
                if(!cases.isEmpty()) {
                   tmpid = cases[0].AccountId;
                } else {
                   data.custpath = null;
                }
            }
        }
        else {
            tmpId = recordId;
        }
        list<Account> accts = new list<Account>();
        if(!String.isEmpty(tmpid)){
            accts = [SELECT Id, Name, CloudStorage_Filesystem_Path__c 
                        FROM Account 
                        WHERE Id = :tmpId LIMIT 1];
        }
        if(accts.isEmpty()){
            data.custpath = null;
            data.accountname = '';
            data.acctid = '';
        } else {
            CloudStorage__mdt meta = CloudStorageUtilities.getCloudStorageMeta('Default');
            String tmp = '/<company_root>/<account_path>';
            String finalpath = tmp.replace('<company_root>',meta.Root_Folder__c).replace('<account_path>',(meta.Use_Name__c) ? accts[0].Name : accts[0].CloudStorage_Filesystem_Path__c); 
            data.custpath = finalpath;
            data.accountname = accts[0].Name;
            data.acctid = accts[0].Id;
        }
    }

    @AuraEnabled
    public static Object getinit(String recordId, String Path){ //gets the profile and checks to see if they have admin access for delete, sends workflows for profile, and determines if homeowner or BOD
        if (String.isEmpty(recordId)) {
            //Portal User, grab record from Contact
            recordId = getPortalUserAccount();
        }
        Initdata retdata = new Initdata();
        getcustpath(recordid, path, retdata);
        getprofile(retdata);
        checkfolderinitialization(retdata); 
        return retdata;
    }
    private static Id getPortalUserAccount() {
        User userContact =  [Select ContactId FROM User WHERE Id = :UserInfo.getUserId()];
        Contact loggedInContact = [SELECT AccountId FROM Contact WHERE Id = :userContact.ContactId];
        return Id.valueOf(loggedInContact.AccountId);
    }
    private static void getprofile(Initdata data){
        CloudStorage__mdt meta = CloudStorageUtilities.getCloudStorageMeta('Default');
        map<String,boolean> metamap = new map<String,boolean>();
        for(CloudStorage_Profile_Security__mdt sec: meta.CloudStorage_Profile_Security__r){
            metamap.put(sec.Label,sec.Is_Admin__c);
        }
        list<Profile> prof = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String profilename = prof[0].Name;
        data.userprofile = profilename;
        isHomeownerOrBOD(data); //if they are signing into a community portal it will set the profile based on if it is the homeowner or BOD portal.
        data.isAdmin = (metamap.containsKey(profilename)) ? metamap.get(profilename) : false;

        //loading the workflowrules according to the profile
        for(CloudStorage_WorkFlow_Rule__mdt ruleMeta : meta.CloudStorage_WorkFlow_Rule__r){
            if(ruleMeta.isActive__c){
                list<String> relatedProfiles = new list<String>();
                if(String.isEmpty(ruleMeta.Profiles__c) || ruleMeta.ExecuteFrom__c == 'Backend'){
                    continue;
                }
                relatedProfiles = ruleMeta.Profiles__c.split(',');
                if(relatedProfiles.contains(data.userprofile) || relatedProfiles.contains('*ALL')){
                    list<String> multiplepathconstructor = new list<String>();
                    if(String.isNotEmpty(ruleMeta.path_constructor__c)){
                        multiplepathconstructor.add(ruleMeta.path_constructor__c);
                    }
                    if(String.isNotEmpty(ruleMeta.Multiple_Path_Constructor__c)){
                        multiplepathconstructor.addall(ruleMeta.Multiple_Path_Constructor__c.split(',\\|,')); //changed from comma NL
                    }
                    
                    data.workflowRules.add(new Ruledata(ruleMeta.label, ruleMeta.path_rule__c, multiplepathconstructor, ruleMeta.regex__c, ruleMeta.type__c, ruleMeta.DisplayName__c, ruleMeta.Object_Name__c, ruleMeta.Is_Displayable__c));
                }
            }
        }
        for(Ruledata rule : data.workflowRules){
            if(rule.label == 'readonly'){
                data.readonly = true;
                break;
            }
        }
    }

    private static void checkfolderinitialization(Initdata data){
        Object returnobj;
        returnobj = listDirectory(data.acctid, data.custpath, false, 1); // returns content list of given folder
        try{
            CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
            responseerror = (CloudStorageController.ErrorResponse) returnobj;
            System.debug('data is not initialized.');
            System.debug('response error: ' + responseerror);
            data.isinitialized = false;
        }
        catch(exception e){
            data.isinitialized = true;
        }
    }

    @AuraEnabled
    public static Object initializeFolder(String recordId, String path){ //initializes folder from button press on front end
        if(path == null){
            return null;
        }
        else{ 
        return CloudStorageMiddleware.getCloudStorageRequest(
            new CloudStorageMiddleware.CloudStorageMiddlewareinput(
                'initializefolder',
                new CloudStorageinitializefolderinput(recordId,path)));
    
        }
    }

    private static void isHomeownerOrBOD(Initdata data){
        map<String, Portal_Profile_Map__mdt> portalProfileMap = Utils.getPortalProfileMapMeta();
        String hostURL = URL.getSalesforceBaseUrl().getHost();
        for(Portal_Profile_Map__mdt profileMap : portalProfileMap.values()){
            if(profileMap.Portal_URL__c == hostURL){
                data.userprofile = profileMap.Profile_Name__c;
                break;
            }
        }
    }

    @AuraEnabled
    public static void startReconciledAccounting(String recordId, String path){ //starts the Reconciled Accounting Flow
        CloudStorageController.Metadata linkData = (Metadata) CloudStorageController.getlink(recordId, path);
        String fileLink = linkdata.url;
        String objectname = Utils.getObjectTypeName(recordId);
        Switch on objectname{
            when 'Account'{
                Account reconciledAccount = new Account();
                reconciledAccount = [Select Id,Name,Reconciled_Accounting_Link__c,isReconciledAccounting__c FROM Account WHERE Id = :recordId];
                reconciledAccount.Reconciled_Accounting_Link__c = fileLink;
                update reconciledAccount;
                reconciledAccount.isReconciledAccounting__c = true;
                update reconciledAccount;
            }
            when 'Case'{
                Case reconciledCase = new Case();
                reconciledCase = [SELECT Id,AccountId FROM Case WHERE Id = :recordId];
                String reconciledAccountId = reconciledCase.AccountId;
                Account reconciledAccount = new Account();
                reconciledAccount = [Select Id,Name,Reconciled_Accounting_Link__c,isReconciledAccounting__c FROM Account WHERE Id = :reconciledAccountId];
                reconciledAccount.Reconciled_Accounting_Link__c = fileLink;
                reconciledAccount.isReconciledAccounting__c = true;
                update reconciledAccount;
            }
        }
    }
    
    
    public class Initdata {
        @AuraEnabled public boolean isadmin{get;set;}
        @AuraEnabled public String custpath{get;set;}
        @AuraEnabled public String userprofile{get;set;}
        @AuraEnabled public String accountname{get;set;}
        @AuraEnabled public String acctid{get;set;}
        @AuraEnabled public boolean isinitialized{get;set;}
        @AuraEnabled public boolean readonly{get;set;}
        @AuraEnabled public list<Ruledata> workflowRules{get;set;}
        public Initdata(){
            this.isadmin = false;
            this.custpath = '';
            this.userprofile = '';
            this.accountname = '';
            this.acctid = '';
            this.isinitialized = false;
            this.readonly = false;
            this.workflowRules = new list<Ruledata>();
        }
    }

     public class Ruledata {
        @AuraEnabled public String label {get;set;}
        @AuraEnabled public String path_rule {get;set;}
        @AuraEnabled public list<String> path_constructor {get;set;}
        @AuraEnabled public String regex {get;set;}
        @AuraEnabled public String type {get;set;}
        @AuraEnabled public String display_name {get;set;}
        @AuraEnabled public String object_name {get;set;}
        @AuraEnabled public Boolean is_displayable {get;set;}
        
        public Ruledata(){
            this.label = '';
            this.path_rule = '';
            this.path_constructor = new list<String>();
            this.regex = '';
            this.type = '';
            this.display_name = '';
            this.object_name = '';
        }
        public Ruledata(String label, String path_rule, list<String> path_constructor, String regex, String type, String display_name, String object_name, Boolean is_displayable){
            this.label = label;
            this.path_rule = path_rule;
            this.path_constructor = path_constructor;
            this.regex = regex;
            this.type = type;
            this.display_name = display_name;
            this.object_name = object_name;
            this.is_displayable = is_displayable;
        }
    } 

    public class ErrorResponse {

        @AuraEnabled public Integer status_code{get;set;}
        @AuraEnabled public String error_code{get;set;}
        @AuraEnabled public String error_message{get;set;}
        @AuraEnabled public Long correct_offset {get;set;}
        public ErrorResponse(){
            this.status_code = 0;
            this.error_code = '';
            this.error_message = '';
            this.correct_offset = 0;
        }
        public ErrorResponse(Integer status_code, String error_code, String error_message, Long correct_offset){
            this.status_code = status_code;
            this.error_code = error_code;
            this.error_message = error_message;
            this.correct_offset = correct_offset;
        }
        public ErrorResponse(Integer status_code, String error_code, String error_message){
            this.status_code = status_code;
            this.error_code = error_code;
            this.error_message = error_message;
            this.correct_offset = 0;
        }     
    }

    public class Entry {
        @AuraEnabled public String id {get;set;}
        @AuraEnabled public String node_type {get;set;}
        @AuraEnabled public String file_type {get;set;}
        @AuraEnabled public Boolean downloadable {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public Integer size {get;set;}
        @AuraEnabled public Boolean read_only {get;set;}
        @AuraEnabled public String path {get;set;}
        @AuraEnabled public String display_path {get;set;}
        @AuraEnabled public String url {get;set;}
        public Entry(){
            this.id = '';
            this.node_type = '';
            this.file_type = '';
            this.downloadable = false;
            this.name = '';
            this.size = 0;
            this.read_only = false;
            this.path = '';
            this.display_path = '';
            this.url = '';
        }
        public Entry(String id, String node_type, String file_type, Boolean downloadable, String name, Integer size, Boolean read_only, String path, String display_path, String url){
            this.id = id;
            this.node_type = node_type;
            this.file_type = file_type;
            this.downloadable = downloadable;
            this.name = name;
            this.size = size;
            this.read_only = read_only;
            this.path = path;
            this.display_path = display_path;
            this.url = url;
        }
    }

    public class Entries {

        @AuraEnabled public String cursor {get;set;}
        @AuraEnabled public Boolean has_more {get;set;}
        @AuraEnabled public list<Entry> entries {get;set;}
        public Entries(){
            this.cursor = '';
            this.has_more = false;
            this.entries = new list<Entry>();
        }
        public Entries(String cursor, Boolean has_more, list<Entry> entries){
            this.cursor = cursor;
            this.has_more = has_more;
            this.entries = entries;
        }
    }

    public class Moves {

        @AuraEnabled public list<Move> moves {get;set;}
        public Moves(){
            this.moves = new list<Move>();
        }
    }

    public class Move {

		@AuraEnabled public String src {get;set;}
        @AuraEnabled public String dest {get;set;}
        public Move(){
            this.src = '';
            this.dest = '';
        }

     public Move(String src, String dest){ // in play for testing
         this.src = src;
         this.dest = dest;
     }
    }

    public class Responsetomovedelete { //used as a response for most batch processes

		@AuraEnabled public Boolean success {get;set;}
        @AuraEnabled public String async_job_id {get;set;}
        @AuraEnabled public String status {get;set;}
        @AuraEnabled public Long offset {get;set;}
        @AuraEnabled public list<StatusObj> completionList {get;set;}
        public Responsetomovedelete(){
            this.success = false;
            this.async_job_id = '';
            this.status = '';
            this.offset = 0;
            this.completionList = new list<StatusObj>();  
        }
        public Responsetomovedelete(Boolean success, String async_job_id, String status, Long offset, list<StatusObj> completionList){
            this.success = success;
            this.async_job_id = async_job_id;
            this.status = status;
            this.offset = offset;
            this.completionList = completionList;  
        }
        public Responsetomovedelete(Boolean success, String async_job_id, String status, list<StatusObj> completionList){
            this.success = success;
            this.async_job_id = async_job_id;
            this.status = status;
            this.offset = 0;
            this.completionList = completionList;  
        }
    }

    public class StatusObj { // representing the completionstatus of each Entry in batch processes that don't return back the Metadata obj below

		@AuraEnabled public Boolean success {get;set;}
        @AuraEnabled public String failureMessage {get;set;}
        
        public StatusObj(){
            this.success = false;
            this.failureMessage = '';
        }
        public StatusObj(Boolean success, String failureMessage){
            this.success = success;
            this.failureMessage = failureMessage;
        }
    }
    
    public class Metadata {

        @AuraEnabled public String id {get;set;}
        @AuraEnabled public String node_type {get;set;}
        @AuraEnabled public String file_type {get;set;}
        @AuraEnabled public Boolean downloadable {get;set;}
        @AuraEnabled public String name {get;set;}
        @AuraEnabled public String last_modified {get;set;}
        @AuraEnabled public String rev {get;set;}
        @AuraEnabled public Integer size {get;set;}
        @AuraEnabled public Boolean read_only {get;set;}
        @AuraEnabled public String path {get;set;}
        @AuraEnabled public String display_path {get;set;}
        @AuraEnabled public String url {get;set;}
        public Metadata() {
            this.id = '';
            this.node_type = '';
            this.file_type = '';
            this.downloadable = false;
            this.name = '';
            this.last_modified = '';
            this.rev = '';
            this.size = 0;
            this.read_only = false;
            this.path = '';
            this.display_path = '';
            this.url = '';
        }
        public Metadata(String id, String node_type, String file_type, Boolean downloadable, String name, String last_modified, String rev, Integer size, Boolean read_only, String path, String display_path, String url){
            this.id = id;
            this.node_type = node_type;
            this.file_type = file_type;
            this.downloadable = downloadable;
            this.name = name;
            this.last_modified = last_modified;
            this.rev = rev;
            this.size = size;
            this.read_only = read_only;
            this.path = path;
            this.display_path = display_path;
            this.url = url;
        }
    }
}