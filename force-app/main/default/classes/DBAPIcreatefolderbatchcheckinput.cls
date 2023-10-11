/*
@Author: P. Sutherland and N. Larkin
@Date: 12-11-2020
@Description:  For sending in Async_Job_Id when checking if move batch has completed.
@History:
*/
public class DBAPIcreatefolderbatchcheckinput {

    public String async_job_id {get;set;}
    
    public DBAPIcreatefolderbatchcheckinput(){
        this.async_job_id = '';
    }

    public DBAPIcreatefolderbatchcheckinput(String async_job_id){
        this.async_job_id = async_job_id;
    }
}