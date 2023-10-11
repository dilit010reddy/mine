import { LightningElement, api } from 'lwc';
import template from './cloudStorageModifier.html';

export default class CloudStorageModifier extends LightningElement {

    @api show;
    @api item;
    @api isfolder;

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

    updateName(event) {
        this.item.display_name = event.target.value;
        this.item.name = `${this.item.display_name}.${this.item.extension.toLowerCase()}`;
    }

    onSubmit() {
        const event = CustomEvent('submit', {
            composed: true,
            bubbles: true,
            cancelable: true
        });
        this.dispatchEvent(event);
    }
}