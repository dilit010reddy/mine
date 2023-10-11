/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API memberslist response.

@History:
*/

public class DBAPImemberslist {

    public List<Members> members {get;set;} 
	public String cursor {get;set;} 
    public Boolean has_more {get;set;} 
    public DBAPImemberslist(){
        this.members = new list<Members>();
        this.cursor = '';
        this.has_more = false;
    }

	public class Status {
		public String x_tag {get;set;} // in json: .tag
        public Status(){
            this.x_tag = '';
        }

		public Status(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == '.tag') {
							x_tag = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Status consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public DBAPImemberslist(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'members') {
						members = arrayOfMembers(parser);
					} else if (text == 'cursor') {
						cursor = parser.getText();
					} else if (text == 'has_more') {
						has_more = parser.getBooleanValue();
					} else {
						System.debug(LoggingLevel.WARN, 'DBAPImemberslist consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Secondary_emails {        

		public Secondary_emails(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							System.debug(LoggingLevel.WARN, 'Secondary_emails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Profile {
		public String team_member_id {get;set;} 
		public String account_id {get;set;} 
		public String email {get;set;} 
		public Boolean email_verified {get;set;} 
		public List<Secondary_emails> secondary_emails {get;set;} 
		public Status status {get;set;} 
		public Name name {get;set;} 
		public Status membership_type {get;set;} 
		public String joined_on {get;set;} 
		public List<String> groups {get;set;} 
        public String member_folder_id {get;set;}
        public Profile(){
            this.team_member_id = ''; 
		    this.account_id = ''; 
		    this.email = ''; 
		    this.email_verified = false; 
		    this.secondary_emails = new List<Secondary_emails>(); 
		    this.status = new Status(); 
		    this.name = new Name(); 
		    this.membership_type = new Status(); 
		    this.joined_on = ''; 
		    this.groups = new List<String>();
            this.member_folder_id ='';
        } 

		public Profile(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'team_member_id') {
							team_member_id = parser.getText();
						} else if (text == 'account_id') {
							account_id = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'email_verified') {
							email_verified = parser.getBooleanValue();
						} else if (text == 'secondary_emails') {
							secondary_emails = arrayOfSecondary_emails(parser);
						} else if (text == 'status') {
							status = new Status(parser);
						} else if (text == 'name') {
							name = new Name(parser);
						} else if (text == 'membership_type') {
							membership_type = new Status(parser);
						} else if (text == 'joined_on') {
							joined_on = parser.getText();
						} else if (text == 'groups') {
							groups = arrayOfString(parser);
						} else if (text == 'member_folder_id') {
							member_folder_id = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Profile consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Members {
		public Profile profile {get;set;} 
        public Status role {get;set;}
        public Members(){
            this.profile = new Profile();
            this.role = new Status();
        } 

		public Members(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'profile') {
							profile = new Profile(parser);
						} else if (text == 'role') {
							role = new Status(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Members consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Name {
		public String given_name {get;set;} 
		public String surname {get;set;} 
		public String familiar_name {get;set;} 
		public String display_name {get;set;} 
        public String abbreviated_name {get;set;} 
        public Name(){
            this.given_name = '';
            this.surname = '';
            this.familiar_name = '';
            this.display_name = '';
            this.abbreviated_name = '';
        }

		public Name(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'given_name') {
							given_name = parser.getText();
						} else if (text == 'surname') {
							surname = parser.getText();
						} else if (text == 'familiar_name') {
							familiar_name = parser.getText();
						} else if (text == 'display_name') {
							display_name = parser.getText();
						} else if (text == 'abbreviated_name') {
							abbreviated_name = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Name consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static DBAPImemberslist parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new DBAPImemberslist(parser);
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

    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

    private static List<Members> arrayOfMembers(System.JSONParser p) {
        List<Members> res = new List<Members>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Members(p));
        }
        return res;
    }


    private static List<Secondary_emails> arrayOfSecondary_emails(System.JSONParser p) {
        List<Secondary_emails> res = new List<Secondary_emails>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Secondary_emails(p));
        }
        return res;
    }
}