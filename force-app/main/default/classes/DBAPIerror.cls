/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API generic error return.

@History:
1/12/2021 P Sutherland Added the Correct_offest variable for error trapping on upload 
*/
public class DBAPIerror {

    public String error_summary {get;set;} 
    public Error error {get;set;} 
    public DBAPIerror(){
        this.error_summary = '';
        this.error = new Error();
    }

	public class Path {
		public String x_tag {get;set;} // in json: .tag
        public Conflict conflict {get;set;}
        public Path(){
            this.x_tag = '';
            this.conflict = new Conflict();
        } 

		public Path(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
							x_tag = parser.getText();
						} else if (text == 'conflict') {
							conflict = new Conflict(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Path consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}

	public DBAPIerror(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'error_summary') {
						error_summary = parser.getText();
					} else if (text == 'error') {
						error = new Error(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'DBAPIerror consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Conflict {
        public String x_tag {get;set;} // in json: .tag
        public Conflict(){
            this.x_tag = '';
        }

		public Conflict(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
							x_tag = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Conflict consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Error {
		public String x_tag {get;set;} // in json: .tag
		public Path path {get;set;}
		public Long correct_offset {get;set;}
        public Error(){
            this.x_tag = '';
			this.path = new Path();
			this.correct_offset = 0;
        } 

		public Error(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
							x_tag = parser.getText();
						} else if (text == 'path') {
							path = new Path(parser);
						} else if (text == 'correct_offset') {
							correct_offset = parser.getLongValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Error consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}	
	
	public static DBAPIerror parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPIerror(parser);
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