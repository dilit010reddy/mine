/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   API Class for CloudStorage get link input

@History:
*/
public class CloudStoragegetlinkinput {

	public String recordId;
    public String path;
    public CloudStoragegetlinkinput(){
        this.recordId = '';
        this.path = '';
    }
    public CloudStoragegetlinkinput(String recordId, String path){
        this.recordId = recordId;
        this.path = path;
    }
}