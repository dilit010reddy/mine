@istest
public class RuleHandler_TC {
	static testmethod void Insertaccount()
    {
        Account A1= new account();
        A1.Name = 'bankaccount';
        Insert A1;
        list<Rule__c> Rulelist = new list<Rule__c>();
          Rule__c R1 = new Rule__c();
            R1.Rule_Name__c = 'Bankrule1';
        	R1.Account__c = A1.Id;
         Rule__c R2 = new Rule__c();
            R2.Rule_Name__c = 'Bankrule2';
        	R2.Account__c = A1.Id;
            Rulelist.add(R1);
            Rulelist.add(R2);
        Insert Rulelist;
        
        Delete Rulelist[0];
    }
        
}