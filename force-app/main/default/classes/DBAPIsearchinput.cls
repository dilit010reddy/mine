/*
@Author: P. Sutherland, Admins on Call
@Date: 11-24-2020
@Description:   Drop Box API search input JSON class

@History:
*/
public class DBAPIsearchinput {

    public String query {get;set;} 
	public Options options {get;set;} 
    public Match_field_options match_field_options {get;set;}
    public DBAPISearchinput() {
        this.query = '';
        this.options = new Options();
        this.match_field_options = new Match_field_options();
    } 

	public class Options {
		public String path {get;set;} 
		public Integer max_results {get;set;} 
		public Order_by order_by {get;set;} 
		public File_status file_status {get;set;} 
		public Boolean filename_only {get;set;} 
		public List<String> file_extensions {get;set;} 
        public List<File_categories> file_categories {get;set;}
        public Options() {
            this.path = null;
            this.max_results = 500;
            this.order_by = new Order_by(); // x_tag
            this.file_status = new File_status(); //x_tag
            this.filename_only = null;
            this.file_extensions = new list<String>();
            this.file_categories = new list<File_categories>(); //has an x_tag
        }		
    }

    public class Match_field_options {
        public Boolean include_highlights {get;set;}
        public Match_field_options() {
            this.include_highlights = null;
        }         
    }

	public class Order_by {
        public String x_tag {get;set;} // in json: .tag
        public Order_by() {
            this.x_tag = '';
        }
    }
    
    public class File_status {
        public String x_tag {get;set;} // in json: .tag
        public File_status() {
            this.x_tag = '';
        }
	}

    public class File_categories {
        public String x_tag {get;set;} // in json: .tag
        public File_categories() {
            this.x_tag = '';
        }
    }
    
    //public method to construct the json with the .tag element
    public static String gensearchJSONString(DBAPIsearchinput input){
        // Create a JSONGenerator object.
        JSONGenerator gen = JSON.createGenerator(false);
                
        // Write data to the JSON string.
        gen.writeStartObject();
        gen.writeStringField('query', input.query);
        if(!String.isEmpty(input.options.path) ||
           input.options.max_results > 0 ||
           !String.isEmpty(input.options.order_by.x_tag) ||
           !String.isEmpty(input.options.file_status.x_tag) ||
           input.options.filename_only != null ||
           input.options.file_extensions.size() > 0 ||
           input.options.file_categories.size() > 0
        ){
            gen.writeFieldName('options');
            gen.writeStartObject();
            if(!String.isEmpty(input.options.path)){ 
               gen.writeStringField('path', input.options.path);
            }
            if(input.options.max_results > 0 ){
                gen.writeNumberField('max_results', input.options.max_results);
            }
            if(!String.isEmpty(input.options.order_by.x_tag)){
                gen.writeFieldName('order_by');
                gen.writeStartObject();
                gen.writeStringField('.tag',input.options.order_by.x_tag);
                gen.writeEndObject();
            }
            if(!String.isEmpty(input.options.file_status.x_tag)){
                gen.writeFieldName('file_status');
                gen.writeStartObject();
                gen.writeStringField('.tag',input.options.file_status.x_tag);
                gen.writeEndObject();
            }
            if(input.options.filename_only != null){
                gen.writeBooleanField('filename_only', input.options.filename_only);
            }
            if(input.options.file_extensions.size() > 0){
                gen.writeObjectField('file_extensions', input.options.file_extensions);
            }
            if(input.options.file_categories.size() > 0){
                gen.writeFieldName('file_categories');
                gen.writeStartArray();
                for(DBAPIsearchinput.File_categories cat : input.options.file_categories){
                    gen.writeStartObject();
                    gen.writeStringField('.tag', cat.x_tag);
                    gen.writeEndObject();
                }
                gen.writeEndArray(); 
            }
            gen.writeEndObject();
        }
        if(input.match_field_options.include_highlights != null){
            gen.writeFieldName('match_field_options');
            gen.writeStartObject();
            gen.writeBooleanField('include_highlights',input.match_field_options.include_highlights);
            gen.writeEndObject();
        }
        gen.writeEndObject();
        
        // Get the JSON string.
        return gen.getAsString();
    }
}