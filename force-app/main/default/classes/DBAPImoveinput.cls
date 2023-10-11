/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API move input

@History:
*/
public class DBAPImoveinput {

	public String from_path{get;set;}
	public String to_path{get;set;}
	public Boolean allow_shared_folder{get;set;}
	public Boolean autorename{get;set;}
	public Boolean allow_ownership_transfer{get;set;}
    public DBAPImoveinput(){
        this.from_path = '';
        this.to_path = '';
        this.allow_shared_folder = null;
        this.autorename = null;
        this.allow_ownership_transfer = null;
    }	
}