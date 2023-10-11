/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   Drop Box API get metadata input JSON class

@History:
*/
public class DBAPIgetmetadatainput {

    public String path {get;set;} 
	public Boolean include_media_info {get;set;} 
	public Boolean include_deleted {get;set;} 
	public Boolean include_has_explicit_shared_members {get;set;} 
    public Include_property_groups include_property_groups {get;set;}
    public DBAPIgetmetadatainput() {
        this.path = '';
        this.include_media_info = null;
        this.include_deleted = null;
        this.include_has_explicit_shared_members = null;
        this.include_property_groups = new Include_property_groups();
    } 
    
    public class Include_property_groups {
		public String x_tag {get;set;} // in json: .tag
        public List<String> filter_some {get;set;}
        public Include_property_groups(){
            this.x_tag = '';
            this.filter_some = new list<String>();
        } 
    }
    
    public static String gengetmetadataJSONString(DBAPIgetmetadatainput input){
        // Create a JSONGenerator object.
        JSONGenerator gen = JSON.createGenerator(false);
              
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('path', input.path);
        if(input.include_media_info != null){
            gen.writeBooleanField('include_media_info',input.include_media_info);
        }
        if(input.include_deleted != null){
            gen.writeBooleanField('include_deleted',input.include_media_info);
        }
        if(input.include_has_explicit_shared_members != null){
            gen.writeBooleanField('include_has_explicit_shared_members',input.include_has_explicit_shared_members);
        }
        if(!input.include_property_groups.filter_some.isEmpty()){
            gen.writeFieldName('include_property_groups');
            gen.writeStartObject();
            gen.writeStringField('.tag',input.include_property_groups.X_tag);
            gen.writeObjectField('filter_some', input.include_property_groups.filter_some);
            gen.writeEndObject();
        }
        gen.writeEndObject();
        
        // Get the JSON string.
        return gen.getAsString();
    }
}