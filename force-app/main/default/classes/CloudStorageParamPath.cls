public class CloudStorageParamPath {
    
        
        public List<Param> params {get;set;} 
        public CloudStorageParamPath(){
            this.params = new List<Param>();
        }
        public CloudStorageParamPath(List<Param> params){
            this.params = params;
        }
        

        public class Param{
            public String key {get;set;}
            public String val {get;set;}


            public Param(){
                this.key = '';
                this.val = '';
            }
            public Param(String key, String val){
                this.key = key;
                this.val = val;
            }
        } 


}