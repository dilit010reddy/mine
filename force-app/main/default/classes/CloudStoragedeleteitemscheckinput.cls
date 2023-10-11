/*
@Author: P. Sutherland and N. Larkin
@Date: 12-9-2020
@Description:   Move batch API response parse routine and class
 This class combines the check and the initial struture from Dropbox because they could
 return the response to the inital request or we may have to loop over them
@History:
*/
public class CloudStoragedeleteitemscheckinput {
    public String async_job_id {get;set;}
    
    public CloudStoragedeleteitemscheckinput(){
        this.async_job_id = '';
    }

    public CloudStoragedeleteitemscheckinput(String async_job_id){
        this.async_job_id = async_job_id;
    }
}