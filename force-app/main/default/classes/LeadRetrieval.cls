global class LeadRetrieval{

webService static String getLead(String id) {
   List<Lead> leads = new List<Lead>();
   for (Lead lead : Database.query('Select Id, Name, Phone, Company from Lead where Id = :id')){
     leads.add(lead);
   }
       String JSONString = JSON.serialize(leads);
       return JSONString;
   }
}