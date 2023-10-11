import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getUrl from '@salesforce/apex/GenerateUrl.getUrl';

export default class CallComposer extends NavigationMixin(LightningElement) {

    @api recordId;

    @api invoke() {

        getUrl({caseId:this.recordId}).then((result)=>{
            console.log(result);
            if(result)
            {
                const config = {
                    type: 'standard__webPage',
                    attributes: {
                        url: result
                    }
                };
                this[NavigationMixin.Navigate](config);
             
            }
        })

    }
}