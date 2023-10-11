public class WorkOrderTriggerHandler {

    public void OnAfterInsert(WorkOrder[] newWorkOrders, Map<ID, WorkOrder> newWorkOrdersMap){
        WorkOrderTriggerHelper.AssignContactEmailToCase(newWorkOrders, newWorkOrdersMap);
    }

    /* public void OnBeforeInsert(WorkOrder[] oldWorkOrders, WorkOrder[] updatedWorkOrders, Map<ID, WorkOrder> oldWorkOrdersMap, Map<ID, WorkOrder> updatedWorkOrdersMap){
        WorkOrderTriggerHelper.AssignContactEmailCase(oldWorkOrders, updatedWorkOrders, oldWorkOrdersMap, updatedWorkOrdersMap);
    } */

}