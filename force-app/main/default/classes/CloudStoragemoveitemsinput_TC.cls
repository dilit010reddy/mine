/*
@Author: P. Sutherland, Admins on Call
@Date: 11-18-2020
@Description:   API Class for CloudStorage move items input test

@History:
*/
@IsTest
public class CloudStoragemoveitemsinput_TC {
	
	static testMethod void testmeth() {
		String json = '{'+
		'	\"recordId\": \"123456789012345678\",'+
		'	\"moves\": [{'+
		'			\"src\": \"from\",'+
		'			\"dest\": \"to\"'+
		'		},'+
		'		{'+
		'			\"src\": \"from\",'+
		'			\"dest\": \"to\"'+
		'		}'+
		'	]'+
		'}';
		CloudStoragemoveitemsinput obj = new CloudStoragemoveitemsinput();
		System.assert(obj != null);
		CloudStoragemoveitemsinput.Move tstmove = new CloudStoragemoveitemsinput.Move();
        list<CloudStoragemoveitemsinput.Move> lstmoves = new list<CloudStoragemoveitemsinput.Move>(); 
        lstmoves.add(new CloudStoragemoveitemsinput.Move('from','to'));
        lstmoves.add(new CloudStoragemoveitemsinput.Move('src','dest'));
        obj = new CloudStoragemoveitemsinput('123456789012345678',lstmoves);
        System.assert(obj != null);
	}
}