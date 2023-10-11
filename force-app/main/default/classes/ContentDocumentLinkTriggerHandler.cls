public with sharing class ContentDocumentLinkTriggerHandler {

    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public ContentDocumentLinkTriggerHandler(boolean isExecuting, integer size){
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    public void OnBeforeInsert(ContentDocumentLink[] newContentDocumentLinks, Map<ID, ContentDocumentLink> newContentDocumentLinkMap) {
        // only run this if trigger is NOT fired from SyncStagingAndLiveDocController, controller already has
        // a prevent upload check
        ContentDocumentLinkTriggerHelper.SetVisibility(newContentDocumentLinks);
    }
}