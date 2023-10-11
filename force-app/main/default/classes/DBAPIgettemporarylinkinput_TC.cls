/*
@Author: P. Sutherland, Admins on Call
@Date: 11-23-2020
@Description:   Drop Box API get temporary link input JSON class test

@History:
*/
@IsTest
public class DBAPIgettemporarylinkinput_TC {
	
	static testMethod void testMeth() {
		String json = '{'+
		'    \"path\": \"/thg_customers/test_customer/sample.txt\"'+
		'}';
		DBAPIgettemporarylinkinput obj = new DBAPIgettemporarylinkinput();
		System.assert(obj != null);
	}
}