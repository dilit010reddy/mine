/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage folder list input

@History:
*/

public class CloudStoragefolderinput {

	public String recordId {get;set;}
	public String path {get;set;}
	public Boolean recursive {get;set;}
	public Integer limit_Z {get;set;}
	public CLoudStoragefolderinput(){
        this.recordId = '';
        this.path = '';
        this.recursive = null;
        this.limit_z = null;
    }
    public CLoudStoragefolderinput(String recordId, String path, Boolean recursive, Integer limit_Z){
        this.recordId = recordId;
        this.path = path;
        this.recursive = recursive;
        this.limit_z = limit_z;
    }	
}