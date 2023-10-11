import { LightningElement,api,wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {getRecordNotifyChange} from "lightning/uiRecordApi";
import approveRule from "@salesforce/apex/RulesQuickActionController.approveRule";
import { CurrentPageReference } from "lightning/navigation";
export default class ApproveRuleQuickActioncmp extends LightningElement {

    @api recordId;

    quickActionAPIName = "";

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference.type === "standard__quickAction") {
            let quickActionPath = currentPageReference.attributes.apiName; // ex: Opportunity.My_Quick_Action
            this.quickActionAPIName = quickActionPath.split('.')[1]; // Ex: My_Quick_Action
        }
    }

    @api
    async invoke() {
       // alert(this.quickActionAPIName);
        approveRule({ruledetailId:this.recordId})
        .then(result=>{
            getRecordNotifyChange([{ recordId: this.recordId }]);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Rule Approval",
                    message: "You activated the rule successfully",
                    variant: "success"
                })
            );
            
        }).catch(error=>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Error",
                    message: "Unknown error occurred",
                    variant: "error"
                })
            );
        })
    }
}