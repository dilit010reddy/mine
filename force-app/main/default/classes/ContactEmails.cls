/*
@Author: Vince Boyle
@Date: 07-07-2021
@Description: Class contains methods for sending different emails on the Contact object

@History:
*/

public without sharing class ContactEmails {
    public static void sendVerifyContactInfoChangeEmail(List<Contact> changedContacts, Map<Id, Contact> oldContacts, Boolean emailChanged) {
        List<Messaging.SingleEmailMessage> allEmails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE Name = 'Verify Contact Information'];
        OrgWideEmailAddress fromAddress = [SELECT Id FROM OrgWideEmailAddress WHERE Address = 'donotreply@helsing.com' LIMIT 1];

        for (Contact changedContact : changedContacts) {
            List<String> sendTo = new List<String>();
            if(changedContact.Email != null){
                sendTo.add(changedContact.Email);
            }
            if (emailChanged == true && oldContacts.get(changedContact.Id).Email != null) {
                sendTo.add(oldContacts.get(changedContact.Id).Email);
            }

            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(changedContact.Id); 
            // this cannot be set when an org wide default email is also sent
            // message.setSenderDisplayName(changedContact.Account_Name_Formula__c); 
            message.setOrgWideEmailAddressId(fromAddress.Id);
            message.setReplyTo(changedContact.Association_Email__c);
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(false);
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(changedContact.Id); //This is important for the merge fields in template to work
            if(sendTo.size() > 0){
                message.setToAddresses(sendTo);
                allEmails.add(message);
            }
        }


        if (allEmails.isEmpty() == false) {
            try {
                Messaging.SendEmailResult[] results = Messaging.sendEmail(allEmails);
            } catch (Exception e) {
                System.debug('Caught Exception when sending email to changed contacts in ContactEmail.cls, Exception: ' + e);
            }
        }
    }
}