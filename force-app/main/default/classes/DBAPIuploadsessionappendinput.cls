/*
@Author: P. Sutherland, Admins on Call
@Date: 01-11-2021
@Description:   API Class for Dropbox API upload session append input

@History:
*/

public class DBAPIuploadsessionappendinput {

	public Cursor cursor;
	public Boolean close;
	public DBAPIuploadsessionappendinput(){
		this.cursor = new Cursor();
		this.close = null;
	}

	public class Cursor {
		public String session_id;
		public Long offset;
		public Cursor(){
			this.session_id = '';
			this.offset = 0;
		}
	}
}