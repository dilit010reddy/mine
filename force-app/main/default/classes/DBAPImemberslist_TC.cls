/*
@Author: P. Sutherland, Admins on Call
@Date: 11-02-2020
@Description:   Test Class for Dropbox API memberslist response.

@History:
*/

@IsTest
public class DBAPImemberslist_TC {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  "members": ['+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AADfdb8nlqSdNyRx2jVxKrztpP_cK6dS0cA",'+
		'        "account_id": "dbid:AAATrqAXq2K1Y_oASIxpGizjsvZ0a39E8bQ",'+
		'        "email": "chris@adminsoncall.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Chris",'+
		'          "surname": "Sinkwitz",'+
		'          "familiar_name": "Chris",'+
		'          "display_name": "Chris Sinkwitz",'+
		'          "abbreviated_name": "CS"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-08-25T21:13:24Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "8206317072"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "team_admin"'+
		'      }'+
		'    },'+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AABUtB5iWcYaVZxtN8OUrHScCvCcmBWxt9E",'+
		'        "account_id": "dbid:AABla4X9NtAm2d_JVD97SvrkIDjVjr16Qss",'+
		'        "email": "csinkwitz@adminsoncall.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Corree",'+
		'          "surname": "Sinkwitz",'+
		'          "familiar_name": "Corree",'+
		'          "display_name": "Corree Sinkwitz",'+
		'          "abbreviated_name": "CS"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-08-25T01:37:14Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "8205175072"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "team_admin"'+
		'      }'+
		'    },'+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AAA-eTTP-bYRGwgyxeuCjCuR_ZPfi08Vo2M",'+
		'        "account_id": "dbid:AAA5HqgQX6rDE6dAWpLdThbszInCg8liAs8",'+
		'        "email": "bhubbell@adminsoncall.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [' +
		'			{' +
		'			"email": "grape@strawberry.com",' +
		'			"is_verified": false' +
		'			},' +
		'			{ '+
		'			"email": "apple@orange.com",' +
		'			"is_verified": true' +
		'			}' +
		'			],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Brian",'+
		'          "surname": "Hubbell",'+
		'          "familiar_name": "Brian",'+
		'          "display_name": "Brian Hubbell",'+
		'          "abbreviated_name": "BH"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-09-02T04:08:40Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "8206312976"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "team_admin"'+
		'      }'+
		'    },'+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AAD3pKEvetUBA7Dk-WIdWWoZ1WHlwK365JQ",'+
		'        "account_id": "dbid:AADhrBS_TmJkiw3ZwbLroiDgSEoqHVXFkhU",'+
		'        "email": "bendbuddy@yahoo.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Ben",'+
		'          "surname": "Bertrandt",'+
		'          "familiar_name": "Ben",'+
		'          "display_name": "Ben Bertrandt",'+
		'          "abbreviated_name": "BB"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-08-25T04:45:16Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "3423629"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "team_admin"'+
		'      }'+
		'    },'+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AABURvvG-GpyJxvqK2eQFXptdbu2nzwV8So",'+
		'        "account_id": "dbid:AADBuGvT9EjlLJSBiWcC8nsSmRgwgNLQF38",'+
		'        "email": "creynolds@adminsoncall.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Chris",'+
		'          "surname": "Reynolds",'+
		'          "familiar_name": "Chris",'+
		'          "display_name": "Chris Reynolds",'+
		'          "abbreviated_name": "CR"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-08-26T15:14:42Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "8216177360"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "team_admin"'+
		'      }'+
		'    },'+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AAACXF7VTuO6PeOTlESYCF2c3ZTglrQviU0",'+
		'        "account_id": "dbid:AAC8_XQzzGN8qFof4guLqZn0nK_QSFzNeh0",'+
		'        "email": "bburke@adminsoncall.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Brett",'+
		'          "surname": "Burke",'+
		'          "familiar_name": "Brett",'+
		'          "display_name": "Brett Burke",'+
		'          "abbreviated_name": "BB"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-09-02T16:21:58Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "8256668432"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "member_only"'+
		'      }'+
		'    },'+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AAAiEDJrewhnIZykcsMaaXMju0x_TNLxiMI",'+
		'        "account_id": "dbid:AAB9t-rTcU3sqEfJPHKmxIHL64FPNne783k",'+
		'        "email": "abalci@adminsoncall.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Aydin",'+
		'          "surname": "Balci",'+
		'          "familiar_name": "Aydin",'+
		'          "display_name": "Aydin Balci",'+
		'          "abbreviated_name": "AB"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-09-25T17:44:11Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "8391560016"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "member_only"'+
		'      }'+
		'    },'+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AAAWBZR3bdV_h6m9FSjssXLoMe86A-4KUm8",'+
		'        "account_id": "dbid:AAAMAFVYIxEqYPCpXQK4NuP5CVHQFXB1dRA",'+
		'        "email": "psutherland@adminsoncall.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Pat",'+
		'          "surname": "Sutherland",'+
		'          "familiar_name": "Pat",'+
		'          "display_name": "Pat Sutherland",'+
		'          "abbreviated_name": "PS"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-10-19T19:56:11Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "8521862256"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "team_admin"'+
		'      }'+
		'    },'+
		'    {'+
		'      "profile": {'+
		'        "team_member_id": "dbmid:AAC1WJWE8pmS6b6uZBks2KDYzy2fn2oSBbY",'+
		'        "account_id": "dbid:AAC_ViLmsEgT3QAt6OFODoKWcSPonuyFR0Y",'+
		'        "email": "sam.torrejon@dracosol.com",'+
		'        "email_verified": true,'+
		'        "secondary_emails": [],'+
		'        "status": {'+
		'          ".tag": "active"'+
		'        },'+
		'        "name": {'+
		'          "given_name": "Sam",'+
		'          "surname": "Torrejon",'+
		'          "familiar_name": "Sam",'+
		'          "display_name": "Sam Torrejon",'+
		'          "abbreviated_name": "ST"'+
		'        },'+
		'        "membership_type": {'+
		'          ".tag": "full"'+
		'        },'+
		'        "joined_on": "2020-10-26T19:40:42Z",'+
		'        "groups": ['+
		'          "g:bdaefc21e9d14e0b0000000000000002"'+
		'        ],'+
		'        "member_folder_id": "8557504928"'+
		'      },'+
		'      "role": {'+
		'        ".tag": "member_only"'+
		'      }'+
		'    }'+
		'  ],'+
		'  "cursor": "AADqUnHgnUIH0_hhHh7rIw06YJCJzwBA35vQ6aurRON3C-Bs2pt1CtTtqWhHn-uzXrl1XtMDVi4nDZ1P-eJosxWw3oI4pE3dZjnzy2QodBbhAA",'+
		'  "has_more": false'+
		'}';
		DBAPImemberslist r = new DBAPImemberslist();
		r = DBAPImemberslist.parse(json);
		System.assert(r != null);
		
		

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImemberslist.Status objStatus = new DBAPImemberslist.Status(System.JSON.createParser(json));
		System.assert(objStatus != null);
		System.assert(objStatus.x_tag == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImemberslist objDBAPImemberslist = new DBAPImemberslist(System.JSON.createParser(json));
		System.assert(objDBAPImemberslist != null);
		System.assert(objDBAPImemberslist.members == null);
		System.assert(objDBAPImemberslist.cursor == null);
		System.assert(objDBAPImemberslist.has_more == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImemberslist.Secondary_emails objSecondary_emails = new DBAPImemberslist.Secondary_emails(System.JSON.createParser(json));
		System.assert(objSecondary_emails != null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImemberslist.Profile objProfile = new DBAPImemberslist.Profile(System.JSON.createParser(json));
		System.assert(objProfile != null);
		System.assert(objProfile.team_member_id == null);
		System.assert(objProfile.account_id == null);
		System.assert(objProfile.email == null);
		System.assert(objProfile.email_verified == null);
		System.assert(objProfile.secondary_emails == null);
		System.assert(objProfile.status == null);
		System.assert(objProfile.name == null);
		System.assert(objProfile.membership_type == null);
		System.assert(objProfile.joined_on == null);
		System.assert(objProfile.groups == null);
		System.assert(objProfile.member_folder_id == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImemberslist.Members objMembers = new DBAPImemberslist.Members(System.JSON.createParser(json));
		System.assert(objMembers != null);
		System.assert(objMembers.profile == null);
		System.assert(objMembers.role == null);

		json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		DBAPImemberslist.Name objName = new DBAPImemberslist.Name(System.JSON.createParser(json));
		System.assert(objName != null);
		System.assert(objName.given_name == null);
		System.assert(objName.surname == null);
		System.assert(objName.familiar_name == null);
		System.assert(objName.display_name == null);
		System.assert(objName.abbreviated_name == null);

		DBAPImemberslist.Status constructedStatus = new DBAPImemberslist.Status();
		System.assert(constructedStatus != null);
		System.assert(constructedStatus.x_tag == '');

		DBAPImemberslist.Profile constructedProfile = new DBAPImemberslist.Profile();
		System.assert(objProfile != null);
		
		DBAPImemberslist.Members constructedMembers = new DBAPImemberslist.Members();
		System.assert(constructedMembers != null);



	
		//json = '{"TestAMissingObject": { "TestAMissingArray": [ { "TestAMissingProperty": "Some Value" } ] } }';
		//DBAPImemberslist secondaryEmailsMembersList = new DBAPImemberslist();
		//secondaryEmailsMembersList.
		//List<Secondary_emails> addedSecondary_emails = new DBAPImemberslist.Secondary_emails(System.JSON.createParser(json));
		//System.assert(addedSecondary_emails != null);

	}
}