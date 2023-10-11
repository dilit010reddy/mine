/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API createfolder response.

@History:
*/
public class DBAPIcreatefolder {

    public Metadata metadata {get;set;} 
    public DBAPIcreatefolder(){
        this.metadata = new Metadata();
    }
	public class Sharing_info {
		public Boolean read_only {get;set;} 
		public String parent_shared_folder_id {get;set;} 
		public Boolean traverse_only {get;set;} 
        public Boolean no_access {get;set;}
        public Sharing_info(){
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
        public Metadata(){
            this.name = '';
            this.path_lower = '';
            this.path_display = '';
            this.parent_shared_folder_id ='';
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
	
	public DBAPIcreatefolder(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'metadata') {
						metadata = new Metadata(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'DBAPIcreatefolder consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}	
	
	public static DBAPIcreatefolder parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPIcreatefolder(parser);
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
}