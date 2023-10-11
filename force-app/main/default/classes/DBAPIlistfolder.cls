/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API listfolder response.

@History:
*/

public class DBAPIlistfolder {

	public List<Entries> entries {get;set;} 
	public String cursor {get;set;} 
	public Boolean has_more {get;set;} 
    public DBAPIlistfolder(){
        this.entries = new list<Entries>();
        this.cursor = '';
        this.has_more = false;
    }

	public DBAPIlistfolder(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'entries') {
						entries = arrayOfEntries(parser);
					} else if (text == 'cursor') {
						cursor = parser.getText();
					} else if (text == 'has_more') {
						has_more = parser.getBooleanValue();
					} else {
						System.debug(LoggingLevel.WARN, 'DBAPIlistfolder consuming unrecognized property: '+text);
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
		public String modified_by {get;set;} 
        public Sharing_info(){
            this.read_only = false;
            this.parent_shared_folder_id = '';
            this.traverse_only = false;
			this.no_access = false;
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
						} else if (text == 'traverse_only') {
							traverse_only = parser.getBooleanValue();
						} else if (text == 'no_access') {
							no_access = parser.getBooleanValue();
						} else if (text == 'modified_by') {
							modified_by = parser.getText();
						}else {
							System.debug(LoggingLevel.WARN, 'Sharing_info consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/*
	public class Sharing_info_Z {
		public Boolean read_only {get;set;} 
		public String parent_shared_folder_id {get;set;} 
        public String modified_by {get;set;}
        public Sharing_info_Z(){
            this.read_only = false;
            this.parent_shared_folder_id = '';
            this.modified_by = '';
        }

		public Sharing_info_Z(JSONParser parser) {
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
							System.debug(LoggingLevel.WARN, 'Sharing_info_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	} */
	
	public class Entries {
		public String x_tag {get;set;} // in json: .tag
		public String name {get;set;} 
		public String path_lower {get;set;} 
		public String path_display {get;set;} 
		public String parent_shared_folder_id {get;set;} 
		public String id {get;set;} 
		public Sharing_info sharing_info {get;set;} 
		public String client_modified {get;set;} 
		public String server_modified {get;set;} 
		public String rev {get;set;} 
		public Integer size {get;set;} 
		public Boolean is_downloadable {get;set;} 
        public String content_hash {get;set;}
        public Entries(){
            this.x_tag = '';
            this.name = '';
            this.path_lower = '';
            this.path_display = '';
            this.parent_shared_folder_id = '';
            this.id = '';
            this.sharing_info = new Sharing_info();
            this.client_modified = '';
            this.server_modified = '';
            this.rev = '';
            this.size =0;
            this.is_downloadable = false;
            this.content_hash = '';
        } 

		public Entries(JSONParser parser) {
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
						} else if (text == 'sharing_info') {
							sharing_info = new Sharing_info(parser);
						} else if (text == 'client_modified') {
							client_modified = parser.getText();
						} else if (text == 'server_modified') {
							server_modified = parser.getText();
						} else if (text == 'rev') {
							rev = parser.getText();
						} else if (text == 'size') {
							size = parser.getIntegerValue();
						} else if (text == 'is_downloadable') {
							is_downloadable = parser.getBooleanValue();
						} else if (text == 'content_hash') {
							content_hash = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Entries consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	
	public static DBAPIlistfolder parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPIlistfolder(parser);
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