/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class for Dropbox API delete input

@History:
*/
public class DBAPIdeleteinput {
	public String path{get;set;}
	public Boolean autorename{get;set;}
	public DBAPIdeleteinput(){
        this.path = '';
        this.autorename = null;
    }
}