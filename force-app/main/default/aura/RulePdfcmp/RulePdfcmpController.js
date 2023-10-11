({
    doinit:function(cmp){
        //alert(cmp.get("v.recordId"));
    },
    handleExit : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire()
        
    },
    handleClick : function(component, event, helper) {
        //downloadExcelFile : function(component) { 
        //alert(component.get("v.recordId"));
        var action = component.get("c.RulesPdfupdate");
        var self = this;
        var ruleId = component.get("v.recordId");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(action){
            console.log(action.getState());
            var state = action.getState();
            if(state == 'SUCCESS') {
                var strFile = "data:application/pdf;base64,"+action.getReturnValue();
                download(strFile, "proposedRule.pdf", "application/pdf");
                $A.get("event.force:showToast")
                .setParams({
                    title: "Success",
                    type: "success",
                    message: "The Rule is sent for approval"
                })
                .fire();
                
                $A.get("event.force:refreshView").fire();
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": ruleId
                });
                navEvt.fire();
            }else{
                $A.get("e.force:showToast")
                .setParams({
                    title: "Error",
                    type: "error",
                    message: "An error occurred while saving changes."
                })
                .fire();
            }
        }); 
        $A.enqueueAction(action);    	
    }
})