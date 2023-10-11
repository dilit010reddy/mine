/*
@Author: P. Sutherland, Admins on Call
@Date: 11-05-2020
@Description:   API Class for Dropbox API download return.

@History:
*/

public class DBAPIdelete {

	public Metadata metadata {get;set;} 
    public DBAPIdelete() {
        this.metadata = new Metadata();
    }


	public class Fields {
		public String name {get;set;} 
        public String value {get;set;}
        public Fields(){
            this.name = '';
            this.value = '';
        } 

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
	}
	
	public class File_lock_info {
		public Boolean is_lockholder {get;set;} 
		public String lockholder_name {get;set;} 
        public String created {get;set;}
        public File_lock_info() {
            this.is_lockholder = false;
            this.lockholder_name = '';
            this.created = '';
        } 

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
	}
	
	public class Property_groups {
		public String template_id {get;set;} 
        public List<Fields> fields {get;set;}
        public Property_groups() {
            this.template_id = '';
            this.fields = new list<Fields>();
        } 

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
	}
	
	public class Sharing_info {
		public Boolean read_only {get;set;} 
		public String parent_shared_folder_id {get;set;} 
        public String modified_by {get;set;}
        public Sharing_info() {
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
        public Metadata() {
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
            this.property_groups = new list<Property_groups>();
            this.has_explicit_shared_members = false;
            this.content_hash = '';
            this.file_lock_info = new File_lock_info();
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
							System.debug(LoggingLevel.WARN, 'Metadata consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public DBAPIdelete(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'metadata') {
						metadata = new Metadata(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'DBAPIdelete consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
		
	public static DBAPIdelete parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPIdelete(parser);
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

    private static List<Property_groups> arrayOfProperty_groups(System.JSONParser p) {
        List<Property_groups> res = new List<Property_groups>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Property_groups(p));
        }
        return res;
    }
}