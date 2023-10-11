/*
@Author: P. Sutherland, Admins on Call
@Date: 11-04-2020
@Description:   API Class for Dropbox API requests.

@History:
*/

public class DropBoxApiRequest {
    public final static String METHOD_POST = 'POST';
    public final static String METHOD_GET = 'GET';
    public final static String METHOD_PUT = 'PUT';
    public final static String METHOD_DELETE = 'DELETE';

    private static final Integer DEFAULT_CALLOUT_TIMEOUT = 20000;
    private static final Integer MAX_CALLOUT_FILE_SIZE = 6000000;

    public list<RequestHeader> headers;
    public final String method;
    public String authToken{get;set;}

    public String url { get; set; }
    //public String baererToken { get; set; }
    public String body { get; set; }
    public Blob bodyAsBlob { get; set; }
    public long bodyLength { get; set; }

    public DropBoxApiRequest() {
        this.url = '';
        this.method = '';
        this.headers = new List<RequestHeader>();
    }

    public DropBoxApiRequest(String url, String method, String baererToken) {
        this.url = url;
        this.method = method;
        this.headers = new List<RequestHeader>();
        this.addHeader('Authorization',baererToken);
    }

    public void addHeader(String key, String value) {
        this.headers.add(new RequestHeader(key, value));
    }

    public void setBody(String body) {
        this.body = body;
    }

    public HttpResponse send() {
        try {
             HttpResponse response = this.trySend();
             if(response.getStatusCode() == 401){
                System.debug('NICHOLAS we got a 401');
                authToken = RedirectToDBLink_AC.doRefreshAccessToken(true);
                for(integer i = 0; i < this.headers.size(); i++){
                    if(this.headers[i].key == 'Authorization' && this.headers[i].value.contains('Bearer')){
                        String bearerToken = 'Bearer ' + authToken;
                        this.headers[i].value = bearerToken;
                    }
                    if(this.headers[i].key == 'Content-Type'){
                        this.headers.remove(i);
                    }
                }
                HttpResponse response2 = this.trySend();

                Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
                customMetadata.fullName = 'CloudStorage.Default'; //custom metadata name
                customMetadata.label = 'Default';

                Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue(); //the values you're changing/updating
                customField1.field = 'Token__c'; //the custom field API Name that you're wanting to insert/update a value of
                customField1.value = authToken;
                customMetadata.values.add(customField1);

                Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
                mdContainer.addMetadata(customMetadata);
                
                Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, null);

                return response2;
            }
             return response;
        } catch (Exception ex) {
            system.debug('Exception: ' + ex.getMessage());
            throw new DropBoxApiRequestException(
                'An unexpected error occurred when trying to make a callout to the DropBox API. ' +
                ex.getMessage());
        }
    }

    private HttpResponse trySend() {
        Http h = new Http();
        //system.debug('@#@ Enter the trysend: ');
        HttpRequest request = new HttpRequest();
        request.setMethod(this.method);
        request.setEndpoint(this.url);
        request.setTimeout(DEFAULT_CALLOUT_TIMEOUT);
        if (this.bodyAsBlob != null) {
            request.setBodyAsBlob(this.bodyAsBlob);
            addOctetContentTypeHeader();
            // for blob content domain calls the json arguments are passed via the Dropbox-API-Arg header
            if(this.body != null){
               addheader('Dropbox-API-Arg',this.body);
               //this.body = null; 
            } 
        } else if (this.body != null) {
            request.setBody(this.body);
            addJsonContentTypeHeader();
        }/*  else {
            addJsonContentTypeHeader();
        } */
        for (RequestHeader header : this.headers) {
            system.debug('NICHOLAS Header: ' + header);
            request.setHeader(header.getKey(), header.getValue());
        }
        System.debug('NIcholas before send, request: ' + request);
        HttpResponse response = h.send(request);
        return response;
    }

    private static Boolean isResponseRetryable(Integer responseCode) {
        return (responseCode >= 500 || responseCode == 429);
    }

    private static Boolean isResponseRedirect(Integer responseCode) {
        return (responseCode == 301 || responseCode == 302);
    }

    private static Boolean isResponseBadRequest(Integer responseCode) {
        return (responseCode == 400);
    }

    private static Boolean isResponseNotFound(Integer responseCode) {
        return (responseCode == 404);
    }

    private class RequestHeader {
        private final String key;
        private String value;

        public RequestHeader(String key, String value) {
            this.key = key;
            this.value = value;
        }

        public String getKey() {
            return this.key;
        }

        public String getValue() {
            return this.value;
        }
    }

    public void addJsonContentTypeHeader() {
        this.addHeader('Content-Type', 'application/json');
    }
    public void addOctetContentTypeHeader() {
        this.addHeader('Content-Type', 'application/octet-stream');
    }
    public void addContentLengthHeader(Long length) {
        this.addHeader('Content-Length', String.valueof(length.intValue()));
    }

    public class DropBoxApiRequestException extends Exception {
    }
}