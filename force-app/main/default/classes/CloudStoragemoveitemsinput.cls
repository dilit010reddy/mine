/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage move items input

@History:
*/
public class CloudStoragemoveitemsinput {

    public String recordId {get;set;}
    public List<Move> moves {get;set;}
    public CloudStoragemoveitemsinput(){
        this.recordId = '';
        this.moves = new list<Move>();
    }
    public CloudStoragemoveitemsinput(String recordId, List<Move> moves){
        this.recordId = recordId;
        this.moves = moves;
     }
	public class Move {
		public String src {get;set;}
        public String dest {get;set;}
        public Move(){
            this.src = '';
            this.dest = '';
        }
        public Move(String src, String dest){
            this.src = src;
            this.dest = dest;
        }
	}

}