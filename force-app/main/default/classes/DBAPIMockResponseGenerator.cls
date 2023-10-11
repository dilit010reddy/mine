/*
@Author: P. Sutherland, Admins on Call
@Date: 11-25-2020
@Description:   Class for API generic return json.

@History:
N. Larkin, Admins on Call
*/

//Contains all the mock responses from Drop Box API
public class DBAPIMockResponseGenerator {
    //Remove overload and code appropriately - tmep for testing of UI
    public static String createJsonResponse(String method) {
        return createJsonResponse('DropBox',method);
    }
    public static String createJsonResponse(String app, String method) {
        Switch on app.toLowercase() {
            when 'dropbox' { return getDBResponse(method); }
            when else { return null; }
        }
    }
    private static String getDBResponse(String method) {
        String response = '';
        DropboxAPI dbapi = new DropboxAPI();
        if(method ==  dbapi.getDROP_BOX_LIST_FOLDER()) {
           response = genDropboxlistfolder();
        } else if(method == dbapi.getDROP_BOX_LIST_FOLDER_CONTINUE()) { 
                  response = genDropboxlistfoldercontinue();
        } else if(method == dbapi.getDROP_BOX_GET_METADATA()) { 
                  response = genDropboxgetmetadata();
        } else if(method == dbapi.getDROP_BOX_GET_TEMPORARY_LINK()) { 
                  response = genDropboxgettemporarylink();
        } else if(method == dbapi.getDROP_BOX_SEARCH_V2()) { 
                  response = genDropboxsearch();
        } else if(method == dbapi.getDROP_BOX_SEARCH_CONTINUE_V2()) { 
                  response = genDropboxsearchcontinue();
        } else if(method == 'DBerror') {
                  response = genDropBoxerror(); 
        } else if(method == dbapi.getDROP_BOX_UPLOAD()){
                  response = genDropBoxUpload();
        } else if(method == dbapi.getDROP_BOX_DOWNLOAD()){
                  response = getDropBoxDownload();
        } else if(method == dbapi.getDROP_BOX_Move_Batch_V2()){ 
                  response = genDropBoxMoveBatchV2();
        } else if(method == dbapi.getDROP_BOX_Move_Batch_Check_V2()){
                  response = genDropBoxMoveBatchCheckV2();
        } else if(method == dbapi.getDROP_BOX_DELETE_BATCH()){ 
                  response = genDropBoxDeleteBatch();
        } else if(method == dbapi.getDROP_BOX_DELETE_BATCH_CHECK()){ 
                  response = genDropBoxDeleteBatchCheck();
        } else if(method == dbapi.getDROP_BOX_CREATE_FOLDER_BATCH()){ 
                  response = genDropBoxCreateFolderBatch();
        } else if(method == dbapi.getDROP_BOX_CREATE_FOLDER_BATCH_CHECK()){ 
                  response = genDropBoxCreateFolderBatchCheck();
        } else if(method == dbapi.getDROP_BOX_UPLOAD_SESSION_START()){ 
            response = genDropBoxUploadSessionStart();
        } else if(method == dbapi.getDROP_BOX_UPLOAD_SESSION_APPEND_V2()){ 
            response = genDropBoxUploadSessionAppendV2();
        } else if(method == dbapi.getDROP_BOX_UPLOAD_SESSION_FINISH()){ 
            response = genDropBoxUploadSessionFinish();
        } else if(method == dbapi.getDROP_BOX_NAMESPACES_LIST()){ 
                  response = genDropBoxNamespacesList();
        } else if(method == dbapi.getDROP_BOX_NAMESPACES_LIST_CONTINUE()){ 
                  response = genDropBoxNamespacesListContinue();
        } else if(method == dbapi.getDROP_BOX_MEMBERS_LIST()){ 
                  response = genDropBoxMembersList();
        } else if(method == dbapi.getDROP_BOX_MEMBERS_LIST_CONTINUE()){ 
                  response = genDropBoxMembersListContinue();
        } 
        
        else { response = genHTTPError(); }
            
        return response;    
    }

