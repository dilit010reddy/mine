/* @Author: N. Larkin, QuantumRhino
@Date: 4/13/2021
@Description: Class for functions being run by the trigger helper*/
public with sharing class AccountTriggerHelper {
    public void InitializeAccountFolders(list<Account> newAccounts){
        if(TriggerStatus.shouldRunTrigger()){
          System.enqueueJob(new QueueableInitializeFolder(newAccounts));
        }
        }
}