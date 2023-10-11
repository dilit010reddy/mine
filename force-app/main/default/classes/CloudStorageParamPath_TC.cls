/*
@Author: N. Larkin, Admins on Call
@Date: 01/25/2021
@Description: Test Class for ParamPath

@History:
*/
@isTest
public with sharing class CloudStorageParamPath_TC {

    static testMethod void Methodtest() { 
		//Start the Testing
		Test.startTest();
        CloudStorageParamPath constructedParamPath = new CloudStorageParamPath();
        
        CloudStorageParamPath.Param constructedParam = new CloudStorageParamPath.Param();

        CloudStorageParamPath.Param constructedParam2 = new CloudStorageParamPath.Param('key', 'value');

        List<CloudStorageParamPath.Param> Params = new List<CloudStorageParamPath.Param>();
        Params.add(constructedParam);
        Params.add(constructedParam2);

        CloudStorageParamPath constructedParamPath2 = new CloudStorageParamPath(Params);
        
        System.assert(constructedParamPath2.params[1].key == 'key');
        System.assert(constructedParamPath2.params[1].val == 'value');

		Test.stopTest(); 
	}
}