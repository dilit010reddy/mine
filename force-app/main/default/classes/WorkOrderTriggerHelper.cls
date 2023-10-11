public class WorkOrderTriggerHelper {
    public WorkOrderTriggerHelper() {
    }

    public static void AssignContactEmailToCase(WorkOrder[] newWorkOrders, Map<ID, WorkOrder> newWorkOrdersMap){
        List<Id> CaseIds = new List<Id>();

        //loop through updated work orders to grab all related cases
        for(WorkOrder wo : newWorkOrders){
            System.debug('NICHOLAS CASE ID:' + wo.CaseId);
            CaseIds.add(wo.CaseId);
        }
        List<Case> caseList = [SELECT ID, Work_Order__c, WorkOrderContactEmail__c, WorkOrderContactEmailField__c FROM Case WHERE ID IN :CaseIds];
        List<Case> caseListToUpdate = new List<Case>();

        //loop through Cases and assign their lookup WorkOrders to the WorkOrders inserted
        for(Case c : caseList){
            for(WorkOrder wo : newWorkOrders){
                if(wo.CaseId == c.Id){
                    c.Work_Order__c = wo.Id; //set case's lookup to inserted Work Order.
                    caseListToUpdate.add(c);
                }
            }
        }
        update caseListToUpdate; //update cases to set email Formula Field WorkOrderContactEmail__c
        caseListToUpdate.clear(); //clear contents of list for second update.
        List<Case> caseList2 = [SELECT ID, Work_Order__c, WorkOrderContactEmail__c, WorkOrderContactEmailField__c FROM Case WHERE ID IN :CaseIds]; //requery to get updated Email fields.
        //loop through related cases and then set the email field to its formula field containing its related Work Order's Contact's Email
        for(Case c : caseList2){
            if(c.WorkOrderContactEmail__c != null){
                System.debug('NICHOLAS EMAIL FIELD:' + c.WorkOrderContactEmailField__c);
                System.debug('NICHOLAS FORMULA FIELD:' + c.WorkOrderContactEmail__c);
                c.WorkOrderContactEmailField__c = c.WorkOrderContactEmail__c; //assign email field to formula field.
            }
            caseListToUpdate.add(c);
        }
        TriggerStatus.setDoNotRunTrigger(); // to prevent recursion.
        update caseListToUpdate;
    }
}