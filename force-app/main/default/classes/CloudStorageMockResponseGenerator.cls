/*
@Author: P. Sutherland, Admins on Call
@Date: 12-08-2020
@Description:   Class for CloudStorageMockTesting

@History:
*/
@isTest
public with sharing class CloudStorageMockResponseGenerator {
    public static map<String,HttpResponse> CloudStorageMockResponseGen(String request, CloudStorage__mdt meta){
        map<String,HttpResponse> response = new map<String, HttpResponse>();
        switch on meta.Connected_App__c {
            when 'DropBox' {
                response.putAll(execDBMockResponse(request,meta));
            }
        }        
        return response;
    }
    private static map<String,HttpResponse> execDBMockResponse(String request, CloudStorage__mdt meta){
        map<String,HttpResponse> mockresponses = new map<String, HttpResponse>();
        DropBoxAPI dbapi = new DropboxAPI();
        switch on request {
            when 'folderlist_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER(), dbapi.getDROP_BOX_LIST_FOLDER(), 200, 'OK'));
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), 200, 'OK'));
                //for(String s : mockresponses.keySet()){
                //    System.debug('@#@ mock key: ' + s);
                //    System.debug('@#@ mock response: ' + mockresponses.get(s));
                //    System.debug('@#@ mock response body: ' + mockresponses.get(s).getBody());
                //    System.debug('@#@ mock response status: ' + mockresponses.get(s).getStatusCode());
                //}
            }
            //when 'folderlist_failure' {                
            //    mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'},'err', dbapi.getDROP_BOX_LIST_FOLDER(), 400, 'Bad Request'));
            //    mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE(), 200, 'OK'));
            //}
            when 'getmetadata_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_GET_METADATA(), dbapi.getDROP_BOX_GET_METADATA(), 200, 'OK'));
            }
            //when 'getmetadata_failure' {                
            //    mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'},'err', dbapi.getDROP_BOX_GET_METADATA(), 400, 'Bad Request'));
            //}
            when 'getlink_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), 200, 'OK'));
            }
            //when 'getlink_failure' {                
            //    mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'},'err', dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), 400, 'Bad Request'));
            //}
            when 'search_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_SEARCH_V2(), dbapi.getDROP_BOX_SEARCH_V2(), 200, 'OK'));
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), dbapi.getDROP_BOX_SEARCH_CONTINUE_V2(), 200, 'OK'));
            }
            when 'createitem_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), dbapi.getDROP_BOX_CREATE_FOLDER_BATCH(), 200, 'OK'));
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK(), 200, 'OK'));
            }
            when 'upload_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD(), dbapi.getDROP_BOX_UPLOAD(), 200, 'OK', null));
            }
            when 'upload_session_start_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD_SESSION_START(), dbapi.getDROP_BOX_UPLOAD_SESSION_START(), 200, 'OK', null));
            }
            when 'upload_session_append' {                
                mockresponses.putAll(DropBoxAPI_TC.createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD_SESSION_APPEND_V2(), dbapi.getDROP_BOX_UPLOAD_SESSION_APPEND_V2(), 200, 'OK', null));
            }
            when 'upload_session_finish' {                
                mockresponses.putAll(DropBoxAPI_TC.createContentMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_UPLOAD_SESSION_FINISH(), dbapi.getDROP_BOX_UPLOAD_SESSION_FINISH(), 200, 'OK', null));
            }
            when 'deleteitem_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_DELETE_BATCH(), dbapi.getDROP_BOX_DELETE_BATCH(), 200, 'OK'));
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), dbapi.getDROP_BOX_DELETE_BATCH_CHECK(), 200, 'OK'));
            }
            when 'moveitems_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_V2(), dbapi.getDROP_BOX_MOVE_BATCH_V2(), 200, 'OK'));
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'OK'));
            }
            when 'modifyitems_success' {                
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_V2(), dbapi.getDROP_BOX_MOVE_BATCH_V2(), 200, 'OK'));
                mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'}, dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), dbapi.getDROP_BOX_MOVE_BATCH_CHECK_V2(), 200, 'OK'));
            }
            //when 'getlink_failure' {                
            //    mockresponses.putAll(DropBoxAPI_TC.createMock(new map<String, String>{'Content-Type' => 'application/json'},'err', dbapi.getDROP_BOX_GET_TEMPORARY_LINK(), 400, 'Bad Request'));
            //}
            //when 'createitem' {
            //    response = DBcreateitem(meta, (CloudStoragecreateiteminput) input.inputparms);
            //}
            //when 'moveitems' {
            //    response = DBmoveitems(meta, (CloudStoragemoveitemsinput) input.inputparms);
            //}
            //when 'renameitems' {
            //    response = DBmoveitems(meta, (CloudStoragemoveitemsinput) input.inputparms);
            //}
            //when 'deleteitems' {
            //    response = DBdeleteitems(meta, (CloudStoragedeleteitemsinput) input.inputparms);
            //}
            //when 'getmetadata' {
            //    response = DBgetmetadata(meta, (CloudStoragegetmetadatainput) input.inputparms);
            //}
            //when 'getlink' {
            //    response = DBgettemporarylink(meta, (CloudStoragegetlinkinput) input.inputparms);
            //}
            //when 'searchitem' {
            //    response = DBsearch(meta, (CloudStoragesearchinput) input.inputparms);
            //}
        }
        return mockresponses; 
    }
}