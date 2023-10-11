import { LightningElement,api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from 'lightning/navigation';
import cloneRule from "@salesforce/apex/RulesQuickActionController.cloneRule";
export default class CloneRuleQuickActioncmp extends NavigationMixin(LightningElement){

    @api recordId;

    @api
    async invoke() {

        cloneRule({ruledetailId:this.recordId}).then(result=>{
            //getRecordNotifyChange([{ recordId: this.recordId }]);
            this.navigateToViewRulePage(result);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: "Rule cloned",
                    message: "You cloned the rule successfully",
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

      // Navigate to View Rule Page
    navigateToViewRulePage(ruleId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: ruleId,
                objectApiName: 'Rule_Detail__c',
                actionName: 'view'
            },
        });
    }
}