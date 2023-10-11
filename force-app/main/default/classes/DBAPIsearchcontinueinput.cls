public with sharing class DBAPIsearchcontinueinput {
    public String cursor {get;set;}
    public DBAPIsearchcontinueinput(){
        this.cursor = '';
    }
    public DBAPIsearchcontinueinput(String cursor){
        this.cursor = cursor;
    }
}