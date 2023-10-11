/*
    Utility class for Cloud Storage Manager.
    
    Provides connecting functions to Apex Controller and
    Utility classes for managing Cloud Storage Items

    createdBy: ddurbin - 01/25/2021
*/
import getListDirectory from '@salesforce/apex/CloudStorageController.getListDirectory';
import getlink from '@salesforce/apex/CloudStorageController.getlink';
import searchitem from '@salesforce/apex/CloudStorageController.searchitem';
import moveItems from '@salesforce/apex/CloudStorageController.moveItems';
import createItem from '@salesforce/apex/CloudStorageController.createItem';
import deleteItems from '@salesforce/apex/CloudStorageController.deleteItems';
import modifyItems from '@salesforce/apex/CloudStorageController.modifyItems';
import getmetadata from '@salesforce/apex/CloudStorageController.getmetadata';
import getinit from '@salesforce/apex/CloudStorageController.getinit';
import initializeFolder from '@salesforce/apex/CloudStorageController.initializeFolder';

const buildRows = () => {
  let count = Math.floor(Math.random() * 20) + 1;
  let rows = [];
  for (var i = 0; i < count; i++) {
    rows.push({
      id: i,
      item_name: "File " + i,
      item_link: "https://www.google.com",
      item_type: "PNG",
      item_size: "1.6mb"
    });
  }
  return rows;
};

/* 
    This method retrieves the init callout object which return details for inital component load
    @param recordId - The ID of the record that the LWC is being rendered on
    @param path - The string path of the directory to be listed.

    @return object - The init Object containing path, account name, and permissions
*/
const getInitCallout = (recordId, path) => {
    return getinit({recordId: recordId, path: path});
};

/* 
    This method retrieves the items in the passed path for the given recordId
    @param recordId - The ID of the record that the LWC is being rendered on
    @param path - The string path of the directory to be listed.
    @param recursive - The boolean determining whether to list items recursively
    @param cursor - The string cursor for continuing calls when has_more is true

    @return object - The Object outlining the items in the current directory
*/
const listDirectory = ({recordId, path, recursive, cursor}) => {
    return getListDirectory({recordId: recordId, path: path, recursive: recursive, cursor: cursor});
};

/* 
    This method creates one item in the passed path with the given data. It can also upload chunks of the item using the type, offset, and jobId
    @param recordId - The ID of the record that the LWC is being rendered on
    @param paths - The path of where the item will be uploaded to.
    @param data - The base64 encoded binday data
    @param type - The action type if batching: single, start, append, finish
    @param offset - The chunk offset if batching
    @param jobId - The jobId for uploading successive chunks if batching

    @return object - The Object representing a batch success or item upload success
*/
const createItems = ({recordId, paths, data, type, offset, jobId, workflowLabel}) => {
    return createItem({recordId: recordId, paths: paths, data: data, type: type, offset: offset, async_job_id: jobId, workflowLabel: workflowLabel}); 
};

/* 
    This method moves one or more items using the given paths
    @param recordId - The ID of the record that the LWC is being rendered on
    @param paths - The array of objects which contains the source and destination paths for each of the items to be moved
    @param jobId - The batch jobId, initially null and then the id returned in the response if the batch job has not completed

    @return object - The Object representing the batch job status
*/
const moveItemsCallout = ({recordId, paths, jobId}) => {
    return moveItems({recordId: recordId, paths: JSON.stringify(paths), async_job_id: jobId});
};

/* 
    This method deletes one or more items from the given paths
    @param recordId - The ID of the record that the LWC is being rendered on
    @param paths - The string array of paths for the itmes that will be deleted
    @param jobId - The string array of paths for the itmes that will be deleted

    @return object - The Object representing the batch job response
*/
const deleteItemsCallout = ({recordId, items, jobID = null}) => {
    return deleteItems({recordId: recordId, items: items, async_job_id: jobID});
};

