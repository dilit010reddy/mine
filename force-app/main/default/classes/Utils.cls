/**
@Author: C. Reynolds, Admins on Call
@Date: 07-12-2020
@Description: Utility functions
@History:
01/11/2021 P Sutherland - Added method to get object name from an id
01/21/2021 P Sutherland - Added method to get SObject Schema
*/

public with sharing class Utils {
    // Use a Cache map get the sObject Record Types
    private static map<Schema.SObjectType,map<String,ID>> rtypesCache;
    static { rtypesCache = new map<Schema.SObjectType,map<String,ID>>(); }

    // Use a Cache map get the sObject Schema
    private static map<Schema.SObjectType,Schema.DescribeSobjectResult> schemasCache;
    static { schemasCache = new map<Schema.SObjectType,Schema.DescribeSobjectResult>(); }

    public static map<String, ID> getRecordTypes( Schema.SObjectType token) 
    {
        map<String, ID> mapRecTypes = new map<String, ID>();
        mapRecTypes = getRecordTypes(token, true);
        return mapRecTypes;
    }
    public static map<String, ID> getRecordTypes( Schema.SObjectType token, Boolean dname) {
        // Do we already have a result? 
        map<String, ID> mapRecordTypes = rtypesCache.get(token);
        if (mapRecordTypes != null) 
           return mapRecordTypes;
        // Not Cached so build it out   
        mapRecordTypes = new map<String, ID>();
        Schema.DescribeSObjectResult obj = token.getDescribe();
        String soql = 
        'SELECT Id, Name, DeveloperName '
        + 'FROM RecordType '
        + 'WHERE SObjectType = \'' + String.escapeSingleQuotes(obj.getName()) + '\' '
        + 'AND IsActive = TRUE';
        list<SObject> results;
        try {
            results = Database.query(soql);
        } catch (Exception ex) {
            results = new list<SObject>();
        }
        map<ID,Schema.RecordTypeInfo> recordTypeInfos = obj.getRecordTypeInfosByID();
        for (SObject rt : results) {  
            if (recordTypeInfos.get(rt.Id).isAvailable()) 
            {
                if (dname)
                    mapRecordTypes.put(String.valueOf(rt.get('DeveloperName')),rt.Id);
                else
                    mapRecordTypes.put(String.valueOf(rt.get('Name')),rt.Id);
            }
        }
        rtypesCache.put(token,mapRecordTypes);
        return mapRecordTypes;
    }
    
    public class CloneChildrenResult {
        public sObject[] oldObjs;
        public sObject[] newObjs;
    }
    
    // returns two lists: the list of original values and list of clones
    /*public static CloneChildrenResult cloneChildrenAndAdopt(String objectName, String parentField, String parentId, String newParentId) {
        CloneChildrenResult result = cloneChildren(objectName, parentField, parentId);
        for ( sObject obj: result.newObjs ) {
            obj.put(parentField, newParentId);
        }   
        insert result.newObjs;
        return result;
    }*/
    
    // returns two lists: the list of original values and list of clones
    /*public static CloneChildrenResult cloneChildren(String objectName, String parentField, String parentId) {
        String soql = getCreatableFieldsSOQL(objectName, parentField +' =  \''+ parentId +'\'');
        sObject[] oldObjs = Database.query(soql);
        sObject[] newObjs = new list<sObject>();
        for ( sObject obj: oldObjs ) {
            sObject newObj = obj.clone(false);
            newObjs.add(newObj);
        }
        CloneChildrenResult retval = new CloneChildrenResult();
        retval.oldObjs = oldObjs;
        retval.newObjs = newObjs;
        return retval;
    }*/
    
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    /*public static string getCreatableFieldsSOQL(String objectName, String whereClause) {
        String selects = '';
        if (whereClause == null || whereClause == '') { return null; }
        // Get a map of field name and field token
        map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if (fMap != null){
            for ( Schema.SObjectField ft : fMap.values() ){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe();
                if ( fd.isCreateable() && fd.getName() != 'Location__c'){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        if ( !selectFields.isEmpty() ) {
            selects = String.join(selectFields,',');
            //for ( string s:selectFields ) {
            //    selects += s + ',';
            //}
            //if ( selects.endsWith(',') ){selects = selects.substring(0,selects.lastIndexOf(','));}
        }
        String retval = 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        //System.Debug(LoggingLevel.DEBUG, '>>> getCreatableFieldsSOQL SOQL: ' + retval);
        return retval;
    }*/
    // Emil: overload
    /*public static string getAllFieldsSOQL(String objectName, String whereClause) {
        return getAllFieldsSOQL(objectName, whereClause, null);
    }*/
    
    // Emil: overload
    /*public static string getAllFieldsSOQL(String objectName, String whereClause, String orderBy) {
        return getAllFieldsSOQL(objectName, whereClause, orderBy, null);
    }*/
    // Mohan
    // Emil: added orderBy and ExtraFields
    /*public static string getAllFieldsSOQL(String objectName, String whereClause, String orderBy, String extraFields) {
        String selects = '';
        if (whereClause == null || whereClause == '') { return null; }
        // Get a map of field name and field token
        map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        if ( fMap != null ){
            for ( Schema.SObjectField ft : fMap.values() ){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if ( fd.getName() != 'Location__c' )
                    selectFields.add(fd.getName());
            }
        }
        if ( !selectFields.isEmpty() ) {
            selects = String.join(selectFields,',');
            //for ( string s:selectFields ) {
            //    selects += s + ',';
            //}
            //if ( selects.endsWith(',') ){selects = selects.substring(0,selects.lastIndexOf(','));}
            if ( extraFields != null && extraFields != '' )
                selects += ', ' + extraFields;
        }
        String retval = 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        if ( orderBy != null && orderBy != '' ) retval += ' ORDER BY ' + orderBy;
        //System.Debug(LoggingLevel.DEBUG, '>>> getAllFieldsSOQLv2 SOQL: ' + retval);
        return retval;
    }*/
 
    /*public static void deleteChildren(String objectName, String parentField, String parentId) {
        objectName = String.escapeSingleQuotes(objectName);
        parentField = String.escapeSingleQuotes(parentField);
        SObject[] delThese = Database.query('SELECT Id FROM ' + objectName + ' WHERE ' + parentField + ' = :parentId');
        Database.delete(delThese);
    }*/
    // P. Sutherland Relocate this code for use everywhere
    /*public static list<selectOption> getPickValues(Sobject object_name, String field_name, String first_val) {
        list<selectOption> options = new list<selectOption>(); //new list for holding all of the picklist options
        if ( first_val != null) {//if there is a first value being provided
            options.add(new selectOption(first_val, first_val)); //add the first option
        }
        Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        list<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for ( Schema.PicklistEntry a : pick_list_values ) { //for all values in the picklist list
            options.add(new selectOption(a.getLabel(), a.getValue())); //add the value and label to our final list
        }
        return options; //return the List
    }*/
    // Public Function to Strip Characters out of text
    /*public static String stripSpecialCharsHTML(String txt){
        String retstr = '';
        if ( txt != null ) {
           //first replace all <BR> tag
           system.debug('Text A: '+txt);
           txt = txt.replaceAll('(?i)<br>','\n').replaceAll('(?i)<br/>','\n').replaceAll('(?i)<br />','\n').replaceAll('\'','&#39');
           //regular expression to match all HTML/XML tags ( keeps injected JS and CSS out )
           string HTML_TAG_PATTERN = '<.*?>';
           pattern strPattern = pattern.compile(HTML_TAG_PATTERN);
           matcher strMatcher = strPattern.matcher(txt);
           txt = strMatcher.replaceAll('');
           txt = txt.replaceAll('<','(').replaceAll('>',')').replaceAll('”','"').replaceAll('–','-');
           //remove the White Space
           //string WHITESPACE_PATTERN = '\\s';
           //pattern strPattern2 = pattern.compile(WHITESPACE_PATTERN);
           //matcher strMatcher2 = strPattern2.matcher(txt);
           //txt = strMatcher2.replaceAll(' ');
           system.debug('Text B: '+txt);
           txt = txt.replaceAll('\n','<br>').replaceAll('\r\n','<br>').replaceAll('\r','<br>').replaceAll('\t','<br>');
           system.debug('Text C: '+txt);
           //txt = txt.replaceAll('\n',' ');           
       }
       else
           return '';
       retstr = txt;
       return retstr;
    }*/
    // Public Function to Strip Characters out of text
    /*public static String replaceIllegalCharsHTML(String txt){
        String retstr = '';
        if ( txt != null ) {
           //first replace all ' tags and the <br>
           txt = txt.replaceAll('&#39','\'').replaceAll('<br>','\n');
       }
       else
           return '';
       retstr = txt;
       return retstr;
    }*/
    // Phone Number Validation
    /*public static Boolean validateUSPhone(String phoneNumber) {  
        if( phoneNumber != null ) {
            phoneNumber = phoneNumber.replaceAll('[^\\d]', ''); 
            if ( phoneNumber.length() == 10 ) 
                 return true;       //return true - if success  
            return false;       //else return false  
        }  
        else return false ;      //if Phone field is empty return false  
    }*/
    // returns a map of all the Object prefixes and Names
    /*public static map<String,String> getgdObjectTypeMap() {
        map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        map<String,String> keyPrefixMap = new map<String,String>{};
        for ( String sObj : gd.keySet()){
             Schema.DescribeSObjectResult r = gd.get(sObj).getDescribe();
             String tempName = r.getName();
             String tempPrefix = r.getKeyPrefix();
             keyPrefixMap.put(tempPrefix,tempName);
        }
        return keyPrefixMap;    
    }*/
    // scrub an address to remove leading verbage
    /*public static String scrubAddress(String address) {
        String addstr = '';
        list<String> ls = address.splitByCharacterTypeCamelCase();
        for ( integer i=0; i < ls.size(); i++ ) {
            if ( ls[i].substring(1) > '0' && ls[i].substring(1) <= '9' ) {
                while ( i < ls.size() ) {
                    addstr += ls[i];
                    i++;
                }
            }    
        }
        return addstr;
    }*/
    // determine if sandbox or production
    /*public static Boolean runningInASandbox() {
      return [select id,issandbox from organization].issandbox;
    }   */ 

    /*public static Boolean duplicateMgmtActive(String type) {
        String qstr = Utils.getAllFieldsSOQL('DuplicateRule','isactive = true and sobjecttype = :type');
        list <duplicateRule> drlst = database.query(qstr);
        if (drlst.size() == 0)
            return false;
        else
            return true;
    }*/ // end of duplicateMgmtActive    

    /*public static Messaging.SingleEmailMessage createEmail(List<String> toAddresses, String subject, String plainTextBody) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('The Helsing Group');
        mail.setSubject(subject);
        mail.setPlainTextBody(plainTextBody);

        return mail;
    }*/
    // P Sutherland. 1/11/2021 finds the object name from the record id of the SObject provided
    public static String getObjectTypeName(ID input){
        return input.getSObjectType().getDescribe().getName();
    }
    // P Sutherland added so that we can check the objects from the Metadata against salesforce
    // Begin SObjectDescibeCache
    // 1/21/2021
    public static map<Schema.SObjectType,Schema.DescribeSobjectResult> getSObjectSchema(list<Schema.SObjectType> tokens) {
        map<Schema.SObjectType,Schema.DescribeSobjectResult> mapSchemas = new map<Schema.SObjectType,Schema.DescribeSobjectResult>();
        mapSchemas = getSObjectSchema(tokens, true);
        return mapSchemas;
    }
    public static map<Schema.SObjectType,Schema.DescribeSobjectResult> getSObjectSchema(list<Schema.SObjectType> tokens, Boolean dname) {
        map<Schema.SObjectType,Schema.DescribeSobjectResult> mapSchemas = new map<Schema.SObjectType,Schema.DescribeSobjectResult>();
        list<String> notFound = new list<String>();
        for(Schema.SObjectType objName: tokens){
            if(schemasCache.containsKey(objName)){
                mapSchemas.put(objName,schemasCache.get(objName));
            } else {            
                notfound.add(String.valueOf(objName));
            }
        }
        // Cache Found
        if (notFound.isEmpty()) {
            return mapSchemas; }
        // Make the describe call
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(notFound);
        // For each returned result, write to cache and return map
        for(Schema.DescribeSobjectResult res : results) {
            if(dname){
                schemasCache.put(((SObject) Type.forName(res.getName()).newInstance()).getSObjectType(),res);
                mapSchemas.put(((SObject) Type.forName(res.getName()).newInstance()).getSObjectType(),res);
            } else {
                schemasCache.put(((SObject) Type.forName(res.getLabel()).newInstance()).getSObjectType(),res);
                mapSchemas.put(((SObject) Type.forName(res.getLabel()).newInstance()).getSObjectType(),res);
            }
        }
        return mapSchemas;
    }
    // end SObject DescribeCache

        // Use a Cache map to get the metadata you need
        private static map<String,Portal_Profile_Map__mdt> mdtPortalMapCache;
        static { mdtPortalMapCache = new map<String,Portal_Profile_Map__mdt>();} 
        // Use a Cache map to get the callout metadata you need
        public static map<String, Portal_Profile_Map__mdt> getPortalMapMeta() {
            map<String, Portal_Profile_Map__mdt> mdt = new map<String, Portal_Profile_Map__mdt>();
            mdt.putall(getPortalMapMeta(true));
            return mdt;
        }
    
        // Returns the cachemap if found, else it looksup the key value and returns the cachemap
        public static map<String, Portal_Profile_Map__mdt> getPortalMapMeta(Boolean b){
            // Cache Found
            if(!mdtPortalMapCache.keySet().IsEmpty()){
                return mdtPortalMapCache;
            }
            // Load the cache map and return from metadata query
            list<Portal_Profile_Map__mdt> metadata = new list<Portal_Profile_Map__mdt>();
            try{metadata = [SELECT Id,label,Profile_Id__c
                            FROM Portal_Profile_Map__mdt];
            } catch(Exception e){metadata = new list<Portal_Profile_Map__mdt>();}
    
            // Create Cache
            for(Portal_Profile_Map__mdt meta:metadata){
                if(!mdtPortalMapCache.containsKey(meta.label)){
                    mdtPortalMapCache.put(meta.label,meta);
                }
            }  
            return mdtPortalMapCache;      
        }


        // Use a Cache map to get the metadata you need
        private static map<String,Portal_Defaults__mdt> mdtPortalDefaultCache;
        static {mdtPortalDefaultCache = new map<String,Portal_Defaults__mdt>();} 
        // Use a Cache map to get the callout metadata you need
        public static map<String, Portal_Defaults__mdt> getPortalDefaultMeta() {
            map<String, Portal_Defaults__mdt> mdt = new map<String, Portal_Defaults__mdt>();
            mdt.putall(getPortalDefaultMeta(true));
            return mdt;
        }
    
        // Returns the cachemap if found, else it looksup the key value and returns the cachemap
        public static map<String, Portal_Defaults__mdt> getPortalDefaultMeta(Boolean b){
            // Cache Found
            if(!mdtPortalDefaultCache.keySet().IsEmpty()){
                return mdtPortalDefaultCache;
            }
            // Load the cache map and return from metadata query
            list<Portal_Defaults__mdt> metadata = new list<Portal_Defaults__mdt>();
            try{metadata = [SELECT Id,label,Portal_Profile_ID__c,Portal_Profile_Locale__c,
                            Portal_Profile_Language__c,Portal_Profile_Email_Key__c,
                            Portal_Profile_Timezone__c FROM Portal_Defaults__mdt];
            } catch(Exception e){metadata = new list<Portal_Defaults__mdt>();}
    
            // Create Cache
            for(Portal_Defaults__mdt meta:metadata){
                if(!mdtPortalDefaultCache.containsKey(meta.label)){
                    mdtPortalDefaultCache.put(meta.label,meta);
                }
            }  
            return mdtPortalDefaultCache;      
        }

        // Use a Cache map to get the metadata you need
        private static map<String,Portal_Profile_Map__mdt> mdtPortalProfileMapCache;
        static {mdtPortalProfileMapCache = new map<String,Portal_Profile_Map__mdt>();} 
        // Use a Cache map to get the callout metadata you need
        public static map<String, Portal_Profile_Map__mdt> getPortalProfileMapMeta() {
            map<String, Portal_Profile_Map__mdt> mdt = new map<String, Portal_Profile_Map__mdt>();
            mdt.putall(getPortalProfileMapMeta(true));
            return mdt;
        }
    
        // Returns the cachemap if found, else it looksup the key value and returns the cachemap
        public static map<String, Portal_Profile_Map__mdt> getPortalProfileMapMeta(Boolean b){
            // Cache Found
            if(!mdtPortalProfileMapCache.keySet().IsEmpty()){
                return mdtPortalProfileMapCache;
            }
            // Load the cache map and return from metadata query
            list<Portal_Profile_Map__mdt> metadata = new list<Portal_Profile_Map__mdt>();
            try{metadata = [SELECT Id,label,Portal_URL__c,Profile_Name__c
                            FROM Portal_Profile_Map__mdt];
            } catch(Exception e){metadata = new list<Portal_Profile_Map__mdt>();}
    
            // Create Cache
            for(Portal_Profile_Map__mdt meta:metadata){
                if(!mdtPortalProfileMapCache.containsKey(meta.label)){
                    mdtPortalProfileMapCache.put(meta.label,meta);
                }
            }  
            return mdtPortalProfileMapCache;      
        }
}