    private static String genDropboxlistfolder(){
        return '{'+
               '  "entries": ['+
               '    {'+
               '      ".tag": "folder",'+
               '      "name": "Invoices",'+
               '      "path_lower": "/thg_customers/test_customer/invoices",'+
               '      "path_display": "/THG_Customers/Test_Customer/Invoices",'+
               '      "parent_shared_folder_id": "8593825504",'+
               '      "id": "id:CBh9W4LXJYIAAAAAAAAO2A",'+
               '      "sharing_info": {'+
               '        "read_only": false,'+
               '        "parent_shared_folder_id": "8593825504",'+
               '        "traverse_only": false,'+
               '        "no_access": false'+
               '      }'+
               '    },'+
               '    {'+
               '      ".tag": "file",'+
               '      "name": "requirements.txt",'+
               '      "path_lower": "/thg_customers/test_customer/requirements.txt",'+
               '      "path_display": "/THG_Customers/Test_Customer/requirements.txt",'+
               '      "parent_shared_folder_id": "8593825504",'+
               '      "id": "id:CBh9W4LXJYIAAAAAAAAO1w",'+
               '      "client_modified": "2020-11-02T21:25:09Z",'+
               '      "server_modified": "2020-11-02T21:25:09Z",'+
               '      "rev": "015b32661800c2600000002003b5ee0",'+
               '      "size": 1091,'+
               '      "sharing_info": {'+
               '        "read_only": false,'+
               '        "parent_shared_folder_id": "8593825504",'+
               '        "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
               '      },'+
               '      "is_downloadable": true,'+
               '      "content_hash": "1f9cf9b7b1c9376f9abc77959d28745dc49d983a4731ca6e8a24c22ef8d954e9"'+
               '    }'+
               '  ],'+
               '  "cursor": "AAHoThz4Kpo8F15eOKa8yEgH71QmLNTDEhT-OpYOuGGLuXuH6j9ndAnq9HFOnzxb8UI3VH9-_HefY5Bqje2zqAcDVdmTy5_hLee205tTyDdv81Rb11ZVObpQP883TiB9oNl-zxQ3yDzpNUMZVF_fNF0bJ29SZGZJgFu7sod7h3Zk8PZesO0UT5eUu4ICYeMPIyvCAFt1Z6gpfJUD85peApuvwybWG0i-MPzqfVLUsGja1chV4ovN9LZ68rrRjvarkcvRFQNIIXPDD0Is7b00jhDZJ7yKVSHdRAcYibQtQe6-N09e-FUspGDwbsdL0BXpHek",'+
               '  "has_more": true'+
               '}';
    }
    private static String genDropboxlistfoldercontinue(){
        return '{'+
               '  "entries": ['+
               '    {'+
               '      ".tag": "folder",'+
               '      "name": "Invoices",'+
               '      "path_lower": "/thg_customers/test_customer/invoices/1999",'+
               '      "path_display": "/THG_Customers/Test_Customer/Invoices/1999",'+
               '      "parent_shared_folder_id": "8593825504",'+
               '      "id": "id:CBh9W4LXJYIAAAAAAAAO2B",'+
               '      "sharing_info": {'+
               '        "read_only": false,'+
               '        "parent_shared_folder_id": "8593825504",'+
               '        "traverse_only": false,'+
               '        "no_access": false'+
               '      }'+
               '    },'+
               '    {'+
               '      ".tag": "file",'+
               '      "name": "requirements.txt",'+
               '      "path_lower": "/thg_customers/test_customer/invoices/1999/requirements.txt",'+
               '      "path_display": "/THG_Customers/Test_Customer/Invoices/1999/requirements.txt",'+
               '      "parent_shared_folder_id": "8593825504",'+
               '      "id": "id:CBh9W4LXJYIAAAAAAAAO1x",'+
               '      "client_modified": "2020-11-02T21:25:09Z",'+
               '      "server_modified": "2020-11-02T21:25:09Z",'+
               '      "rev": "015b32661800c2600000002003b5ee0",'+
               '      "size": 1091,'+
               '      "sharing_info": {'+
               '        "read_only": false,'+
               '        "parent_shared_folder_id": "8593825504",'+
               '        "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
               '      },'+
               '      "is_downloadable": true,'+
               '      "content_hash": "1f9cf9b7b1c9376f9abc77959d28745dc49d983a4731ca6e8a24c22ef8d954e9"'+
               '    }'+
               '  ],'+
               '  "cursor": "AAHoThz4Kpo8F15eOKa8yEgH71QmLNTDEhT-OpYOuGGLuXuH6j9ndAnq9HFOnzxb8UI3VH9-_HefY5Bqje2zqAcDVdmTy5_hLee205tTyDdv81Rb11ZVObpQP883TiB9oNl-zxQ3yDzpNUMZVF_fNF0bJ29SZGZJgFu7sod7h3Zk8PZesO0UT5eUu4ICYeMPIyvCAFt1Z6gpfJUD85peApuvwybWG0i-MPzqfVLUsGja1chV4ovN9LZ68rrRjvarkcvRFQNIIXPDD0Is7b00jhDZJ7yKVSHdRAcYibQtQe6-N09e-FUspGDwbsdL0BXpHfk",'+
               '  "has_more": false'+
               '}';
    }

