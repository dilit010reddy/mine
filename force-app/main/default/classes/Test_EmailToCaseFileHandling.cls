@isTest
public class Test_EmailToCaseFileHandling {
//     @isTest
//     public static void emailHandler(){
//         XFILES__Cloud_Storage_Provider__c csp = new XFILES__Cloud_Storage_Provider__c();
//         csp.Name = 'my drive';
//         csp.XFILES__API_Auth_Token__c = 'ya29.GlsBB7oM_CHqNf-9bYRLnYm_CbEFT8mUasTHl-38R~1/JHrWvzeor0w7MwTyuTzTp165HSEvuTSO_ZC-ghZok9xb9KFEhGDggV7LUGXBQzkT';
//         csp.XFILES__Username__c = XFILES.XFilesCommonUtil.encryptKey('nzb4OtVa7T6l8K/Jhj5QKL3JLw036DIPiCTxMrTcO1ieY+08Cr5Mgrs0lN0Ulk4BS2iHnw2BuAw4nmOhRVLWkkUT3nROsl5YzF9B7VG8RT9tsXYOVvVKaHseZ5yKySb8');
//         csp.XFILES__Password__c = XFILES.XFilesCommonUtil.encrypt('iiJWsYZxqjEE+BFtdKNE6cQMdcEJ/DeW4Jo3yTDufwrpSdXv1lS9ADwQraZEwWNM');
//         csp.XFILES__Service_Endpoint_URL__c ='https://www.googleapis.com';
//         csp.XFILES__prefix__c = 'x';
//         csp.XFILES__Root_Folder_Name__c = 'CEPTES100';
//         insert csp;
//         System.assertEquals('my drive',csp.Name);
        
//         XFILES__Xfile_Manage_Folder_Hierarchy__c mfh = new XFILES__Xfile_Manage_Folder_Hierarchy__c();
//         mfh.Name = 'Case';
//         mfh.XFILES__Folder_Id__c = '0B97U1jPVjrw0djJ4R1BPOVVLd2ssad';
//         mfh.XFILES__Provider_Id__c = csp.Id;
//         mfh.XFILES__Provider_Name__c = csp.Name;
//         mfh.XFILES__Provider_Type__c = 'GoogleDrive';
//         mfh.XFILES__Folder_Structure__c = true;
//         mfh.XFILES__Folder_Reference_Field_API_Name__c = 'Name';
//         insert mfh;
        
//         XFILES__Xfile_Manage_Folder_Hierarchy__c mfh1 = new XFILES__Xfile_Manage_Folder_Hierarchy__c();
//         mfh1.Name = 'EmailMessage';
//         mfh1.XFILES__Folder_Id__c = '0B97U1jPVjrw0djJ4R1BPOVVLd2ssad';
//         mfh1.XFILES__Provider_Id__c = csp.Id;
//         mfh1.XFILES__Provider_Name__c = csp.Name;
//         mfh1.XFILES__Provider_Type__c = 'GoogleDrive';
//         mfh1.XFILES__Folder_Structure__c = true;
//         mfh1.XFILES__Folder_Reference_Field_API_Name__c = 'CaseNumber';
//         insert mfh1;
        
//         XFILES__Xfile_Manage_Folder_Hierarchy__c mfh2 = new XFILES__Xfile_Manage_Folder_Hierarchy__c();
//         mfh2.Name = 'Account';
//         mfh2.XFILES__Folder_Id__c = '0B97U1jPVjrw0djJ4R1BPOVVLd2ssad';
//         mfh2.XFILES__Provider_Id__c = csp.Id;
//         mfh2.XFILES__Provider_Name__c = csp.Name;
//         mfh2.XFILES__Provider_Type__c = 'GoogleDrive';
//         mfh2.XFILES__Folder_Structure__c = true;
//         mfh2.XFILES__Folder_Reference_Field_API_Name__c = 'Name';
//         insert mfh2;
        
//         Account acc = new Account();
//         acc.Name = 'Test acc';
//         acc.Website = 'www.xfilespro.com';
//         acc.Industry = 'Chemicals';
//         acc.Description = 'Account/Test acc';
//         insert acc;
        
//         Contact conc = new Contact();
//         conc.LastName = 'Test Contact';
//         conc.AccountId = acc.Id;
//         conc.Email = 'support@xfilespro.com';
//         insert conc;
        
//         Case cs = new Case();
//         cs.AccountId = acc.Id;
//         cs.ContactId = conc.Id;
//         cs.Status = 'Open';
//         cs.Origin = 'Email';
//         cs.Priority = 'Low';
//         cs.Subject = 'Test';
//         cs.Description = 'abc/efg'; 
// 		insert cs;
        
//         List<String> emailIds = new List<String>();
//         List<String> recIds = new List<String>();
        
//         EmailMessage em = new EmailMessage();
//         em.ParentId = cs.Id;
//         em.Subject = 'test';
//         em.FromAddress = 'support@xfilespro.com';
//         em.Incoming = false;
//         em.ToAddress = 'sales@xfilespro.com';
//         em.TextBody = 'abc/efg'; 
//         insert em;
//         emailIds.add(em.Id);
        
//         Blob htmlBody = Blob.valueOf('<html><head><meta http-equiv="Refresh" content="0; "></head></html>');
        
//         Attachment att = new Attachment();
//         att.Name = 'test.png';
//         att.ParentId = em.Id;
//         att.Body = htmlBody;
//         att.ContentType = 'image/png';
//         insert att;
//         recIds.add(att.Id);
        
//          Map<String, String> fileDet = new Map<String, String>();
//         fileDet.put('fileName',att.Name);
//         fileDet.put('recordId',att.Id);
//         fileDet.put('isLinkType','true');
//         fileDet.put('providerId',mfh2.XFILES__Provider_Id__c);
//         fileDet.put('parentId',em.Id);
//         List<String> fList = new List<String>();
//         fList.add(JSON.serialize(fileDet));
        
        
//         Test.StartTest();
//         if(emailIds.size() > 0 &&  acc.Id != null){
//             XfilesproFileScheduleForEmail XFPsch = new XfilesproFileScheduleForEmail(emailIds);
//             String cron = '0 0 23 * * ?';
//             system.schedule('===ETOC=='+System.now(), cron, XFPsch);
//             //XfilesproNotesAndAttachmentsClass.processExternalContentDetails(fList, mfh2.XFILES__Provider_Name__c, mfh2.XFILES__Provider_Type__c);
//         }
//         Test.stopTest(); 
//     }
    
    
//    @isTest
//     public static void emailHandler1(){
//         XFILES__Cloud_Storage_Provider__c csp = new XFILES__Cloud_Storage_Provider__c();
//         csp.Name = 'my drive';
//         csp.XFILES__API_Auth_Token__c = 'ya29.GlsBB7oM_CHqNf-9bYRLnYm_CbEFT8mUasTHl-38R~1/JHrWvzeor0w7MwTyuTzTp165HSEvuTSO_ZC-ghZok9xb9KFEhGDggV7LUGXBQzkT';
//         csp.XFILES__Username__c = XFILES.XFilesCommonUtil.encryptKey('nzb4OtVa7T6l8K/Jhj5QKL3JLw036DIPiCTxMrTcO1ieY+08Cr5Mgrs0lN0Ulk4BS2iHnw2BuAw4nmOhRVLWkkUT3nROsl5YzF9B7VG8RT9tsXYOVvVKaHseZ5yKySb8');
//         csp.XFILES__Password__c = XFILES.XFilesCommonUtil.encrypt('iiJWsYZxqjEE+BFtdKNE6cQMdcEJ/DeW4Jo3yTDufwrpSdXv1lS9ADwQraZEwWNM');
//         csp.XFILES__Service_Endpoint_URL__c ='https://www.googleapis.com';
//         csp.XFILES__prefix__c = 'x';
//         csp.XFILES__Root_Folder_Name__c = 'CEPTES100';
//         insert csp;
//         System.assertEquals('my drive',csp.Name);
        
//         XFILES__Xfile_Manage_Folder_Hierarchy__c mfh = new XFILES__Xfile_Manage_Folder_Hierarchy__c();
//         mfh.Name = 'Case';
//         mfh.XFILES__Folder_Id__c = '0B97U1jPVjrw0djJ4R1BPOVVLd2ssad';
//         mfh.XFILES__Provider_Id__c = csp.Id;
//         mfh.XFILES__Provider_Name__c = csp.Name;
//         mfh.XFILES__Provider_Type__c = 'GoogleDrive';
//         mfh.XFILES__Folder_Structure__c = true;
//         mfh.XFILES__Folder_Reference_Field_API_Name__c = 'CaseNumber';
//         insert mfh;
        
//         XFILES__Xfile_Manage_Folder_Hierarchy__c mfh1 = new XFILES__Xfile_Manage_Folder_Hierarchy__c();
//         mfh1.Name = 'EmailMessage';
//         mfh1.XFILES__Folder_Id__c = '0B97U1jPVjrw0djJ4R1BPOVVLd2ssad';
//         mfh1.XFILES__Provider_Id__c = csp.Id;
//         mfh1.XFILES__Provider_Name__c = csp.Name;
//         mfh1.XFILES__Provider_Type__c = 'GoogleDrive';
//         mfh1.XFILES__Folder_Structure__c = true;
//         mfh1.XFILES__Folder_Reference_Field_API_Name__c = 'Name';
//         insert mfh1;
        
//         XFILES__Xfile_Manage_Folder_Hierarchy__c mfh2 = new XFILES__Xfile_Manage_Folder_Hierarchy__c();
//         mfh2.Name = 'Account';
//         mfh2.XFILES__Folder_Id__c = '0B97U1jPVjrw0djJ4R1BPOVVLd2ssad';
//         mfh2.XFILES__Provider_Id__c = csp.Id;
//         mfh2.XFILES__Provider_Name__c = csp.Name;
//         mfh2.XFILES__Provider_Type__c = 'GoogleDrive';
//         mfh2.XFILES__Folder_Structure__c = true;
//         mfh2.XFILES__Folder_Reference_Field_API_Name__c = 'Name';
//         insert mfh2;
        
//         Account acc = new Account();
//         acc.Name = 'Test acc';
//         acc.Website = 'www.xfilespro.com';
//         acc.Industry = 'Chemicals';
//         acc.Description = 'Account/Test acc';
//         insert acc;
        
//         Contact conc = new Contact();
//         conc.LastName = 'Test Contact';
//         conc.AccountId = acc.Id;
//         conc.Email = 'support@xfilespro.com';
//         insert conc;
        
//         Case cs = new Case();
//         cs.Status = 'Open';
//         cs.Origin = 'Email';
//         cs.Priority = 'Low';
//         cs.Subject = 'Test';  
//         cs.Description = 'abc/efg';
//         cs.AccountId = acc.Id;
//         cs.ContactId = conc.Id;
// 		insert cs;
        
//         List<String> emailIds = new List<String>();
//         List<String> recIds = new List<String>();
        
//         EmailMessage em = new EmailMessage();
//         em.ParentId = cs.Id;
//         em.Subject = 'test';
//         em.FromAddress = 'support@xfilespro.com';
//         em.Incoming = true;
//         em.ToAddress = 'sales@xfilespro.com';
//         em.TextBody = 'abc/efg'; 
//         insert em;
//         emailIds.add(em.Id);
        
//         EmailMessage em1 = new EmailMessage();
//         em1.ParentId = cs.Id;
//         em1.Subject = 'test';
//         em1.FromAddress = 'support@xfilespro.com';
//         em1.Incoming = false;
//         em1.ToAddress = 'sales@xfilespro.com';
//         insert em1;
//         emailIds.add(em1.Id);
        
//         Blob htmlBody = Blob.valueOf('<html><head><meta http-equiv="Refresh" content="0; "></head></html>');
//         String body = '{"mimeType": "application/vnd.google-apps.folder","name": "abc","parents":["005678653245765456"]}';
//         String token = 'ya29.GlsBB7oM_CHqNf-9bYRLnYm_CbEFT8mUasTHl-38R';
        
//         ContentVersion con = new Contentversion();
//         con.Title = 'test';
//         con.PathOnClient = 'test.png';
//         con.VersionData = htmlBody;
//         insert con;
        
//         Id contentDocId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:con.Id LIMIT 1].ContentDocumentId; 
//         ContentDocumentLink conLink = new ContentDocumentLink();
//         conLink.ContentDocumentId=contentDocId;
//         conLink.LinkedEntityId=em.Id;
//         conLink.ShareType='v';
//         conLink.Visibility = 'AllUsers';
//         insert conLink;
//         recIds.add(conLink.Id);
        
//         ContentVersion con1 = new Contentversion();
//         con1.Title = 'test';
//         con1.PathOnClient = 'test.png';
//         con1.VersionData = htmlBody;
//         insert con1;
        
//         Id contentDocId1 = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =:con1.Id LIMIT 1].ContentDocumentId; 
//         ContentDocumentLink conLink1 = new ContentDocumentLink();
//         conLink1.ContentDocumentId=contentDocId1;
//         conLink1.LinkedEntityId=em1.Id;
//         conLink1.ShareType='v';
//         conLink1.Visibility = 'AllUsers';
//         insert conLink1;
//         recIds.add(conLink1.Id);
        
//         Map<String, String> fileDet = new Map<String, String>();
//         fileDet.put('fileName',con.Title);
//         fileDet.put('recordId',conLink1.Id);
//         fileDet.put('isLinkType','true');
//         fileDet.put('providerId',mfh2.XFILES__Provider_Id__c);
//         fileDet.put('parentId',em.Id);
//         List<String> fList = new List<String>();
//         fList.add(JSON.serialize(fileDet));
        
//         Test.StartTest();
//         if(emailIds.size() > 0 && acc.Id != null){
//             XfilesproFileScheduleForEmail XFPsch = new XfilesproFileScheduleForEmail(emailIds);
//             String cron = '0 0 23 * * ?';
//             system.schedule('===ETOC=='+System.now(), cron, XFPsch);
//         }
//         XfilesproNotesAndAttachmentsClass.createFolder(token, body);
//         XfilesproNotesAndAttachmentsClass.createFolderInfo('0B6yzSSOP_q6ndUlQSkdaQmhvQkU', acc.Id, 'Account', '');
//         XfilesproNotesAndAttachmentsClass.getFolderId('0B6yzSSOP_q6ndUlQSkdaQmhvQkU','Account','ya29.GlsBB7oM_CHqNf-9bYRLnYm_CbEFT8mUasTHl-38R');
//         XfilesproNotesAndAttachmentsClass.processFilesAndAttachmentsForGDrive(mfh2.XFILES__Provider_Name__c, mfh2.XFILES__Provider_Id__c, 'ya29.GlsBB7oM_CHqNf-9bYRLnYm_CbEFT8mUasTHl-38R', '0B6yzSSOP_q6ndUlQSkdaQmhvQkU', conLink1.Id);
//         XfilesproNotesAndAttachmentsClass.processExternalContentDetails(fList, mfh2.XFILES__Provider_Name__c, mfh2.XFILES__Provider_Type__c);
//         Test.stopTest(); 
//     }
}