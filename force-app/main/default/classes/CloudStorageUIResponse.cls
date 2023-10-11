/*
@Author: P. Sutherland, Admins on Call
@Date: 11-12-2020
@Description:   API Class for Dropbox API callouts.

@History:
*/

public class CloudStorageUIResponse {
    public String storage_app {get;set;}
    public String method {get;set;} 
    public Object response {get;set;}
    public String error_message {get;set;}
    public Integer http_status {get;set;}
    public Long correct_offset {get;set;}
    public CloudStorageUIResponse(){
        this.storage_app = '';
        this.method = '';
        this.response = null;
        this.error_message = '';
        this.http_status = 0;
        this.correct_offset = 0;
    }
    public CloudStorageUIResponse(String storage_app, String method, Object response, String error_message, Integer http_status){
        this.storage_app = storage_app;
        this.method = method;
        this.response = response;
        this.error_message = error_message;
        this.http_status = http_status;
        this.correct_offset = 0;
    }
    public CloudStorageUIResponse(String storage_app, String method, Object response, String error_message, Integer http_status, Long correct_offset){
        this.storage_app = storage_app;
        this.method = method;
        this.response = response;
        this.error_message = error_message;
        this.http_status = http_status;
        this.correct_offset = correct_offset;
    }
}