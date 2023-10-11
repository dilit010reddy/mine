@isTest
public class GenerateURL_TC {

    @isTest
    static void GenerateURLTest() {
        //Insert Test Account
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        
        //Insert Test Contact
        Contact con = new Contact(accountid = acct.Id, lastname = 'Contact2', firstname = 'Test', Email = 'testContact2@test.com', HasOptedOutOfEmail = false, Active__c = true, BOD__c = true);
        con.Signing_Order__c = '1';
        con.BOD_Term__c = System.today();
        con.Title = 'Test Title';
        insert con;
        
        //Insert Test Case
        Case cse = new Case();
        cse.AccountId = acct.Id;
        cse.Type = 'Work Order';
        cse.Status = 'new';
        cse.Signature_Card_Case__c = true;
        insert cse;

        APXTConga4__Conga_Template__c temp = new APXTConga4__Conga_Template__c(APXTConga4__Name__c = 'Signature Card for Conga Sign');
        insert temp;

        String genUrl = GenerateUrl.getUrl(cse.Id);
        System.assert(genURL.length()>0,true);
    }
}