/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API callouts.

@History:
N. Larkin, Admins on Call
*/
public without sharing class DropBoxAPI {

    private final static String APPLICATION = 'DropBox';
    private final static String METHOD_POST = 'POST';
    private final static String METHOD_GET = 'GET';
    private final static Integer DEFAULT_CALLOUT_TIMEOUT = 20000;
    private final static String DROP_BOX_NAMESPACES_LIST = '/2/team/namespaces/list';
    private final static String DROP_BOX_NAMESPACES_LIST_CONTINUE = '/2/team/namespaces/list/continue';
    private final static String DROP_BOX_MEMBERS_LIST = '/2/team/members/list';
    private final static String DROP_BOX_MEMBERS_LIST_CONTINUE = '/2/team/members/list/continue';
    private final static String DROP_BOX_CREATE_FOLDER_BATCH = '/2/files/create_folder_batch';
    private final static String DROP_BOX_CREATE_FOLDER_BATCH_CHECK = '/2/files/create_folder_batch/check'; 
    private final static String DROP_BOX_LIST_FOLDER = '/2/files/list_folder';
    private final static String DROP_BOX_LIST_FOLDER_CONTINUE = '/2/files/list_folder/continue'; 
    private final static String DROP_BOX_MOVE_BATCH_V2 = '/2/files/move_batch_v2';
    private final static String DROP_BOX_MOVE_BATCH_CHECK_V2 = '/2/files/move_batch/check_v2';
    private final static String DROP_BOX_DELETE_BATCH = '/2/files/delete_batch';
    private final static String DROP_BOX_DELETE_BATCH_CHECK = '/2/files/delete_batch/check';
    private final static String DROP_BOX_UPLOAD = '/2/files/upload';
    private final static String DROP_BOX_DOWNLOAD = '/2/files/download';
    private final static String DROP_BOX_GET_METADATA = '/2/files/get_metadata';
    private final static String DROP_BOX_GET_TEMPORARY_LINK = '/2/files/get_temporary_link';
    private final static String DROP_BOX_SEARCH_V2 = '/2/files/search_v2';
    private final static String DROP_BOX_SEARCH_CONTINUE_V2 = '/2/files/search/continue_v2';
    private final static String DROP_BOX_UPLOAD_SESSION_START = '/2/files/upload_session/start';
    private final static String DROP_BOX_UPLOAD_SESSION_APPEND_V2 = '/2/files/upload_session/append_v2';
    private final static String DROP_BOX_UPLOAD_SESSION_FINISH = '/2/files/upload_session/finish';
    //Endpoints we no longer use:
    //private final static String DROP_BOX_MOVE_V2 = '/2/files/move_v2';
    //private final static String DROP_BOX_DELETE_V2 = '/2/files/delete_v2';
    //private final static String DROP_BOX_CREATE_FOLDER_V2 = '/2/files/create_folder_v2';

    public String getDROP_BOX_LIST_FOLDER(){
        return DROP_BOX_LIST_FOLDER;
    }
    public String getDROP_BOX_LIST_FOLDER_CONTINUE(){
        return DROP_BOX_LIST_FOLDER_CONTINUE;
    }
    public String getDROP_BOX_GET_METADATA(){
        return DROP_BOX_GET_METADATA;
    }
    public String getDROP_BOX_GET_TEMPORARY_LINK(){
        return DROP_BOX_GET_TEMPORARY_LINK;
    }
    public String getDROP_BOX_SEARCH_V2(){
        return DROP_BOX_SEARCH_V2;
    }
    public String getDROP_BOX_SEARCH_CONTINUE_V2(){
        return DROP_BOX_SEARCH_CONTINUE_V2;
    }
    public String getDROP_BOX_NAMESPACES_LIST(){
        return DROP_BOX_NAMESPACES_LIST;
    }
    public String getDROP_BOX_NAMESPACES_LIST_CONTINUE(){
        return DROP_BOX_NAMESPACES_LIST_CONTINUE;
    }
    public String getDROP_BOX_MEMBERS_LIST(){
        return DROP_BOX_MEMBERS_LIST;
    }
    public String getDROP_BOX_MEMBERS_LIST_CONTINUE(){
        return DROP_BOX_MEMBERS_LIST_CONTINUE;
    }
    public String getDROP_BOX_CREATE_FOLDER_BATCH(){
        return DROP_BOX_CREATE_FOLDER_BATCH;
    }
    public String getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(){
        return DROP_BOX_CREATE_FOLDER_BATCH_CHECK;
    }
    public String getDROP_BOX_MOVE_BATCH_V2(){
        return DROP_BOX_MOVE_BATCH_V2;
    }
    public String getDROP_BOX_MOVE_BATCH_CHECK_V2(){
        return DROP_BOX_MOVE_BATCH_CHECK_V2;
    }
    public String getDROP_BOX_DELETE_BATCH(){
        return DROP_BOX_DELETE_BATCH;
    }
    public String getDROP_BOX_DELETE_BATCH_CHECK(){
        return DROP_BOX_DELETE_BATCH_CHECK;
    }
    public String getDROP_BOX_UPLOAD(){
        return DROP_BOX_UPLOAD;
    }
    public String getDROP_BOX_DOWNLOAD(){
        return DROP_BOX_DOWNLOAD;
    }
    public String getDROP_BOX_UPLOAD_SESSION_START(){
        return DROP_BOX_UPLOAD_SESSION_START;
    }
    public String getDROP_BOX_UPLOAD_SESSION_APPEND_V2(){
        return DROP_BOX_UPLOAD_SESSION_APPEND_V2;
    }
    public String getDROP_BOX_UPLOAD_SESSION_FINISH(){
        return DROP_BOX_UPLOAD_SESSION_FINISH;
    }
    //outdated endpoint getters
    /*public String getDROP_BOX_DELETE_V2(){
        return DROP_BOX_DELETE_V2;
    }*/
    /* public String getDROP_BOX_MOVE_V2(){
        return DROP_BOX_MOVE_V2;
    } */
    /* public String getDROP_BOX_CREATE_FOLDER_V2(){
        return DROP_BOX_CREATE_FOLDER_V2;
    } */
    

    //To get API Endpoint URL     
    public static String getDropBoxEndpoint(CloudStorage__mdt meta, String method){
        string endpointURL = '';
        endpointURL = (meta == null) ? method : meta.Endpoint__c + method;
        return endpointURL;
    }

    //To get content URL     
    public static string getDropBoxContentEndpoint(CloudStorage__mdt meta, String method){
        string endpointURL = '';
        endpointURL = (meta == null) ? method : meta.Content_Endpoint__c + method;
        return endpointURL;
    }

    // creates the Auth header for callouts
    public static String createBearerToken(CloudStorage__mdt meta){
        return 'Bearer ' + meta.Token__c;
    }

    // creates the Dropbox-Api-Path-Root header for callouts
    public static String getAPIPathRoot(CloudStorage__mdt meta){
        if(String.isEmpty(meta.Dropbox_Api_Path_Root__c)){
            DBAPInamespaceslist response = postnamespaceslist();
            for(DBAPInamespaceslist.namespaces ns: response.namespaces){
                if(ns.name == meta.Api_Path_Root_Name__c){
                   updAPIPAthRoot(meta,ns.namespace_id);
                   break;
                }
            }
        }
        return generateApiPathRoot(new APIPathRoot(meta.Dropbox_Api_Path_Root__c));
    }
    // updates the metadata with the root id and updates the cache/metadata record
    private static void updAPIPathRoot(CloudStorage__mdt meta, String root){
        meta.DropBox_Api_Path_Root__c = root;
        CloudStorageUtilities.updateCloudStorageMetaCache(meta);
        String retstr = CloudStorageMetadataUtils.CloudStorageupsertMetadata(meta);
    }

    // creates the Dropbox-Api-Select-Admin header for callouts
    public static String getAPISelectAdmin(CloudStorage__mdt meta){
        if(String.isEmpty(meta.Dropbox_Api_Select_Admin__c)){
            DBAPImemberslist response = postmemberslist();
            for(DBAPImemberslist.members member: response.members){
                if(member.profile.email == meta.Api_Select_Admin_Name__c){
                   updAPISelectAdmin(meta, member.profile.team_member_id);
                   break;
                }
            }
        }
        return meta.Dropbox_Api_Select_Admin__c;
    }
    // updates the metadata with the admin id and updates the cache/metadata record
    private static void updAPISelectAdmin(CloudStorage__mdt meta, String admin){
        meta.Dropbox_Api_Select_Admin__c = admin;
        CloudStorageUtilities.updateCloudStorageMetaCache(meta);
        String retstr = CloudStorageMetadataUtils.CloudStorageupsertMetadata(meta);
    }

    // get metadata custom setting information..
    public static CloudStorage__mdt getDropboxMeta(){
        String mdt_key = 'Default';
        return CloudStorageUtilities.getCloudStorageMeta(mdt_key);
    }
    
    // Method to get response to namespaces/list API Call out
    @testvisible
    private static DBAPInamespaceslist postnamespaceslist(){
        DBAPInamespaceslist responseobj = new DBAPInamespaceslist();
        boolean hasmore = true,firsttimethru = true;
        String cursor = '';
        CloudStorage__mdt meta = getDropboxMeta();
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
            DropboxApiRequest dropboxreq = new DropboxApiRequest();
            while (hasmore) {
                dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,(firsttimethru)? DROP_BOX_NAMESPACES_LIST : DROP_BOX_NAMESPACES_LIST_CONTINUE),
                                                  METHOD_POST,
                                                  createBearerToken(meta)
                                                 );
               dropboxresp = new HttpResponse();
               if(firsttimethru){                  
                  firsttimethru = false;
                  dropboxreq.bodyLength = 0;
               } else {
                  dropboxreq.body = generatecursor(cursor);
                  dropboxreq.bodyLength = dropboxreq.body.length();
               }

               dropboxresp = dropboxreq.send();

               if(isResponseGood(dropboxresp.getStatusCode())){
                  DBAPInamespaceslist r = DBAPInamespaceslist.parse(dropboxresp.getBody());
                  responseobj.namespaces.addAll(r.namespaces);
                  responseobj.cursor = r.cursor;
                  responseobj.has_more = r.has_more;
                  cursor = r.cursor;                  
                  hasmore = r.has_more;
               } else {
                  responseobj = new DBAPInamespaceslist();
                  hasmore = false;
                  cursor = '';
               }
            }   
           } catch(Exception e){
            responseobj= new DBAPInamespaceslist();
           }
        } else {
            responseobj= new DBAPInamespaceslist();
        }
        return responseobj;
    }

    // Method to get response to members/list API Call out
    @TestVisible
    private static DBAPImemberslist postmemberslist(){
        DBAPImemberslist responseobj = new DBAPImemberslist();
        boolean hasmore = true,firsttimethru = true;
        String cursor = '';
        CloudStorage__mdt meta = getDropboxMeta();
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
            DropboxApiRequest dropboxreq = new DropboxApiRequest();
            while (hasmore) {               
               dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,(firsttimethru) ? DROP_BOX_MEMBERS_LIST: DROP_BOX_MEMBERS_LIST_CONTINUE),
                                                  METHOD_POST,
                                                  createBearerToken(meta)
                                                 );
               dropboxresp = new HttpResponse();
               if(firsttimethru){
                  firsttimethru = false;
                  dropboxreq.bodyLength = 0; 
               } else {
                  dropboxreq.body = generatecursor(cursor);
                  dropboxreq.bodyLength = dropboxreq.body.length(); 
               }                  
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                  DBAPImemberslist r = DBAPImemberslist.parse(dropboxresp.getBody());
                  responseobj.members.addAll(r.members);
                  responseobj.cursor = r.cursor;
                  cursor = r.cursor;
                  responseobj.has_more = r.has_more;
                  hasmore = r.has_more;
               } else {
                  DBAPIerror err = DBAPIerror.parse(dropboxresp.getBody());
                  hasmore = false;
             }
            }   
           } catch(Exception e){
            responseobj= new DBAPImemberslist();
           }
        } else {
            responseobj= new DBAPImemberslist();
        }
        return responseobj;
    }

    // Method to list folders
    public static CloudStorageUIResponse postlistfolder(DBAPIlistfolderinput input){
        DBAPIlistfolder responseobj = new DBAPIlistfolder();
        HTTPResponse dropboxresp = new HttpResponse();
        DBAPIerror responseerror = new DBAPIerror();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           DropboxApiRequest dropboxreq = new DropboxApiRequest();           
           try{
               dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_LIST_FOLDER),
                                                  METHOD_POST,
                                                  createBearerToken(meta)
                                                 );
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.body = DBAPIlistfolderinput.genlistfolderJSONString(input);                     
               dropboxreq.bodyLength = dropboxreq.body.length();
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){                   
                  responseobj = DBAPIlistfolder.parse(dropboxresp.getBody());
                } else {
                   responseerror = getErrorReponse(dropboxresp);
               }
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIlistfolder();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
        }
        return new CloudStorageUIResponse('Dropbox','listfolder',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    // Method to list folders continue
    public static CloudStorageUIResponse postlistfoldercontinue(DBAPIlistfoldercontinput input){
        DBAPIlistfolder responseobj = new DBAPIlistfolder();
        DBAPIerror responseerror = new DBAPIerror();
        DropboxApiRequest dropboxreq = new DropboxApiRequest(); 
        HTTPResponse dropboxresp = new HttpResponse();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){           
           try{
               dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_LIST_FOLDER_CONTINUE),
                                                   METHOD_POST,
                                                   createBearerToken(meta)
                                                  );
                loadTeamHeaders(meta, dropboxreq);
                dropboxreq.body = JSON.serialize(input,true);   
                dropboxreq.bodyLength = dropboxreq.body.length();
                dropboxresp = dropboxreq.send();
                if(isResponseGood(dropboxresp.getStatusCode())){
                    responseobj = DBAPIlistfolder.parse(dropboxresp.getBody());
                } else {
                    responseerror = getErrorReponse(dropboxresp);
                }
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIlistfolder();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIlistfolder();
        }
        return new CloudStorageUIResponse(APPLICATION,'listfoldercontinue',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    // Method to create folders
    // This method assumes the calling frontend code has formatted the code as follows:
    // Custom setting: root folder + / + account folder + any sub folder etc.....
    public static CloudStorageUIResponse postcreatefolderbatch(DBAPIcreatefolderbatchinput input){
        DBAPIcreatefolderbatch responseobj = new DBAPIcreatefolderbatch();
        DBAPIError responseerror = new DBAPIError();
        CloudStorage__mdt meta = getDropboxMeta();        
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_CREATE_FOLDER_BATCH), //Changed from Move Batch
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.body = JSON.serialize(input,true);
               dropboxreq.bodyLength = dropboxreq.body.length();
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                   responseobj = DBAPIcreatefolderbatch.parse(dropboxresp.getBody());
               } else {
                   responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIcreatefolderbatch();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIcreatefolderbatch();
        }
        return new CloudStorageUIResponse(APPLICATION,'createfolderbatch',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    public static CloudStorageUIResponse postcreatefolderbatchcheck(DBAPIcreatefolderbatchcheckinput input){
        DBAPIcreatefolderbatch responseobj = new DBAPIcreatefolderbatch();
        DBAPIError responseerror = new DBAPIError();
        CloudStorage__mdt meta = getDropboxMeta();        
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_CREATE_FOLDER_BATCH_CHECK),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.body = JSON.serialize(input,true);
               dropboxreq.bodyLength = dropboxreq.body.length();
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                   responseobj = DBAPIcreatefolderbatch.parse(dropboxresp.getBody());
               } 
               else {
                   responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIcreatefolderbatch();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIcreatefolderbatch();
        }
        return new CloudStorageUIResponse(APPLICATION,'createfolderbatchcheck',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    // Method that replaced moveitems
    public static CloudStorageUIResponse postmovebatch(DBAPImovebatchinput input){
        DBAPImovebatch responseobj = new DBAPImovebatch();
        DBAPIError responseerror = new DBAPIError();
        CloudStorage__mdt meta = getDropboxMeta();        
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_MOVE_BATCH_V2),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.body = JSON.serialize(input,true);
               dropboxreq.bodyLength = dropboxreq.body.length();
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                   responseobj = DBAPImovebatch.parse(dropboxresp.getBody());
               } else {
                   responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPImovebatch();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPImovebatch();
        }
        return new CloudStorageUIResponse(APPLICATION,'movebatch',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    // Method to check move batch
    public static CloudStorageUIResponse postmovebatchcheck(DBAPImovebatchcheckinput input){
    DBAPImovebatch responseobj = new DBAPImovebatch();
    DBAPIError responseerror = new DBAPIError();
    CloudStorage__mdt meta = getDropboxMeta();        
    HTTPResponse dropboxresp = new HttpResponse();
    // if metadata found proceed, else respond with an error
    if(meta <> null){
        try{
            DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_MOVE_BATCH_CHECK_V2),
                                                                METHOD_POST,
                                                                createBearerToken(meta)
                                                                );
            loadTeamHeaders(meta, dropboxreq);
            dropboxreq.body = JSON.serialize(input,true);
            dropboxreq.bodyLength = dropboxreq.body.length();
            dropboxresp = dropboxreq.send();
            if(isResponseGood(dropboxresp.getStatusCode())){
                responseobj = DBAPImovebatch.parse(dropboxresp.getBody());

            } else {
                responseerror = getErrorReponse(dropboxresp);
            }  
        } catch(Exception e){
            setExceptionError(responseerror,dropboxresp,e);
            responseobj= new DBAPImovebatch();
        }
    } else {
        setMetaError(responseerror,dropboxresp);
        responseobj= new DBAPImovebatch();
    }
    return new CloudStorageUIResponse(APPLICATION,'movebatchcheck',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
}

    // Method to delete batch
    public static CloudStorageUIResponse postdeletebatch(DBAPIdeletebatchinput entries){
        DBAPIdeletebatch responseobj = new DBAPIdeletebatch();
        DBAPIError responseerror = new DBAPIError();
        CloudStorage__mdt meta = getDropboxMeta();        
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
            try{
                DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_DELETE_BATCH),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                    );
                loadTeamHeaders(meta, dropboxreq);
                dropboxreq.body = JSON.serialize(entries,true);
                dropboxreq.bodyLength = dropboxreq.body.length();
                dropboxresp = dropboxreq.send();
                if(isResponseGood(dropboxresp.getStatusCode())){
                    responseobj = DBAPIdeletebatch.parse(dropboxresp.getBody());
                } else {
                    responseerror = getErrorReponse(dropboxresp);
                }  
            } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj = new DBAPIdeletebatch();
            }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIdeletebatch();
        }
        return new CloudStorageUIResponse(APPLICATION,'deletebatch',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    // Method to check batch delete
    public static CloudStorageUIResponse postdeletebatchcheck(DBAPIdeletebatchcheckinput input){
        DBAPIdeletebatch responseobj = new DBAPIdeletebatch();
        DBAPIError responseerror = new DBAPIError();
        CloudStorage__mdt meta = getDropboxMeta();        
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
            try{
                DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_DELETE_BATCH_CHECK),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                    );
                loadTeamHeaders(meta, dropboxreq);
                dropboxreq.body = JSON.serialize(input,true);
                dropboxreq.bodyLength = dropboxreq.body.length();
                dropboxresp = dropboxreq.send();
                if(isResponseGood(dropboxresp.getStatusCode())){
                    responseobj = DBAPIdeletebatch.parse(dropboxresp.getBody());
                } else {
                    responseerror = getErrorReponse(dropboxresp);
                }  
            } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIdeletebatch();
            }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIdeletebatch();
        }
        return new CloudStorageUIResponse(APPLICATION,'deletebatchcheck',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    // Method to upload a blob to dropbox
    // This method assumes the calling frontend code has formatted the code as follows:
    // Custom setting: root folder + / + account folder + any sub folder etc.....
    public static CloudStorageUIResponse postupload(DBAPIuploadinput input, Blob blobz){
        DBAPIupload responseobj = new DBAPIupload();
        DBAPIError responseerror = new DBAPIError();
        HTTPResponse dropboxresp = new HttpResponse();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxContentEndpoint(meta,DROP_BOX_UPLOAD),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );                                                  
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.body = DBAPIuploadinput.genuploadJSONString(input);
               dropboxreq.bodyAsBlob = blobz;
               dropboxreq.bodyLength = dropboxreq.bodyAsBlob.size(); 
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                   responseobj = DBAPIupload.parse(dropboxresp.getBody());
               } else {
                   responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIupload();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIupload();
        }
        return new CloudStorageUIResponse(APPLICATION,'upload',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    // Method to download a blob from dropbox
    public static CloudStorageUIResponse postdownload(DBAPIdownloadinput input){
        DBAPIdownload responseobj = new DBAPIdownload();
        DBAPIError responseerror = new DBAPIError();
        HTTPResponse dropboxresp = new HttpResponse();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxContentEndpoint(meta,DROP_BOX_DOWNLOAD),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );
               loadTeamHeaders(meta, dropboxreq);
               // must load the body to the arg header when interfacing with the content domain
               loadArgHeader(JSON.serialize(input,true), dropboxreq);
               dropboxreq.bodyLength = 0;
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){             
                   responseobj = DBAPIdownload.parse(dropboxresp.getHeader('Dropbox-Api-Result'));
                   responseobj.filedata = dropboxresp.getBodyAsBlob();
               } else {
                   responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIdownload();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIdownload();
        }
        return new CloudStorageUIResponse(APPLICATION,'download',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }
    // Method to get metadata
    public static CloudStorageUIResponse postgetmetadata(DBAPIgetmetadatainput input){
        DBAPIgetmetadata responseobj = new DBAPIgetmetadata();
        DBAPIerror responseerror = new DBAPIerror();
        CloudStorage__mdt meta = getDropboxMeta();        
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_GET_METADATA),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );               
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.body = DBAPIgetmetadatainput.gengetmetadataJSONString(input);
               dropboxreq.bodyLength = dropboxreq.body.length();
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                  responseobj = DBAPIgetmetadata.parse(dropboxresp.getBody());
               } else {
                  responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIgetmetadata();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIgetmetadata();
        }
        return new CloudStorageUIResponse('Dropbox','getmetadata',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }
    // Method to get a temporary link
    public static CloudStorageUIResponse postgettemporarylink(DBAPIgettemporarylinkinput input){
        DBAPIgettemporarylink responseobj = new DBAPIgettemporarylink();
        DBAPIerror responseerror = new DBAPIerror();
        CloudStorage__mdt meta = getDropboxMeta();        
        HTTPResponse dropboxresp = new HttpResponse();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_GET_TEMPORARY_LINK),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );               
               loadUserHeaders(meta, dropboxreq);
               dropboxreq.body = JSON.serialize(input,true);
               dropboxreq.bodyLength = dropboxreq.body.length();
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                  responseobj = DBAPIgettemporarylink.parse(dropboxresp.getBody());
               } else {
                  responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj = new DBAPIgettemporarylink();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIgettemporarylink();
        }
        return new CloudStorageUIResponse('Dropbox','getlink',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    // Method to search dropbox
    public static CloudStorageUIResponse postsearch(DBAPIsearchinput input){
        DBAPIsearch responseobj = new DBAPIsearch();
        HTTPResponse dropboxresp = new HttpResponse();
        DBAPIerror responseerror = new DBAPIerror();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           DropboxApiRequest dropboxreq = new DropboxApiRequest();           
           try{
               dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_SEARCH_V2),
                                                  METHOD_POST,
                                                  createBearerToken(meta)
                                                 );
               // for unknown reason the API does not work the same here have to use
               // user headers not admin header
               loadUserHeaders(meta, dropboxreq);
               dropboxreq.body = DBAPIsearchinput.gensearchJSONString(input);                     
               dropboxreq.bodyLength = dropboxreq.body.length();
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){    
                  responseobj = DBAPIsearch.parse(dropboxresp.getBody());             
                } else {
                   responseerror = getErrorReponse(dropboxresp);
               }
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj = new DBAPIsearch();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
        }
        return new CloudStorageUIResponse('Dropbox','searchitem',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }
    
    // Method to list folders continue
    public static CloudStorageUIResponse postsearchcontinue(DBAPIsearchcontinueinput input){
        DBAPIsearch responseobj = new DBAPIsearch();
        DBAPIerror responseerror = new DBAPIerror();
        DropboxApiRequest dropboxreq = new DropboxApiRequest(); 
        HTTPResponse dropboxresp = new HttpResponse();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){           
            try{
                dropboxreq = new DropboxApiRequest(getDropBoxEndpoint(meta,DROP_BOX_SEARCH_CONTINUE_V2),
                                                    METHOD_POST,
                                                    createBearerToken(meta)
                                                    );
                loadUserHeaders(meta, dropboxreq);
                dropboxreq.body = JSON.serialize(input,true);   
                dropboxreq.bodyLength = dropboxreq.body.length();
                dropboxresp = dropboxreq.send();
                if(isResponseGood(dropboxresp.getStatusCode())){
                    responseobj = DBAPIsearch.parse(dropboxresp.getBody());
                } else {
                    responseerror = getErrorReponse(dropboxresp);
                }
            } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIsearch();
            }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIsearch();
        }
        return new CloudStorageUIResponse(APPLICATION,'searchcontinue',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    public static CloudStorageUIResponse postuploadsessionstart(DBAPIuploadsessionstartinput input, Blob blobz){
        DBAPIuploadsession responseobj = new DBAPIuploadsession();
        DBAPIError responseerror = new DBAPIError();
        HTTPResponse dropboxresp = new HttpResponse();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxContentEndpoint(meta,DROP_BOX_UPLOAD_SESSION_START),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );                                                  
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.body = DBAPIuploadsessionstartinput.genUploadsessionstartJSONString(input);
               dropboxreq.bodyAsBlob = blobz;
               dropboxreq.bodyLength = dropboxreq.bodyAsBlob.size();
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                   responseobj = DBAPIuploadsession.parse(dropboxresp.getBody());
                   responseobj.offset = dropboxreq.bodyLength;
                } else {
                    responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIuploadsession();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIuploadsession();
        }
        return new CloudStorageUIResponse(APPLICATION,'uploadsessionstart',responseobj,responseerror.error_summary,dropboxresp.getStatusCode());
    }

    public static CloudStorageUIResponse postuploadsessionappend(DBAPIuploadsessionappendinput input, Blob blobz){
        DBAPIuploadsession responseobj = new DBAPIuploadsession();
        DBAPIError responseerror = new DBAPIError();
        HTTPResponse dropboxresp = new HttpResponse();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxContentEndpoint(meta,DROP_BOX_UPLOAD_SESSION_APPEND_V2),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );                                                  
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.bodyAsBlob = blobz;
               dropboxreq.bodyLength = dropboxreq.bodyAsBlob.size();
               dropboxreq.body = JSON.serialize(input, true); 
               dropboxresp = dropboxreq.send();
               if(isResponseGood(dropboxresp.getStatusCode())){
                   responseobj.session_id = input.cursor.session_id;
                   responseobj.offset = input.cursor.offset + dropboxreq.bodyLength;
                } else {
                    responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIuploadsession();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIuploadsession();
        }
        return new CloudStorageUIResponse(APPLICATION,'uploadsessionappend',responseobj,responseerror.error_summary,dropboxresp.getStatusCode(), responseerror.error.correct_offset);
    }

    public static CloudStorageUIResponse postuploadsessionfinish(DBAPIuploadsessionfinishinput input, Blob blobz){
        DBAPIuploadsession responseobj = new DBAPIuploadsession();
        DBAPIError responseerror = new DBAPIError();
        HTTPResponse dropboxresp = new HttpResponse();
        CloudStorage__mdt meta = getDropboxMeta();
        // if metadata found proceed, else respond with an error
        if(meta <> null){
           try{
               DropboxApiRequest dropboxreq = new DropboxApiRequest(getDropBoxContentEndpoint(meta,DROP_BOX_UPLOAD_SESSION_FINISH),
                                                                    METHOD_POST,
                                                                    createBearerToken(meta)
                                                                   );                                                  
               loadTeamHeaders(meta, dropboxreq);
               dropboxreq.bodyAsBlob = blobz;
               dropboxreq.bodyLength = dropboxreq.bodyAsBlob.size();
               dropboxreq.body = DBAPIuploadsessionfinishinput.genuploadsessionfinishJSONString(input); 
               dropboxresp = dropboxreq.send();
               
               if(isResponseGood(dropboxresp.getStatusCode())){
                   responseobj = DBAPIuploadsession.parse(dropboxresp.getBody());
                   responseobj.session_id = input.cursor.session_id;
                } else {
                    responseerror = getErrorReponse(dropboxresp);
               }  
           } catch(Exception e){
                setExceptionError(responseerror,dropboxresp,e);
                responseobj= new DBAPIuploadsession();
           }
        } else {
            setMetaError(responseerror,dropboxresp);
            responseobj= new DBAPIuploadsession();
        }
        return new CloudStorageUIResponse(APPLICATION,'uploadsessionfinish',responseobj,responseerror.error_summary,dropboxresp.getStatusCode(), responseerror.error.correct_offset);
    }

    public class Asyncoutput{
        public String async_job_id {get;set;}
        public Asyncoutput(){
            this.async_job_id = '';
        }
        public Asyncoutput(String async_job_id){
            this.async_job_id = async_job_id;
        }
    }
    // Cursor input inner class definition.
    public class Cursorinput{
        public String cursor {get;set;}
        public Cursorinput(){
            this.cursor = '';
        }
        public Cursorinput(String cursor){
            this.cursor = cursor;
        }
    }    

    public class APIPathRoot {
        public String x_tag {get;set;} // in json: .tag
        public String namespace_id {get;set;}
        public APIPathRoot() {
            this.x_tag = 'namespace_id';
            this.namespace_id = '';
        }
        public APIPathRoot(String namespace_id){
            this.x_tag = 'namespace_id';
            this.namespace_id = namespace_id;
        }
    }
    
    private static String generateApiPathRoot(APIPathRoot input){
        // Create a JSONGenerator object.
        JSONGenerator gen = JSON.createGenerator(false);
              
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('.tag', input.x_tag);
        gen.writeStringField('namespace_id', input.namespace_id);
        gen.writeEndObject();
        
        // Get the JSON string.
        return gen.getAsString();
    } 

    // Evaluates response codes
    private static Boolean isResponseGood(Integer responseCode){
        return (responseCode == 200);
    }
    // Evaluates response codes for error request(does not return a error response json)
    private static Boolean isResponseBadRequest(Integer responseCode){
        return (responseCode == 400 || responseCode == 404);
    }
    // loads the DropBoxApiRequest headers with the team admin and root directory entries
    private static void loadTeamHeaders(CloudStorage__mdt meta, DropBoxApiRequest dropboxreq){
        dropboxreq.addHeader('Dropbox-Api-Path-Root',getAPIPathRoot(meta)); //Do not push to production, commented out due to connection to QR's Business account
        dropboxreq.addHeader('Dropbox-Api-Select-User',getAPISelectAdmin(meta));
        //dropboxreq.addHeader((meta.DropBoxTeam__c) ? 'Dropbox-Api-Select-Admin' : 'Dropbox-Api-Select-User' ,getAPISelectAdmin(meta));
    }
    // loads the DropBoxApiRequest headers with the User and root directory entries
    private static void loadUserHeaders(CloudStorage__mdt meta, DropBoxApiRequest dropboxreq){
        dropboxreq.addHeader('Dropbox-Api-Path-Root',getAPIPathRoot(meta)); //Do not push to production, commented out due to connection to QR's Business account
        dropboxreq.addHeader('Dropbox-Api-Select-User',getAPISelectAdmin(meta));
    }
    // loads the DropBoxApiRequest header with the Arg header for content domain calls
    private static void loadArgHeader(String json, DropBoxApiRequest dropboxreq){
        dropboxreq.addHeader('Dropbox-API-Arg',json);
    }
    // returns the json string for a cursor event
    @TestVisible
    private static String generatecursor(String cursor){
        return JSON.serialize(new Cursorinput(cursor),true);
    }
    //Error response
    //Drop box send just a plain text message for 400 staus vs other status codes not
    private static DBAPIError getErrorReponse(HttpResponse dropboxresp){
        DBAPIError responseerror = new DBAPIError();
        if(!isResponseBadRequest(dropboxresp.getStatusCode())){
            responseerror = DBAPIerror.parse(dropboxresp.getBody());
        } else {
            responseerror.error_summary = dropboxresp.getBody();
        }
        return responseerror;
    }
    // Set the salesforce error
    private static void setExceptionError(DBAPIError responseerror, HttpResponse dropboxresp, Exception e){
        responseerror.error_summary = 'SFDC Details: ' + e.getMessage();
        dropboxresp.setStatusCode(500);
    }
    //Set the Meta missing error - just in case
    private static void setMetaError(DBAPIError responseerror, HttpResponse dropboxresp){
        responseerror.error_summary = 'Custom Setting Metadata missing for DropBox API connection';
        dropboxresp.setStatusCode(500);
    }
    //Set the Other error - just in case
    @TestVisible
    private static void setOtherError(DBAPIError responseerror, HttpResponse dropboxresp, String error){
        responseerror.error_summary = error;
        dropboxresp.setStatusCode(500);
    }
}