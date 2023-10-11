import { LightningElement, api } from 'lwc';
import template from './confirmModal.html';

export default class ConfirmModal extends LightningElement {

    @api message;
    @api show;
    @api action

    render() {
        return template;
    }

    onConfirm() {
        const event = CustomEvent('confirm', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                action: this.action
            }
        });
        this.dispatchEvent(event);
    }

    onCancel() {
        const event = CustomEvent('cancel', {
            composed: true,
            bubbles: true,
            cancelable: true
        });
        this.dispatchEvent(event);
    }
}