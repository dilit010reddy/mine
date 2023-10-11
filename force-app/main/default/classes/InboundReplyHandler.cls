/*
@Author: N. Larkin, QuantumRhino
@Date: 8/6/2021
@Description: InboundEmailHandler class that receives inbound emails and saves them to the appropriate case.

@History:
*/
global class InboundReplyHandler implements Messaging.InboundEmailHandler{

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, 
                                                            Messaging.InboundEnvelope env ) {
        Messaging.InboundEmailResult inboundResult = new Messaging.InboundEmailResult();

        if(email.toAddresses.contains('workorders@helsing.com') || 	email.toAddresses.contains('workorders@1idpvgag20uvcd4mkpiw37xegf0s7cre07qw23ptsupotv9o01.1f-bbkpuao.cs90.apex.sandbox.salesforce.com') || Test.isRunningTest()){
            if(email.subject.contains('500') || email.plainTextBody.contains('500')){ //If the email has the first 3 numbers of any case ID in the Subject or Body, you know it needs to be saved into that case.
                String caseId = email.subject.right(18); //grabs the last 15 characters of the subject which should be the case ID
                System.debug('NICHOLAS caseId: ' + caseId);
                Case workingCase = new Case();
                try{
                    workingCase = [SELECT id FROM Case WHERE id = :caseId];
                    EmailMessage inboundEmailObject = new EmailMessage();
                    inboundEmailObject.FromAddress = email.fromAddress;
                    inboundEmailObject.ToAddress = email.toAddresses[0];
                    if(email.fromName <> null){
                        inboundEmailObject.FromName = email.fromName;
                    }
                    inboundEmailObject.Subject = email.subject;
                    inboundEmailObject.TextBody = email.plainTextBody;
                    inboundEmailObject.HtmlBody = email.htmlBody;
                    inboundEmailObject.ParentId = caseId;
                    insert inboundEmailObject;

                    if(email.binaryAttachments <> null){
                        for(Messaging.InboundEmail.BinaryAttachment binaryAttach : email.binaryAttachments){
                            Attachment myAttachment  = new Attachment();
                            myAttachment.Body = binaryAttach.body;
                            myAttachment.Name = binaryAttach.filename;
                            myAttachment.ParentId = caseId;
                            insert myAttachment;
                        }
                    }

                    if(email.textAttachments <> null){
                        for(Messaging.InboundEmail.textAttachment textAttach : email.textAttachments){
                            Attachment myAttachment  = new Attachment();
                            myAttachment.Body = Blob.valueof(textAttach.body);
                            myAttachment.Name = textAttach.filename;
                            myAttachment.ParentId = caseId;
                            insert myAttachment;
                        }
                    }

                    inboundResult.success = true;
                    return inboundResult;
                }
                catch(exception e){
                        caseId = email.plainTextBody.right(18);
                        workingCase = [SELECT id FROM Case WHERE id = :caseId];
                        EmailMessage inboundEmailObject = new EmailMessage();
                    inboundEmailObject.FromAddress = email.fromAddress;
                    inboundEmailObject.ToAddress = email.toAddresses[0];
                    if(email.fromName <> null){
                        inboundEmailObject.FromName = email.fromName;
                    }
                    inboundEmailObject.Subject = email.subject;
                    inboundEmailObject.TextBody = email.plainTextBody;
                    inboundEmailObject.HtmlBody = email.htmlBody;
                    inboundEmailObject.ParentId = caseId;
                    insert inboundEmailObject;

                    if(email.binaryAttachments <> null){
                        for(Messaging.InboundEmail.BinaryAttachment binaryAttach : email.binaryAttachments){
                            Attachment myAttachment  = new Attachment();
                            myAttachment.Body = binaryAttach.body;
                            myAttachment.Name = binaryAttach.filename;
                            myAttachment.ParentId = caseId;
                            insert myAttachment;
                        }
                    }

                    if(email.textAttachments <> null){
                        for(Messaging.InboundEmail.textAttachment textAttach : email.textAttachments){
                            Attachment myAttachment  = new Attachment();
                            myAttachment.Body = Blob.valueof(textAttach.body);
                            myAttachment.Name = textAttach.filename;
                            myAttachment.ParentId = caseId;
                            insert myAttachment;
                        }
                    }

                    inboundResult.success = true;
                    return inboundResult;
                }
            }
            else{ //if the email is not a reply in custom threadID system send a response back to the sender.
                //inboundResult.success = false;
                /* list<String> emails = new list<String>();
                 emails.add(env.fromAddress); //adding email address of person who used this email address incorrectly
                 system.debug('From address in inbound: ' + env.fromAddress);
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 mail.setToAddresses(emails);
                 //mail.setReplyTo('workorders@helsing.com');
                 mail.setSenderDisplayName('DO NOT REPLY');
                 String emailSubject = 'Email Thread Not Found';
                 mail.setSubject(emailSubject);*/
                 String emailBody = 'Dear sir or madam, \n\nYou have replied to an email without proper reference to the work order provided.  Please respond to the last email received from our office regarding this work order to ensure this response is properly logged. \n\nThank you, The Helsing Group';
                 /*mail.setHtmlBody(emailBody);
                 try{
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                 }
                 catch(exception e){
                     e.setMessage('Error replying to email without case thread ID');
                     throw e;
                 } */
                inboundResult.success = false;
                inboundResult.message = emailBody;
                return inboundResult;
            }
        }
        else{ //if the email is not related to this process, return inboundResult
            return inboundResult;
        }
    }
}