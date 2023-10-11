/*
@Author: N. Larkin, QuantumRhino
@Date: 3/12/2021
@Description: Account Trigger, trigger handler. 

@History:
*/
public class AccountTriggerHandler {
   /* public AccountTriggerHandler() {
    }
    public void InitializeAccountFolders(list<Account> newAccounts){
      if(TriggerStatus.shouldRunTrigger()){
        System.enqueueJob(new QueueableInitializeFolder(newAccounts));
      }
    } */
    public void OnAfterInsert(list<Account> newAccounts){
      if(TriggerStatus.shouldRunTrigger()){
        AccountTriggerHelper helper = new AccountTriggerHelper();
        helper.InitializeAccountFolders(trigger.new);
      }
  }
}