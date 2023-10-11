/*
    Dropbox Manager class.
    
    Acts as the Controller for the Dropbox
    Manager Lightning Web Component

    createdBy: ddurbin - 01/25/2021
*/
import {
    listDirectory,
    CloudStorageNode,
    moveItemsCallout,
    modifyItemsCallout,
    deleteItemsCallout,
    searchCallout,
    getLink,
    createItems,
    getMetadataCallout,
    getInitCallout,
    ChunkedItemUploader,
    initializeDropboxCallout
} from 'c/utils';

const MAX_CHUNK_SIZE = 2000000;


/*
*
*/
class DropboxDirectoryManager {
    isInitialized; // Boolean of whether or not the Dropbox has been initialized for the Account
    root_path; // The root path of the dropbox manager
    root_display_path; // The display root path for init directory calls
    curr_node; // The current node that the dropbox manager is displaying
    directory_root; // The root node of the dropbox manager
    bread_crumbs; // The array of breadcrumb objects for UI display
    mover_bread_crumbs; // The array of breadcrumb objects for Mover UI display
    recordId; // The ID of the Object associated to the dropbox component
    recordName; // The Name of the Object associated to the dropbox component
    searchResults; // The search result entries
    isAdmin; // Boolean to determine if component should have admin rights
    userProfile; // The profile name of the current user
    uploadStatuses; // An array for tracking item upload status
    uploadComplete; // Flag for tracking upload complete callback
    workflowRules; // The workflow rules Map
    displayableWorkflows; // A Map of the workflows that will be displayed in the dropdown
    deleteButtonShow;

    constructor(recordId) {
        this.recordId = recordId;
        this.searchResults = [];
        this.displayableWorkflows = new Map();
        this.uploadStatuses = {};
        this.uploadComplete = false;
        this.isInitialized = false;
        this.deleteButtonShow = false;
    }

    initDirectoryManager() {
        return new Promise((resolve, reject) => {
            getInitCallout(this.recordId, "/").then((result) => {
                if (result.error) {
                    //An error has occurred
                    console.error(`An error has occurred on init callout: ${JSON.stringify(response)}`);
                    reject(result);
                }

                //Parse init response
                this.isAdmin = result.isadmin;
                this.isReadOnly = result.readonly;
                //Set up root
                this.isInitialized = result.isinitialized;
                this.root_display_path = result.custpath;
                this.root_path = result.custpath.toLowerCase();
                this.recordName = result.accountname;
                this.userProfile = result.userprofile;
                this.bread_crumbs = [{
                    key: 1,
                    label: this.recordName,
                    path: this.root_path
                }];
                this.mover_bread_crumbs = [{
                    key: 1,
                    label: this.recordName,
                    path: this.root_path
                }];

                //Build workflow rules
                if (result.workflowRules) {
                    this.buildWorkflowRules(result.workflowRules);
                    this.isRestricted = this.workflowRules.has('folder_restriction');
                }

                if (this.isInitialized) {
                    //Get inital data load
                    this.loadDirectory(this.root_path, false, true).then((data) => {
                        resolve(data);
                    }).catch((ex) => {
                        console.error(`An exception has occurred on init callout: ${JSON.stringify(ex)}`);
                        reject(ex);
                    });
                } else {
                    resolve({ success: true, data: [] });
                }
            }).catch((e) => {
                console.error(`An exception has occurred refreshing the data: ${JSON.stringify(e)}`);
                reject(e);
            });
        });
    }

    buildWorkflowRules(rules) {
        if (rules) {
            this.workflowRules = new Map(); //Initialize Rules map
            rules.forEach(aRule => {
                let ruleTypeArr = this.workflowRules.get(aRule.type);
                if (ruleTypeArr) {
                    ruleTypeArr.push(aRule); //Add rule to Type Arr
                } else {
                    this.workflowRules.set(aRule.type, [aRule]); // Initialize new Type array with rule
                }
                //Check if workflow is displayable
                if (aRule.is_displayable) {
                    this.displayableWorkflows.set(aRule.label, aRule);
                }
            });
        }
    }

    getWorkflowOptions() {
        const workflows = [];
        if (this.displayableWorkflows) {
            this.displayableWorkflows.forEach((rule, key) => {
                workflows.push({
                    label: rule.display_name,
                    value: key
                });
            })
        }

        return workflows;
    }

    getWorkflowType(workflowKey) {
        return this.displayableWorkflows.get(workflowKey).type;
    }

    isWorkflowRunnable(workflowName) {
        const isRootPath = this.root_path == this.getCurrPath();
        switch (workflowName) {
            case 'create_annual_folder':
                return !isRootPath;
            // case 'Create_Homeowner_Address_Folder':
            //     return !isRootPath;
            default:
                return true;
        }
    }

