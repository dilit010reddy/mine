/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   API Class for CloudStorage get temporary link input

@History:
*/
public class CloudStoragegettemporarylinkinput {

	public String recordId;
    public String path;
    public CloudStoragegettemporarylinkinput(){
        this.recordId = '';
        this.path = '';
    }
    public CloudStoragegettemporarylinkinput(String recordId, String path){
        this.recordId = recordId;
        this.path = path;
    }
}