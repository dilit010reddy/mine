/*
@Author: P. Sutherland, Admins on Call
@Date: 11-05-2020
@Description:   API Class for Dropbox API download return.

@History:
*/

public class DBAPIdownload {

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
    public Blob filedata {get;set;}
    public DBAPIdownload(){
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
        this.filedata = null;
    }
    
    public class Sharing_info {
         
		public Boolean read_only {get;set;} 
		public String parent_shared_folder_id {get;set;} 
        public String modified_by {get;set;} 
        public Sharing_info(){
            this.read_only = false;
            this.parent_shared_folder_id = '';
            this.Modified_by = '';
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

	public DBAPIdownload(JSONParser parser) {
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
					} 
				    else {
						System.debug(LoggingLevel.WARN, 'DBAPIdownload consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}	
	
	public static DBAPIdownload parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPIdownload(parser);
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