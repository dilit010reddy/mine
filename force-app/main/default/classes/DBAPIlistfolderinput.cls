/*
@Author: P. Sutherland, Admins on Call
@Date: 11-16-2020
@Description:   API Class for Dropbox API list folder input

@History:
*/
public class DBAPIlistfolderinput {

    public String path {get;set;} 
	public Boolean recursive {get;set;} 
	public Boolean include_media_info {get;set;} 
	public Boolean include_deleted {get;set;} 
	public Boolean include_has_explicit_shared_members {get;set;} 
	public Boolean include_mounted_folders {get;set;} 
	public Integer limit_Z {get;set;} // in json: limit
    public Include_property_groups include_property_groups {get;set;}
    public Shared_link shared_link {get;set;} 
    public Boolean include_non_downloadable_files {get;set;}
    public DBAPIlistfolderinput(){
        this.path = '';
        this.recursive = null;
        this.include_media_info = null;
        this.include_deleted = null;
        this.include_has_explicit_shared_members = null;
        this.include_mounted_folders = null;
        this.limit_Z = null;
        this.include_property_groups = new Include_property_groups();
        this.shared_link = new Shared_link();
        this.include_non_downloadable_files = null;
    } 

    public class Shared_link{
        public String url {get;set;}
        public String password {get;set;}
        public Shared_link(){
            this.url = '';
            this.password = '';
        }
        public Shared_link(String url, String password){
            this.url = url;
            this.password = password;
        }
    }

	public class Include_property_groups {
		public String x_tag {get;set;} // in json: .tag
		public List<String> filter_some {get;set;} 
        public Include_property_groups(){
            this.x_tag = '';
            this.filter_some = new list<String>();
        }
    }
    
    //public method to construct the json with the .tag element
    public static String genlistfolderJSONString(DBAPIlistfolderinput input){
        // Create a JSONGenerator object.
        JSONGenerator gen = JSON.createGenerator(false);
              
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('path', input.path);
        if(input.recursive != null){
            gen.writeBooleanField('recursive',input.recursive);
        }
        if(input.include_media_info != null){
            gen.writeBooleanField('include_media_info',input.include_media_info);
        }
        if(input.include_deleted != null){
            gen.writeBooleanField('include_deleted',input.include_media_info);
        }
        if(input.limit_Z != null){
            gen.writeNumberField('limit',input.limit_Z);
        }
        if(input.include_has_explicit_shared_members != null){
            gen.writeBooleanField('include_has_explicit_shared_members',input.include_has_explicit_shared_members);
        }
        if(input.include_mounted_folders != null){
            gen.writeBooleanField('include_mounted_folders',input.include_mounted_folders);
        }
        if(input.include_non_downloadable_files != null){
            gen.writeBooleanField('include_non_downloadable_files',input.include_non_downloadable_files);
        }
        if(!String.isEmpty(input.shared_link.url)){
            gen.writeFieldName('shared_link');
            gen.writeStartObject();
            gen.writeStringField('url',input.shared_link.url);
            gen.writeObjectField('password', input.shared_link.password);
            gen.writeEndObject();
        }
        if(!input.Include_property_groups.filter_some.isEmpty()){
            gen.writeFieldName('include_property_groups');
            gen.writeStartObject();
            gen.writeStringField('.tag',input.Include_property_groups.X_tag);
            gen.writeObjectField('filter_some', input.Include_property_groups.filter_some);
            gen.writeEndObject();
        }
        gen.writeEndObject();
        
        // Get the JSON string.
        return gen.getAsString();
    }	
}