/* 
    This method modifies items
    @param recordId - The ID of the record that the LWC is being rendered on
    @param items - The object array of the items to be renamed. Each object will contain the path and new_path values.
    @param jobId - The batch job ID

    @return object - The Object representing the batch job response
*/
const modifyItemsCallout = ({recordId, items, jobId}) => {
    return modifyItems({recordId: recordId, paths: JSON.stringify(items), async_job_id: jobId});
};

/* 
    This method searches for items
    @param recordId - The ID of the record that the LWC is being rendered on
    @param searchTerm - The string search term
    @param path - The string search term
    @param cursor - The string cursor for continuing calls when has_more is true

    @return object - The Object representing the items returned from search and details about the job if has_more is true
*/
const searchCallout = async ({recordId, searchTerm, path, cursor}) => {
    return searchitem({recordId: recordId, search: searchTerm, path: path, cursor: cursor});
};

/* 
    This method returns a URL for access an item
    @param recordId - The ID of the record that the LWC is being rendered on
    @param path - The string item path

    @return object - The Object representing the item including the URL
*/
const getLink = (recordId,path) => {
    return getlink({recordId: recordId, path: path});
};


/* 
    This method returns the metadata for a specific item
    @param recordId - The ID of the record that the LWC is being rendered on
    @param path - The path of the item

    @return object - The Object representing the item with metadata
*/
const getMetadataCallout = ({recordId, path}) => {
    return getmetadata({recordId: recordId, path: path});
};

/* 
    This method will initialize the Dropbox Directory structure for a new account
    @param recordId - The ID of the record that the LWC is being rendered on

    @return object - The Object representing the success or failure
*/
const initializeDropboxCallout = ({recordId, path}) => {
    return initializeFolder({recordId: recordId, path: path});
};

/* 
    Class representing a Cloud Storage Item which contains all of the
    cloud storage item metadata and necessary methods for managing an item
*/
class CloudStorageNode {
    id;
    node_type;
    url;
    downloadable;
    name;
    size;
    read_only;
    path;
    display_path;
    files;
    children;

    constructor(id,node_type,url,downloadable,name,extension,size,read_only,path,display_path) {
        this.id = id;
        this.node_type = node_type;
        this.url = url;
        this.downloadable = downloadable ? downloadable : true;
        this.name = name;
        this.display_name = node_type === "file" ? this.getDisplayName(name) : this.name;
        this.extension = extension;
        this.size = size ? this.getReadableFileSizeString(size) : "Unknown";
        this.read_only = read_only ? read_only : false;
        this.path = path;
        this. display_path = display_path ? display_path : path;
        this.files = new Map();
        this.children = new Map();
        this.last_modified = "Unknown";
    }

    getDisplayName(name) {
        if (name) {
            let name_parts = name.split(".");
            name_parts.pop();
            return name_parts.join(".");
        }else {
            return "";
        }
    }

    getReadableFileSizeString(fileSizeInBytes) {
        var i = -1;
        var byteUnits = [' kB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
        do {
            fileSizeInBytes = fileSizeInBytes / 1024;
            i++;
        } while (fileSizeInBytes > 1024);
    
        return Math.max(fileSizeInBytes, 0.1).toFixed(1) + byteUnits[i];
    };

    setLastModified(last_modified) {
        let result = "Unknown";
        if (last_modified) {
            try {
                let date = new Date(last_modified);
                result = date.toLocaleDateString("en-US",{ weekday: 'short', year: 'numeric', month: 'short', day: 'numeric', hour: 'numeric', minute: 'numeric' });
            }catch(e) { 
                console.error(`An error has occurred converting the Last Modifed Date: ${JSON.stringify(e)}`);
            }
        }
        this.last_modified = result;
        return result;
    }
};

/* 
    Class representing a Cloud Storage Batch Uploader.

    This class can be used to take a file and chunk into pieces for upload to the controller
*/
class ChunkedItemUploader {
    DEFAULT_CHUNK_SIZE = 1024 * 2000; // 2 MB

    constructor(recordId, item, worflowLabel) {
        this._recordId = recordId;
        this._item = item;
        this._worflowLabel = worflowLabel;
        this._cSize = this.DEFAULT_CHUNK_SIZE;
        this._uploadType = 'start';
        this._offset = 0;
        this._jobId = null;
        this._response = null;
        this._isUploadComplete = false;
        this._isUploadError = false;
    }