    getRulesByType(type) {
        let rules = [];
        let rulesTypeArr = this.workflowRules ? this.workflowRules.get(type) : null;
        if (rulesTypeArr && rulesTypeArr.length > 0) {
            for (let i = 0; i < rulesTypeArr.length; i++) {
                const rule = rulesTypeArr[i];
                Array.prototype.push.apply(rules, rule.path_constructor.map(path => this.getAbsolutePath(path).toLowerCase()));
            }
        }
        console.log(rules);
        return rules;
    }

    loadDirectory(path = this.root_path, recursive = false, isRefresh = false, isMover = false) {

        if (path === this.root_path && recursive && isRefresh) {
            //Full refresh, clear directory root
            this.directory_root = null;
        } else if (isRefresh) {
            this.clearDirectory(path, recursive);
        }

        // Get Structure
        return this.loadStructure(path, recursive).then(() => {
            return new Promise((resolve, reject) => {
                try {
                    //Get the root directory
                    let dir = this.getDirectory(path, isMover);
                    let result = { success: true, data: dir };
                    resolve(result);
                } catch (e) {
                    reject(e);
                }
            });
        });
    }

    shouldRenderButton(buttonName, path) {
        let shouldRender = false;
        if (!this.workflowRules.has('button_show')) {
            return shouldRender;
        }
        const paths = this.workflowRules.get('button_show')
        .filter(aRule => aRule.object_name === buttonName)
        .reduce((accumulator, currVal) => {
            return accumulator.concat(currVal.path_constructor);
        }, []);
        
        paths.forEach(aPath => {
            if(path === aPath) {
                shouldRender = true;
            }
        });

        return shouldRender;
    }

    loadStructure(path = this.root_path, recursive = false) {
        if (this.isRestricted) {
            let promises = [];
            let paths = this.workflowRules.has('folder_restriction') ? this.getRulesByType('folder_restriction') : [];
            for (let index = 0; index < paths.length; index++) {
                const aPath = paths[index];
                if (aPath.includes(path)) {
                    //Navigating into a restricted directory, only load folders which are not restricted
                    promises.push(this.pollJob({
                        actionFn: listDirectory,
                        args: { recordId: this.recordId, path: aPath, recursive: false, cursor: null },
                        validate: this.listDirectoryValidate,
                        interval: null,
                        maxAttempts: 30
                    }));
                }
            }
            return Promise.allSettled(promises);
        } else {
            this.deleteButtonShow = this.shouldRenderButton('delete', this.getRelativePath(path));
            return this.pollJob({
                actionFn: listDirectory,
                args: { recordId: this.recordId, path: path, recursive: recursive, cursor: null },
                validate: this.listDirectoryValidate,
                interval: null,
                maxAttempts: 30
            });
        }
    }

    buildFileStructure(file_structure) {
        if (!this.directory_root) {
            this.directory_root = new CloudStorageNode('', 'folder', '', false, '_root_', "Folder", 0, true, this.root_path, this.getRelativePath(this.root_path));
        }
        if (file_structure) {
            file_structure.entries.forEach(entry => {
               this.insertNode(entry, true);
            });
        }
    }

    clearDirectory(path, recursive) {
        if (path && path != "") {
            let node = this.directory_root;
            let relative_path = this.getRelativePath(path);
            if (!relative_path) {
                // Directory is above the root path
                return directory;
            }
            let path_parts = relative_path.split("/");
            path_parts.shift();
            if (path_parts.length >= 1 && path_parts[0] != "") {
                // Get nested directory
                let curr_path = '';
                do {
                    let curr_name = path_parts.shift();
                    curr_path = node.path + '/' + curr_name.toLowerCase();
                    node = node.children.get(curr_path);
                } while (path_parts.length > 0);
            }

            //Clear Directory
            if (node && node.path === path) {
                if (recursive) {
                    node.children = new Map();
                    node.files = new Map();
                } else {
                    node.files = new Map();
                }
            }
        }
    }

