public with sharing class ContentDocumentLinkTriggerHelper {
    public static void SetVisibility(ContentDocumentLink[] newContentDocumentLinks) {
        for(ContentDocumentLink l:newContentDocumentLinks) {
            l.Visibility='AllUsers';
        }

    }
}