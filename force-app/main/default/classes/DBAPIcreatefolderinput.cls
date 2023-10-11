/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class for Dropbox API createfolder input.

@History:
*/
public class DBAPIcreatefolderinput {
	public String path{get;set;}
    public Boolean autorename{get;set;}
    public DBAPIcreatefolderinput(){
        this.path = '';
        this.autorename = null;
    }
}