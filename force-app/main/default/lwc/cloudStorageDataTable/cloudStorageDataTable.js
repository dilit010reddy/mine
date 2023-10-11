import LightningDatatable from 'lightning/datatable'
import customCloudStorageItemTypeTemplate from './customCloudStorageItemType.html';

export default class CloudStorageDataTable extends LightningDatatable {
    static customTypes = {
        itemNavigation: {
            template: customCloudStorageItemTypeTemplate,
            // Provide template data here if needed
            typeAttributes: ['label','path','type']
        }
       //more custom types here
    };
}