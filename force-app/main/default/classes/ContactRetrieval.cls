global class ContactRetrieval{

webService static String getContact(String id) {
   List<Contact> contacts = new List<Contact>();
   for (Contact contact : Database.query('Select Id, Name, Phone, AccountId from Contact where Id = :id')){
     contacts.add(contact);
   }
       String JSONString = JSON.serialize(contacts);
       return JSONString;
   }
}