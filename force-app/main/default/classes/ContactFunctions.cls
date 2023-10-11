/*
@Author: C. Reynolds, Admins on Call
@Date: 07-12-2020
@Description: Generic Class for Contact Methods

@History:
1/26/2021
N. Larkin and P.Sutherland fixed deployment bug getting null pointer when Contact had no AccountId when running ContactRetrievalTest
*/
public without sharing class ContactFunctions{
    public static void checkForCommunityUsers(Contact[] records, Map<Id,Contact> oldRecs){
        List<Contact> contactToInsertList = new List<Contact>();
        List<Id> contactToRetireList = new List<Id>();
        Map<Id,Account> acctMap = new Map<Id,Account>();
        List<Id> acctIdList = new List<Id>();
        for(Contact con : records){
            acctIdList.add(con.AccountId); //loop contacts and add their associated accounts to a list.
        }
        List<Account> acctList = [SELECT Id, HG_Self_Managed__c, RecordType.Name, InActive__c FROM Account WHERE Id IN :acctIdList]; //query all of the accounts in that list.
        //List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType WHERE Name =];
        map<String, Id> contactRecordTypes = Utils.getRecordTypes(Contact.SObjectType);
        for(Account acct : acctList){
            acctMap.put(acct.Id,acct);
        }
        for(Contact con : records){
            if(con.AccountId != null){
                system.debug('Nicholas recordType.Name: ' + acctMap.get(con.AccountId).RecordType.Name);
                if(acctMap.get(con.AccountId).RecordType.Name == 'Association'){
                    //Meets the criteria to have an Active Community User Record
                    system.debug('Nicholas HG Self Managed: ' + acctMap.get(con.AccountId).HG_Self_Managed__c);
                    system.debug('Nicholas con.Active__c: ' + con.Active__c);
                    system.debug('Nicholas Account Inactive: ' + acctMap.get(con.AccountId).InActive__c);
                    if(acctMap.get(con.AccountId).HG_Self_Managed__c == FALSE && //if the account is not self managed, and inactive, and the Contact is active and has an email, and is a BOD member.
                    con.BOD__c == TRUE && con.Active__c == TRUE && 
                    con.Email != null && acctMap.get(con.AccountId).InActive__c == FALSE){
                        system.debug('Nicholas oldRecs.containskey(con.Id): ' + oldRecs.containskey(con.Id));
                        if(oldRecs.containskey(con.Id)){
                            system.debug('Nicholas oldRecs.get(con.Id).Active__c: ' + oldRecs.get(con.Id).Active__c);
                            system.debug('Nicholas oldRecs.get(con.Id).Email: ' + oldRecs.get(con.Id).Email);
                        }
                        if(!oldRecs.containskey(con.Id) || 
                        (oldRecs.containskey(con.Id) /*&& (oldRecs.get(con.Id).BOD__c == False*/ && (oldRecs.get(con.Id).Active__c == FALSE || oldRecs.get(con.Id).Email == null || (oldRecs.get(con.Id).BOD__c == False)))){ //If this is a new record, or (if it's an old record and also either is inactive or does not have an email)
                        system.debug('Nicholas con.RecordTypeId: ' + con.RecordTypeId);
                        system.debug('Nicholas contactRecordTypes.get(\'Homeowner\'): ' + contactRecordTypes.get('Homeowner'));
                            if(con.RecordTypeId == contactRecordTypes.get('Homeowner')){ //If the Record Type is Homeowner    con.RecordType.Name == 'Homeowner'
                                contactToInsertList.add(con);  //add contacts to list of contacts to create Users for.
                            }
                        }
                    }
                    if(oldRecs.containskey(con.Id) && ( (oldRecs.get(con.Id).BOD__c == TRUE && con.BOD__c == FALSE)  || (oldRecs.get(con.Id).Active__c == TRUE && con.Active__c == FALSE))){ //If this record is old and has been de-activated 
                        contactToRetireList.add(con.Id); //add to list of Users to retire.
                    }
                }
            } 
        }
        //Send the Contacts over to the CommunityUserHelper to create the Community Users
        System.debug('NIcholas size of contactToInsertList: ' + contactToInsertList.size());
        if(contactToInsertList.size()>0){
            CommunityUserHelper.communityUserCreator(contactToInsertList);
        }
        //Send the Contacts over to the CommunityUserHelper to create the Community Users
        if(contactToRetireList.size()>0){
            CommunityUserHelper.communityUserRetire(contactToRetireList);
        }
    }
    public static void createHomeownerAddressFolder(Contact[] records, Map<Id,Contact> oldRecs){
        //getmetadata
        //CloudStorage__mdt mdt = DropBoxAPI.getDropboxMeta();
        /*Boolean isInvalidField = false;
        //Map the param strucutre
        CloudStorageParamPath params = new CloudStorageParamPath();
        params = (CloudStorageParamPath) JSON.deserialize(mdt.CloudStorage_WorkFlow_Rule__r[0].Object_Fields__c, CloudStorageParamPath.class); //gets parameters from mdt.CloudStorage_WorkFlow_Rule__r
        map<String,map<String,list<String>>> parammap = new map<String,map<String,list<String>>>();
        set<String> objset = new set<String>();
        map<String,list<String>> objfields = new map<String,list<String>>();
        for(CloudStorageParamPath.Param p : params.params){
            if(!parammap.containsKey(p.key)){
                parammap.put(p.key,new map<String,list<String>>()); //adding all the keys to the parammap
            }
            String obj = p.val.mid(0,p.val.indexOf('.'));
            if(parammap.get(p.key).containsKey(obj)){
                parammap.get(p.key).put(obj, new list<String>()); //adding all the objects ("Contact" & "Account") to parammap
                objset.add(obj); //adding the object to the set of objects
                objfields.put(obj, new list<String>()); //adding the object as a key to a objfields map.
            }
            String fld = p.val.mid((p.val.indexOf('.') + 1),(p.val.length() - (p.val.indexOf('.') + 1)));
            parammap.get(p.key).get(obj).add(fld); //adding the fields to the value map of parammap
            objfields.get(obj).add(fld); //adding the fields to the objfieldsmap
        }
        // build a list for schema cache creation 
        list<Schema.SObjectType> schemalist = new list<Schema.SObjectType>();
        for(String s: objfields.keySet()){
            schemalist.add(((SObject) Type.forName(s).newInstance()).getSObjectType()); //make a list of schemas for every object in objfields map
        }
        // Get SchemaCache
        map<Schema.SObjectType,Schema.DescribeSObjectResult> objrslts = Utils.getSObjectSchema(schemalist); //get the schemas in the list. 
        map<String, list<String>> verifiedObjFields = new map<String, list<String>>();
        // iterate through the map of objects/fields and build a final mapping
        for(String obj: objfields.keySet()){
            Schema.DescribeSObjectResult objrslt;
            objrslt = objrslts.get(((SObject) Type.forName(obj).newInstance()).getSObjectType());
            map<String,Schema.SObjectField> fieldsMap = objrslt.fields.getMap();
            verifiedObjFields.put(obj, new list<String>());
            //Itierate through the list of fields per object and make sure they are accessible and valid
            for(String fld : objfields.get(obj)){ 
                if(fieldsMap.get(fld.toLowerCase()).getDescribe().isAccessible()){ //verifying schema of objects and then adding them to verified list of objects and fields. 
                    // add logic here to get the final list of valid fields
                    verifiedObjFields.get(obj).add(fld);
                }
                else{
                    isInvalidField = true;
                    System.debug('Field was not valid: ' + obj + ', Field: ' + fld);
                }
            }
        }
        Map<String, String> objectsoqls = new Map<String, String>();
        map<String, list<String>> idMap = new map<String, list<String>>();
        for(String obj: verifiedObjFields.keySet()){
            idMap.put(obj, new list<String>());
            for(Contact c : records){
                if(obj == 'Account'){
                //idMap.put(obj, c.Accountid);
                idMap.get(obj).add(c.Accountid);
                }
                if(obj == 'Contact'){
                //idMap.put(obj, c.Id);
                idMap.get(obj).add(c.Id);
                }
            }
        }
        for(String obj: verifiedObjFields.keySet()){
            verifiedObjFields.get(obj).add('id');
            verifiedObjFields.get(obj).add('name');
            if(obj != 'CloudStorage__mdt'){
                String SOQL = 'SELECT ' + String.join(verifiedObjFields.get(obj), ',') + ' FROM ' + obj + ' WHERE id IN ' + idMap.get(obj);
                objectsoqls.put(obj, SOQL);
            }
        }
        map<String, map<Id, SObject>> queryresultsmap = new map<String, map<Id, SObject>>();
        if(verifiedObjFields.containsKey('CloudStorage__mdt')){
            queryresultsmap.put('CloudStorage__mdt', new map<Id, SObject>{mdt.Id => mdt});
        }
        for(String obj : objectsoqls.keySet()){
            List<SObject> returnList = new List<SObject>();
            returnList = Database.query(objectsoqls.get(obj));
            map<Id, SObject> tempMap = new map<Id,SObject>((list<SObject>)returnList);
            queryresultsmap.put(obj, new map<id, SObject>());
            queryresultsmap.get(obj).putAll(tempMap);
        } 
        //map<String,map<String,list<String>>> parammap = new map<String,map<String,list<String>>>(); 
        String concatenatedPath;
        list<String> paths = new list<String>();
        map<Id,Account> idAccountMap = new map<Id, Account>();
        map<Id,Id> accountContactMap = new map<Id, Id>();
        map<Id, Contact> idContactMap = new map<Id, Contact>();
        
        for(Contact con : records){
            concatenatedPath = mdt.CloudStorage_WorkFlow_Rule__r[0].Path_Constructor__c;
            for(String param : parammap.keySet()){
                for(String obj : parammap.get(param).keySet()){
                    for(String fld : parammap.get(param).get(obj)){
                        //String tempVar = objectsoqls;
                        //SObject tempObj = new SObject();
                        //tempObj = queryresultsmap.get(obj).get(con.Id);
                    }
                }
            }  
        }*/

        /*for(Contact con : records){
            if(con.AccountId != null){
                accountContactMap.put(con.AccountId, con.Id);
                idContactMap.put(con.Id, con);
            }
        }*/
        /* if(!accountContactMap.isEmpty()){
            idAccountMap.putAll([SELECT Id, Name FROM Account WHERE Id IN :accountContactMap.keySet()]);
            if(!idAccountMap.isEmpty()){
                
                /*for(Id mapId : idContactMap.keySet()){
                    Contact contactAdded = idContactMap.get(mapId);
                    paths.add(contactAdded.VMS_RC_Address__c);
                }/******

            }
        } */
        
        map<String, Id> contactRecordTypeMap = Utils.getRecordTypes(Contact.SObjectType);
        set<Id> RecordTypeIds = new set<Id>();
        set<Id> contactIds = new set<Id>();
        for(String rt : contactRecordTypeMap.keySet()) {
            if(rt == 'Homeowner'){
                RecordTypeIds.add(contactRecordTypeMap.get(rt));
            }
        }
        for(Contact con : records){
            if(RecordTypeIds.contains(con.RecordTypeId)){
                contactIds.add(con.Id);
            }
        }
        if(contactIds.size() > 0){
            CloudStorage_addHomeownerFolders(contactIds);
        }
    }
    @future(callout=true)
    public static void CloudStorage_addHomeownerFolders(set<Id> contactIds){
        CloudStorage__mdt meta = DropBoxAPI.getDropboxMeta();
        String pathConstructor;
        list<Contact> contacts = new list<Contact>();
        contacts = [SELECT AccountId,Id,Name,Account.Name,Account.CloudStorage_Filesystem_Path__c,VMS_RC_Address__c, VMS_Unit_Address__c,VMS_Unit_Address_2__c  FROM Contact WHERE Id IN :contactIds];
        list<String> paths = new List<String>();
        String concatenatedPath;
        CloudStoragecreateiteminput input = new CloudStoragecreateiteminput();
        CloudStorageMiddleware.CloudStorageMiddlewareinput Middlewareinput = new CloudStorageMiddleware.CloudStorageMiddlewareinput();
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        
        for(CloudStorage_WorkFlow_Rule__mdt workflowRules : meta.CloudStorage_WorkFlow_Rule__r){
            if(workflowRules.label == 'folderbyaddress'){ //make more variable
                 pathConstructor = workflowRules.path_constructor__c;
                 break;
            }
        }
        for(Contact con : contacts){
            String unitPath = con.VMS_Unit_Address__c + ' ' + con.VMS_Unit_Address_2__c;
            concatenatedPath = pathConstructor;
            String finalpath = concatenatedPath.replace('<root_folder>',meta.Root_Folder__c).replace('<account_path>',(meta.Use_Name__c) ?con.Account.Name.toLowercase() : con.Account.CloudStorage_Filesystem_Path__c.toLowercase()).replace('<contact_path>', unitPath);
            paths.add(finalpath);
        }

        if(!paths.isEmpty()){
            Middlewareinput = new CloudStorageMiddleware.CloudStorageMiddlewareinput('createitem',
                                                                    new CloudStoragecreateiteminput(null,paths,null,null,0,null)
           );
           try{response = (CloudStorageController.Responsetomovedelete) CloudStorageMiddleware.getCloudStorageRequest(Middlewareinput);
           }
           catch(exception e){
            System.debug('System Exception: ' + e);
           }
        }
    }
    
    // a public class
    /*public class Param{
        public String obj {get;set;}
        public list<String> fld {get;set;}
        public Param(){
            this.obj = '';
            this.fld = new list<String>();
        }
        public Param(String obj, list<String> fld){
            this.obj = obj;
            this.fld = fld;
        }
    }*/

    
    // checks if certain fields on contact have changed, if so, sends email to contact verifying info is correct
    public static void checkIfContactInfoChanged(Contact[] updatedContacts, Map<Id, Contact> oldContactMap) {
        Boolean emailChanged;
        Boolean addContactToList;
        List<Contact> filteredNewContactsList = new List<Contact>();
        // use this list if we only want to display fields that were changed
        // List<Contact> filteredNewContactsOnlyChangedFields = new List<Contact>();
        Map<Id, Contact> filterdOldContactMap = new Map<Id, Contact>();
        Set<String> fieldsToCheck = new Set<String>{'Name', 'Email', 'Phone', 'MobilePhone', 
                                                    'VMS_RC_Address__c', 'VMS_RC_Address_2__c', 'VMS_RC_City__c', 'VMS_RC_State__c', 'VMS_RC_Zip__c', 'Country__c'};

        // loop through contacts
        for (Contact updatedContact : updatedContacts) {
            emailChanged = false;
            addContactToList = false;
            // Only use these objects if displaying fields that were changed
            /* Contact filteredNewContact = new Contact();
            Contact filterdOldContact = new Contact(); */
            // compare new fields to old map fields, capture all fields in case requirements change (display only changed fields in email, display old and new values, etc.)
            // creating temporary contacts in case we only want to display the fields that were changed, not being passed into send email method yet
            for (String currentField : fieldsToCheck) {
                if (updatedContact.get(currentField) != oldContactMap.get(updatedContact.Id).get(currentField)) {
                    if (currentField == 'Email') {
                        emailChanged = true;
                    }
                    addContactToList = true;
                    // use these objects if we only want to display fields that were changed in the email
                    /* filteredNewContact.set(currentField) = updatedContact.get(currentField);
                    filteredOldContact.set(currentField) = oldContactMap.get(updatedContact.Id).get(currentField); */
                }
            }
            if (addContactToList == true && updatedContact.Email != null && updatedContact.Active__c == true) {
                filteredNewContactsList.add(updatedContact);
                filterdOldContactMap.put(updatedContact.Id, oldContactMap.get(updatedContact.Id));
            }

            // use this only if want to display fields that were changed in the email
            /* if (filteredNewContact != null) {
                filteredNewContactsOnlyChangedFields.add(filterdNewContact);
                filterdOldContactMap.put(updatedContact.Id, filterdOldContact);
            }  */
        }  
        
        ContactEmails.sendVerifyContactInfoChangeEmail(filteredNewContactsList, filterdOldContactMap, emailChanged);
    }
}