    insertNode(entry, force = false) {
        if (this.directory_root && entry) {
            let parent_node = null;
            let relative_path = this.getRelativePath(entry.path);
            let relative_display_path = this.getRelativePath(entry.display_path);
            if (!relative_path || relative_path === "/") {
                // Item is above the root path of the current directory or is the root node
                return;
            }
            let path_parts = relative_path.split("/");
            path_parts.shift(); //remove first empty string from split call
            let display_path_parts = relative_display_path.split("/");
            display_path_parts.shift();
            if (path_parts.length == 1) {
                // Entry goes in the root directory
                parent_node = this.directory_root;
            } else {
                //Entry is nested below root directory
                parent_node = this.directory_root;
                let curr_path = '';
                let display_path = '';
                do {
                    //Process directory
                    let curr_name = path_parts.shift();
                    let display_name = display_path_parts.shift();
                    curr_path = parent_node.path + '/' + curr_name.toLowerCase();
                    display_path = parent_node.display_path === '/' ?
                        parent_node.display_path + display_name :
                        parent_node.display_path + '/' + display_name;
                    let dir = parent_node.children.get(curr_path);
                    if (!dir) {
                        //Entry does not exist create it
                        let new_item = new CloudStorageNode('', 'folder', '', false, display_name, "Folder", 0, false, curr_path, display_path);
                        parent_node.children.set(curr_path, new_item);
                        parent_node = new_item;
                    } else {
                        parent_node = dir;
                    }
                } while (path_parts.length > 1);
            }

            if (parent_node) {
                if (entry.node_type === 'file') {
                    //Check if File already exists
                    let file = parent_node.files.get(entry.path.toLowerCase());
                    if (file && !force) {
                        //File already exists, update it
                        file.url = file.url ? file.url : entry.url;
                        file.downloadable = entry.downloadable;
                        file.name = file.name ? file.name : entry.name;
                        file.display_name = file.display_name ? file.display_name : entry.display_name;
                        file.read_only = entry.read_only;
                        file.display_path = file.display_path ? file.display_path : entry.display_path;
                    } else {
                        // Add entry to parent file array
                        let node = new CloudStorageNode(entry.id, entry.node_type, entry.url, entry.downloadable, entry.name, this.getExtension(entry.file_type), entry.size, entry.read_only, entry.path, this.getRelativePath(entry.display_path));
                        if (entry.last_modified) {
                            node.setLastModified(entry.last_modified);
                        }
                        parent_node.files.set(entry.path, node);
                    }
                } else {
                    //check if directory already exists
                    let dir = parent_node.children.get(entry.path.toLowerCase());
                    if (dir && !force) {
                        //Entry child already created, update it
                        dir.url = dir.url ? dir.url : entry.url;
                        dir.downloadable = entry.downloadable;
                        dir.name = dir.name ? dir.name : entry.name;
                        dir.display_name = dir.display_name ? dir.display_name : entry.display_name;
                        dir.read_only = entry.read_only;
                        dir.display_path = dir.display_path ? dir.display_path : entry.display_path;
                    } else {
                        //Entry does not exist, create it
                        parent_node.children.set(entry.path.toLowerCase(), new CloudStorageNode(entry.id, entry.node_type, entry.url, entry.downloadable, entry.name, "Folder", entry.size, entry.read_only, entry.path, this.getRelativePath(entry.display_path)));
                    }
                }
                return true;
            }
        }
        return false;
    }



    getDirectory(path, isMover = false) {
        let directory = [];
        path = path ? path : this.curr_node.path;
        this.deleteButtonShow = this.shouldRenderButton('delete', this.getRelativePath(path));
        //Build folder exlusion list from workflow rules
        let exclusions = this.getRulesByType('folder_exclusion');
        if (isMover) {
            this.mover_bread_crumbs.splice(1);
        } else {
            this.bread_crumbs.splice(1);
        }
        if (path) {
            let node = this.directory_root;
            let relative_path = this.getRelativePath(path);
            if (!relative_path) {
                // Directory is above the root path
                return directory;
            }
            let path_parts = relative_path.split("/");
            path_parts.shift();
            if (path_parts.length >= 1 && path_parts[0] != "") {
                // Get nested directory
                let curr_path = '';
                do {
                    let curr_name = path_parts.shift();
                    curr_path = node.path + '/' + curr_name.toLowerCase();
                    node = node.children.get(curr_path);
                    //Add node as bread crumb
                    this.addBreadCrumb(node, isMover);
                } while (path_parts.length > 0);
            }

            //Get items from directory
            if (node) {
                //Set the current node only if not navigating via the mover modal
                this.curr_node = isMover ? this.curr_node : node;
                //Process Folders in the node
                for (let [path, dir] of node.children) {
                    if (!exclusions.includes(path.toLowerCase())) {
                        directory.push(dir);
                    }
                }
                if (!isMover) {
                    //Process Files in the node
                    for (let [path, file] of node.files) {
                        if (!exclusions.includes(path.toLowerCase())) {
                            let item = file;
                            delete item.children;
                            delete item.files;
                            directory.push(item);
                        }
                    }
                }
            }
        }
        return directory;
    }

    getItem(path, isFile = true) {
        let item = null;
        if (path) {
            let node = this.directory_root;
            let relative_path = this.getRelativePath(path);
            if (!relative_path || relative_path === "/") {
                // Item is above the root path of the current directory or is the root node
                console.error(`Attempting to access Item that is above the root path: ${path}`);
                return null;
            }
            let path_parts = relative_path.split("/");
            path_parts.shift();
            if (path_parts.length > 1) {
                // Find Item Parent
                let curr_path = '';
                do {
                    let curr_name = path_parts.shift();
                    curr_path = node.path + '/' + curr_name.toLowerCase();
                    node = node.children.get(curr_path);
                } while (path_parts.length > 1);
            }

            if (node) {
                // Get Item
                item = isFile ? node.files.get(path) : node.children.get(path);
            }
        }

        return item;
    }

