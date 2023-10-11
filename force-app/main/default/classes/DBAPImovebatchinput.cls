/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class move batch input

@History:
*/

public class DBAPImovebatchinput { //removed with sharing NL
        public List<Entries> entries{get;set;}
        public Boolean autorename{get;set;}
        public Boolean allow_ownership_transfer{get;set;}
        public DBAPImovebatchinput(){
            this.entries = new list<Entries>();
            this.autorename = null;
            this.allow_ownership_transfer = null;
        }

        public class Entries {
            public String from_path{get;set;}
            public String to_path{get;set;}
            public Entries(){
                this.from_path = '';
                this.to_path = '';
            }
            public Entries(String from_path, String to_path){
                this.from_path = from_path;
                this.to_path = to_path;
            }
        }    
}