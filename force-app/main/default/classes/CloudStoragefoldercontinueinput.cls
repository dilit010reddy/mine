/*
@Author: P. Sutherland and N. Larkin
@Date: 12-9-2020
@Description:  API Class for CloudStorage folder list input when it continues looping through the batches.
@History:
*/
public class CloudStoragefoldercontinueinput {
        
        public String recordId {get;set;}
        public String cursor {get;set;}

        public CLoudStoragefoldercontinueinput(){
            this.recordId = '';
            this.cursor = '';
        }
        public CLoudStoragefoldercontinueinput(String recordId, String cursor){
            this.recordId = recordId;
            this.cursor = cursor;
        }
}