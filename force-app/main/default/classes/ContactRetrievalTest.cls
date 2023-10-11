@isTest(SeeAllData=true)
private class ContactRetrievalTest {

    private static testMethod void testGetContacts() {
        // ANI to search on
        string ANI = '1234567890';
        // Create Contact
        Contact contact = new Contact();
        contact.FirstName = 'Test' + DateTime.now();
        contact.LastName = 'ContactRetrievalTest';
        contact.phone = ANI;
        insert contact;
        try {
            // Test contact query method
            System.assert(ContactRetrieval.getContact(contact.Id).contains(ANI), 'Result should contain at least one contact with ANI');
        } finally {
            // Delete Contact
            delete contact;
        }
    }
}