    openItem(path) {
        return new Promise((resolve, reject) => {
            if (!path) {
                let error = 'Failed to open item, a path is required.';
                console.error(error);
                reject(error);
            }
            //Check if item is downloadable
            let item = this.getItem(path);
            if (!item || (item && !item.downloadable)) {
                resolve({ success: false, error: "Item is not downloadable." });
            }

            //Get Item Link
            return getLink(this.recordId, path).then((response) => {
                let result = { success: true };
                if (response && response.error) {
                    console.error(`An error occurred on getLink callout: ${JSON.stringify(response.error)}`);
                    result.success = false;
                    result.error = response.error;
                    reject(result);
                } else if (response && response.url && response.url !== "") {
                    result.data = response.url;
                    resolve(result);
                } else {
                    let error = `Failed to open the item. Please try again or contact support.`;
                    result.success = false;
                    result.error = error;
                    console.error(error);
                    reject(result);
                }
            }).catch((e) => {
                console.error(`An exception occurred opening the item: ${JSON.stringify(e)}`);
                reject({ success: false, error: e });
            })
        });
    }

    moveItems(to_path, items) {
        if (!to_path || !items || items.length == 0) {
            console.error("Item move requires a path and 1 or more items.");
            return new Promise(resolve, reject => { reject() });
        }
        //Move Items
        let paths = {
            moves: []
        };
        items.forEach(aItem => {
            paths.moves.push({
                src: aItem.path,
                dest: `${to_path}/${aItem.name.toLowerCase()}`
            });
        });

        return this.pollJob({
            actionFn: moveItemsCallout,
            args: { recordId: this.recordId, paths: paths, jobId: null },
            validate: this.moveItemsValidate,
            interval: this.getWaitTime(paths.moves.length),
            maxAttempts: 30
        });
    }

    createDirectory(paths) {
        if (!paths || paths.length == 0) {
            console.error(`One or more items must be passed to createDirectory().`);
            return new Promise(resolve, reject => { reject() });
        }

        //Create the Directories
        return this.pollJob({
            actionFn: createItems,
            args: { recordId: this.recordId, paths: paths, data: null, type: null, jobId: null },
            validate: this.createDirectoryValidate,
            interval: 500,
            maxAttempts: 20
        });
    }


    uploadItems(items, workflowLabel = null) {
        if (!items || items.length == 0) {
            console.error(`One or more items must be passed to uploadItems().`);
            return new Promise(resolve, reject => { reject() });
        }

        //Clear upload statuses
        this.uploadStatuses = {};
        this.uploadComplete = false;

        //Start chunk upload for all items
        for (let index = 0; index < items.length; index++) {
            const item = items[index];
            // Uploader object
            let uploader = new ChunkedItemUploader(this.recordId, item, workflowLabel);
            // Completion handler
            uploader.onComplete((result) => {
                this.chunkUploaderCompleteHandler.call(this, result);
            });
            // Error handler
            uploader.onError((error) => {
                this.chunkUploaderErrorHandler.call(this, error);
            });
            // Add item for status tracking
            this.uploadStatuses[item.path.toLowerCase()] = 'uploading';
            // Start the upload
            uploader.start();
        }

        const executeUploadPoll = (resolve, reject) => {
            try {
                let batchComplete = true;
                //Check the item upload statuses
                for (var path in this.uploadStatuses) {
                    if (this.uploadStatuses[path] === 'uploading') {
                        // Contine polling
                        batchComplete = false;
                        break;
                    }
                }
                if (this.uploadComplete) {
                    return;
                } else if (batchComplete) {
                    //Item uploads complete
                    this.uploadComplete = true;
                    let errorItems = Object.keys(this.uploadStatuses)
                        .reduce((accumulator, key) => {
                            if (this.uploadStatuses[key] === 'error') {
                                accumulator.push(this.getItemName(key));
                            }
                            return accumulator;
                        }, []);
                    let message = errorItems.length === 0 ? null : `The following items failed to upload: ${errorItems.join()}`;
                    return resolve({ success: errorItems.length === 0, message: message });
                } else {
                    return setTimeout(executeUploadPoll, 3000, resolve, reject);
                }
            } catch (e) {
                console.error(`An error has occurred while polling for item upload completion. Error: ${JSON.stringify(e)}`);
                return reject(e);
            }
        };


        //Start polling for completion
        return new Promise((resolve, reject) => {
            try {
                return executeUploadPoll.call(this, resolve, reject);
            } catch (e) {
                console.error(e);
                reject(e);
            }
        });
    }

    chunkUploaderCompleteHandler(result) {
        try {
            //Check for error
            if (result.error_code) {
                throw (new Error(`Error Code: ${result.error_code}, Error Message: ${result.error_message}, Status Code: ${result.status_code}`));
            }
            // Update the status
            this.uploadStatuses[result.path] = 'complete';
            //Success, create item
            let newItem = new CloudStorageNode('', 'file', '', true, result.name, this.getExtension(result.file_type), 0, false, result.path, result.display_path);
            this.insertNode(newItem);
        } catch (e) {
            this.uploadStatuses[result.path] = 'error';
            console.error(`An error has occurred on handling item upload completion. Error: ${e.message}`);
        }
    }

