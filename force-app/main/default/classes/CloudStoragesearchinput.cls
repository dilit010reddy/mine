/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   API Class for CloudStorage search input

@History:
*/
public class CloudStoragesearchinput {

	public String recordId;
    public String search;
    public String path;
    public CloudStoragesearchinput(){
        this.recordId = '';
        this.search = '';
        this.path = '';
    }
    public CloudStoragesearchinput(String recordId, String search, String path){
        this.recordId = recordId;
        this.search = search;
        this.path = path;
    }
}