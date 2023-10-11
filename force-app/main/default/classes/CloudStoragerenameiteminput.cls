/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage rename item input

@History:
*/
public class CloudStoragerenameiteminput {

	public String recordId;
    public String src;
    public String dest;
    public CloudStoragerenameiteminput(){
        this.recordId = '';
        this.src = '';
        this.dest = '';
    }
    public CloudStoragerenameiteminput(String recordId, String src, String dest){
        this.recordId = recordId;
        this.src = src;
        this.dest = dest;
    }
}