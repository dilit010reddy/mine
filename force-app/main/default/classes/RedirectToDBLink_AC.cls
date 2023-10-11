/*
@Author: N. Larkin, Quantum Rhino
@Date: 6/10/2021
@Description: Controller for Dropbox Oauth2 flow

@History:
*/
public class RedirectToDBLink_AC{

    public RedirectToDBLink_AC(){
        if(ApexPages.currentPage().getParameters().get('code') == null){
            doAuthorizationDropbox();
        }
    }
    /*
     * @Name - doAuthorizationDropbox
     * @Param - None
     * @Description - to get the authentication code from the Dropbox Account
     * @ReturnType - PageReference
    */
    
    public static PageReference doAuthorizationDropbox(){

        CloudStorage__mdt meta = DropboxAPI.getDropboxMeta();
    
        String authorization_endpoint = 'https://www.dropbox.com/oauth2/authorize';
        
        String scope = 'files.content.read files.metadata.read sharing.read sharing.write';

        System.debug('NICHOLAS client id: ' + meta.Client_Id__c);
        String final_EndPoint = authorization_endpoint+'?client_id='+meta.Client_Id__c+'&redirect_uri='+meta.Redirect_URI__c+'&response_type=code&token_access_type=offline';
        //String final_EndPoint = authorization_endpoint+'?client_id=qjymcscmo11rsjn'+'&redirect_uri='+meta.Redirect_URI__c+'&response_type=code&token_access_type=offline';
        PageReference pageRef = new PageReference(final_EndPoint);
        return pageRef;
    }
    /*
     * @Name - doFetchAccessToken
     * @Param - None
     * @Description - to get the Access Token, Refresh Token, and other Information after getting the authentication code
     * @ReturnType - void
    */
    public static void doFetchAccessToken(){
        CloudStorage__mdt meta = DropboxAPI.getDropboxMeta();
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(meta.Client_Id__c+':'+meta.Client_Secret__c));
        String endPoint = 'https://api.dropbox.com/oauth2/token';
        
        String oAuthCode = ApexPages.currentPage().getParameters().get('code');
        String requestBody = 'grant_type=authorization_code&code='+oAuthCode+'&redirect_uri='+meta.Redirect_URI__c;
        String errorMessage ='';
        
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(endPoint);
        httpReq.setHeader('Authorization' , 'Basic '+encodedString);
        //httpReq.setHeader('Dropbox-API-Select-User', 'dbmid:AABMgpvPCGxHYdpUpD_hqRO_6GzAlN3PM9s');
        //httpReq.setHeader('Content-Type' , 'application/x-www-form-urlencoded');
        httpReq.setBody(requestBody);
        
