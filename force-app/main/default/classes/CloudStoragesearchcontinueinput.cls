/*
@Author: P. Sutherland and N. Larkin
@Date: 12-9-2020
@Description:   API Class for Dropbox API search when it continues searching through the batches

@History:
*/
public class CloudStoragesearchcontinueinput {
    public String cursor {get;set;}
    public CloudStoragesearchcontinueinput(){
        this.cursor = '';
    }
    public CloudStoragesearchcontinueinput(String cursor){
        this.cursor = cursor;
    } 
}