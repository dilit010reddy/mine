import { LightningElement, api } from 'lwc';
import template from './cloudStorageWorkflowModal.html';

export default class CloudStorageModifier extends LightningElement {

    @api show;
    @api foldercreation;
    @api metadata;

    render() {
        return template;
    }
    
    connectedCallback() {
        this.metadata = {};
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

    onSubmit() {
        const event = CustomEvent('submit', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                metadata: this.metadata
            }
        });
        this.dispatchEvent(event);
    }
}