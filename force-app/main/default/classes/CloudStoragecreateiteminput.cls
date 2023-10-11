/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage create item input

@History:
*/
public class CloudStoragecreateiteminput {

	public String recordId {get;set;}
    public list<String> paths  {get;set;}
    public String async_job_id {get;set;}
    public String type {get;set;}
    public Long offset {get;set;}
    public Blob data  {get;set;}
    public CloudStoragecreateiteminput() {
        this.recordId = '';
        this.paths = new list<String>();
        this.async_job_id = '';
        this.type = '';
        this.offset = 0;
        this.data = null;
    }

    public CloudStoragecreateiteminput(String recordId, list<String> paths, String async_job_id, String type, Long offset, Blob data) {
        this.recordId = recordId;
        this.paths = paths;
        this.async_job_id = async_job_id;
        this.type = type;
        this.offset = offset;
        this.data = data;
    }


}