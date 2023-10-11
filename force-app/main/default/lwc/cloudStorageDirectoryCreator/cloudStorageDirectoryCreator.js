import { LightningElement, api } from 'lwc';
import template from './cloudStorageDirectoryCreator.html';

export default class CloudStorageDirectoryCreator extends LightningElement {
    @api show;
    @api workflowtype;
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
                type: 'folder_initiation',
                metadata: this.metadata
            }
        });
        this.dispatchEvent(event);
    }
}