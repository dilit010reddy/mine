/*
@Author: P. Sutherland, Admins on Call
@Date: 11-03-2020
@Description:   API Class for Dropbox API create_folder_batch return.

@History:
*/

public class DBAPIcreatefolderbatch {

	public String x_tag {get;set;} // in json: .tag
    public List<Entries> entries {get;set;}
    public String async_job_id {get;set;}
    public DBAPIcreatefolderbatch() {
        this.x_tag = '';
        this.entries = new List<Entries>();
        this.async_job_id = '';
    }  

	public DBAPIcreatefolderbatch(JSONParser parser) {
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
                    } else {
						System.debug(LoggingLevel.WARN, 'DBAPIcreatefolderbatch consuming unrecognized property: '+text);
                        consumeObject(parser);
                    
					}
				}
			}
		}
	}
	
	public class Sharing_info {
		public Boolean read_only {get;set;} 
		public String parent_shared_folder_id {get;set;} 
		public Boolean traverse_only {get;set;} 
        public Boolean no_access {get;set;}
        public Sharing_info() {
            this.read_only = false;
            this.parent_shared_folder_id = '';
            this.traverse_only = false;
            this.no_access = false;
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
						} else if (text == 'traverse_only') {
							traverse_only = parser.getBooleanValue();
						} else if (text == 'no_access') {
							no_access = parser.getBooleanValue();
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
		public String name {get;set;} 
		public String path_lower {get;set;} 
		public String path_display {get;set;} 
		public String parent_shared_folder_id {get;set;} 
		public String id {get;set;} 
        public Sharing_info sharing_info {get;set;}
        public Metadata() {
            this.name = '';
            this.path_lower = '';
            this.path_display = '';
            this.parent_shared_folder_id = '';
            this.id = '';
            this.sharing_info = new Sharing_info();
        } 

		public Metadata(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'path_lower') {
							path_lower = parser.getText();
						} else if (text == 'path_display') {
							path_display = parser.getText();
						} else if (text == 'parent_shared_folder_id') {
							parent_shared_folder_id = parser.getText();
						} else if (text == 'id') {
							id = parser.getText();
						} else if (text == 'sharing_info') {
							sharing_info = new Sharing_info(parser);
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
        public Entries() {
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
	
	public static DBAPIcreatefolderbatch parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPIcreatefolderbatch(parser);
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