@isTest
public with sharing class TC_makepublicTrigger {
    @isTest
    public static void TC_makepublicTrigger() {
        EmailMessage em = new EmailMessage();
        insert em;
    }
}