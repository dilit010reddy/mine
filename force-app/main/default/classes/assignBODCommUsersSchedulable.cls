/*
    Name: assignBODCommUsersSchedulable
    Author: Vincent Boyle
    Date: 6/21/2021
    Description: Schedulable interface for the batch class that assigns BOD community users
                 to a public group for list views
*/

public class assignBODCommUsersSchedulable implements Schedulable {
    public void execute(SchedulableContext sc) {
        assignBODCommUsersBatch b = new assignBODCommUsersBatch();
        database.executebatch(b);
    }
}