    // INTERNAL FUNCTIONS

    async _upload() {
        try { 
            //Build the Item chunks
            await this._buildChunks();

            //Start the Upload
            this._uploadType = this._itemChunks.length === 1 ? 'single' : this._uploadType; //Check if just a single callout is needed
            for (let i = 0; i < this._itemChunks.length; i++) {
                const chunk = this._itemChunks[i];

                if (this._isUploadError) {
                    //Stop the upload some error has occurred
                    break;
                }else if (i === this._itemChunks.length -1 && this._uploadType !== 'single') {
                    //Last call set to type to finish
                    this._uploadType = 'finish'
                }

                console.debug(`Chunk upload callout ${i+1}. Payload: ${JSON.stringify({
                    recordId: this._recordId,
                    paths: [this._item.path],
                    jobId: this._jobId,
                    type: this._uploadType,
                    offset: this._offset,
                    data: chunk
                })}`);

                await createItems({
                    recordId: this._recordId,
                    paths: [this._item.path],
                    jobId: this._jobId,
                    type: this._uploadType,
                    offset: this._offset,
                    data: chunk,
                    workflowLabel: this._worflowLabel
                }).then((result) => {
                    this._onChunkComplete.call(this,result);
                }).catch((e) => {
                    this._onChunkError.call(this,e);
                  });
            }

            //Handle success or failure
            if (this._isUploadError) {
                this._onError(this._item.path);
            }else if (this._isUploadComplete) {
                this._onComplete(this._response);
            }else {
                this._onError("Something went wrong uploading the item.");
            }
        }catch(e) {
            this._onError(`An error hass occurred uploading the item: ${JSON.stringify(e)}`);
        }
    }

    async _buildChunks() {
        try {
            let chunks = [];
            let start = 0;
            while (start < this._item.file.size) {
                let blob_chunk = this._item.file.slice(start,start + this._cSize);
                let base64File = "";
                //Base64 encode the chunk
                await this._base64Encode(blob_chunk).then(result => {
                    if (result) {
                        base64File = result;
                    }
                }).catch(e => {
                    throw e;
                });
                chunks.push(base64File);
                start = start + this._cSize;
            }

            this._itemChunks = chunks;
        }catch(e) {
            throw e;
        }
    }

    _base64Encode(fileBlob) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onerror = reject;
            reader.onload = () => {
                resolve(reader.result.split(',')[1]);
            }
            reader.readAsDataURL(fileBlob);
        });
    }

    _onChunkComplete(result) {
        console.debug(`Chunk upload response: ${JSON.stringify(result)}`);
        if (this._uploadType === 'single' || this._uploadType === 'finish') {
            // Exepcting Complete response
            this._isUploadComplete = true;
            this._response = result;
        }else {
            // Expecting chunk response
            if (result.success) {
                //Grab job params
                this._uploadType = 'append';
                this._jobId = result.async_job_id;
                this._offset = result.offset; 
            }else {
                this._isUploadError = true;
                console.error(`An error has occurred uploading the item: ${JSON.stringify(result)}`);
            }
        }
    }

    _onChunkError(error) {
        this._isUploadError = true;
        console.error(`An error has occurred uploading the item: ${JSON.stringify(error)}`);
    }

    // PUBLIC FUNCTIONS

    start() {
        if (!this._item) {
            this._onError("No item passed to the Chunk Uploader");
            return;
        }
        //Start the Upload
        this._upload();
    }

    pause() {

    }

    resume() {

    }

    onComplete(handler) {
        this._onComplete = handler;
    }

    onError(handler) {
        this._onError = handler;
    }

}

export {
    buildRows,
    listDirectory,
    createItems,
    moveItemsCallout,
    modifyItemsCallout,
    deleteItemsCallout,
    getLink,
    searchCallout,
    getMetadataCallout,
    getInitCallout,
    initializeDropboxCallout,
    // createHomeownerAddressFolder,
    CloudStorageNode,
    ChunkedItemUploader
 };