    private static String genDropboxgetmetadata(){
        return '{'+
               '    ".tag": "file",'+
               '    "name": "Prime_Numbers.txt",'+
               '    "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
               '    "client_modified": "2015-05-12T15:50:38Z",'+
               '    "server_modified": "2015-05-12T15:50:38Z",'+
               '    "rev": "a1c10ce0dd78",'+
               '    "size": 7212,'+
               '    "path_lower": "/homework/math/prime_numbers.txt",'+
               '    "path_display": "/Homework/math/Prime_Numbers.txt",'+
               '    "sharing_info": {'+
               '        "read_only": true,'+
               '        "parent_shared_folder_id": "84528192421",'+
               '        "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"'+
               '    },'+
               '    "is_downloadable": true,'+
               '    "property_groups": ['+
               '        {'+
               '            "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
               '            "fields": ['+
               '                {'+
               '                    "name": "Security Policy",'+
               '                    "value": "Confidential"'+
               '                }'+
               '            ]'+
               '        }'+
               '    ],'+
               '    "has_explicit_shared_members": false,'+
               '    "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",'+
               '    "file_lock_info": {'+
               '        "is_lockholder": true,'+
               '        "lockholder_name": "Imaginary User",'+
               '        "created": "2015-05-12T15:50:38Z"'+
               '    }'+
               '}';
    }
    private static String genDropboxgettemporarylink(){
        return '{'+
               '  "metadata": {'+
               '    "name": "sample.txt",'+
               '    "path_lower": "/thg_customers/test_customer/sample.txt",'+
               '    "path_display": "/THG_Customers/Test_Customer/sample.txt",'+
               '    "parent_shared_folder_id": "8593825504",'+
               '    "id": "id:CBh9W4LXJYIAAAAAAAAO1w",'+
               '    "client_modified": "2020-11-02T21:25:09Z",'+
               '    "server_modified": "2020-11-03T17:56:09Z",'+
               '    "rev": "015b33793ed126a00000002003b5ee0",'+
               '    "size": 1091,'+
               '    "sharing_info": {'+
               '      "read_only": false,'+
               '      "parent_shared_folder_id": "8593825504",'+
               '      "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
               '    },'+
               '    "is_downloadable": true,'+
               '    "content_hash": "1f9cf9b7b1c9376f9abc77959d28745dc49d983a4731ca6e8a24c22ef8d954e9"'+
               '  },'+
               '  "link": "https://content.dropboxapi.com/apitl/1/Al6BW8hvXbcMSlCVnB-fUlhH35rulZt4dgbH5uGOpoJx6K7wJOH7rIzZKMdCmZAbviWuDpsaOQN6_1lzh3m-KnoUyAAU9AMPXXwnLYBY9cdscmc9176QXysXRYVTeNyPI3ZOBDvAEhMmC3yBAeUcjbP1Ka930b7q-qU7VDmu-iu9Pl6SORcoyYCTiayzOJP9y8jVdQcx5PzCcXlWxHHAFO0GfZ03KufnQJn21BLGqZr_DaC7suT8KpYTEXDCaJPmDrdby8GCPzCCVxfUy9MbCElp0hPuxDyIri3aMq4R8f11UKm8LOYT3NftB3lmnBB9FcO52FoXkNn3irs_mutGQUrFQwZM0aB57-KpRXLH7Pyk9g6ar_r1fh8_TJRpglZ62H3KerCHQ2xAboH5y-MZm3iS39SEc58GUlmjIY6OS2RpuGDMAtF9ZOQBJvb4kkvqfV6i07LnltOwVH3cWp7IU--XnfKKvZFqXbqqD4MWWkkSHC6izeb1S5Q8b1eJswMH-mU"'+
               '}';
    }

    private static String genDropboxsearch(){
        return '{'+
               '    "matches": ['+
               '        {'+
               '      		 "match_type": {'+
               '        		 ".tag": "filename_and_content"'+
               '      		 },'+
               '            "metadata": {'+
               '                ".tag": "metadata",'+
               '                "metadata": {'+
               '                    ".tag": "file",'+
               '                    "name": "Prime_Numbers.txt",'+
               '                    "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
               '                    "client_modified": "2015-05-12T15:50:38Z",'+
               '                    "server_modified": "2015-05-12T15:50:38Z",'+
               '                    "rev": "a1c10ce0dd78",'+
               '                    "size": 7212,'+
               '                    "path_lower": "/homework/math/prime_numbers2.txt",'+
               '                    "path_display": "/Homework/math/Prime_Numbers2.txt",'+
               '                    "sharing_info": {'+
               '               		 "is_parent_shared_folder_read_only": false,'+
               '            			 "no_access": false,'+
               '                        "read_only": true,'+
               '                        "parent_shared_folder_id": "84528192421",'+
               '                        "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc",'+
               '            			 "traverse_only": false'+
               '                    },'+
               '                    "is_downloadable": true,'+
               '                    "property_groups": ['+
               '                        {'+
               '                            "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
               '                            "fields": ['+
               '                                {'+
               '                                    "name": "Security Policy",'+
               '                                    "value": "Confidential"'+
               '                                }'+
               '                            ]'+
               '                        }'+
               '                    ],'+
               '                    "has_explicit_shared_members": false,'+
               '                    "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",'+
               '                    "file_lock_info": {'+
               '                        "is_lockholder": true,'+
               '                        "lockholder_name": "Imaginary User",'+
               '                        "created": "2015-05-12T15:50:38Z"'+
               '                    }'+
               '                }'+
               '            }'+
               '        }'+
               '    ],'+
               '    "cursor": "ZtkX9_EHj3x7PMkVuFIhwKYXEpwpLwyxp9vMKomUhllil9q7eWiAu",'+
               '    "has_more": true'+
               '}';
    }
    private static String genDropboxsearchcontinue(){
        return '{'+
               '    "matches": ['+
               '        {'+
               '      		 "match_type": {'+
               '        		 ".tag": "filename_and_content"'+
               '      		 },'+
               '            "metadata": {'+
               '                ".tag": "metadata",'+
               '                "metadata": {'+
               '                    ".tag": "file",'+
               '                    "name": "Prime_Numbers.txt",'+
               '                    "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
               '                    "client_modified": "2015-05-12T15:50:38Z",'+
               '                    "server_modified": "2015-05-12T15:50:38Z",'+
               '                    "rev": "a1c10ce0dd78",'+
               '                    "size": 7212,'+
               '                    "path_lower": "/homework/math/prime_numbers.txt",'+
               '                    "path_display": "/Homework/math/Prime_Numbers.txt",'+
               '                    "sharing_info": {'+
               '               		 "is_parent_shared_folder_read_only": false,'+
               '            			 "no_access": false,'+
               '                        "read_only": true,'+
               '                        "parent_shared_folder_id": "84528192421",'+
               '                        "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc",'+
               '            			 "traverse_only": false'+
               '                    },'+
               '                    "is_downloadable": true,'+
               '                    "property_groups": ['+
               '                        {'+
               '                            "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
               '                            "fields": ['+
               '                                {'+
               '                                    "name": "Security Policy",'+
               '                                    "value": "Confidential"'+
               '                                }'+
               '                            ]'+
               '                        }'+
               '                    ],'+
               '                    "has_explicit_shared_members": false,'+
               '                    "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",'+
               '                    "file_lock_info": {'+
               '                        "is_lockholder": true,'+
               '                        "lockholder_name": "Imaginary User",'+
               '                        "created": "2015-05-12T15:50:38Z"'+
               '                    }'+
               '                }'+
               '            }'+
               '        }'+
               '    ],'+
               '    "cursor": "ZtkX9_EHj3x7PMkVuFIhwKYXEpwpLwyxp9vMKomUhllil9q7eWiAz",'+
               '    "has_more": false'+
               '}';
    }

