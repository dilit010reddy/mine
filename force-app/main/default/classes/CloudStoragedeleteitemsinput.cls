/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage delete items input
@History:
*/
public class CloudStoragedeleteitemsinput {

	public String recordId {get;set;}
    public List<String> deletes {get;set;}
    public CloudStoragedeleteitemsinput(){
        this.recordId = '';
        this.deletes = new list<String>();
    }
    public CloudStoragedeleteitemsinput(String recordId, list<String> deletes){
        this.recordId = recordId;
        this.deletes = deletes;
    }
}