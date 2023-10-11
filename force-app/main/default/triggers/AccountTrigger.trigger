trigger AccountTrigger on Account (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
   /* if(TriggerStatus.shouldRunTrigger()){
        AccountTriggerHandler handler = new AccountTriggerHandler();
        handler.InitializeAccountFolders(trigger.new);
    }*/

    if(TriggerStatus.shouldRunTrigger()){
        AccountTriggerHandler handler = new AccountTriggerHandler();

        if ( trigger.isInsert && trigger.isBefore ){
            }
            else if( trigger.isInsert && trigger.isAfter ){
                handler.OnAfterInsert(trigger.new); 
            }     
            /*else if( trigger.isUpdate && trigger.isBefore ){
            }
            else if( trigger.isUpdate && trigger.isAfter ){
            }
            else if( trigger.isDelete && trigger.isBefore ){

            }
            else if( trigger.isDelete && trigger.isAfter ){
            }
            else if( trigger.isUnDelete ){  
            }*/
    }
}