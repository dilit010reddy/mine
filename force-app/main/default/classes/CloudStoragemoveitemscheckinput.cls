/*
@Author: P. Sutherland and N. Larkin
@Date: 12-10-2020
@Description: The input when you check the status of your move batch method
*/
public class CloudStoragemoveitemscheckinput {
    public String async_job_id{get;set;}

    public CloudStoragemoveitemscheckinput(){
        this.async_job_id = '';
    }

    public CloudStoragemoveitemscheckinput(String async_job_id){
        this.async_job_id = async_job_id;
    }
}