import { LightningElement,api,track } from 'lwc';
import getRules from '@salesforce/apex/RuleHandler.getAccRules';
import { updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';
const columns = [
    {  type: 'button-icon', typeAttributes: { iconName: 'utility:arrowup', name: 'up'}, initialWidth: 80 },
    {  type: 'button-icon', typeAttributes: { iconName: 'utility:arrowdown', name: 'down'}, initialWidth: 80 },
    { label: 'Order', fieldName: 'Order__c', type: 'number',hideDefaultActions: true, sortable: false, wrapText: true, initialWidth: 100 },
    { label: 'Rule Name', fieldName: 'Rule_Name__c', hideDefaultActions: true, sortable: false, wrapText: true }
]
export default class SequenceRules extends LightningElement {
    @api recordId;
    @track columns;
    error;
    rules;
    dataTable = true;
    isLoading = true;
    retrievedRecordId = false;

    renderedCallback() {
        if (!this.retrievedRecordId && this.recordId){
            this.columns=columns
            //alert(this.recordId)            
            this.retrievedRecordId = true; 
            getRules({accountId:this.recordId})
            .then((result)=>{
                //alert(JSON.stringify(result))
                this.dataTable = true;
                this.rules = result;
                this.isLoading = false;
                //alert(JSON.stringify(result))
            })
            .catch((error)=>{                    
                    let errorMessage = "Unknown error";
                    this.isLoading = false;
                    if (Array.isArray(error.body)) {
                        errorMessage = error.body.map((e) => e.message).join(", ");
                    } else if (typeof error.body.message === "string") {
                        errorMessage = error.body.message;
                    }
                    this.error = errorMessage;
                })
        }
    }


    saveSequences() {
        const promises = this.rules.map((currentRow) => {
            const fields = { Id: currentRow.Id, Order__c: currentRow.Order__c};
            const recordInput = {
                fields: fields
            };
            updateRecord(recordInput);
        });
        Promise.all(promises)
            .then(() => {
                this.closeModal();
                //showSuccessMessage(this, "Sequences updated successfully.");  
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Order Rules',
                    message: 'Sequences updated successfully.',
                    variant: 'success'
                }));              
            })
            .catch((error) => {
                //showErrorMessage(this, `Error updating sequence order. ${error}`);
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Order Rules',
                    message: `Error updating sequence order. ${error}`,
                    variant: 'error'
                }));
            });
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());        
    }


    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case "up":
                this.rowSortUp(row);
                break;
            case "down":
                this.rowSortDown(row);
                break;
            default:
        }
    }

    rowSortDown(row) {
        let existingRow = this.rules.find((obj) => obj.Id === row.Id);
        if (existingRow) {
            // The array and object elements inside it are read-only and so we need to use the
            // spread operator to copy them into a mutable object for the sorting update
            let sourceDataForSort = [...this.rules];
            let updatedRowIndex = sourceDataForSort.indexOf(existingRow);
            if (updatedRowIndex + 1 < sourceDataForSort.length) {
                let rowBelow = { ...sourceDataForSort[updatedRowIndex + 1] };
                let rowShiftingDown = {
                    ...sourceDataForSort[updatedRowIndex]
                };
                console.log(rowBelow.Order__c, rowShiftingDown.Order__c);
                rowBelow.Order__c = rowShiftingDown.Order__c;
                rowShiftingDown.Order__c = updatedRowIndex + 2;
                sourceDataForSort[updatedRowIndex + 1] = rowShiftingDown;
                sourceDataForSort[updatedRowIndex] = rowBelow;
                this.rules = sourceDataForSort;
            }
        }
    }

    rowSortUp(row) {
        let existingRow = this.rules.find((obj) => obj.Id === row.Id);
        if (existingRow) {
            let sourceDataForSort = [...this.rules];
            let updatedRowIndex = sourceDataForSort.indexOf(existingRow);
            if (updatedRowIndex - 1 >= 0) {
                let rowAbove = { ...sourceDataForSort[updatedRowIndex - 1] };
                let rowShiftingUp = { ...sourceDataForSort[updatedRowIndex] };
                rowAbove.Order__c = rowShiftingUp.Order__c;
                rowShiftingUp.Order__c = updatedRowIndex;
                sourceDataForSort[updatedRowIndex - 1] = rowShiftingUp;
                sourceDataForSort[updatedRowIndex] = rowAbove;
                this.rules = sourceDataForSort;
            }
        }
    }
}