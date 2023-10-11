/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class delete batch output
 This class combines the check and the initial struture from Dropbox because they could
 return the response to the inital request or we may have to loop over them
@History:
*/

public class DBAPIdeletebatch {
    	
	public String x_tag {get;set;} // in json: .tag
	public String async_job_id {get;set;} 
	public List<Entries> entries {get;set;} 
    public DBAPIdeletebatch(){
        this.x_tag = '';
        this.async_job_id = '';
        this.entries = new list<Entries>();
    }

	public class Sharing_info {
		public Boolean read_only {get;set;} 
		public String parent_shared_folder_id {get;set;} 
		public String modified_by {get;set;} 
        public Sharing_info(){
            this.read_only = false;
            this.parent_shared_folder_id = '';
            this.modified_by = '';
        }
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
	}
	
	public class Metadata {
		public String x_tag {get;set;} // in json: .tag
		public String name {get;set;} 
		public String path_lower {get;set;} 
		public String path_display {get;set;} 
		public String parent_shared_folder_id {get;set;} 
		public String id {get;set;} 
		public String client_modified {get;set;} 
		public String server_modified {get;set;} 
		public String rev {get;set;} 
		public Integer size {get;set;} 
		public Sharing_info sharing_info {get;set;} 
		public Boolean is_downloadable {get;set;} 
        public String content_hash {get;set;} 
        public Metadata(){
            this.x_tag = '';
            this.name = '';
            this.path_lower = '';
            this.path_display = '';
            this.parent_shared_folder_id = '';
            this.id = '';
            this.client_modified = '';
            this.server_modified = '';
            this.rev = '';
            this.size = 0;
            this.sharing_info = new Sharing_info();
            this.is_downloadable = false;
            this.content_hash = '';
        }

		public Metadata(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
							x_tag = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'path_lower') {
							path_lower = parser.getText();
						} else if (text == 'path_display') {
							path_display = parser.getText();
						} else if (text == 'parent_shared_folder_id') {
							parent_shared_folder_id = parser.getText();
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
						} else if (text == 'sharing_info') {
							sharing_info = new Sharing_info(parser);
						} else if (text == 'is_downloadable') {
							is_downloadable = parser.getBooleanValue();
						} else if (text == 'content_hash') {
							content_hash = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Metadata consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Entries {
		public String x_tag {get;set;} // in json: .tag
		public Metadata metadata {get;set;} 
		public Failure failure {get;set;}
        public Entries(){
            this.x_tag = '';
			this.metadata = new Metadata();
			this.failure = new Failure();
        }

		public Entries(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
							x_tag = parser.getText();
						} else if (text == 'metadata') {
							metadata = new Metadata(parser);
						} else if (text == 'failure') {
							failure = new Failure(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Entries consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public class Failure {
		public String failureMessage {get;set;}
		public String x_tag {get;set;}

		public Failure(){
			this.failureMessage = '';
			this.x_tag = '';
		}

		public Failure(JSONParser parser) {
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

	public DBAPIdeletebatch(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == '.tag') {
						x_tag = parser.getText();
					} else if (text == 'async_job_id') {
						async_job_id = parser.getText();
					} else if (text == 'entries') {
						entries = arrayOfEntries(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'DBAPIdeletebatch consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static DBAPIdeletebatch parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPIdeletebatch(parser);
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

    private static List<Entries> arrayOfEntries(System.JSONParser p) {
        List<Entries> res = new List<Entries>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Entries(p));
        }
        return res;
    }
}