    private static String genDropBoxerror(){
        return '{'+
               '  "error_summary": "path/conflict/folder/..",'+
               '  "error": {'+
               '    ".tag": "path",'+
               '    "path": {'+
               '      ".tag": "conflict",'+
               '      "conflict": {'+
               '        ".tag": "folder"'+
               '      }'+
               '    }'+
               '  }'+
               '}';
    }

    private static String genHTTPerror(){
        return 'This is an error that is not trapped by http response code';
    }

   /*  private static String genDropBoxCreateFolder(){
        return '{'+
		'  "metadata": {'+
		'    "name": "THG_Customers",'+
		'    "path_lower": "/thg_customers",'+
		'    "path_display": "/THG_Customers",'+
		'    "parent_shared_folder_id": "8206105904",'+
		'    "id": "id:CBh9W4LXJYIAAAAAAAAOyA",'+
		'    "sharing_info": {'+
		'      "read_only": false,'+
		'      "parent_shared_folder_id": "8206105904",'+
		'      "traverse_only": false,'+
		'      "no_access": false'+
		'    }'+
		'  }'+
        '}';
    } */
    private static String genDropBoxUpload(){
        return '{'+
		'    "name": "sample2.xlsx",'+
		'    "path_lower": "/thg_customers/test_customer/sample2.xlsx",'+
		'    "path_display": "/THG_Customers/Test_Customer/sample2.xlsx",'+
		'    "parent_shared_folder_id": "8593825504",'+
		'    "id": "id:CBh9W4LXJYIAAAAAAAAQEA",'+
		'    "client_modified": "2020-11-04T20:50:55Z",'+
		'    "server_modified": "2020-11-04T20:50:55Z",'+
		'    "rev": "015b34e22c87efe00000002003b5ee0",'+
		'    "size": 10012,'+
		'    "sharing_info": {'+
		'        "read_only": false,'+
		'        "parent_shared_folder_id": "8593825504",'+
		'        "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
		'    },'+
		'    "is_downloadable": true,'+
		'    "content_hash": "a3fda19decfed5996a3e758825157a5b0d16a8d1a14617762e5c2614a490c2bf"'+
        '}';
    }
    /* private static String genDropBoxMoveV2(){
               return '{'+
               '  "metadata": {'+
               '    ".tag": "file",'+
               '    "name": "sample.txt",'+
               '    "path_lower": "/thg_customers/test_customer/sample.txt",'+
               '    "path_display": "/THG_Customers/Test_Customer/sample.txt",'+
               '    "parent_shared_folder_id": "8593825504",'+
               '    "id": "id:CBh9W4LXJYIAAAAAAAAO1w",'+
               '    "client_modified": "2020-11-02T21:25:09Z",'+
               '    "server_modified": "2020-11-03T17:56:09Z",'+
               '    "rev": "015b33793ed126a00000002003b5ee0",'+
               '    "size": 1091,'+
               '    "sharing_info": {'+
               '      "read_only": false,'+
               '      "parent_shared_folder_id": "8593825504",'+
               '      "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
               '    },'+
               '    "is_downloadable": true,'+
               '    "content_hash": "1f9cf9b7b1c9376f9abc77959d28745dc49d983a4731ca6e8a24c22ef8d954e9"'+
               '  }'+
               '}'; 
    } */

