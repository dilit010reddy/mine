import { LightningElement, api } from 'lwc';
import template from './cloudStorageUploader.html';

export default class CloudStorageUploader extends LightningElement {

    @api show;
    @api items;

    render() {
        return template;
    }

    hideUploader() {
        const event = CustomEvent('hide', {
            composed: true,
            bubbles: true,
            cancelable: true
        });
        this.dispatchEvent(event);
    }

    onChange(event) {
        const changeEvent = CustomEvent('uploadchange', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                type: 'upload',
                metadata: {
                    files: event.target.files
                }
                
            }
        });
        this.dispatchEvent(changeEvent);
    }

    uploadComplete() {
        const event = CustomEvent('uploadcomplete', {
            composed: true,
            bubbles: true,
            cancelable: true
        });
        this.dispatchEvent(event);
    }

}