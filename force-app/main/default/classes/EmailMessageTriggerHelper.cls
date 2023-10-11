public with sharing class EmailMessageTriggerHelper {
    
    public static void dedupeEmailReplies(List<EmailMessage> newEmailMessages){
        //List of Cases to delete, as they are deemed duplicate
        List<Case> casesToDelete = new List<Case>();
        //Bulkified Set of strings representing all referenced Message IDs on new Email Messages being inserted (used to locate existing Cases)
        Set<String> refIdStrings = new Set<String>();
        //Map of Email Message ID --> List of Referenced Message IDs
        Map<Id,List<String>> emIdRefListMap = new Map<Id,List<String>>();
        //List of pared down Email Messages to process. The criteria is that they must have Headers, must be related to a Case, and must be an Incoming Email
        List<EmailMessage> emailsToProcess = new List<EmailMessage>();
        //Map of Email Message Id to a Map of the keys in the Headers field with their value
        Map<Id,Map<String,String>> emailHeadersMap = new Map<Id,Map<String,String>>();
        //Go through trigger of Email Messages to find eligible Emails to process
        for(EmailMessage em : newEmailMessages){
            //Check what the Email Message is related to
            String sObjName = em.ParentId.getSObjectType().getDescribe().getName();
            //Make sure headers exist and that it is an incoming email related to a Case
            if(em.Headers != null && sObjName == 'Case' && em.Incoming && !em.Subject.contains('[ ref:')){
                emailsToProcess.add(em);                
            }
        }
        //Process eligible Email Messages and parse out Referenced Message IDs.
        //These IDs are the Message IDs of other emails earlier in the message chain to which this Email is a reply to
        for(EmailMessage em : emailsToProcess){
            //Holds a list of all the lines in the Headers field before we parse key and value pairs
            List<String> headerStringList = new List<String>();
            //Split the Header value by new line character
            headerStringList = em.Headers.split('\n');
            //Start to build a map for the Email Message with all of its Header properties
            emailHeadersMap.put(em.Id,new Map<String,String>());
            //Add each Header key value pair into the Map
            for(String str : headerStringList){
                emailHeadersMap.get(em.Id).put(str.substringBefore(': '),str.substringAfter(': '));
                //Check if we have a References key in the mix
                if(str.substringBefore(': ') == 'References'){
                    //Parse References value into a List of strings
                    List<String> refIds = str.substringAfter(': ').replace('<','').replace('>','').split(' ');
                    //Add all Referenced Message IDs into a List for SOQL
                    refIdStrings.addAll(refIds);
                    //Also put References into a Map keyed by Email Message ID for later
                    emIdRefListMap.put(em.Id,new List<String>(refIds));
                }
            }
        }
        //Query existing Email Messages for all the Referenced Message IDs in the Insert
        List<EmailMessage> emailMessageList = new List<EmailMessage>();
        emailMessageList = [SELECT Id, ParentId, Message_ID__c FROM EmailMessage WHERE Message_ID__c IN :refIdStrings WITH SECURITY_ENFORCED];
        Map<String,Id> messIdToEmParentMap = new Map<String,Id>();
        
        //Build a Map of ParentIDs (Cases), keyed by the Message ID
        //This is used to associate the duplicate email to the existing Case
        for(EmailMessage em : emailMessageList){
            messIdToEmParentMap.put(em.Message_ID__c,em.ParentId);
        }
        //Process eligible Email Messages a second time (avoids SOQL in a Loop)
        //This time parse out the Message ID in case it is a novel Email Message
        //We also compare the Referenced Message IDs to existing Email Messages to find duplicates
        for(EmailMessage em : emailsToProcess){
            String messId;
            //Parse out the Message ID
            messId = emailHeadersMap.get(em.id).get('Message-ID').replace('<','').replace('>','');
            //Used to tell us if we find any match to existing Email Messages
            Boolean matchFound = FALSE;
            //Go through all Referenced Message IDs and see if we have a match to an existing Email Message
            if(emailHeadersMap.get(em.id).containsKey('References')){
                for(String ref : emIdRefListMap.get(em.Id)){
                    //Existing Email Message found
                    if(messIdToEmParentMap.containsKey(ref)){
                        //Mark the new Case for deletion
                        casesToDelete.add(new Case(Id=em.parentId));
                        //Set the Email Message's ParentId to the existing Case
                        em.ParentId = messIdToEmParentMap.get(ref);
                        //Denote we found a match
                        matchFound = TRUE;
                        //Break the Loop
                        break;
                    }
                }
                //We went through all Referenced Message IDs and did not find a match. This is a novel Case/Email Message
                if(!matchFound){
                    em.Message_ID__c = messId;
                }
            }else{
                //There were no Referenced Message IDs in the Headers. This is a novel Case/Email Message
                em.Message_ID__c = messId;
            }
        }
        //Check if there are Cases to Delete
        if(casesToDelete.size()>0 && Schema.sObjectType.Case.isDeletable()){
            //Delete duplicate Cases
            delete casesToDelete;
        }
    }

    public static void makeExternalVisible(List<EmailMessage> newEmailMessages){
        for(EmailMessage em : newEmailMessages){
            em.IsExternallyVisible=true;
        }
    }
}