    private static String getDropBoxDownload(){
        return '{"name": "sample.xlsx", "path_lower": "/thg_customers/test_customer/sample.xlsx", "path_display": "/THG_Customers/Test_Customer/sample.xlsx", "parent_shared_folder_id": "8593825504", "id": "id:CBh9W4LXJYIAAAAAAAAQDw", "client_modified": "2020-11-04T20:17:31Z", "server_modified": "2020-11-04T20:17:31Z", "rev": "015b34dab534b3900000002003b5ee0", "size": 10012, "sharing_info": {"read_only": false, "parent_shared_folder_id": "8593825504", "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"}, "is_downloadable": true, "content_hash": "a3fda19decfed5996a3e758825157a5b0d16a8d1a14617762e5c2614a490c2bf"}';
    }

    private static String genDropBoxMoveBatchCheckV2(){
        return '{'+
		'    ".tag": "complete",'+
		'    "entries": ['+
		'   		{ '+
        '   		".tag": "failure", '+
        '    		"failure": { '+
        '       	".tag": "relocation_error", '+
        '   		 		"relocation_error": { '+
        '            		".tag": "duplicated_or_nested_paths" '+
        '        			} '+
        '          	} '+
		' 			},'+ 
		'        {'+
		'            ".tag": "success",'+
		'            "success": {'+
		'                ".tag": "file",'+
		'                "name": "Prime_Numbers.txt",'+
		'                "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
		'                "client_modified": "2015-05-12T15:50:38Z",'+
		'                "server_modified": "2015-05-12T15:50:38Z",'+
		'                "rev": "a1c10ce0dd78",'+
		'                "size": 7212,'+
		'                "path_lower": "/homework/math/prime_numbers.txt",'+
		'                "path_display": "/Homework/math/Prime_Numbers.txt",'+
		'                "sharing_info": {'+
		'                    "read_only": true,'+
		'                    "parent_shared_folder_id": "84528192421",'+
		'                    "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"'+
		'                },'+
		'                "is_downloadable": true,'+
		'                "property_groups": ['+
		'                    {'+
		'                        "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
		'                        "fields": ['+
		'                            {'+
		'                                "name": "Security Policy",'+
		'                                "value": "Confidential"'+
		'                            }'+
		'                        ]'+
		'                    }'+
		'                ],'+
		'                "has_explicit_shared_members": false,'+
		'                "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",'+
		'                "file_lock_info": {'+
		'                    "is_lockholder": true,'+
		'                    "lockholder_name": "Imaginary User",'+
		'                    "created": "2015-05-12T15:50:38Z"'+
		'                }'+
		'            }'+
		'        },'+
		'{'+
        '	".tag": "failure",'+
        '	"failure": {'+
        '		".tag": "relocation_error",'+
        '		"relocation_error": {'+
        '			".tag": "from_lookup",'+
        '			"from_lookup": { '+
        '				".tag": "not_found"'+
        '           	 }'+
        '       	 }'+
		'		}'+
		'}'+ 
		'    ]'+
		'}';
    }
    private static String genDropBoxMoveBatchV2(){
        return '{ '+
               ' ".tag": "async_job_id", '+
               '"async_job_id": "34g93hh34h04y384084" }';
    }
    private static String genDropBoxDeleteBatch(){
        return '{'+
                '  ".tag": "async_job_id",'+
                '  "async_job_id": "dbjid:AADjhFP1iVehathQQMzwfoBKETWcaUqjGHoJ2yuxJVXLoM6AW-sctEKYSCVLT3c7GaSb4Rk59Z2qWh7_BCr_2_RA",'+
                '  "entries": ['+
                '{'+
                '            ".tag": "failure",'+
                '            "failure": {'+
                '                ".tag": "path_lookup",'+
                '                "path_lookup": {'+
                '                    ".tag": "not_found"'+
                '                }'+
                '            }'+
                '        },'+
                '    {'+
                '      ".tag": "success",'+
                '      "metadata": {'+
                '        ".tag": "file",'+
                '        "name": "deleteme.txt",'+
                '        "path_lower": "/thg_customers/test_customer2/forms/formation/deleteme.txt",'+
                '        "path_display": "/THG_Customers/test_customer2/forms/Formation/deleteme.txt",'+
                '        "parent_shared_folder_id": "8593825504",'+
                '        "id": "id:CBh9W4LXJYIAAAAAAAATUg",'+
                '        "client_modified": "2020-11-16T20:17:22Z",'+
                '        "server_modified": "2020-11-16T20:18:01Z",'+
                '        "rev": "015b43f1337151e00000002003b5ee0",'+
                '        "size": 37,'+
                '        "sharing_info": {'+
                '          "read_only": false,'+
                '          "parent_shared_folder_id": "8593825504",'+
                '          "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
                '        },'+
                '        "is_downloadable": true,'+
                '        "content_hash": "5bd83a7b93b9139208e6f06a52a0a42b4aa55cd8c8e604c28f6fc6e8780921c6"'+
                '      }'+
                '    }'+
                '  ]'+
                '}';

    }

