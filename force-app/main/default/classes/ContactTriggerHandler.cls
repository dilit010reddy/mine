/*
@Author: C. Reynolds, Admins on Call
@Date: 07-12-2020
@Description:   Generic Trigger Handler for Contact.

@History:
*/
public with sharing class ContactTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean firstRun = true;

    public ContactTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert(Contact[] newContacts, Map<ID, Contact> newContactMap){
    }

    public void OnAfterInsert(Contact[] newContacts, Map<ID, Contact> newContactMap){
        ContactFunctions.checkForCommunityUsers(newContacts, new Map<Id,Contact>());
        ContactFunctions.createHomeownerAddressFolder(newContacts, new Map<Id,Contact>());
    }

    @future public static void OnAfterInsertAsync(Set<ID> newContactIDs){

    }

    public void OnBeforeUpdate(Contact[] oldContacts, Contact[] updatedContacts, Map<ID, Contact> oldContactMap, Map<ID, Contact> updatedContactMap){
    }
    
    public void OnAfterUpdate(Contact[] oldContacts, Contact[] updatedContacts, Map<ID, Contact> oldContactMap, Map<ID, Contact> updatedContactMap){
        ContactFunctions.checkForCommunityUsers(updatedContacts, oldContactMap);
        ContactFunctions.checkIfContactInfoChanged(updatedContacts, oldContactMap);
        if ( firstRun ) {
            firstRun = false;
        } else {
            system.debug('Already ran!');
            return;
        }
    }

    @future public static void OnAfterUpdateAsync(Set<ID> updatedContactIDs){
    }

    public void OnBeforeDelete(Contact[] ContactsToDelete, Map<ID, Contact> ContactsToDeleteMap){

    }

    public void OnAfterDelete(Contact[] deletedContacts, Map<ID, Contact> deletedContactMap){
    }

    @future public static void OnAfterDeleteAsync(Set<ID> deletedContactIDs){
    }

    public void OnUndelete(Contact[] restoredContacts, Map<ID, Contact> restoredContactMap){
    }

    public boolean IsTriggerContext{
        get{ return m_isExecuting;}
    }

    public boolean IsVisualforcePageContext{
        get{ return !IsTriggerContext;}
    }

    public boolean IsWebServiceContext{
        get{ return !IsTriggerContext;}
    }

    public boolean IsExecuteAnonymousContext{
         get{ return !IsTriggerContext;}
    }
}