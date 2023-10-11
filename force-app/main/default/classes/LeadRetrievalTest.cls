@isTest(SeeAllData=true)
private class LeadRetrievalTest {

    private static testMethod void testGetLead() {
        // ANI to search on
        string ANI = '1234567890';
        Lead lead = new Lead();
        lead.LastName = 'LeadRetrievalTest' + DateTime.now();
        lead.company = 'LeadRetrievalTestComp';
        lead.phone = ANI;
        insert lead;
        try {
            System.assert(LeadRetrieval.getLead(lead.Id).contains(ANI), 'Result should contain at least one lead with ANI');
        } finally {
            delete lead;
        }
    }
}