/*
@Author: N. Larkin, QuantumRhino
@Date: 08/09/2021
@Description: test class for Inbound Email Handler

@History:
*/
@isTest
public class InboundReplyHandler_TC {
    @isTest
    static void testhandleInbbound(){ //with thread ID in the Subject
        TriggerStatus.setDoNotRunTrigger();
        // create case for email to be attached to.
        Case testCase = new Case();
        testCase.Subject = 'testSubject';
        insert testCase;

        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        // setup the data for the email
        email.subject = 'Test Email Subject ' + testCase.Id;
        env.fromAddress = 'sbrady@digitalhands.com';
        list<string> toEmails = new list<string>();
        toEmails.add('sbrady@digitalhands.com');
        email.toAddresses = toEmails;

        // add attachments
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfile.txt';
        attachment.mimeTypeSubType = 'text/plain';

        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };

        Messaging.InboundEmail.textAttachment attachment2 = new Messaging.InboundEmail.textAttachment();
        attachment2.body = 'my attachment text';
        attachment2.fileName = 'textfile.txt';
        attachment2.mimeTypeSubType = 'text/plain';

        email.textAttachments = new Messaging.inboundEmail.textAttachment[] { attachment2 };

        // call the email service class and test it with the data in the testMethod
        InboundReplyHandler emailProcess = new InboundReplyHandler();
        emailProcess.handleInboundEmail(email, env);

        // query for the case related to the thread
        //BMCServiceDesk__Incident__c ticket = [select id, Emailed_From__c  from BMCServiceDesk__Incident__c where Emailed_From__c = :env.fromAddress];

        //System.assertEquals(ticket.Emailed_From__c,'sbrady@digitalhands.com');

        list<Attachment> attachments = [select name from attachment where parentId = :testCase.id];
        Attachment a = attachments[0];
        System.assertEquals(a.name,'textfile.txt');
    }

    @isTest
    static void testhandleInbbound2(){ //with thread ID in the Body
        TriggerStatus.setDoNotRunTrigger();
        // create case for email to be attached to.
        Case testCase = new Case();
        testCase.Subject = 'testSubject';
        insert testCase;

        // create a new email and envelope object
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        // setup the data for the email
        email.subject = 'Test Email Subject';
        email.plainTextBody = 'Test Email Body ' + testCase.Id;
        env.fromAddress = 'sbrady@digitalhands.com';
        list<string> toEmails = new list<string>();
        toEmails.add('sbrady@digitalhands.com');
        email.toAddresses = toEmails;

        // add attachments
        Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'textfile.txt';
        attachment.mimeTypeSubType = 'text/plain';

        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };

        Messaging.InboundEmail.textAttachment attachment2 = new Messaging.InboundEmail.textAttachment();
        attachment2.body = 'my attachment text';
        attachment2.fileName = 'textfile.txt';
        attachment2.mimeTypeSubType = 'text/plain';

        email.textAttachments = new Messaging.inboundEmail.textAttachment[] { attachment2 };

        // call the email service class and test it with the data in the testMethod
        InboundReplyHandler emailProcess = new InboundReplyHandler();
        emailProcess.handleInboundEmail(email, env);

        // query for the case related to the thread
        //BMCServiceDesk__Incident__c ticket = [select id, Emailed_From__c  from BMCServiceDesk__Incident__c where Emailed_From__c = :env.fromAddress];

        //System.assertEquals(ticket.Emailed_From__c,'sbrady@digitalhands.com');

        list<Attachment> attachments = [select name from attachment where parentId = :testCase.id];
        Attachment a = attachments[0];
        System.assertEquals(a.name,'textfile.txt');
    }
}