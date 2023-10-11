trigger ContentDocumentLinkTrigger on ContentDocumentLink (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    ContentDocumentLinkTriggerHandler handler = new ContentDocumentLinkTriggerHandler(Trigger.isExecuting, Trigger.size);

    if (Trigger.isInsert && Trigger.isBefore) {
        handler.OnBeforeInsert(Trigger.new, Trigger.newMap);
    }

}