/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   API Class for CloudStorage get metadata input

@History:
*/
public class CloudStoragegetmetadatainput {

	public String recordId;
    public String path;
    public CloudStoragegetmetadatainput(){
        this.recordId = '';
        this.path = '';
    }
    public CloudStoragegetmetadatainput(String recordId, String path){
        this.recordId = recordId;
        this.path = path;
    }
}