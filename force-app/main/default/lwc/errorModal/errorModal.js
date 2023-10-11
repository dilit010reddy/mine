import { LightningElement, api } from 'lwc';

export default class ErrorModal extends LightningElement {
    @api message;
    @api show;

    closeModal() {
        const event = CustomEvent('hide', {
            composed: true,
            bubbles: true,
            cancelable: true
        });
        this.dispatchEvent(event);
    }
}