/*
@Author: P. Sutherland, Admins on Call
@Date: 01-11-2021
@Description:   API Class for Dropbox API upload session start input

@History:
*/
public class DBAPIuploadsessionstartinput {
    public Boolean close {get;set;} 
	public Session_type session_type {get;set;} 
	public DBAPIuploadsessionstartinput() {
		this.close = null;
		this.session_type = new Session_type();
	}

	public class Session_type {
		public String x_tag {get;set;} // in json: .tag
		public Session_type(){
			x_tag = '';
		}
	}	
		
	public static String genUploadsessionstartJSONString(DBAPIuploadsessionstartinput input){
        // Create a JSONGenerator object.
        JSONGenerator gen = JSON.createGenerator(false);
                
        // Write data to the JSON string.
        gen.writeStartObject();
        if(input.close <> null){
            gen.writeBooleanField('close',input.close);
        }
        if(!String.isEmpty(input.session_type.x_tag)) {
            gen.writeFieldName('Session_type');
            gen.writeStartObject();
            gen.writeStringField('.tag',input.session_type.x_tag);
            gen.writeEndObject();
        }
        gen.writeEndObject();
        
        // Get the JSON string.
        return gen.getAsString();
    }   
}