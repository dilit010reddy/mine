trigger makepublic on EmailMessage (before Insert) {

    if(trigger.isBefore && trigger.isInsert){
        EmailMessageTriggerHelper.makeExternalVisible(trigger.new);
        EmailMessageTriggerHelper.dedupeEmailReplies(trigger.new);
    }
    
}