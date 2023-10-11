import { LightningElement, api, track, wire } from 'lwc';
import template from './cloudStorageHomeAddressDirectory.html';
import getAddressNames from "@salesforce/apex/CloudStorageController.getAddressNames";

export default class CloudStorageHomeAddressDirectory extends LightningElement {
    @api show;
    @api workflowtype;
    @api metadata;
    @track options;
    @api recordId;
    id;
    error;

    
    render() {
        return template;
    }
    
    connectedCallback() {
        this.metadata = {};
        this.getOptions();
    }

    /* @wire(getAddressNames, { ObjectId: '$recordId' })
    grabOptions({ error, data }) {
        console.log('NICHOLAS entering wire');
        if (data) {
            console.log('NICHOLAS entering data');
            console.log('data: ' + data);
            let options = [];
              result.forEach(r => {
                options.push({
                  label: r,
                  value: r,
                });
              });
            
            this.options = options;
        } else if (error) {
            console.log('NICHOLAS entering error');
            this.error = error;
            console.log('error: ' + error);
            this.options = undefined;
        }
    } */

    getOptions() {
        console.log(this.recordId);
        getAddressNames({ObjectId : this.recordId})
          .then((result) => {
             let options = [];
            if (result) {
              result.forEach(r => {
                options.push({
                  label: r,
                  value: r,
                });
              });
            }
            this.options = options;
          })
          .catch((error) => {
            // handle Error
          });
      }
    

    hideModal() {
        const event = CustomEvent('hide', {
            composed: true,
            bubbles: true,
            cancelable: true
        });
        this.dispatchEvent(event);
    }

    handleInput(event) {
        this.metadata[event.target.name] = event.target.value;
    }

    handleChange(event) {
        this.metadata[event.target.name] = event.target.value;
    }

    onSubmit() {
        const event = CustomEvent('submit', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                type: 'folder_initiation',
                metadata: this.metadata
            }
        });
        this.dispatchEvent(event);
    }
}