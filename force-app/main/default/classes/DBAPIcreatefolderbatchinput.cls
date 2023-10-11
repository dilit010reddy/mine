/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API createfolder batch input.

@History:
*/
public class DBAPIcreatefolderbatchinput {

	public List<String> paths {get;set;}
	public Boolean autorename {get;set;}
	public Boolean force_async {get;set;}
    public DBAPIcreatefolderbatchinput() {
        this.paths = new list<String>();
        this.autorename = false;
        this.force_async = false;
    }
	
}