    chunkUploaderErrorHandler(error) {
        this.uploadStatuses[error] = 'error';
    }

    executeWorkflow(workflowName, event) {
        // const path = this.getCurrPath();// MJ
        const path = this.root_path;
        return new Promise((resolve, reject) => {
            if (!workflowName || workflowName === '') {
                console.error('Worklow name is required to execute a worflow.');
                reject();
            }
            //Get workflow rule
            const workflowRule = this.displayableWorkflows.get(workflowName);

            if (workflowName === 'create_annual_folder') {
                if (!event.detail || !event.detail.directory_name) {
                    console.error('Create Year Folder workflow requires a directory name.');
                    reject(new Error('VALIDATION_FAIL'));
                }
                //Run rules check
                let pass = this.runWorkflowRule(workflowName, event.detail);
                if (!pass) {
                    reject(new Error('VALIDATION_FAIL'));
                    return;
                }
                const paths = [this.getCurrPath() + `/${event.detail.directory_name}`];
                return this.createDirectory(paths).then((result) => {
                    if (result.success) {
                        result.message = 'Created Annual Folder Successfully';
                        resolve(result);
                    } else {
                        reject();
                    }
                }).catch((e) => {
                    console.error(e);
                    reject(e);
                });
            } else if (workflowName === 'Reconciled_Accounting') {
                (async () => {
                    try {
                        //Check if the Annual Folder exists
                        const absolutePath = this.getAbsolutePath(workflowRule.path_constructor) + '/' + new Date().getFullYear();
                        const listResult = await listDirectory({ recordId: this.recordId, path: absolutePath, recursive: false, cursor: null });
                        if (!listResult.entries) {
                            //Annual Folder does not exist, create it
                        }
                        //Upload the Files
                        event.detail.files.map((fileObject) => {
                            fileObject.path = absolutePath + '/' + fileObject.file.name;
                            fileObject.file.path = fileObject.path;
                        });
                        const uploadResult = await this.uploadItems(event.detail.files, workflowRule.label);
                        if (uploadResult.success) {
                            resolve(uploadResult);
                        } else {
                            reject();
                        }
                    } catch (e) {
                        console.error(e);
                        reject();
                    }
                })();
            } else if(workflowName === 'Create_Homeowner_Address_Folder'){
                if (!event.detail || !event.detail.directory_name) {
                    reject(new Error('VALIDATION_FAIL'));
                }
                //Run rules check --- MJ: this check does nothing
                let pass = this.runWorkflowRule(workflowName, event.detail);
                if (!pass) {
                    reject(new Error('VALIDATION_FAIL'));
                    return;
                }
                const newPath = this.getAbsolutePath(workflowRule.path_constructor) + `/${event.detail.directory_name}`;
                const paths = [newPath];

                return this.createDirectory(paths).then((result) => {
                    if (result.success) {
                        result.message = 'Created Address Folder Successfully';
                        resolve(result);
                    } else {
                        reject();
                    }
                }).catch((e) => {
                    console.error(e);
                    reject(e);
                });
            }
            else {
                reject(new Error('UNKNOWN_WORKFLOW'));
            }

        });
    }

    runWorkflowRule(workflowName, metadata) {
        if (workflowName === 'create_annual_folder') {
            return /^\d{4}$/.test(metadata.directory_name);
        }
        if (workflowName === 'Create_Homeowner_Address_Folder') {
            //MJ - added 
            return true;
        }
        return false;
    }

    getMetaData(item_path) {
        return new Promise((resolve, reject) => {
            if (!item_path || item_path === "") {
                console.error("Get Metadata callout requires a path.");
                reject();
            }
            // Get the Item Metadata
            return getMetadataCallout({ recordId: this.recordId, path: item_path }).then(result => {
                if (result) {
                    this.insertNode(result, true);
                    let item = this.getItem(item_path, result.node_type !== 'folder');
                    resolve({
                        success: true,
                        data: item
                    });
                } else {
                    console.error(`An unknown error has occurred getting item metadata. Response: ${JSON.stringify(response)}`);
                    reject();
                }
            }).catch(e => {
                console.error(`An error has occurred getting item metadata: ${JSON.stringify(e)}`);
                reject();
            });
        });
    }

