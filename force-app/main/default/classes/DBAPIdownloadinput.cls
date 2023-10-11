/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class for Dropbox API download input

@History:
*/

public class DBAPIdownloadinput{
    public String path {get;set;}
    public String rev {get;set;}
    public DBAPIdownloadinput(){
        this.path = '';
        this.rev = null;
    }
    public DBAPIdownloadinput(String path, String rev){
        this.path = path;
        this.rev = rev;
    }
}