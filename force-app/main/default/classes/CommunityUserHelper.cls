/*
@Author: C. Reynolds, Admins on Call
@Date: 07-12-2020
@Description: Used to create or deactivate Community Users based on the Contact and Account attributes

@History:
*/
public without sharing class CommunityUserHelper{
    public static void communityUserCreator(List<Contact> contactList) {
        map<String,Portal_Defaults__mdt> portalDefaults = Utils.getPortalDefaultMeta();
        Portal_Defaults__mdt portalDefault = portalDefaults.get('Portal Default');
        List<User> existingCommunityUsers = [SELECT Id, IsActive, ContactId FROM User WHERE ContactId IN :contactList];
        Map<Id,User> contactIdUserMap = new Map<Id,User>();
        List<User> userToBeCreated = new List<User>();
        List<Id> userToBeActivated = new List<Id>();
        List<Id> acctIdList = new List<Id>();
        Map<Id,Id> contactIdAcctIdMap = new Map<Id,Id>();
        for(User usr : existingCommunityUsers){
            contactIdUserMap.put(usr.ContactId, usr);
        }
        for(Contact con : contactList){
            if(contactIdUserMap.size() > 0 && contactIdUserMap.get(con.Id)!=null){
                // User usr = contactIdUserMap.get(con.Id);
                // usr.IsActive = TRUE;
                userToBeActivated.add(contactIdUserMap.get(con.Id).Id);
            }else{
                User nu = new User();
                nu.FirstName = con.FirstName;
                nu.LastName = con.LastName;
                nu.Email = con.Email;
                nu.UserName = con.email;
                nu.Alias = con.email.substring(0,3) + 'hcu';
                //nu.ProfileId = '00e2E000001jgKi';
                nu.ProfileId = portalDefault.Portal_Profile_ID__c;
                nu.ContactId = con.Id;
                //nu.TimeZoneSidKey = 'America/Phoenix';
                nu.TimeZoneSidKey = portalDefault.Portal_Profile_Timezone__c;
                //nu.LocaleSidKey = 'en_US';
                nu.LocaleSidKey = portalDefault.Portal_Profile_Locale__c;
                //nu.EmailEncodingKey = 'ISO-8859-1';
                nu.EmailEncodingKey = portalDefault.Portal_Profile_Email_Key__c;
                //nu.LanguageLocaleKey = 'en_US';
                nu.LanguageLocaleKey = portalDefault.Portal_Profile_Language__c;
                userToBeCreated.add(nu);
                acctIdList.add(con.AccountId);
                contactIdAcctIdMap.put(con.Id,con.AccountId);
            }
        }
        List<Account> acctList = new List<Account>();
        Map<Id,Account> acctMap = new Map<Id,Account>();
        if(acctIdList.size() > 0){
            acctList = [SELECT Id,Community_Domain__c FROM Account WHERE Id IN :acctIdList];
        }
        for(Account acct : acctList){
            acctMap.put(acct.Id,acct);
        }
        do{
            if(userToBeCreated.size()>0){
                try{
                    //do insert, no fail all on error
                    Database.SaveResult[] srList = Database.insert(userToBeCreated, false);
                    //go thru any duplicate username errors...attempt to fix by adding/incrementing count and add to this list
                    List<User> TMPuserToBeCreated = new List<User>();
                    //loop over saveresults
                    for (Integer i=0; i < srList.size(); i++){
                        //save this saveresult
                        Database.SaveResult sr = srList[i];
                        //if unsuccessful, check for duplicate username errors
                        if (!sr.isSuccess()){
                            //set boolean to false for duplicate username errors
                            Boolean isDuplicateUsernameError = false;
                            //loop over all errors and check if there's a duplicate username error
                            for(Database.Error err : sr.getErrors()){
                                System.debug('err.getStatusCode(): '+err.getStatusCode());
                                System.debug('err: '+err);
                                if(err.getStatusCode() == StatusCode.DUPLICATE_USERNAME){
                                    //duplicate username error, set corresponding boolean to true
                                    isDuplicateUsernameError = true;
                                    //break;
                                }else{
                                    System.debug('The following User error has occurred.');
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('User fields that affected this error: ' + err.getFields());
                                }
                            }
                            //if duplicate username error boolean is true, then we found a duplicate username error to attempt to fix
                            if(isDuplicateUsernameError){
                                //get the user from the original list which errored out, assuming the sequence of errorlist and userlist matches
                                User u = userToBeCreated[i];
                                //split on the @ character to get the first portion of the username
                                String firstPortion = u.UserName.split('@')[0];
                                if(acctMap.size() > 0 && contactIdAcctIdMap.size() > 0 && contactIdAcctIdMap.get(u.ContactId) != null && acctMap.get(contactIdAcctIdMap.get(u.ContactId)) != null && acctMap.get(contactIdAcctIdMap.get(u.ContactId)).Community_Domain__c!= null && u.UserName != firstPortion + acctMap.get(contactIdAcctIdMap.get(u.ContactId)).Community_Domain__c && u.UserName != firstPortion + '@thehelsinggroup.com'){
                                    u.UserName = firstPortion + acctMap.get(contactIdAcctIdMap.get(u.ContactId)).Community_Domain__c;
                                }else if(u.UserName != firstPortion + '@thehelsinggroup.com'){
                                    u.UserName = firstPortion + '@thehelsinggroup.com';
                                }else{
                                    u.UserName = firstPortion + '@thehelsinggroup' + String.valueOf(Integer.valueof((Math.random() * 100)) + '.com');
                                }
                                System.debug('Username: ' + u.UserName);
                                //after username modification, add user to tmp list for another attempt to be inserted
                                TMPuserToBeCreated.add(u);
                            }
                        }
                    }
                    //clear/reset the original user list after processing all errors in order to add the modified one for another attempt
                    userToBeCreated = new List<User>();
                    //if duplicate username errors were found and processed, need to add that list for another attempt to be inserted
                    if(TMPuserToBeCreated.size() > 0){
                        userToBeCreated = TMPuserToBeCreated;
                    }
                    //insert userToBeCreated;
                }catch (Exception e){
                    throw e;
                }
            }
        } while(userToBeCreated.size()>0); //every iteration, we clear this list and check if there are users to be reprocessed. If there are, then we repopulate this list with those users, otherwise size should go to 0 and exit this loop.
        
        if(userToBeActivated.size()>0){
            communityUserActivate(userToBeActivated);
        }
        // update userToBeActivated;
    }

    @future
    public static void communityUserRetire(List<Id> contactIdList) {
        List<User> existingCommunityUsers = [SELECT Id, IsActive, ContactId FROM User WHERE ContactId IN :contactIdList];
        for(User usr : existingCommunityUsers){
            if(usr.isActive == TRUE){
                usr.isActive = FALSE;
            }
        }
        if(!Test.isRunningTest()){
            update existingCommunityUsers;
        }
    }

    @future
    public static void communityUserActivate(List<Id> userIdList) {
        List<User> userUpdateList = new List<User>();
        for(Id usrId : userIdList){
            User usr = new User();
            usr.Id = usrId;
            usr.isActive = TRUE;
            userUpdateList.add(usr);
        }
        update userUpdateList;
    }
}