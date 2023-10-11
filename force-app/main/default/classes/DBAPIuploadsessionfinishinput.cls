/*
@Author: P. Sutherland, Admins on Call
@Date: 01-11-2021
@Description:   API Class for Dropbox API upload session finish input

@History:
*/

public class DBAPIuploadsessionfinishinput {

	public Cursor cursor {get;set;} 
	public Commit_Z commit_Z {get;set;} // in json: commit
	public DBAPIuploadsessionfinishinput(){
		this.cursor = new Cursor();
		this.commit_Z = new Commit_Z();
	}

	public class Fields {
		public String name {get;set;} 
		public String value {get;set;} 
		public Fields(){
			this.name = '';
			this.value = '';
		}
	}
	
	public class Property_groups {
		public String template_id {get;set;} 
		public List<Fields> fields {get;set;}
		public Property_groups(){
			this.template_id = '';
			this.fields = new list<Fields>();
		}
	}
	
	public class Commit_Z {
		public String path {get;set;} 
		public Boolean autorename {get;set;} 
		public Boolean mute {get;set;} 
		public Boolean strict_conflict {get;set;} 
		public Mode mode {get;set;} 
		public String client_modified {get;set;} 
		public List<Property_groups> property_groups {get;set;}
		public Commit_Z() {
			this.path = '';
			this.autorename = null;
			this.mute = null;
			this.strict_conflict = null;
			this.mode = new Mode();
			this.client_modified = '';
			this.property_groups = new list<Property_groups>();
		}
	}
	
	public class Mode{
		public String x_tag {get;set;} // in json: .tag
		public String update_Z {get;set;} // in json: update
		public Mode(){
			this.x_tag = '';
			this.update_Z = '';
		}
	}
	
	public class Cursor{
		public String session_id {get;set;}
		public Long offset {get;set;}
		public Cursor(){
			this.session_id = '';
			this.offset = 0;
		}
    }
    
	public static String genuploadsessionfinishJSONString(DBAPIuploadsessionfinishinput input){
        // Create a JSONGenerator object.
        JSONGenerator gen = JSON.createGenerator(false);
                
        // Write data to the JSON string.
        gen.writeStartObject();
		if(!String.isEmpty(input.cursor.session_id) || input.cursor.offset > 0){
            gen.writeFieldName('cursor');
            gen.writeStartObject();
            gen.writeStringField('session_id',input.cursor.session_id);
            gen.writeNumberField('offset',input.cursor.offset);
            gen.writeEndObject();
        }
        if(!String.isEmpty(input.commit_Z.path) ||
            input.commit_Z.autorename != null ||
            input.commit_Z.mute != null ||
            input.commit_Z.strict_conflict != null ||
            !String.isEmpty(input.commit_Z.mode.x_tag) ||
            !String.isEmpty(input.commit_Z.client_modified) ||
            !input.commit_z.property_groups.isEmpty()
		){
            gen.writeFieldName('commit');
            gen.writeStartObject();
            gen.writeStringField('path',input.commit_Z.path);
            if(input.commit_Z.autorename != null){
                gen.writeBooleanField('autorename',input.commit_Z.autorename);
            }
            if(input.commit_Z.mute != null){
                gen.writeBooleanField('mute',input.commit_Z.mute);
            }
            if(input.commit_Z.strict_conflict != null){
                gen.writeBooleanField('strict_conflict',input.commit_Z.strict_conflict);
            }
            if(!String.isEmpty(input.commit_Z.mode.x_tag)){
                gen.writeFieldName('mode');
                gen.writeStartObject();
                gen.writeStringField('.tag',input.commit_Z.mode.x_tag);
                if(!String.isEmpty(input.commit_Z.mode.update_Z)){
                    gen.writeStringField('update',input.commit_Z.mode.update_z);
                }
                gen.writeEndObject();
            }
            if(input.commit_z.property_groups.size() > 0){
                gen.writeFieldName('property_groups');
                gen.writeStartArray();                
                for( Integer i = 0; i < input.commit_z.property_groups.size(); i++ ){
                    gen.writeStartObject(); 
                    gen.writeStringField('template_id',input.commit_z.property_groups[i].template_id);
                    if(input.commit_z.property_groups[i].fields.size() > 0){
                        gen.writeFieldName('fields');
                        gen.writeStartArray();                        
                        for ( Integer j = 0; j < input.commit_z.property_groups[i].fields.size(); j++){
                            gen.writeStartObject();
                            if(!String.isEmpty(input.commit_z.property_groups[i].fields[j].name)){
                                gen.writeStringField('name',input.commit_z.property_groups[i].fields[j].name);
                            }
                            if(!String.isEmpty(input.commit_z.property_groups[i].fields[j].value)){
                                gen.writeStringField('value',input.commit_z.property_groups[i].fields[j].value);
                            }
                            gen.writeEndObject();
                        }
                        gen.writeEndArray();    
                    }
                    gen.writeEndObject();
                }
                gen.writeEndArray();
            }   
            gen.writeEndObject();     
        }            
       	gen.writeEndObject();
        
        // Get the JSON string.
        return gen.getAsString();
    }	
}