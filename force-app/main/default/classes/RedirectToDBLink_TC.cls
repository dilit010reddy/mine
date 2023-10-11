/*
@Author: N. Larkin, Admins on Call
@Date: 10/14/2021
@Description: Test Class for RedirectToDBLink_AC

@History:
*/
@isTest
public class RedirectToDBLink_TC {
    
    static testMethod void RedirectToDBLinkWithoutParamters() {

        RedirectToDBLink_AC redirectLink = new RedirectToDBLink_AC();
        RedirectToDBLink_AC.doFetchAccessToken();
        RedirectToDBLink_AC.doRefreshAccessToken();
    }

    static testMethod void RedirectToDBLinkWithParamters() {
        ApexPages.currentPage().getParameters().put('code', '4084165105168');
        test.startTest();
        RedirectToDBLink_AC redirectLink = new RedirectToDBLink_AC();
        RedirectToDBLink_AC.doFetchAccessToken();
        RedirectToDBLink_AC.doRefreshAccessToken();
        RedirectToDBLink_AC.doRefreshAccessToken(true);
        test.stopTest();
    }
}