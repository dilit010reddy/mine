/*
@Author: P. Sutherland and N.Larkin, Admins on Call
@Date: 12/29-2020
@Description:   Move batch API response parse routine and class
 This class combines the check and the initial struture from Dropbox because they could
 return the response to the inital request or we may have to loop over them
@History:
*/
public with sharing class DBAPImovebatch {
    public String x_tag {get;set;} // in json: .tag
    public String async_job_id {get;set;}
	public List<Entries> entries {get;set;}
	
	
    public DBAPImovebatch(){
        this.x_tag = ''; 
		this.async_job_id = ''; 
		this.entries = new list<Entries>();
    } 

	public DBAPImovebatch(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == '.tag') {
						x_tag = parser.getText();
					} else if (text == 'entries') {
						entries = arrayOfEntries(parser);
					} else if (text == 'async_job_id') {
						async_job_id = parser.getText();
					}else {
						System.debug(LoggingLevel.WARN, 'DBAPImovebatch consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}

	public class Fields {
		public String name {get;set;} 
		public String value {get;set;} 

		public Fields(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Fields consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}

		public Fields(){
			this.name = '';
			this.value = '';
		}
	}
	
	public class File_lock_info {
		public Boolean is_lockholder {get;set;} 
		public String lockholder_name {get;set;} 
		public String created {get;set;} 

		public File_lock_info(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'is_lockholder') {
							is_lockholder = parser.getBooleanValue();
						} else if (text == 'lockholder_name') {
							lockholder_name = parser.getText();
						} else if (text == 'created') {
							created = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'File_lock_info consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}

		public File_lock_info(){
			this.is_lockholder = false;
			this.lockholder_name = '';
			this.created = '';
		}
	}
	
	public class Property_groups {
		public String template_id {get;set;} 
		public List<Fields> fields {get;set;}


		public Property_groups(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'template_id') {
							template_id = parser.getText();
						} else if (text == 'fields') {
							fields = arrayOfFields(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Property_groups consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
		public Property_groups(){
			this.template_id = '';
			this.fields = new List<Fields>();
		}
	}
	
	public class Sharing_info {
		public Boolean read_only {get;set;} 
		public String parent_shared_folder_id {get;set;} 
		public String modified_by {get;set;} 

		public Sharing_info(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'read_only') {
							read_only = parser.getBooleanValue();
						} else if (text == 'parent_shared_folder_id') {
							parent_shared_folder_id = parser.getText();
						} else if (text == 'modified_by') {
							modified_by = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Sharing_info consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
		public Sharing_info(){
			this.read_only = false;
			this.parent_shared_folder_id = '';
			this.modified_by = '';
		}
	}
	
	public class Entries {
		public String x_tag {get;set;} // in json: .tag
		public Success success {get;set;}
		public Failure failure {get;set;}
		
        public Entries(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {          
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                   // System.debug('Shouldn\'t be a fieldname' + parser.getCurrentToken());
                   // System.debug('Shouldn\'t be a fieldname value: ' + parser.getText());
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        //System.debug('Should be a .tag token: ' + parser.getCurrentToken());
						if (text == '.tag') {
							x_tag = parser.getText();
						} else if (text == 'success') {
							success = new Success(parser);
						} else if (text == 'failure') {
							failure = new Failure(parser);
						}else {
							System.debug(LoggingLevel.WARN, 'Entries consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}

		/*public Entries(JSONParser parser) {
			Boolean continueLoop = true;
			Integer counter = 0;
			//System.JSONToken tempToken;
			while (parser.nextToken() != System.JSONToken.END_OBJECT) { 
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
							x_tag = parser.getText();
						} else if (text == 'success') {
							success = new Success(parser);
							break;
						} else if (text == 'failure') {
							failure = new Failure();
							//System.debug('Nick the gettext: ' + parser.getText());
							/*parser.nextToken(); //get to the failure object contents
							//System.debug('the next token: ' + parser.getCurrentToken());
							//System.debug('the next token text: ' + parser.getText());
							//System.debug('the next token text: ' + parser.getText());
							while(continueLoop == true){
								System.debug('Current Token ' + parser.getCurrentToken());
								if((parser.getCurrentToken() == System.JSONToken.END_ARRAY) || (parser.getCurrentToken() == null)){
									continueLoop = false;
									break;
								}
								if(parser.getCurrentToken() == System.JSONToken.END_OBJECT) { 
									//tempToken = parser.getCurrentToken;
									while(parser.nextToken() != System.JSONToken.START_OBJECT){   //(parser.nextToken() == System.JSONToken.START_OBJECT)
										failure.failureMessage = failure.failureMessage + parser.getText();
									}
									continueLoop = false;
									break;
								}
								else{
									if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME || parser.getCurrentToken() == System.JSONToken.VALUE_STRING || parser.getCurrentToken() == System.JSONToken.START_OBJECT){ //added third for start of objects
									failure.failureMessage = failure.failureMessage + parser.getText();
									}
									parser.nextToken();
								}
								/*if(parser.nextToken() == System.JSONToken.VALUE_NULL){
									continueLoop = false;
								}*/
								/*if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
									if(parser.getText() == '.tag'){
										if(parser.nextToken() != System.JSONToken.VALUE_NULL){
											if(parser.getText() == 'failure' || parser.getText() == 'success') {
											continueLoop = false;
											break;
											}
											else{
											failure.failureMessage = failure.failureMessage + '.tag';
											}
										}
									}
									else {
										failure.failureMessage = failure.failureMessage + parser.getText();
										parser.nextToken();
									}
								}*/
								//System.debug('inside loop: ' + parser.getCurrentToken());
							/* 	else{
								failure.failureMessage = failure.failureMessage + parser.getText();
								parser.nextToken();
								} /**** 
							}/*** 
							
							//System.debug('final failure message: ' + failure.failureMessage)
							}
							//system.debug('failure text after parse: ' + parser.getText());
							//failure.failureMessage = parser.getText();   // changed from "failure = new Failure();"
						}else {
							System.debug(LoggingLevel.WARN, 'Entries consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
					else{
						if(parser.getCurrentToken() == System.JSONToken.END_ARRAY){
							break;
						}
						System.debug('Counter increasing with: ' + parser.getCurrentToken());
						counter = counter + 1;
						if(counter > 4){
							break;
						}
					}
				}
	
			}*/
		
		Public Entries(){
			this.x_tag = '';
			this.success = new Success();
			this.failure = new Failure();
		}
	}
	public class Failure{
        public String failureMessage {get;set;}
        public String x_tag {get;set;}

		public Failure(){
			this.failureMessage = '';
			this.x_tag = '';
        }
        
        public Failure(JSONParser parser) {
			failureMessage = ''; //so it isn't null
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
                            x_tag = parser.getText();
                            failureMessage = failureMessage + ' ' + x_tag; //failure message is null here when it is first used.
                        }
                        else if(parser.getCurrentToken() == System.JSONToken.START_OBJECT){
                                CustomFailure custfail = new CustomFailure(parser);
                                failureMessage = failureMessage + ' ' + custfail.failureMessage;
                        }
                    else {
						System.debug(LoggingLevel.WARN, 'Entries consuming unrecognized property: '+ text);
						consumeObject(parser);
						}
					}
				}
			}
        }
        
    }
    
    public class CustomFailure{
        public String failureMessage {get;set;}
        public String x_tag {get;set;}

		public CustomFailure(){
			this.failureMessage = '';
			this.x_tag = '';
        }
        
        public CustomFailure(JSONParser parser) {
			failureMessage = '';
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
                            x_tag = parser.getText();
                            failureMessage = failureMessage + ' ' + x_tag;
                        }
                        else if(parser.getCurrentToken() == System.JSONToken.START_OBJECT){
                            CustomFailure custfail = new CustomFailure(parser);
                            failureMessage = failureMessage + ' ' + custfail.failureMessage;
                        }
                        
                    else {
						System.debug(LoggingLevel.WARN, 'Entries consuming unrecognized property: '+text);
						consumeObject(parser);
						}
					}
				}
			}
		}
        
	}

	public class Success {
		public String x_tag {get;set;} // in json: .tag
		public String name {get;set;} 
		public String id {get;set;} 
		public String client_modified {get;set;} 
		public String server_modified {get;set;} 
		public String rev {get;set;} 
		public Integer size {get;set;} 
		public String path_lower {get;set;} 
		public String path_display {get;set;} 
		public Sharing_info sharing_info {get;set;} 
		public Boolean is_downloadable {get;set;} 
		public List<Property_groups> property_groups {get;set;} 
		public Boolean has_explicit_shared_members {get;set;} 
		public String content_hash {get;set;} 
		public File_lock_info file_lock_info {get;set;} 


		public Success(){
			this.x_tag = '';
			this.name = '';
			this.id = '';
			this.client_modified = '';
			this.server_modified = '';
			this.rev = '';
			this.size = 0;
			this.path_lower = '';
			this.path_display = '';
			this.sharing_info = new Sharing_info();
			this.is_downloadable = false;
			this.property_groups = new List<Property_groups>();
			this.has_explicit_shared_members = false;
			this.content_hash = '';
			this.file_lock_info = new File_lock_info();
		}

		public Success(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
							x_tag = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'client_modified') {
							client_modified = parser.getText();
						} else if (text == 'server_modified') {
							server_modified = parser.getText();
						} else if (text == 'rev') {
							rev = parser.getText();
						} else if (text == 'size') {
							size = parser.getIntegerValue();
						} else if (text == 'path_lower') {
							path_lower = parser.getText();
						} else if (text == 'path_display') {
							path_display = parser.getText();
						} else if (text == 'sharing_info') {
							sharing_info = new Sharing_info(parser);
						} else if (text == 'is_downloadable') {
							is_downloadable = parser.getBooleanValue();
						} else if (text == 'property_groups') {
							property_groups = arrayOfProperty_groups(parser);
						} else if (text == 'has_explicit_shared_members') {
							has_explicit_shared_members = parser.getBooleanValue();
						} else if (text == 'content_hash') {
							content_hash = parser.getText();
						} else if (text == 'file_lock_info') {
							file_lock_info = new File_lock_info(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Success consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
		
	}
	
	public static DBAPImovebatch parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPImovebatch(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	

    private static List<Fields> arrayOfFields(System.JSONParser p) {
        List<Fields> res = new List<Fields>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Fields(p));
        }
        return res;
    }
	
	private static List<Entries> arrayOfEntries(System.JSONParser p) {
		List<Entries> res = new List<Entries>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Entries(p));
        }
        return res;
    }

    private static List<Property_groups> arrayOfProperty_groups(System.JSONParser p) {
        List<Property_groups> res = new List<Property_groups>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Property_groups(p));
        }
        return res;
    }
}