    private static String genDropBoxDeleteBatchCheck(){
        return '{'+
                '  ".tag": "complete",'+
                '  "entries": ['+
                '    {'+
                '      ".tag": "success",'+
                '      "metadata": {'+
                '        ".tag": "file",'+
                '        "name": "deleteme.txt",'+
                '        "path_lower": "/homework/math/prime_numbers.txt",'+
                '        "path_display": "/THG_Customers/test_customer2/forms/Formation/deleteme.txt",'+
                '        "parent_shared_folder_id": "8593825504",'+
                '        "id": "id:CBh9W4LXJYIAAAAAAAATUg",'+
                '        "client_modified": "2020-11-16T20:17:22Z",'+
                '        "server_modified": "2020-11-16T20:18:01Z",'+
                '        "rev": "015b43f1337151e00000002003b5ee0",'+
                '        "size": 37,'+
                '        "sharing_info": {'+
                '          "read_only": false,'+
                '          "parent_shared_folder_id": "8593825504",'+
                '          "modified_by": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA"'+
                '        },'+
                '        "is_downloadable": true,'+
                '        "content_hash": "5bd83a7b93b9139208e6f06a52a0a42b4aa55cd8c8e604c28f6fc6e8780921c6"'+
                '      }'+
                '    }'+
                '  ]'+
                '}';

    }

    private static String genDropBoxCreateFolderBatch(){
            return '{'+
            '  "async_job_id": "this is the id",'+
            '  ".tag": "async_job_id"'+
            '}';
    }

