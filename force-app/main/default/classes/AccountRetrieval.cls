global class AccountRetrieval{

webService static String getAccount(String id) {
   List<Account> accounts = new List<Account>();
   for (Account account : Database.query('Select Id, Name, Phone from Account where Id = :id')){
     accounts.add(account);
   }
       String JSONString = JSON.serialize(accounts);
       return JSONString;
   }
}