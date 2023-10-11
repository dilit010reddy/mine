trigger EmailToCaseFileHandling on EmailMessage (after insert) {
//     if(TriggerStatus.shouldRunTrigger()){
//     String templateFolder,objApi;
//     XFILES__Xfile_Manage_Folder_Hierarchy__c xfileFolderHierarchy;
//     List<String> emailIds = new List<String>();
//     for(EmailMessage em : trigger.new){
//         if(!test.isRunningTest()){
//             if(em.HasAttachment == true && em.ParentId != null && String.valueOf(em.ParentId.getSobjectType()) == 'Case'){
//                 objApi = String.valueOf(em.ParentId.getSobjectType());
//                 System.debug('xfileFolderHierarchy----------- '+xfileFolderHierarchy);
//                 xfileFolderHierarchy = XFILES__Xfile_Manage_Folder_Hierarchy__c.getValues(objApi);
//                 if(Schema.sObjectType.XFILES__External_Content_Detail__c.isCreateable()){
//                     emailIds.add(em.Id);
//                 }else{
//                     em.addError('Please add permisson Xfilespro sets to users');
//                 }
//             }
//         }else{
//             objApi = String.valueOf(em.ParentId.getSobjectType());
//             xfileFolderHierarchy = XFILES__Xfile_Manage_Folder_Hierarchy__c.getValues(objApi);
//             emailIds.add(em.Id);
//         }
//     }
//     if(xfileFolderHierarchy != null){
//         if(String.isNotBlank(xfileFolderHierarchy.XFILES__Provider_Type__c) &&
//            xfileFolderHierarchy.XFILES__Provider_Type__c.equalsIgnoreCase('GoogleDrive')){
//                if(emailIds.size() > 0){
//                    XfilesproFileScheduleForEmail XFPsch = new XfilesproFileScheduleForEmail(emailIds);
//                    try{
//                        String CRON_EXP = string.valueOf(DateTime.now().addMinutes(1).format('s m H d M ? y'));
//                        system.schedule('===ETOC=='+string.valueOf(DateTime.now().addMinutes(1).format('s m H d M ? y')), CRON_EXP, XFPsch);
//                    }catch(Exception e){
//                        e.getMessage();
//                    }
//                }
//            }
//     }
// }
}