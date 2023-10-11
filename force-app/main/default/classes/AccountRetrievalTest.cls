@isTest(SeeAllData=true)
private class AccountRetrievalTest {

    private static testMethod void testGetContacts() {
        TriggerStatus.setDoNotRunTrigger();
        // ANI to search on
        string ANI = '1234567890';
        Account account = new Account();
        account.Name = 'AccountRetrievalTest' + DateTime.now();
        account.phone = ANI;
        insert account;
        try {
            System.assert(AccountRetrieval.getAccount(account.Id).contains(ANI), 'Result should contain at least one account with ANI');
        } finally {
            delete account;
        }
    }
}