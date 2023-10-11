/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   API Class for Dropbox API createfolder response.

@History:
*/
@IsTest
public class CloudStorageUIResponse_TC {
    static testMethod void testMeth() {
        CloudStorageUIResponse res = new CloudStorageUIResponse();
        res = new CloudStorageUIResponse('DropBox','createfolder',new DBAPIcreatefolder(),'',200);
    }
}