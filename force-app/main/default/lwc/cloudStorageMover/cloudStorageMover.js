import { LightningElement, api } from 'lwc';
import template from './cloudStorageMover.html';

const mover_columns = [
    {label: "Item Name", fieldName: "name", type: "itemNavigation", typeAttributes: {label: {fieldName: 'name'}, path: {fieldName: "path"}, type: {fieldName: "node_type"} } },
    { label: "Type", fieldName: "node_type" }
  ]

export default class CloudStorageMover extends LightningElement {
    @api show;
    @api rows;
    @api moverbreadcrumbs;
    @api isdisabled;
    @api isloading;
    topath;
    columns; // Mover directory manager columns

     // LWC Constructor lifecycle method
    constructor() {
        super();
        this.columns = mover_columns;
        this.topath = "";
    }

    render() {
        return template;
    }

    navigate(event) {
        this.topath = event.target.name;
        const e = CustomEvent('navigate', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                path: this.topath
            }
        });
        this.dispatchEvent(e);
    }

    handleItemClick(event) {
        this.topath = event.detail.path;
        const e = CustomEvent('itemclick', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                path: this.topath
            }
        });
        this.dispatchEvent(e);
    }

    handleSubmit() {
        const event = CustomEvent('submit', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                toPath: this.topath
            }
        });
        this.dispatchEvent(event);
    }

    closeModal() {
        const event = CustomEvent('close', {
            composed: true,
            bubbles: true,
            cancelable: true
        });
        this.dispatchEvent(event);
    }

    
}