        try{
            if(!Test.isRunningTest()){
            httpRes = http.send(httpReq);
            }
            
            if(httpRes.getStatusCode() == 200 || Test.isrunningtest() == true){
                Map<String, Object> response_Map = new Map<String, Object>();
                    if(!Test.isrunningtest()){
                        response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
                    }
                    else{
                        response_Map.put('access_token', 'testToken');
                        response_Map.put('refresh_token', 'testRefreshToken');
                    }
                
                String accessToken = (String)response_Map.get('access_token');
                String refreshToken = (String)response_Map.get('refresh_token');

                Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
                customMetadata.fullName = 'CloudStorage.Default'; //custom metadata name
                customMetadata.label = 'Default';

                Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue(); //the values you're changing/updating
                customField1.field = 'Token__c'; //the custom field API Name that you're wanting to insert/update a value of
                customField1.value = accessToken;
                customMetadata.values.add(customField1);

                Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue(); //the values you're changing/updating
                customField2.field = 'Refresh_Token__c'; //the custom field API Name that you're wanting to insert/update a value of
                customField2.value = refreshToken;
                customMetadata.values.add(customField2);

                Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
                mdContainer.addMetadata(customMetadata);
                
                Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
        
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Successfully Authenticated with Dropbox System!!!'));
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error while communicating with Dropbox API'+
                                         'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode()));
            }
           
        }catch(System.Exception e){
            System.debug('#### Exception Executed '+e.getStackTraceString());
             if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                    errorMessage = 'Unauthorize endpoint: '+ endPoint;
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                    //return null;
            }else{
                errorMessage = 'Unexpected Error while communicating with Dropbox API. '
                    +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                //return null;
            }
        }  
    }
    /*
     * @Name - doRefreshAccessToken
     * @Param - None
     * @Description - to get the Refresh Token and other Information after access token expires
     * @ReturnType - void
    */
    public static void doRefreshAccessToken(){
        CloudStorage__mdt meta = DropboxAPI.getDropboxMeta();
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(meta.Client_Id__c+':'+meta.Client_Secret__c));
        String endPoint = 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer';
        
        //DropBoxSettings__c DBInfo = new DropBoxSettings__c();
        //DBInfo = DropBoxSettings__c.getinstance('Dropbox Setting Info');
        
        String oAuthCode = ApexPages.currentPage().getParameters().get('code');
        String requestBody = 'grant_type=refresh_token&refresh_token=';
        if(meta.Refresh_Token__c != null){
            requestBody+= meta.Refresh_Token__c;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Refresh Token is NULL'));
        }
        String errorMessage ='';
        
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(endPoint);
        httpReq.setHeader('Authorization' , 'Basic '+encodedString);
        httpReq.setHeader('Content-Type' , 'application/x-www-form-urlencoded');
        httpReq.setBody(requestBody);
        
        try{
            // Check if Access Token is expired or not.
            // if Expired then get the new Token
            //if(DBInfo != null && DBInfo.Expires_In_Time__c <= System.Now()){
                if(!Test.isRunningTest()){
                    httpRes = http.send(httpReq);
                }
                if(httpRes.getStatusCode() == 200  || Test.isrunningtest() == true){
                    Map<String, Object> response_Map = new Map<String, Object>();
                    if(!test.isRunningTest()){
                        response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
                    }
                    else{
                        response_Map.put('access_token', 'testToken');
                    }
                    // Assign the Value to the Existing Dropbox info Object and at the last update the information
                    // with new values
                    

                    Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
                    customMetadata.fullName = 'CloudStorage.Default'; //custom metadata name
                    customMetadata.label = 'Default';

                    Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue(); //the values you're changing/updating
                    customField1.field = 'Token__c'; //the custom field API Name that you're wanting to insert/update a value of
                    customField1.value = String.valueOf(response_Map.get('access_token'));
                    customMetadata.values.add(customField1);


                    Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
                    mdContainer.addMetadata(customMetadata);
                    
                    Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error while communicating with Dropbox API'+
                                             'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode()));
                }
            //}
            
        }catch(System.Exception e){
            System.debug('#### Exception Executed '+e.getStackTraceString());
             if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                    errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                        +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                    //return null;
            }else{
                errorMessage = 'Unexpected Error while communicating with Dropbox API. '
                    +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                //return null;
            }
        }  
    }

    public static String doRefreshAccessToken(boolean t){
        CloudStorage__mdt meta = DropboxAPI.getDropboxMeta();
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(meta.Client_Id__c+':'+meta.Client_Secret__c));
        String endPoint = 'https://api.dropbox.com/oauth2/token';
        String accessToken;
        
        String requestBody = 'grant_type=refresh_token&refresh_token=';
        if(meta.Refresh_Token__c != null){
            requestBody+= meta.Refresh_Token__c;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Refresh Token is NULL'));
        }
        String errorMessage ='';
        
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(endPoint);
        httpReq.setHeader('Authorization' , 'Basic '+encodedString);
        httpReq.setBody(requestBody);
        
        try{
                if(!Test.isRunningTest()){
                    httpRes = http.send(httpReq);
                }
                System.debug('Nicholas, Going in.');
                if(httpRes.getStatusCode() == 200 || Test.isrunningtest() == true){
                    System.debug('Nicholas, Successfully in.');
                    Map<String, Object> response_Map = new Map<String, Object>();
                    if(!test.isRunningTest()){
                        response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
                    }
                    else{
                        response_Map.put('access_token', 'testToken');
                        response_Map.put('expires_in', 1.1);
                    }
                    accessToken = String.valueOf(response_Map.get('access_token')); 
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error while communicating with Dropbox API'+
                                             'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode()));
                }
            
        }catch(System.Exception e){
            System.debug('#### Exception Executed '+e.getStackTraceString());
             if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                    errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                        +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }else{
                errorMessage = 'Unexpected Error while communicating with Dropbox API. '
                    +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
            }
        } 
       if(accessToken != null){
           return accessToken;
       }  
       else{
           return 'error in getting access token';
       }
    }
}