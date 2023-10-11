import { LightningElement, api } from 'lwc';
import template from './cloudStorageItemNavigation.html';

export default class CloudStorageItemNavigation extends LightningElement {
    @api label;
    @api path;
    @api type;

    render() {
        return template;
    }

    itemclick() {
        const event = CustomEvent('itemclick', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                label: this.label,
                path: this.path,
                node_type: this.type
            },
        });
        this.dispatchEvent(event);
    }
}