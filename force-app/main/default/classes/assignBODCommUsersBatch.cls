/*
    Name: assignBODCommUsersBatch
    Author: Vincent Boyle
    Date: 6/21/2021
    Description: Queries for BOD Community Users, if they are not assigned to Public Group
                 'BOD Portal User List View' it assigns them
*/

public class assignBODCommUsersBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // query for active BOD community portal users
        // can only execute one batch in test class, limit test query to 200 records
        // user records are visible to test methods, reference only test users
        Profile BODCommProfile = [SELECT Id FROM Profile WHERE Name = 'BOD Community User' LIMIT 1];
        Id BODCommProfileId = BODCommProfile.Id;

        if (Test.isRunningTest()) {
            return Database.getQueryLocator('SELECT Id ' +
                                              'FROM User ' +
                                             'WHERE Id NOT IN ' + 
                                                    '(SELECT UserOrGroupId FROM GroupMember ' +
                                                    'WHERE Group.Name = \'BOD Portal User List View\') ' +
                                               'AND ProfileId = :BODCommProfileId AND IsActive = true AND LastName = \'testBOD\'' +
                                             'LIMIT 200');
        } else {
            return Database.getQueryLocator('SELECT Id ' +
                                              'FROM User ' +
                                             'WHERE Id NOT IN ' + 
                                                    '(SELECT UserOrGroupId FROM GroupMember ' +
                                                    'WHERE Group.Name = \'BOD Portal User List View\')' +
                                               'AND ProfileId = :BODCommProfileId AND IsActive = true');
        }  
    }

    public void execute(Database.BatchableContext bc, List<User> userRecords) {
        // all users that pass into this method have not been assigned to the public group
        // loop records and add users to group
        Group portalGroup = new Group();
        List<GroupMember> newGroupMembers = new List<GroupMember>();

        // check that the public has not been removed
        try {
            portalGroup = [SELECT Id FROM Group WHERE DeveloperName = 'BOD_Portal_User_List_View' LIMIT 1];
            for (User portalUser : userRecords) {
                newGroupMembers.add(new GroupMember(UserOrGroupId = portalUser.Id,
                                                            GroupId = portalGroup.Id));
            }
            if (newGroupMembers.isEmpty() == false) {
                insert newGroupMembers;
            }
        } catch(Exception e) {
            system.debug('Error assigning users to group: ' + e.getMessage());
        }    
    }

    public void finish(Database.BatchableContext bc) {
        // may not need to execute any code here
    }
}