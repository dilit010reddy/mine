/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API list folder continue input

@History:
*/
public class DBAPIlistfoldercontinput{
    public String cursor {get;set;}
    public DBAPIlistfoldercontinput(){
        this.cursor = '';
    }
    public DBAPIlistfoldercontinput(String cursor){
        this.cursor = cursor;
    }
}