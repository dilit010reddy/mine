@isTest
public class NotifyBOD_TC {
    @isTest
    static void NotifyBOD_TC() {
        TriggerStatus.setDoNotRunTrigger();
        Account acc = new Account();
        acc.Name = 'Helsing Test';
        acc.Email__c = 'testemail@helsingtest.com';
        acc.Phone = '4283882889';
        insert acc;
        List<Contact> conList = new List<Contact>();
        Contact con = new Contact();
        con.AccountId = acc.Id;
        con.FirstName = 'Helsing';
        con.LastName = 'Contact';
        con.Email = 'test@helsingtest.com';
        con.Remove_Board__c = true;
        Contact con2 = new Contact();
        con2.AccountId = acc.Id;
        con2.FirstName = 'Helsing';
        con2.LastName = 'Contact2';
        con2.Email = 'test2@helsingtest.com';
        con2.Added_Board__c = true;

        conList.add(con);
        conList.add(con2);

        insert conList;

        Test.StartTest();
        BODScheduler bod = new BODScheduler();
        SchedulableContext sc = null;
        bod.execute(sc);
        Test.StopTest();
    }
}