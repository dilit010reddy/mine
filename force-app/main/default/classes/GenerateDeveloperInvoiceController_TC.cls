@isTest(SeeAllData=true)
public class GenerateDeveloperInvoiceController_TC {

    @isTest
    public static void testmethod1() {
        // Developer_Billing_Data__c dbd = [SELECT Account__c FROM Developer_Billing_Data__c WHERE Account__c != null LIMIT 1];
        Account acc = [SELECT Id FROM Account Limit 1];
        ApexPages.currentPage().getParameters().put('accId', acc.Id);
        GenerateDeveloperInvoiceController cdic = new GenerateDeveloperInvoiceController();
    }
}