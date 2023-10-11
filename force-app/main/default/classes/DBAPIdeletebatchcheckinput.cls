/*
@Author: P. Sutherland and N. Larkin
@Date: 12-9-2020
@Description:   API Class for the delete batch check 

@History:
*/
public with sharing class DBAPIdeletebatchcheckinput {
    public String async_job_id {get;set;}
    
    public DBAPIdeletebatchcheckinput(){
        this.async_job_id = '';
    }

    public DBAPIdeletebatchcheckinput(String async_job_id){
        this.async_job_id = async_job_id;
    }
}