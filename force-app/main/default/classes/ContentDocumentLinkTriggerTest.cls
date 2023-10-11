@isTest
public with sharing class ContentDocumentLinkTriggerTest {

    private static String name='Test Account';

    @isTest
    public static void ContentDocumentLinkTriggerTest() {
        // Create an account with an opportunity
        Account acct = new Account(Name = name); 
        insert acct;
        Opportunity opp = new Opportunity(AccountId=acct.Id, StageName='Deal Won', Name='Test', CloseDate = Date.today());
        insert opp;
        // Create a ContentVersion
        ContentVersion ContentVer = new ContentVersion();
        ContentVer.Title = 'My Docs';
        ContentVer.ContentUrl= 'test.com';
        Insert ContentVer;
        
        // Create a ContentDocumentLink
        ContentDocumentLink ContentDL = new ContentDocumentLink();
        ContentDL.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: ContentVer.Id].ContentDocumentId;
        ContentDL.LinkedEntityId=opp.id;
        Insert ContentDL;
        List<ContentDocumentLink> cl = [SELECT Visibility FROM ContentDocumentLink WHERE Id = :ContentDL.Id];
        system.debug('cl.size(): '+cl.size());



        Test.startTest();
        for(ContentDocumentLink c : cl){
            system.debug('cl.Visibility: '+c.Visibility);
            system.assertEquals('AllUsers', c.Visibility);
        }
        Test.stopTest();
    }
}