    private static String genDropBoxCreateFolderBatchCheck(){
        return '{'+
        '  ".tag": "complete",'+
        '  "entries": ['+
        '{'+
        '    ".tag": "failure",'+
        '    "failure": {'+
        '        ".tag": "path",'+
        '        "path": {'+
        '            ".tag": "conflict",'+
        '            "conflict": {'+
        '               ".tag": "file"'+
        '            }'+
        '       }'+
        '    }'+
		'    },'+
        '    {'+
        '      ".tag": "success",'+
        '      "metadata": {'+
        '        "name": "test_customer2",'+
        '        "path_lower": "/thg_customers/test_customer2",'+
        '        "path_display": "/THG_Customers/test_customer2",'+
        '        "parent_shared_folder_id": "8593825504",'+
        '        "id": "id:CBh9W4LXJYIAAAAAAAAPOA",'+
        '        "sharing_info": {'+
        '          "read_only": false,'+
        '          "parent_shared_folder_id": "8593825504",'+
        '          "traverse_only": false,'+
        '          "no_access": false'+
        '        }'+
        '      }'+
        '    },'+
        '    {'+
        '      ".tag": "success",'+
        '      "metadata": {'+
        '        "name": "Invoices",'+
        '        "path_lower": "/thg_customers/test_customer2/invoices",'+
        '        "path_display": "/THG_Customers/test_customer2/Invoices",'+
        '        "parent_shared_folder_id": "8593825504",'+
        '        "id": "id:CBh9W4LXJYIAAAAAAAAPPA",'+
        '        "sharing_info": {'+
        '          "read_only": false,'+
        '          "parent_shared_folder_id": "8593825504",'+
        '          "traverse_only": false,'+
        '          "no_access": false'+
        '        }'+
        '      }'+
        '    },'+
        '    {'+
        '      ".tag": "success",'+
        '      "metadata": {'+
        '        "name": "1999",'+
        '        "path_lower": "/thg_customers/test_customer2/invoices/1999",'+
        '        "path_display": "/THG_Customers/test_customer2/Invoices/1999",'+
        '        "parent_shared_folder_id": "8593825504",'+
        '        "id": "id:CBh9W4LXJYIAAAAAAAAPPQ",'+
        '        "sharing_info": {'+
        '          "read_only": false,'+
        '          "parent_shared_folder_id": "8593825504",'+
        '          "traverse_only": false,'+
        '          "no_access": false'+
        '        }'+
        '      }'+
        '    },'+
        '    {'+
        '      ".tag": "success",'+
        '      "metadata": {'+
        '        "name": "Formation",'+
        '        "path_lower": "/thg_customers/test_customer2/forms/formation",'+
        '        "path_display": "/THG_Customers/test_customer2/forms/Formation",'+
        '        "parent_shared_folder_id": "8593825504",'+
        '        "id": "id:CBh9W4LXJYIAAAAAAAAPOg",'+
        '        "sharing_info": {'+
        '          "read_only": false,'+
        '          "parent_shared_folder_id": "8593825504",'+
        '          "traverse_only": false,'+
        '          "no_access": false'+
        '        }'+
        '      }'+
        '    }'+
        '  ]'+
        '}';
}

private static String genDropBoxNamespacesList(){
    return '{'+
    '  "namespaces": ['+
    '    {'+
    '      "name": "AOC\'s shared workspace",'+
    '      "namespace_id": "8206105904",'+
    '      "namespace_type": {'+
    '        ".tag": "team_folder"'+
    '      },'+
    '     "team_member_id": "dbmid:1234567"'+
    '    },'+
    '    {'+
    '      "name": "Untitled folder",'+
    '      "namespace_id": "8409928256",'+
    '      "namespace_type": {'+
    '        ".tag": "shared_folder"'+
    '      }'+
    '    }'+
    '  ],'+
    '  "cursor": "AADJklTQH2sD4q-ZmzYcHPpC9zCQsaLCwGwrHRQ3e33zOWeV0HZWnGx8fETT2EwdpFbMFeNXhGIyM64K5eQ22hfRml0KLyFKm9YWXeoHNAyZDpD0zMIbTXXqGcN8JqcdUvzn_LJ9KPKZBYnSQh42wWpVJWpLhQNqu-hdPPapVar0yLHvpojXrak59FR4E5OjGlC9QcI_tkRYsjA7BlQG0V0DUUfRRWzOYlgUq4CxSgwi-RNWtyEfkRDyDZqfCoBHszSJ8LjEUNnV0dTTQf6gIoc89uwBfijl3czxXCSFV2iIxdRb4VJCpAm-rnrmtnq4PKVk-FFTlS43HlmvIrFxsJhG",'+
    '  "has_more": true'+
    '}';
}

private static String genDropBoxNamespacesListContinue(){
    return '{'+
    '  "namespaces": ['+
    '    {'+
    '      "name": "Untitled folder",'+
    '      "namespace_id": "8540573296",'+
    '      "namespace_type": {'+
    '        ".tag": "shared_folder"'+
    '      }'+
    '    },'+
    '    {'+
    '      "name": "Zoom",'+
    '      "namespace_id": "8251448048",'+
    '      "namespace_type": {'+
    '        ".tag": "shared_folder"'+
    '      }'+
    '    },'+
    '    {'+
    '      "name": "5th_Anniversary_bendbuddy_sjf_images",'+
    '      "namespace_id": "6610068336",'+
    '      "namespace_type": {'+
    '        ".tag": "shared_folder"'+
    '      }'+
    '    }'+
    '  ],'+
    '  "cursor": "AADJklTQH2sD4q-ZmzYcHPpC9zCQsaLCwGwrHRQ3e33zOWeV0HZWnGx8fETT2EwdpFbMFeNXhGIyM64K5eQ22hfRml0KLyFKm9YWXeoHNAyZDpD0zMIbTXXqGcN8JqcdUvzn_LJ9KPKZBYnSQh42wWpVJWpLhQNqu-hdPPapVar0yLHvpojXrak59FR4E5OjGlC9QcI_tkRYsjA7BlQG0V0DUUfRRWzOYlgUq4CxSgwi-RNWtyEfkRDyDZqfCoBHszSJ8LjEUNnV0dTTQf6gIoc89uwBfijl3czxXCSFV2iIxdRb4VJCpAm-rnrmtnq4PKVk-FFTlS43HlmvIrFxsJhG",'+
    '  "has_more": false'+
    '}';
}

private static String genDropBoxMembersList(){
    return '{'+
    '  "members": ['+
    '    {'+
    '      "profile": {'+
    '        "team_member_id": "dbmid:AADfdb8nlqSdNyRx2jVxKrztpP_cK6dS0cA",'+
    '        "account_id": "dbid:AAATrqAXq2K1Y_oASIxpGizjsvZ0a39E8bQ",'+
    '        "email": "chris@adminsoncall.com",'+
    '        "email_verified": true,'+
    '        "secondary_emails": [],'+
    '        "status": {'+
    '          ".tag": "active"'+
    '        },'+
    '        "name": {'+
    '          "given_name": "Chris",'+
    '          "surname": "Sinkwitz",'+
    '          "familiar_name": "Chris",'+
    '          "display_name": "Chris Sinkwitz",'+
    '          "abbreviated_name": "CS"'+
    '        },'+
    '        "membership_type": {'+
    '          ".tag": "full"'+
    '        },'+
    '        "joined_on": "2020-08-25T21:13:24Z",'+
    '        "groups": ['+
    '          "g:bdaefc21e9d14e0b0000000000000002"'+
    '        ],'+
    '        "member_folder_id": "8206317072"'+
    '      },'+
    '      "role": {'+
    '        ".tag": "team_admin"'+
    '      }'+
    '    },'+
    '    {'+
    '      "profile": {'+
    '        "team_member_id": "dbmid:AABUtB5iWcYaVZxtN8OUrHScCvCcmBWxt9E",'+
    '        "account_id": "dbid:AABla4X9NtAm2d_JVD97SvrkIDjVjr16Qss",'+
    '        "email": "csinkwitz@adminsoncall.com",'+
    '        "email_verified": true,'+
    '        "secondary_emails": ['+	
    '           {' +
    '			"email": "grape@strawberry.com",' +
    '			"is_verified": false' +
    '			},' +
    '			{ '+
    '			"email": "apple@orange.com",' +
    '			"is_verified": true' +
    '			}],' +
    '        "status": {'+
    '          ".tag": "active"'+
    '        },'+
    '        "name": {'+
    '          "given_name": "Corree",'+
    '          "surname": "Sinkwitz",'+
    '          "familiar_name": "Corree",'+
    '          "display_name": "Corree Sinkwitz",'+
    '          "abbreviated_name": "CS"'+
    '        },'+
    '        "membership_type": {'+
    '          ".tag": "full"'+
    '        },'+
    '        "joined_on": "2020-08-25T01:37:14Z",'+
    '        "groups": ['+
    '          "g:bdaefc21e9d14e0b0000000000000002"'+
    '        ],'+
    '        "member_folder_id": "8205175072"'+
    '      },'+
    '      "role": {'+
    '        ".tag": "team_admin"'+
    '      }'+
    '    }'+
    '  ],'+
    '  "cursor": "AADqUnHgnUIH0_hhHh7rIw06YJCJzwBA35vQ6aurRON3C-Bs2pt1CtTtqWhHn-uzXrl1XtMDVi4nDZ1P-eJosxWw3oI4pE3dZjnzy2QodBbhAA",'+
    '  "has_more": true'+
    '}';
}

private static String genDropBoxMembersListContinue(){
    return '{'+
    '  "members": ['+
    '    {'+
    '      "profile": {'+
    '        "team_member_id": "dbmid:AAA-eTTP-bYRGwgyxeuCjCuR_ZPfi08Vo2M",'+
    '        "account_id": "dbid:AAA5HqgQX6rDE6dAWpLdThbszInCg8liAs8",'+
    '        "email": "bhubbell@adminsoncall.com",'+
    '        "email_verified": true,'+
    '        "secondary_emails": [' +
    '			],'+
    '        "status": {'+
    '          ".tag": "active"'+
    '        },'+
    '        "name": {'+
    '          "given_name": "Brian",'+
    '          "surname": "Hubbell",'+
    '          "familiar_name": "Brian",'+
    '          "display_name": "Brian Hubbell",'+
    '          "abbreviated_name": "BH"'+
    '        },'+
    '        "membership_type": {'+
    '          ".tag": "full"'+
    '        },'+
    '        "joined_on": "2020-09-02T04:08:40Z",'+
    '        "groups": ['+
    '          "g:bdaefc21e9d14e0b0000000000000002"'+
    '        ],'+
    '        "member_folder_id": "8206312976"'+
    '      },'+
    '      "role": {'+
    '        ".tag": "team_admin"'+
    '      }'+
    '    },'+
    '    {'+
    '      "profile": {'+
    '        "team_member_id": "dbmid:AAD3pKEvetUBA7Dk-WIdWWoZ1WHlwK365JQ",'+
    '        "account_id": "dbid:AADhrBS_TmJkiw3ZwbLroiDgSEoqHVXFkhU",'+
    '        "email": "bendbuddy@yahoo.com",'+
    '        "email_verified": true,'+
    '        "secondary_emails": [],'+
    '        "status": {'+
    '          ".tag": "active"'+
    '        },'+
    '        "name": {'+
    '          "given_name": "Ben",'+
    '          "surname": "Bertrandt",'+
    '          "familiar_name": "Ben",'+
    '          "display_name": "Ben Bertrandt",'+
    '          "abbreviated_name": "BB"'+
    '        },'+
    '        "membership_type": {'+
    '          ".tag": "full"'+
    '        },'+
    '        "joined_on": "2020-08-25T04:45:16Z",'+
    '        "groups": ['+
    '          "g:bdaefc21e9d14e0b0000000000000002"'+
    '        ],'+
    '        "member_folder_id": "3423629"'+
    '      },'+
    '      "role": {'+
    '        ".tag": "team_admin"'+
    '      }'+
    '    }'+
    '  ],'+
    '  "cursor": "AADqUnHgnUIH0_hhHh7rIw06YJCJzwBA35vQ6aurRON3C-Bs2pt1CtTtqWhHn-uzXrl1XtMDVi4nDZ1P-eJosxWw3oI4pE3dZjnzy2QodBbhAA",'+
    '  "has_more": false'+
    '}';
}

private static String genDropBoxUploadSessionStart(){
    return '{'+
    '  "session_id": "1234faaf0678bcde"'+
    '}';
}

private static String genDropBoxUploadSessionAppendV2(){
    return '';
}

private static String genDropBoxUploadSessionFinish(){
    return '{'+
    '    "name": "Prime_Numbers.txt",'+
    '    "id": "id:a4ayc_80_OEAAAAAAAAAXw",'+
    '    "client_modified": "2015-05-12T15:50:38Z",'+
    '    "server_modified": "2015-05-12T15:50:38Z",'+
    '    "rev": "a1c10ce0dd78",'+
    '    "size": 7212,'+
    '    "path_lower": "/homework/math/prime_numbers.txt",'+
    '    "path_display": "/Homework/math/Prime_Numbers.txt",'+
    '    "sharing_info": {'+
    '        "read_only": true,'+
    '        "parent_shared_folder_id": "84528192421",'+
    '        "modified_by": "dbid:AAH4f99T0taONIb-OurWxbNQ6ywGRopQngc"'+
    '    },'+
    '    "is_downloadable": true,'+
    '    "property_groups": ['+
    '        {'+
    '            "template_id": "ptid:1a5n2i6d3OYEAAAAAAAAAYa",'+
    '           "fields": ['+
    '                {'+
    '                    "name": "Security Policy",'+
    '                    "value": "Confidential"'+
    '                }'+
    '            ]'+
    '        }'+
    '    ],'+
    '    "has_explicit_shared_members": false,'+
    '    "content_hash": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",'+
    '    "file_lock_info": {'+
    '        "is_lockholder": true,'+
    '        "lockholder_name": "Imaginary User",'+
    '        "created": "2015-05-12T15:50:38Z"'+
    '    }'+
    '}';
}


}