    readFile(fileBlob) {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.onerror = reject;
            reader.onload = () => {
                resolve(reader.result.split(',')[1]);
            }
            reader.readAsDataURL(fileBlob);
        });
    }

    deleteItems(items) {
        if (!items || items.length === 0) {
            console.error("Delete requires one or more items to be passed.");
            return new Promise(resolve, reject => { reject() });
        }
        //Delete items
        let item_paths = [];
        items.forEach(aItem => {
            item_paths.push(aItem.path);
        });

        return this.pollJob({
            actionFn: deleteItemsCallout,
            args: { recordId: this.recordId, items: item_paths, jobId: null },
            validate: this.deleteItemsValidate,
            interval: 1000,
            maxAttempts: 10
        });
    }

    search(searchTerm) {
        return new Promise((resolve, reject) => {
            if (!searchTerm || searchTerm === "") {
                reject();
            }
            //clear old search results
            this.searchResults = [];

            if (this.isRestricted) {
                let promises = [];
                let paths = this.workflowRules.has('folder_restriction') ? this.getRulesByType('folder_restriction') : [];
                for (let index = 0; index < paths.length; index++) {
                    const aPath = paths[index];
                    promises.push(this.pollJob({
                        actionFn: searchCallout,
                        args: { recordId: this.recordId, searchTerm: searchTerm, path: aPath, cursor: null },
                        validate: this.searchItemsValidate,
                        interval: null,
                        maxAttempts: 30
                    }));
                }
                Promise.allSettled(promises).then((result) => {
                    resolve({
                        success: true,
                        data: this.searchResults
                    });
                }).catch((e) => {
                    reject(e);
                });
            } else {
                // Poll for Search results
                this.pollJob({
                    actionFn: searchCallout,
                    args: { recordId: this.recordId, searchTerm: searchTerm, path: this.root_path, cursor: null },
                    validate: this.searchItemsValidate,
                    interval: null,
                    maxAttempts: 30
                }).then((result) => {
                    resolve({
                        success: true,
                        data: this.searchResults
                    });
                }).catch((e) => {
                    if (e !== 'MAX_ATTEMPTS') {
                        console.debug(`An error has occurred serching for items: ${JSON.stringify(e)}`);
                    }
                    reject(e);
                });
            }
        });
    }

    initDropboxAccount() {
        return new Promise((resolve, reject) => {
            // Poll for Init Dropbox
            this.pollJob({
                actionFn: initializeDropboxCallout,
                args: { recordId: this.recordId, path: this.root_display_path },
                validate: this.initDropboxValidate,
                interval: 500,
                maxAttempts: 10
            }).then((result) => {
                //Refresh the directory
                this.loadDirectory().then((response) => {
                    resolve(response);
                }).catch((err) => {
                    console.debug(`An error has occurred refreshing after init: ${JSON.stringify(err)}`);
                    reject(err);
                });
            }).catch((e) => {
                if (e.message === 'MAX_ATTEMPTS') {
                    //Let's assume it was successful and refresh the directory
                    //Refresh the directory
                    return this.loadDirectory().then((response) => {
                        resolve(response);
                    }).catch((err) => {
                        console.debug(`An error has occurred refreshing after init polling timed out: ${JSON.stringify(err)}`);
                        reject(err);
                    });
                } else {
                    reject(e);
                }
            });
        });
    }

    getRelativePath(path) {
        if (path.length < this.root_path.length) {
            console.log('path.length: '+path.length);
            console.log('path: '+path);
            console.log('this.root_path '+this.root_path);
            console.log('this.root_path.lengt: '+this.root_path.length);

            // Path is for an item that does not belong in the manager
            return null;
        } else if (path.length === this.root_path.length) {
            // Relative path is the root
            return "/";
        } else {
            return path.slice(this.root_path.length);
        }
    }

    getAbsolutePath(path) {
        return this.root_path + path;
    }

    getItemPath(item) {
        let path_parts = item.path.split("/");
        path_parts.pop();
        let path_to_display = path_parts.join("/");
        return path_to_display === "" ? "/" : path_to_display;
    }

    getItemName(item) {
        let name = item.path ? item.path : item;
        let path_parts = name.split("/");
        return path_parts.length > 0 ? path_parts.pop() : null;
    }

    getBreadCrumbs() {
        return this.bread_crumbs;
    }

    getMoverBreadCrumbs() {
        return this.mover_bread_crumbs;
    }

    addBreadCrumb(node, isMover = false) {
        if (isMover) {
            this.mover_bread_crumbs.push({
                key: this.mover_bread_crumbs.length + 1,
                label: node.name,
                path: node.path
            });
        } else {
            this.bread_crumbs.push({
                key: this.bread_crumbs.length + 1,
                label: node.name,
                path: node.path
            });
        }
    }

    getCurrPath() {
        return this.curr_node ? this.curr_node.path : null;
    }

    getExtension(source) {
        if (!source) {
            return "";
        }
        if (source.includes(":")) {
            let parts = source.split(":");
            return parts.length > 1 ? parts[1].toUpperCase() : "";
        } else if (source.includes(".")) {
            let parts = source.split(".");
            return parts.length > 1 ? parts.pop().toUpperCase() : "";
        } else {
            return "";
        }
    }

    listDirectoryValidate(response, args) {
        //Handle the reponse
        try {
            if (response && response.entries) {
                //Set the cursor for the next callout
                args.cursor = response.cursor;
                //Process the new entries
                this.buildFileStructure(response);
                if (!this.curr_node) {
                    //Set the curr_node
                    this.curr_node = this.directory_root;
                }
                //Return the args or null if polling is complete
                return response.has_more ? args : null;
            } else {
                //Somehting went wrong
                throw new Error(`Something went wrong on list directory callout. Response is: ${JSON.stringify(response)}`);
            }
        } catch (e) {
            //Error has occurred  
            throw e;
        }
    }

    createDirectoryValidate(response, args) {
        //Handle the reponse
        try {
            if (response && response.success) {
                if (response.status === 'complete') {
                    //create Directory
                    let name = this.getItemName(args.paths[0]);
                    let display_path = this.curr_node.display_path === '/' ? this.root_display_path + this.curr_node.display_path + name : this.root_display_path + this.curr_node.display_path + '/' + name;
                    let newItem = new CloudStorageNode('', 'folder', '', true, name, 'Folder', 0, false, args.paths[0], display_path);
                    this.insertNode(newItem);
                    //Success
                    return null;
                }
                //Set the cursor for the next callout
                args.async_job_id = response.async_job_id;
                //Return the args or null if polling is complete
                return args;
            } else {
                //Somehting went wrong
                throw new Error(`Something went wrong on create Directory callout. Response is: ${JSON.stringify(response)}`);
            }
        } catch (e) {
            //Error has occurred
            throw e;
        }
    }

    createItemsValidate(response, args) {
        //Handle the reponse
        try {
            if (response && response.success) {
                if (response.status === 'complete') {
                    //create item
                    let name = this.getItemName(args.paths[0]);
                    let display_path = `${this.curr_node.display_path}/${name}`;
                    let newItem = new CloudStorageNode('', 'file', '', true, name, this.getExtension(name), 0, false, args.paths[0], display_path);
                    this.insertNode(newItem);
                    //Success
                    return null;
                }
                //Set the cursor for the next callout
                args.async_job_id = response.async_job_id;
                //Return the args or null if polling is complete
                return args;
            } else {
                //Somehting went wrong
                throw new Error(`Something went wrong on create items callout. Response is: ${JSON.stringify(response)}`);
            }
        } catch (e) {
            //Error has occurred  
            throw e;
        }
    }

    deleteItemsValidate(response, args) {
        //Handle the reponse
        try {
            if (response && response.success) {
                if (response.status === 'complete') {
                    //Successful delete, remove items from directory
                    args.items.forEach(aPath => {
                        if (this.curr_node.files && this.curr_node.files.has(aPath)) {
                            this.curr_node.files.delete(aPath);
                        } else if (this.curr_node.children && this.curr_node.children.has(aPath)) {
                            this.curr_node.children.delete(aPath);
                        }
                    });
                    return null;
                }
                //Set the cursor for the next callout
                args.async_job_id = response.async_job_id;
                //Return the args or null if polling is complete
                return args;
            } else {
                //Somehting went wrong
                throw new Error(`Something went wrong on delete items callout. Response is: ${JSON.stringify(response)}`);
            }
        } catch (e) {
            //Error has occurred  
            throw e;
        }
    }

    moveItemsValidate(response, args) {
        //Handle the reponse
        try {
            if (response && response.success) {
                if (response.status === 'complete') {
                    //Successful move, update structure
                    let item_to_move = null;
                    args.paths.forEach(aPath => {
                        //Get the item
                        if (this.curr_node.files && this.curr_node.files.has(aPath.source)) {
                            //Item is a file
                            item_to_move = this.curr_node.files.get(aPath.source);
                            //Update the path
                            item_to_move.path = aPath.destination;
                            item_to_move.display_path = aPath.destination;
                            //Delete file from current node
                            this.curr_node.files.delete(aPath.source);
                        } else if (this.curr_node.children && this.curr_node.children.has(aPath.source)) {
                            //Item is a directory
                            item_to_move = this.curr_node.children.get(aPath.source);
                            //Update the path
                            item_to_move.path = aPath.destination;
                            item_to_move.display_path = aPath.destination;
                            //Delete directory from current node
                            this.curr_node.children.delete(aPath.source);
                        }
                        //Move the item
                        this.insertNode(item_to_move);
                    });
                    return null;
                }
                //Set the cursor for the next callout
                args.async_job_id = response.async_job_id;
                //Return the args or null if polling is complete
                return args;
            } else {
                //Something went wrong
                throw new Error(`Something went wrong on move items callout. Response is: ${JSON.stringify(response)}`);
            }
        } catch (e) {
            //Error has occurred  
            throw e;
        }
    }

    modifyItemsValidate(response, args) {
        //Handle the reponse
        try {
            if (response && response.success) {
                if (response.status === 'complete') {
                    //Successful update, update structure
                    let newItem = null;
                    if (this.curr_node.files && this.curr_node.files.has(args.items.moves[0].src)) {
                        newItem = this.curr_node.files.get(args.items.moves[0].src)
                        this.curr_node.files.delete(args.items.moves[0].src);
                    } else if (this.curr_node.children && this.curr_node.children.has(args.items.moves[0].src)) {
                        newItem = this.curr_node.children.get(args.items.moves[0].src)
                        this.curr_node.children.delete(args.items.moves[0].src);
                    }
                    newItem.display_path = args.items.moves[0].dest;
                    newItem.path = args.items.moves[0].dest.toLowerCase();
                    var n = newItem.display_path.lastIndexOf('/');
                    var tempString = newItem.display_path.substring(n + 1);
                    newItem.display_name = tempString.substring(0, tempString.lastIndexOf('.'));

                    newItem.name = newItem.display_name.toLowerCase();
                    this.insertNode(newItem);
                    return null;
                }
                //Set the cursor for the next callout
                args.jobId = response.async_job_id;
                //Return the args or null if polling is complete
                return args;
            } else {
                //Somehting went wrong
                throw new Error(`Something went wrong on modify items callout. Response is: ${JSON.stringify(response)}`);
            }
        } catch (e) {
            //Error has occurred  
            throw e;
        }
    }

    searchItemsValidate(response, args) {
        //Handle the reponse
        try {
            if (response && response.entries) {
                //Set the cursor for the next callout
                args.cursor = response.cursor;
                //Update the exisitng entries with the results
                this.buildFileStructure(response);
                //Add items to the search results
                this.searchResults = this.searchResults.concat(response.entries.map(entry => {
                    var newEntry = Object.assign({}, entry);
                    newEntry.display_path = this.getRelativePath(entry.display_path);
                    return newEntry;
                }));
                //Return the args or null if polling is complete
                return response.has_more ? args : null;
            } else {
                //Something went wrong
                throw new Error(`Something went wrong on list directory callout. Response is: ${JSON.stringify(response)}`);
            }
        } catch (e) {
            //Error has occurred  
            throw e;
        }
    }

    initDropboxValidate(response, args) {
        //Handle the reponse
        try {
            if (response && response.success) {
                if (response.status === 'complete') {
                    //Successful initialization
                    return null;
                }
                //Set the cursor for the next callout
                args.async_job_id = response.async_job_id;
                //Return the args or null if polling is complete
                return args;
            } else {
                //Somehting went wrong
                throw new Error(`Something went wrong on init dropbox callout. Response is: ${JSON.stringify(response)}`);
            }
        } catch (e) {
            //Error has occurred  
            throw e;
        }
    }

    pollJob({ actionFn, args, validate, interval, maxAttempts }) {
        let attempts = 0;
        interval = interval ? interval : 0;

        const executePoll = async (resolve, reject) => {
            try {
                console.debug(`Callout ${attempts + 1} for ${actionFn.name}`);
                //Execute teh callout function
                const result = await actionFn(args);
                console.debug(`Result: ${JSON.stringify(result)}`);
                attempts++;

                //Validate the Response
                let validation = validate.call(this, result, args);
                if (!validation) {
                    //Validation is null, whcih means success
                    return resolve({ success: true });
                } else if (maxAttempts && attempts === maxAttempts) {
                    //Reached max attempts
                    return reject(new Error("MAX_ATTEMPTS"));
                } else {
                    //Args object returned, still need to poll
                    args = validation;
                    setTimeout(executePoll, interval, resolve, reject);
                }
            } catch (e) {
                console.error(`An error has occurred for attempt ${attempts} for callout: ${actionFn.name}. Error: ${JSON.stringify(e)}`);
                return reject(e);
            }
        };

        return new Promise((resolve, reject) => {
            try {
                return executePoll.call(this, resolve, reject);
            } catch (e) {
                console.error(e);
                reject(e);
            }
        });
    }

    getWaitTime(item_count) {
        return item_count / 10 * 1000;
    }

    updateItem(newItem, oldItem) {
        return new Promise((resolve, reject) => {
            if (!newItem || !oldItem) {
                let message = "Both the new and old item must be passed to the directory manager.";
                console.error(message);
                reject(message);
            }

            //Update the item
            let paths = {
                moves: [{
                    src: oldItem.path,
                    dest: `${this.curr_node.path}/${newItem.name}` 
                }]
            };

            this.pollJob({
                actionFn: modifyItemsCallout,
                args: { recordId: this.recordId, items: paths, jobId: null },
                validate: this.modifyItemsValidate,
                interval: 3000,
                maxAttempts: 20
            }).then(result => {
                if (result.success) {
                    return this.loadDirectory(this.curr_node.path, false, true, false);
                } else {
                    if (e !== 'MAX_ATTEMPTS') {
                        console.error(`Failed to successfully complete modify items callout. Response: ${JSON.stringify(response)}`);
                    }
                    reject();
                }
                }).then((result) => {
                //Handle success from loadDirectory
                resolve(result);
            }).catch(e => {
                console.error(`Failed to successfully complete modify items callout. Error: ${JSON.stringify(e)}`);
                reject(e);
            });
        });
    }
}

export { DropboxDirectoryManager }