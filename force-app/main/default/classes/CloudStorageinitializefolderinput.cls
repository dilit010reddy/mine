/* @Author: P. Sutherland and N. Larkin, QuantumRhino
@Date: 02/08/2021
@Description: Class for the inputs to initialize folder */

public class CloudStorageinitializefolderinput {
    public String recordId {get;set;}
    public String path  {get;set;}
    public CloudStorageinitializefolderinput() {
        this.recordId = '';
        this.path = '';

    }

    public CloudStorageinitializefolderinput(String recordId, String path) {
        this.recordId = recordId;
        this.path = path;
      
    }
      
}