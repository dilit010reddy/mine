/*
@Author: P. Sutherland and N. Larkin
@Date: 12-10-2020
@Description:  For sending in Async_Job_Id when checking if move batch has completed.
@History:
*/

public with sharing class DBAPImovebatchcheckinput {
    public String async_job_id {get;set;}
    
    public DBAPImovebatchcheckinput(){
        this.async_job_id = '';
    }

    public DBAPImovebatchcheckinput(String async_job_id){
        this.async_job_id = async_job_id;
    }
}