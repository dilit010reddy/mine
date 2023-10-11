import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import {getRecordNotifyChange} from "lightning/uiRecordApi";
import denyRule from "@salesforce/apex/RulesQuickActionController.denyRule";
export default class DenyRuleQuickActioncmp extends LightningElement {

    @api recordId;

    @api
    async invoke() {

        denyRule({ruledetailId:this.recordId}).then(result=>{
            getRecordNotifyChange([{ recordId: this.recordId }]);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Rule Approved",
                    message: "You approved the rule successfully",
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