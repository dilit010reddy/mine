/*
@Author: P. Sutherland, Admins on Call
@Date: 11-17-2020
@Description:   API Class for Dropbox API upload input 

@History:
*/
public class DBAPIuploadinput {

	public String path {get;set;} 
	public Boolean autorename {get;set;} 
	public String client_modified {get;set;} 
	public Boolean mute {get;set;} 
	public List<Property_groups> property_groups {get;set;} 
	public Boolean strict_conflict {get;set;} 
    public Mode mode {get;set;}
    public DBAPIuploadinput() {
        this.path = '';
        this.autorename = null;
        this.client_modified = null;
        this.mute = null;
        this.property_groups = new list<Property_groups>();
        this.strict_conflict = null;
        this.mode = new Mode();
    } 
	
	public class Fields {
		public String name {get;set;} 
        public String value {get;set;}
        public Fields() {
            this.name = null;
            this.value = null;
        }
	}
	
	public class Property_groups {
		public String template_id {get;set;} 
        public List<Fields> fields {get;set;}
        public Property_groups() {
            this.template_id = null;
            this.fields = new list<Fields>();
        }
	}
	
	public class Mode {
		public String x_tag {get;set;} // in json: .tag
        public String update_Z {get;set;} // in json: update
        public Mode() {
            this.x_tag = null;
            this.update_Z = null;
        }
    }
    
    //public method to construct the json with the .tag element
    public static String genuploadJSONString(DBAPIuploadinput input){
        // Create a JSONGenerator object.
        JSONGenerator gen = JSON.createGenerator(false);
              
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('path', input.path);
        if(input.autorename != null){
            gen.writeBooleanField('autorename',input.autorename);
        }
        if(!String.isEmpty(input.client_modified)){
            gen.writeStringField('client_modified',input.client_modified);
        }
        if(input.mute != null){
            gen.writeBooleanField('mute',input.mute);
        }
        if(!input.property_groups.isEmpty()){
            gen.writeFieldName('property_groups');
            gen.writeStartArray();
            for(DBAPIuploadinput.property_groups pg : input.property_groups){
                gen.writeStartObject();
                gen.writeStringField('template_id', pg.template_id);
                gen.writeFieldName('fields');
                gen.writeStartArray();
                for(DBAPIuploadinput.fields f : pg.fields){
                    gen.writeStartObject();
                    gen.writeStringField('name', f.name);
                    gen.writeStringField('value', f.value);
                    gen.writeEndObject();
                }
                gen.writeEndArray();
                gen.writeEndObject();
            }
            gen.writeEndArray();
        }
        if(input.strict_conflict != null){
            gen.writeBooleanField('strict_conflict',input.strict_conflict);
        }
        if(!String.isEmpty(input.mode.x_tag)){
            gen.writeFieldName('mode');
            gen.writeStartObject();
            gen.writeStringField('.tag',input.mode.x_tag);
            gen.writeObjectField('update', input.mode.update_Z);
            gen.writeEndObject();
        }
        gen.writeEndObject();
        
        // Get the JSON string.
        return gen.getAsString();
    }

}