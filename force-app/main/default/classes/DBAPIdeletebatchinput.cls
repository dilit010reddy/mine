/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class delete batch input

@History:
*/
public class DBAPIdeletebatchinput {
    public List<Entries> entries{get;set;}
    public DBAPIdeletebatchinput(){
        this.entries = new list<Entries>();
    }
	public class Entries {
		public String path{get;set;}
        public String parent_rev{get;set;}
        public Entries(){
            this.path = '';
            this.parent_rev = null;
        }
        public Entries(String path, String parent_rev){
            this.path = path;
            this.parent_rev = parent_rev;
        } 
	}
}