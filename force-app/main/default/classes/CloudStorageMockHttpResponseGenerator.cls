/*
@Author: P. Sutherland, Admins on Call
@Date: 11-25-2020
@Description:   Cloud Storage HTTP response Mock Genertator

@History:
*/
@isTest
public class CloudStorageMockHttpResponseGenerator implements HttpCalloutMock {
    
    map<String, HttpResponse> requests;

	public CloudStorageMockHttpResponseGenerator(map<String, HttpResponse> requests) {
		this.requests = requests;
	}

	public HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = requests.get(req.getEndpoint());
        if(response == null){
           System.debug('@#@ missing callout mock: ' + req.getEndPoint());
        }
		return response;
    }
    public static HTTPResponse constructMockResponse(map<String,String> headers, String body, String Status, Integer statusCode){
        return CloudStorageMockHttpResponseGenerator.constructMockResponse(headers, body, Status, statusCode, null);
    }
    // Construct Mock Response rather than hard code per spec/requirement
    public static HTTPResponse constructMockResponse(map<String,String> headers, String body, String Status, Integer statusCode, Blob bodyFile){
        HttpResponse res = new HttpResponse();
        if(statusCode != null) {
            res.setStatusCode(statusCode);
        }
        if(status != null) {    
            res.setStatus(status);
        }
        if(body != null) {
            System.debug('@#@ body: '+ body);
            res.setBody(body);
        }
        if(bodyFile != null){
            System.debug('@#@ blob: '+ bodyFile);
            res.setBodyAsBlob(bodyFile);
        }
        if(headers.size() > 0) {
            for(String s: headers.keySet()) {
                //System.debug('@#@ header: '+ s + ' '+ headers.get(s));
                res.setHeader(s, headers.get(s));
            }
        }
        return res;
    }
}