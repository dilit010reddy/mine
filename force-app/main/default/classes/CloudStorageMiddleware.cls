/*
@Author: P. Sutherland, Admins on Call
@Date: 11-19-2020
@Description:   A broker class to map the reponse to the correct API based on metadata settings

@History:
N. Larkin, Admins on Call
*/
public without sharing class CloudStorageMiddleware {

    public class CloudStorageMiddlewareinput{
        public String method_name {get;set;}
        public Object inputparms {get;set;}
        public CloudStorageMiddlewareinput(){
            this.method_name = '';
            this.inputparms = null;
        }
        public CloudStorageMiddlewareinput(String method_name, Object inputparms){
            this.method_name = method_name;
            this.inputparms = inputparms;
        } 
    }

    public static Object getCloudStorageRequest(CloudStorageMiddlewareinput input){
        CloudStorage__mdt meta = CloudStorageUtilities.getCloudStorageMeta('Default');
        Object response = execAPICallout(meta, input);
        return (response == null) ? new CloudStorageController.ErrorResponse(500,'Null_Exception','Middleware mapped to null.') : response;
    }

    @TestVisible
    private static Object execAPICallout(CloudStorage__mdt meta, CloudStorageMiddlewareinput input){
        Object response = null;
        if(meta == null){
            response = new CloudStorageController.ErrorResponse(500,'Metadata001','Meta Data is missing');
        }
        else{
        switch on meta.Connected_App__c {
            when 'DropBox' {
                response = execDropBoxAPIcallout(meta,input);
            }
            when else {
                response = new CloudStorageController.ErrorResponse(500,'Metadata002','Meta Data Connected App not configured.');
            }
        }
    }
        return response;
    }
    
    @TestVisible
    private static Object execDropBoxAPIcallout(CloudStorage__mdt meta, CloudStorageMiddlewareinput input){ // reads the method from the controller and sets the response accordingly.
        Object response = null;
        switch on input.method_name {
            when 'folderlist' {
                response = DBlistview(meta, (CloudStoragefolderinput) input.inputparms);
            }
            when 'folderlistcontinue' {
                response = DBlistviewcontinue(meta, (CloudStoragefoldercontinueinput) input.inputparms);
            }
            when 'createitem' {
                response = DBcreateitem(meta, (CloudStoragecreateiteminput) input.inputparms);
            }
            when 'moveitems' {
                response = DBmoveitems(meta, (CloudStoragemoveitemsinput) input.inputparms);
            }
            when 'moveitemscheck' {
                response = DBmoveitemscheck(meta, (CloudStoragemoveitemscheckinput) input.inputparms);
            }
            when 'modifyitems' {
                response = DBmoveitems(meta, (CloudStoragemoveitemsinput) input.inputparms);
            }
            when 'modifyitemscheck' {
                response = DBmoveitemscheck(meta, (CloudStoragemoveitemscheckinput) input.inputparms);
            }
            when 'deleteitems' {
                response = DBdeleteitems(meta, (CloudStoragedeleteitemsinput) input.inputparms);
            }
            when 'deleteitemscheck' {
                response = DBdeleteitemscheck(meta, (CloudStoragedeleteitemscheckinput) input.inputparms);
            }
            when 'getmetadata' {
                response = DBgetmetadata(meta, (CloudStoragegetmetadatainput) input.inputparms);
            }
            when 'getlink' {
                response = DBgettemporarylink(meta, (CloudStoragegetlinkinput) input.inputparms);
            }
            when 'searchitem' {
                response = DBsearch(meta, (CloudStoragesearchinput) input.inputparms);
            }
            when 'searchitemcontinue' {
                response = DBsearchcontinue(meta, (CloudStoragesearchcontinueinput) input.inputparms);
            }
            when 'initializefolder' {
                response = DBinitializefolder(meta, (CloudStorageinitializefolderinput) input.inputparms);
            }
            when else {
                response = new CloudStorageController.ErrorResponse(500,'Callout001','Method for Dropbox not configured.');
            }
        }
        return response;
    }
    // Method to get the list view of folders and files
    // as of 11/19/2020 this will be the standard response for all returns
    public static Object DBlistview(CloudStorage__mdt meta, CloudStoragefolderinput parms) {
        Boolean isError = false;
        CloudStorageController.Entries response = new CloudStorageController.Entries();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){ //not using test responses
            DBAPIlistfolderinput inputparms = new DBAPIlistfolderinput();
            //if the request is for the root make sure it is replace by the customer root value
            if(parms.path == '/' || String.isEmpty(parms.path)){
               CloudStorageController.Initdata data = new CloudStorageController.Initdata();
               CloudStorageController.getcustpath(parms.recordId, parms.path, data);
               parms.path = data.custpath;
            }
            // format the input
            inputparms.path = parms.path;
            inputparms.recursive = parms.recursive;
            inputparms.limit_Z = parms.limit_Z;
            DBresponse = DropBoxAPI.postlistfolder(inputparms);
        } else {      //using test responses
            // Begin mockup for speed of testing
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'listfolder',
                                                    DBAPIlistfolder.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_LIST_FOLDER())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIlistfolder tmpobj = new DBAPIlistfolder();
            tmpobj = (DBAPIlistfolder) DBresponse.response;
            response.cursor = tmpobj.cursor;
            response.has_more = tmpobj.has_more; 
            for(DBAPIlistfolder.Entries ent : tmpobj.Entries){ 
                response.entries.add(new CloudStorageController.Entry(
                                                                      ent.id, 
                                                                      ent.x_tag,
                                                                      getfiletypeInfo(ent.path_lower, ent.x_tag),
                                                                      ent.is_downloadable,
                                                                      ent.name,
                                                                      ent.size,
                                                                      false,
                                                                      ent.path_lower,
                                                                      ent.path_display,
                                                                      '')
                                    );
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'folderlist001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }

    public static Object DBlistviewcontinue(CloudStorage__mdt meta, CloudStoragefoldercontinueinput parms) { //made public
        Boolean isError = false;
        CloudStorageController.Entries response = new CloudStorageController.Entries();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){
            DBAPIlistfoldercontinput inputparms = new DBAPIlistfoldercontinput();
            //format the input
            inputparms.cursor = parms.cursor;
            DBresponse = DropBoxAPI.postlistfoldercontinue(inputparms);
        } else {     
            // Begin mockup for speed of testing
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'listfoldercontinue',
                                                    DBAPIlistfolder.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIlistfolder tmpobj = new DBAPIlistfolder();
            tmpobj = (DBAPIlistfolder) DBresponse.response;
            response.cursor = tmpobj.cursor;
            response.has_more = tmpobj.has_more;   
            for(DBAPIlistfolder.Entries ent : tmpobj.Entries){
                response.entries.add(new CloudStorageController.Entry(
                                                                      ent.id, 
                                                                      ent.x_tag,
                                                                      getfiletypeInfo(ent.path_lower, ent.x_tag),
                                                                      ent.is_downloadable,
                                                                      ent.name,
                                                                      ent.size,
                                                                      false,
                                                                      ent.path_lower,
                                                                      ent.path_display,
                                                                      '')
                                    );
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'folderlistcontinue001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }
    // Process the Dropbox folder create or file upload(Blob data)
    public static Object DBcreateitem(CloudStorage__mdt meta, CloudStoragecreateiteminput input){ //made public
        Boolean isError = false;
        CloudStorageController.Metadata responseMeta = new CloudStorageController.Metadata();
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(input.offset == null){
            input.offset = 0; // prevent api 400 error due to null offset
        }

        if(!meta.Mock_Response__c){ // if it is not a test response.
            // Determine if this is a folder creation or a file upload, they reference different endpoints/domains in DropBox
            if(input.data == null){
                //this is a folder creation
                if(input.async_job_id == null){
                    DBAPIcreatefolderbatchinput inputparms = new DBAPIcreatefolderbatchinput();
                    inputparms.paths.addAll(input.paths);
                    DBresponse = DropBoxAPI.postcreatefolderbatch(inputparms);
                }
                else{
                    DBAPIcreatefolderbatchcheckinput inputparms = new DBAPIcreatefolderbatchcheckinput();
                    inputparms.async_job_id = input.async_job_id;
                    DBresponse = DropBoxAPI.postcreatefolderbatchcheck(inputparms);
                }

            } else { //file creation
                switch on input.type {
                    when 'start' {
                        DBAPIuploadsessionstartinput inputparms = new DBAPIuploadsessionstartinput();
                        DBresponse = DropBoxAPI.postuploadsessionstart(inputparms,input.data);
                    }
                    when 'append' {
                        DBAPIuploadsessionappendinput inputparms = new DBAPIuploadsessionappendinput();
                        inputparms.cursor.offset = input.offset;
                        inputparms.cursor.session_id = input.async_job_id;
                        DBresponse = DropBoxAPI.postuploadsessionappend(inputparms,input.data);
                    }
                    when 'finish' {
                        DBAPIuploadsessionfinishinput inputparms = new DBAPIuploadsessionfinishinput();
                        inputparms.cursor.offset = input.offset;
                        inputparms.cursor.session_id = input.async_job_id;
                        inputparms.commit_Z.path = input.paths[0];
                        DBresponse = DropBoxAPI.postuploadsessionfinish(inputparms,input.data);
                    }
                    when 'single' {
                        DBAPIuploadinput inputparms = new DBAPIuploadinput();
                        inputparms.path = input.paths[0];
                        DBresponse = DropBoxAPI.postupload(inputparms,input.data);
                    }
                    when else {
                        isError = true;
                        responseerror = new CloudStorageController.ErrorResponse(400, 'UploadSession001', 'The input type was not recognized: ' + input.type);
                    }
                }
            }
        } else {  //Using generated test responses 
            DropBoxAPI dbapi = new DropboxAPI();
            if(input.data == null){  //test folder creation
                if(input.async_job_id == null){
                    DBresponse = new CloudStorageUIResponse('DropBox',
                    'createitem',
                    DBAPIcreatefolderbatch.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_CREATE_FOLDER_BATCH())),
                    '',
                    200);
                }
                else{
                    DBresponse = new CloudStorageUIResponse('DropBox',
                    'createitem',
                    DBAPIcreatefolderbatch.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK())),
                    '',
                    200);
                }
            }
            else{ //test file creation
                switch on input.type {
                    when 'start' {
                        DBresponse = new CloudStorageUIResponse('DropBox',
                                                                'createitem',
                                                                DBAPIupload.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_UPLOAD_SESSION_START())),
                                                                '',
                                                                200);
                    }
                    when 'append' {
                        DBresponse = new CloudStorageUIResponse('DropBox',
                                                                'createitem',
                                                                DBAPIupload.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_UPLOAD_SESSION_APPEND_V2())),
                                                                '',
                                                                200);
                    }
                    when 'finish' {
                        DBresponse = new CloudStorageUIResponse('DropBox',
                                                                'createitem',
                                                                DBAPIupload.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_UPLOAD_SESSION_FINISH())),
                                                                '',
                                                                200);
                    }
                    when 'single' {
                        DBresponse = new CloudStorageUIResponse('DropBox',
                                                                'createitem',
                                                                DBAPIupload.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_UPLOAD())),
                                                                '',
                                                                200);
                    }
                    when else {
                        isError = true;
                        responseerror = new CloudStorageController.ErrorResponse(400, 'UploadSession001', 'The input type was not recognized: ' + input.type);
                    }}

                
            }
            
        }
        if(String.isEmpty(DBresponse.error_message)){
            // successful creation now format and load the list input and callout to get response struture
            if(input.data == null){ //successful folder
              dbapicreatefolderbatch responsebatch = new dbapicreatefolderbatch();
              responsebatch = (dbapicreatefolderbatch) DBresponse.response;
              response.success = true;
              response.async_job_id = responsebatch.async_job_id;
              response.status = responsebatch.x_tag;
              if(responsebatch.entries == null){
                responsebatch.entries = new List<DBAPIcreatefolderbatch.Entries>();
            }
                for (DBAPIcreatefolderbatch.Entries e : responsebatch.entries){
                    response.completionList.add(new CloudStorageController.StatusObj((e.x_tag == 'success') ? true : false, (e.x_tag == 'success') ? null : e.failure.failureMessage)); 
                }              
            }
            else{  //successful file creation
                switch on input.type {
                    when 'start' {
                        DBAPIuploadsession responseUpload = new DBAPIuploadsession();
                        responseUpload = (DBAPIuploadsession) DBresponse.response;
                        response.success = true;
                        response.status = 'start';
                        response.offset = responseUpload.offset;
                        response.async_job_id = responseUpload.session_id;
                    }
                    when 'append' {
                        DBAPIuploadsession responseUpload = new DBAPIuploadsession();
                        responseUpload = (DBAPIuploadsession) DBresponse.response;
                        response.success = true;
                        response.status = 'append';
                        response.offset = responseUpload.offset;
                        response.async_job_id = responseUpload.session_id;
                    }
                    when 'finish' {
                        DBAPIuploadsession responseUpload = new DBAPIuploadsession();
                        responseUpload = (DBAPIuploadsession) DBresponse.response;
                        responseMeta = new CloudStorageController.Metadata(responseUpload.id,
                                                                        'file',
                                                                        getfiletypeInfo(responseUpload.path_lower, 'file'),
                                                                        responseUpload.is_downloadable,
                                                                        responseUpload.name,
                                                                        responseUpload.client_modified,
                                                                        responseUpload.rev,
                                                                        responseUpload.size,
                                                                        (responseUpload.sharing_info.read_only == null) ? false :responseUpload.sharing_info.read_only,
                                                                        responseUpload.path_lower,
                                                                        responseUpload.path_display,
                                                                        '');
                    }
                    when 'single' {
                        DBAPIupload responseUpload = new DBAPIupload();
                        responseUpload = (DBAPIupload) DBresponse.response;
                        responseMeta = new CloudStorageController.Metadata(responseUpload.id,
                                                                        'file',
                                                                        getfiletypeInfo(responseUpload.path_lower, 'file'),
                                                                        responseUpload.is_downloadable,
                                                                        responseUpload.name,
                                                                        responseUpload.client_modified,
                                                                        responseUpload.rev,
                                                                        responseUpload.size,
                                                                        (responseUpload.sharing_info.read_only == null) ? false : responseUpload.sharing_info.read_only,
                                                                        responseUpload.path_lower,
                                                                        responseUpload.path_display,
                                                                        '');
                    }
                }
              
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'createitem001',DBresponse.error_message, DBresponse.correct_offset);
        }
        if(!isError){
            if((input.type == 'single' || input.type == 'finish') && input.data != null){ //return Metadata object for single and finish (added third condition to return correct response for folder creation)
                return responseMeta;
            }
            else{
                return response; //return responsetomovedelete for others
            }
        } else {
            return responseerror;
        }
    }
    // Process the Dropbox move item batch
    private static Object DBmoveitems(CloudStorage__mdt meta, CloudStoragemoveitemsinput input){
        Boolean isError = false;
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){
            DBAPImovebatchinput inputparms = new DBAPImovebatchinput();
            for(CloudStoragemoveitemsinput.Move mv: input.moves){
                inputparms.entries.add(new DBAPImovebatchinput.Entries(mv.src,mv.dest));
            }
            DBresponse = DropBoxAPI.postmovebatch(inputparms);
        } else {     
            // Begin mockup for speed of testing
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'movebatch',
                                                    DBAPImovebatch.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_MOVE_BATCH_V2())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPImovebatch responsemove = new DBAPImovebatch();
            responsemove = (DBAPImovebatch) DBresponse.response;
            response.async_job_id = responsemove.async_job_id;
            response.status = responsemove.x_tag;
            response.success = true;
            if(responsemove.entries == null){
                responsemove.entries = new List<DBAPImovebatch.Entries>();
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'movebatch001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }
        // Process the Dropbox move item checkbatch
    private static Object DBmoveitemscheck(CloudStorage__mdt meta, CloudStoragemoveitemscheckinput input){
        Boolean isError = false;
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){
            DBAPImovebatchcheckinput inputparms = new DBAPImovebatchcheckinput();
            inputparms.async_job_id = input.async_job_id;
            DBresponse = DropBoxAPI.postmovebatchcheck(inputparms);
        } else {     
            // Begin mockup for speed of testing
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'movebatchcheck',
                                                    DBAPImovebatch.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPImovebatch responsemove = new DBAPImovebatch();
            responsemove = (DBAPImovebatch) DBresponse.response;
            response.async_job_id = responsemove.async_job_id;
            response.status = responsemove.x_tag;
            response.success = true;
            if(responsemove.entries == null){
                responsemove.entries = new List<DBAPImovebatch.Entries>();
            }
            for (DBAPImovebatch.Entries e : responsemove.entries){
                response.completionList.add(new CloudStorageController.StatusObj((e.x_tag == 'success') ? true : false, (e.x_tag == 'success') ? null : e.failure.failureMessage));
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'movebatchcheck001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }   
    // Process the Dropbox delete item batch
    private static Object DBdeleteitems(CloudStorage__mdt meta, CloudStoragedeleteitemsinput input){
        Boolean isError = false;
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){ // Not using Test Responses
            DBAPIdeletebatchinput inputparms = new DBAPIdeletebatchinput();
            if(input.deletes.size() > 0){
                for(String s : input.deletes){
                    inputparms.entries.add(new DBAPIdeletebatchinput.Entries(s, null));
                }
            }         
            DBresponse = DropBoxAPI.postdeletebatch(inputparms);
        } else {     
            // Using Test Responses
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'deletebatch',
                                                    DBAPIdeletebatch.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_DELETE_BATCH())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIdeletebatch responsedelete = new DBAPIdeletebatch();
            responsedelete = (DBAPIdeletebatch) DBresponse.response;
            response.async_job_id = responsedelete.async_job_id;
            response.status = responsedelete.x_tag;
            response.success = true;
            if(responsedelete.entries == null){
                responsedelete.entries = new List<DBAPIdeletebatch.Entries>();
            }
            for (DBAPIdeletebatch.Entries e : responsedelete.entries){
                response.completionList.add(new CloudStorageController.StatusObj((e.x_tag == 'success') ? true : false, (e.x_tag == 'success') ? null : e.failure.failureMessage));
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'deletebatch001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }

    private static Object DBdeleteitemscheck(CloudStorage__mdt meta, CloudStoragedeleteitemscheckinput input){
        Boolean isError = false;
        CloudStorageController.Responsetomovedelete response = new CloudStorageController.Responsetomovedelete();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){ //Not Using Test Responses
            DBAPIdeletebatchcheckinput inputparms = new DBAPIdeletebatchcheckinput();
            inputparms.async_job_id = input.async_job_id;
            DBresponse = DropBoxAPI.postdeletebatchcheck(inputparms);
        } else {     //Using Test Responses
            // Begin mockup for speed of testing 
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'deletebatchcheck',
                                                    DBAPIdeletebatch.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_DELETE_BATCH_CHECK())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIdeletebatch responsedelete = new DBAPIdeletebatch();
            responsedelete = (DBAPIdeletebatch) DBresponse.response;
            response.async_job_id = responsedelete.async_job_id;
            response.status = responsedelete.x_tag;
            response.success = true;
            if(responsedelete.entries == null){
                responsedelete.entries = new List<DBAPIdeletebatch.Entries>();
            }
            for (DBAPIdeletebatch.Entries e : responsedelete.entries){
                response.completionList.add(new CloudStorageController.StatusObj((e.x_tag == 'success') ? true : false, (e.x_tag == 'success') ? null : e.failure.failureMessage));
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'deletebatchcheck001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }
    // Process the Dropbox get metadata
    private static Object DBgetmetadata(CloudStorage__mdt meta, CloudStoragegetmetadatainput input){
        Boolean isError = false;
        CloudStorageController.Metadata response = new CloudStorageController.Metadata();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){ // Not Using Test Responses
            DBAPIgetmetadatainput inputparms = new DBAPIgetmetadatainput();
            inputparms.path = input.path;
            DBresponse = DropBoxAPI.postgetmetadata(inputparms);
        } else {     //Using Test Responses
            // Begin mockup for speed of testing
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'getmetadata',
                                                    DBAPIgetmetadata.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_GET_METADATA())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIgetmetadata responsemeta = new DBAPIgetmetadata();
            responsemeta = (DBAPIgetmetadata) DBresponse.response;
            response = new CloudStorageController.Metadata(responsemeta.id,
                                                           responsemeta.x_tag,
                                                           getfiletypeInfo(responsemeta.path_lower, responsemeta.x_tag),
                                                           responsemeta.is_downloadable,
                                                           responsemeta.name,
                                                           responsemeta.client_modified,
                                                           responsemeta.rev,
                                                           responsemeta.size,
                                                           (responsemeta.sharing_info.read_only == null) ? false : responsemeta.sharing_info.read_only,
                                                           responsemeta.path_lower,
                                                           responsemeta.path_display,
                                                           '');
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'getmetadata001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }
    // Process the Dropbox get temporary link
    private static Object DBgettemporarylink(CloudStorage__mdt meta, CloudStoragegetlinkinput input){
        Boolean isError = false;
        CloudStorageController.Metadata response = new CloudStorageController.Metadata();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){ // Not Using Test Responses
            DBAPIgettemporarylinkinput inputparms = new DBAPIgettemporarylinkinput();
            inputparms.path = input.path;
            DBresponse = DropBoxAPI.postgettemporarylink(inputparms);
        } else {     //Using Test Responses
            // Begin mockup for speed of testing
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'getlink',
                                                    DBAPIgettemporarylink.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_GET_TEMPORARY_LINK())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIgettemporarylink responselink = new DBAPIgettemporarylink();
            responselink = (DBAPIgettemporarylink) DBresponse.response;
            response = new CloudStorageController.Metadata(responselink.metadata.id,
                                                           'file',
                                                           getfiletypeInfo(responselink.metadata.path_lower, 'file'),
                                                           responselink.metadata.is_downloadable,
                                                           responselink.metadata.name,
                                                           responselink.metadata.client_modified,
                                                           responselink.metadata.rev,
                                                           responselink.metadata.size,
                                                           (responselink.metadata.sharing_info.read_only == null ) ? false : responselink.metadata.sharing_info.read_only,
                                                           responselink.metadata.path_lower,
                                                           responselink.metadata.path_display,
                                                           responselink.link);
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'getlink001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }
    // Process the Dropbox get metadata
    private static Object DBsearch(CloudStorage__mdt meta, CloudStoragesearchinput input){
        Boolean isError = false;
        CloudStorageController.Entries response = new CloudStorageController.Entries();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){ //Not Using Test Responses
            DBAPIsearchinput inputparms = new DBAPIsearchinput();
            inputparms.query = input.search;
            //if the request is for the root make sure it is replace by the customer root value
            if(input.path == '/' || String.isEmpty(input.path)){
               CloudStorageController.Initdata data = new CloudStorageController.Initdata();
               CloudStorageController.getcustpath(input.recordId, input.path, data);
               input.path = data.custpath;
             }
            inputparms.options.path = input.path;
            //to do create the dropboxapi 
            DBresponse = DropBoxAPI.postsearch(inputparms);
        } else {     //Using Test Responses
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'searchitem',
                                                    DBAPIsearch.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_SEARCH_V2())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIsearch responsesearch = new DBAPIsearch();
            responsesearch = (DBAPIsearch) DBresponse.response;
            response.cursor = responsesearch.cursor;
            response.has_more = responsesearch.has_more;
            for(DBAPIsearch.matches match: responsesearch.matches){
                response.entries.add(new CloudStorageController.Entry(match.metadata.metadata.id, 
                                                                      match.metadata.metadata.x_tag,
                                                                      getfiletypeInfo(match.metadata.metadata.path_lower,match.metadata.metadata.x_tag),
                                                                      match.metadata.metadata.is_downloadable,
                                                                      match.metadata.metadata.name,
                                                                      match.metadata.metadata.size,
                                                                      false,
                                                                      match.metadata.metadata.path_lower,
                                                                      match.metadata.metadata.path_display,
                                                                      ''
                                                                     )
                                    );
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'search001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }

    private static Object DBsearchcontinue(CloudStorage__mdt meta, CloudStoragesearchcontinueinput input){
        Boolean isError = false;
        CloudStorageController.Entries response = new CloudStorageController.Entries();
        CloudStorageController.ErrorResponse responseerror = new CloudStorageController.ErrorResponse();
        CloudStorageUIResponse DBresponse = new CloudStorageUIResponse();
        if(!meta.Mock_Response__c){  //Not Using Test Responses
            DBAPIsearchcontinueinput inputparms = new DBAPIsearchcontinueinput();
            inputparms.cursor = input.cursor; 
            DBresponse = DropBoxAPI.postsearchcontinue(inputparms);
        } else {     //Using Test Responses
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'searchitemcontinue',
                                                    DBAPIsearch.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_SEARCH_CONTINUE_V2())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIsearch responsesearch = new DBAPIsearch();
            responsesearch = (DBAPIsearch) DBresponse.response;
            response.cursor = responsesearch.cursor;
            response.has_more = responsesearch.has_more;
            for(DBAPIsearch.matches match: responsesearch.matches){
                response.entries.add(new CloudStorageController.Entry(match.metadata.metadata.id, 
                                                                      match.metadata.metadata.x_tag,
                                                                      getfiletypeInfo(match.metadata.metadata.path_lower,match.metadata.metadata.x_tag),
                                                                      match.metadata.metadata.is_downloadable,
                                                                      match.metadata.metadata.name,
                                                                      match.metadata.metadata.size,
                                                                      false,
                                                                      match.metadata.metadata.path_lower,
                                                                      match.metadata.metadata.path_display,
                                                                      ''
                                                                     )
                                    );
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'searchcontinue001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        }
    }

    private static Object DBinitializefolder(CloudStorage__mdt meta, CloudStorageinitializefolderinput parms) {
        Object FirstResponse; // list of entries
        String concatenatedpath = '/' + meta.Root_Folder__c + '/' + meta.Default_Folder_Path__c;
        System.debug('********* : '+concatenatedpath);
        FirstResponse = CloudStorageMiddleware.DBlistview(meta, new CloudStoragefolderinput(parms.recordId, concatenatedpath, true, 2000)); //pulling default folder template from Dropbox
        CloudStorageController.Entries FolderTemplateList= new CloudStorageController.Entries();
        try{
            FolderTemplateList = (CloudStorageController.Entries) FirstResponse;
        }
        catch(Exception e){
            CloudStorageController.ErrorResponse UncastedError = new CloudStorageController.ErrorResponse();
            UncastedError = (CloudStorageController.ErrorResponse) FirstResponse;
            System.debug('Exception - Cast the FolderTemplateList into an error response: ' + UncastedError);
            return UncastedError;
        }
        list<String> pathstoInitialize = new list<String>();
        for(CloudStorageController.Entry e : FolderTemplateList.entries){
            System.debug('Entry path: ' + e.display_path);
            String replacementEntry;
            replacementEntry = e.display_path.replace(concatenatedpath, parms.path);
            pathstoInitialize.add(replacementEntry);
            //pathstoInitialize.add(e.display_path.replace(concatenatedpath, parms.path));
        }
        while(FolderTemplateList.has_more == true){ // dealing with has more
            CloudStoragefoldercontinueinput listcontinueresponse = new CloudStoragefoldercontinueinput(parms.recordId, FolderTemplateList.cursor);
            Object NextResponse = DBlistviewcontinue(meta, listcontinueresponse);
            try{
                FolderTemplateList = (CloudStorageController.Entries) NextResponse;
                for(CloudStorageController.Entry e : FolderTemplateList.entries){
                    System.debug('List continue path: ' + e);
                    pathstoInitialize.add(e.display_path.replace(concatenatedpath, parms.path));
                    System.debug('List continue replace path: ' + e.display_path.replace(concatenatedpath, parms.path));  
                }
            }
            catch(Exception e){
                CloudStorageController.ErrorResponse UncastedError = new CloudStorageController.ErrorResponse();
                UncastedError = (CloudStorageController.ErrorResponse) NextResponse;
                return UncastedError;
            }
            System.debug('NICHOLAS: has more ' + FolderTemplateList.has_more);
        }
        CloudStoragecreateiteminput createinput = new CloudStoragecreateiteminput();
        system.debug('*********** pathstoInitialize: '+pathstoInitialize);
        createinput.recordId = parms.recordId;
        createinput.paths.addAll(pathstoInitialize);
        createinput.async_job_id = null;
        createinput.data = null;

        return DBcreateitem(meta, createinput); // returns (CloudStorageController.Responsetomovedelete) object from folder initialization.
        
        /* dbapicreatefolderbatch createfolderbatchresponse = new dbapicreatefolderbatch();
        try{
            createfolderbatchresponse = (dbapicreatefolderbatch) DBresponse;
        }
        catch(exception e){
            CloudStorageController.ErrorResponse UncastedError = new CloudStorageController.ErrorResponse();
            UncastedError = (CloudStorageController.ErrorResponse) FirstResponse;
            System.debug('Exception - Cast the FolderTemplateList into an error response: ' + UncastedError);
            return UncastedError;
        }
        return DBresponse; */
        /* if(!meta.Mock_Response__c){ //not using test responses
            DBAPIlistfolderinput inputparms = new DBAPIlistfolderinput();
            //if the request is for the root make sure it is replace by the customer root value
            if(parms.path == '/' || String.isEmpty(parms.path)){
               CloudStorageController.Initdata data = new CloudStorageController.Initdata();
               CloudStorageController.getcustpath(parms.recordId, parms.path, data);
               parms.path = data.custpath;
            }
            // format the input
            inputparms.path = parms.path;
            //inputparms.recursive = parms.recursive;
            //inputparms.limit_Z = parms.limit_Z;
            DBresponse = DropBoxAPI.postlistfolder(inputparms);
        } else {      //using test responses
            // Begin mockup for speed of testing
            DropBoxAPI dbapi = new DropboxAPI();
            DBresponse = new CloudStorageUIResponse('DropBox',
                                                    'listfolder',
                                                    DBAPIlistfolder.parse(DBAPIMockResponseGenerator.createJsonResponse(meta.Connected_App__c,dbapi.getDROP_BOX_LIST_FOLDER())),
                                                    '',
                                                    200);
        }
        if(String.isEmpty(DBresponse.error_message)){
            DBAPIlistfolder tmpobj = new DBAPIlistfolder();
            tmpobj = (DBAPIlistfolder) DBresponse.response;
            response.cursor = tmpobj.cursor;
            response.has_more = tmpobj.has_more; 
            for(DBAPIlistfolder.Entries ent : tmpobj.Entries){ 
                response.entries.add(new CloudStorageController.Entry(
                                                                      ent.id, 
                                                                      ent.x_tag,
                                                                      getfiletypeInfo(ent.path_lower, ent.x_tag),
                                                                      ent.is_downloadable,
                                                                      ent.name,
                                                                      ent.size,
                                                                      false,
                                                                      ent.path_lower,
                                                                      ent.path_display,
                                                                      '')
                                    );
            }
        } else {
            isError = true;
            responseerror = new CloudStorageController.ErrorResponse(DBresponse.http_status,'folderlist001',DBresponse.error_message);
        }
        if(!isError){
            return response;
        } else {
            return responseerror;
        } */
    }
    //method to get extension/folder etc...
    @TestVisible
    private static String getfiletypeInfo(String input, String x_tag){
        if(x_tag == 'folder'){
            return 'doctype:folder';
        }
        String filename = input.right(input.length() - (input.lastindexOf('/') + 1));
        if(filename.Contains('.')){
            String extension = ((filename.length() - (filename.lastindexOf('.') + 1)) > 0) ? filename.right(filename.length() - (filename.lastindexOf('.') + 1)) : 'unknown';
            return 'doctype:' +  extension;
        } else {
            return 'doctype:unknown';
        }
    }
}