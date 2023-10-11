/*
    Dropbox Manager javascript class.
    
    The core Javascript class for the Dropbox
    ManagerLightning Web Component

    createdBy: ddurbin - 01/25/2021
*/

import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { DropboxDirectoryManager } from './DropboxDirectoryManager.js';
const MAX_UPLOAD_SIZE = 20000000; // Max file size in MB


export default class DropboxManager extends LightningElement {

  hasRendered = false;
  @api recordId; // The record ID that this LWC is being rendered on
  @track data = []; // The items in the current directory (files or folders)
  @track moverData = []; // The folders in the current mover directory
  @track pathParts; // The breadcrumb objects for the main directory
  @track moverParts; // The breadcrumb objects for the mover directory
  @track selectedRows; // The currently selected rows
  @track isLoading = false;
  @track isMoverLoading = false;
  @track initialized = true;
  isAdmin; // Boolean to determine admin privelages
  isReadOnly = true; // Boolean to determine if the component should be read only
  directory_manager; //The data structure root node representing the file structure. See utils.js for details

  //Button Visibility
  isUploadDisabled = true;
  isMoveDisabled = true;
  isDeleteDisabled = true;
  isWorkflowDisabled = true;
  isSearchDisabled = true;

  //Workflows
  @track workflows;
  showWorkflow = false;
  workflowType = '';
  workflowSelected = 'null';

  //search
  isSearching = false;
  searchParts = [{
    key: 1,
    label: 'Search Results',
    path: null
  }];
  searchText;

  //Modals
  uploadedFiles;
  showFileUploader = false;
  showItemViewer = false;
  showConfirm = false;
  showDirectoryCreator = false;
  showHomeOwnerCreator = false;
  confirmMessage;
  confirmAction;
  itemViewing; // Item that is selected for modification on row actions
  originalItem; // Cached item for rollback of update failure
  isFolder; // Boolean for whether current item viewing is a folder or not
  showMover = false;
  toPath; // The path for moving items to
  message = "";

  //Sorting
  sortedBy = 'name';
  defaultSortDirection = 'asc';
  sortDirection = 'asc';

  //Main Datatable columns
  columns = [
    { type: 'action', typeAttributes: { rowActions: this.getRowActions } },
    { label: "Item Name", fieldName: "name", type: "itemNavigation", initialWidth: 500, sortable: true, wrapText: true, typeAttributes: { label: { fieldName: 'name' }, path: { fieldName: "path" }, type: { fieldName: "node_type" } } },
    { label: "Type", type: "text", fieldName: "node_type", sortable: true, fixedWidth: 100 },
    { label: "Path", type: "text", initialWidth: 1200, fieldName: "display_path", wrapText: true }
  ];

  //Mover Datatable columns
  moverColumns = [
    { label: "Item Name", fieldName: "name", type: "itemNavigation", typeAttributes: { label: { fieldName: 'name' }, path: { fieldName: "path" }, type: { fieldName: "node_type" } } },
    { label: "Type", fieldName: "node_type" }
  ]

  // LWC Constructor lifecycle method
  constructor() {
    super();
    this.uploadedFiles = [];
    this.selectedRows = [];
    this.workflows = [];
    this.isFolder = false;
  }

  // LWC Connected callback lifecyle method
  connectedCallback() {
    this.isLoading = true;
    this.directory_manager = new DropboxDirectoryManager(this.recordId);
    this.directory_manager.initDirectoryManager().then((result) => {
      if (result.success) {
        //Success
        this.loadData(result.data);
        this.workflows = this.directory_manager.getWorkflowOptions();
        this.buildBreadCrumbs();
      } else {
        this.message = "An unknown error has occurred. Please refresh the Manager";
        this.renderModal('error');
      }
      this.isLoading = false;
      this.initialized = this.directory_manager.isInitialized;
      this.isAdmin = this.directory_manager.isAdmin;
      this.isReadOnly = this.directory_manager.isReadOnly;
      this.buttonRenderUpdate('upload', true);
      this.buttonRenderUpdate('move');
      this.buttonRenderUpdate('delete');
      this.buttonRenderUpdate('workflow');
      this.buttonRenderUpdate('search');
    }).catch((e) => {
      console.debug(e);
      //An error occurred
      this.isLoading = false;
      this.message = "An unknown error has occurred. Please refresh the Manager";
      this.renderModal('error');
      this.initialized = this.directory_manager.isInitialized;
      this.isAdmin = false;
    });
  }

  renderedCallback() {
    if (!this.hasRendered) {

    }
  }

  getRowActions(row, doneCallback) {
    const actions = [];
    if (row['node_type'] === 'file' || row['node_type'] === 'folder') {
      //Define the file row actions here
      actions.push(
        { label: "Details", name: "view" }
      );
    } else if (row['node_type'] === 'folder') {
      //Define the folder row actions here

    }
    doneCallback(actions);
  }

  buttonRenderUpdate(button, additionalOperand = false) {
    switch (button) {
      case 'upload':
        this.isUploadDisabled = this.isReadOnly || additionalOperand;
        break;
      case 'move':
        this.isMoveDisabled = this.isReadOnly || additionalOperand;
        break;
      case 'delete':
        this.isDeleteDisabled = this.isReadOnly || (!this.isAdmin && !this.directory_manager.deleteButtonShow) || additionalOperand;
        break;
      case 'workflow':
        this.isWorkflowDisabled = this.isReadOnly || additionalOperand;
        break;
      case 'search':
        this.isSearchDisabled = false || additionalOperand;
        break;
      default:
        break;
    }
  }

  loadData(data, isMover = false, sortFieldName = this.sortedBy, sortDirection = this.sortDirection) {
    //Sort the data
    let reverse = sortDirection === 'asc' ? 1 : -1;
    data.sort((a, b) => {
      let arg1 = a[sortFieldName];
      let arg2 = b[sortFieldName];
      return reverse * arg1.localeCompare(arg2);
    });

    if (isMover) {
      this.moverData = data;
    } else {
      this.data = data;
    }
  }

  //Event handler for items in the datatable
  handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;
    switch (action.name) {
      case "view":
        try {
          this.handleItemView(row.path);
        } catch (e) {
          console.error(`An error has occurred: ${JSON.stringify(e)}`);
        }
        break;
      default:
        break;
    }
  }

  handleItemView(path) {
    this.directory_manager.getMetaData(path).then(result => {
      if (result.success) {
        this.originalItem = result.data; //Exisitng un-modified Item
        this.itemViewing = Object.create(this.originalItem); //New Item to be modified
        this.isFolder = this.originalItem.node_type === 'folder';
        this.renderModal('view');
      } else {
        this.message = 'An unknown error has occurred getting item details. Please refresh and try again or contact support.';
        this.renderModal('error');
      }
    }).catch(e => {
      this.message = 'An unknown error has occurred getting item details. Please refresh and try again or contact support.';
      this.renderModal('error');
    });
  }

  handleRowClick(event) {
    this.selectedRows = event.detail.selectedRows;
  }

  handleItemClick(event) {
    let item_type = event.detail.node_type;
    let path = event.detail.path;
    if (item_type === 'folder') {
      this.isLoading = true;
      this.directory_manager.loadDirectory(path).then((result) => {
        if (result.success) {
          this.loadData(result.data);
          this.buildBreadCrumbs();
          this.buttonRenderUpdate('upload', path === this.directory_manager.root_path);
          this.buttonRenderUpdate('delete');
        } else {
          //Some error has occurred
          this.message = `An unknown error has occurred. Please refresh and try again or contact support.`;
          this.renderModal('error');
        }
        this.isLoading = false;
      }).catch((e) => {
        this.message = `An unknown error has occurred. Please refresh and try again or contact support.`;
        this.renderModal('error');
        this.isLoading = false;
      });
    } else if (item_type === 'file') {
      //Open the File
      this.directory_manager.openItem(path).then((result) => {
        if (result.success) {
          window.open(result.data, "_blank");
        } else {
          this.message = result.error;
          this.renderModal('errror');
        }
      }).catch((e) => {
        this.message = `An unknown error has occurred. Please refresh and try again or contact support.`;
        this.renderModal('error');
      });
    }
  }

  sortData(event) {
    const { fieldName, sortDirection } = event.detail;
    const sortedData = [...this.data];
    this.loadData(sortedData, false, fieldName, sortDirection);
    this.sortedBy = fieldName;
    this.sortDirection = sortDirection;
  }

  moverHandleItemClick(event) {
    let path = event.detail.path;
    //set move to path
    this.toPath = path;
    //Load the Directory
    this.directory_manager.loadDirectory(path, false, false, true).then((result) => {
      if (result.success) {
        this.loadData(result.data, true);
        //Build bread crumbs
        this.buildBreadCrumbs(true);
        this.buttonRenderUpdate('move', path === '/' || this.directory_manager.getCurrPath() === path);
      } else {
        this.message = `An unknown error has occurred. Please refresh and try again or contact support.`;
        this.renderModal('error');
      }
    }).catch((e) => {
      this.message = `An unknown error has occurred. Please refresh and try again or contact support.`;
      this.renderModal('error');
    });
  }

  navigate(event) {
    event.preventDefault();
    if (this.isSearching) {
      return;
    }
    let path = event.target.name; //path of the breadcrumb
    if (path === this.directory_manager.getCurrPath()) {
      return;
    }
    //reload new directory
    this.isLoading = true;
    this.loadData(this.directory_manager.getDirectory(path));
    this.buttonRenderUpdate('upload', path === this.directory_manager.root_path);
    this.buttonRenderUpdate('delete');
    //Build bread crumbs
    this.buildBreadCrumbs();
    this.isLoading = false;
  }

  moverNavigate(event) {
    event.preventDefault();
    let path = event.detail.path; //path of the breadcrumb
    //set move to path
    this.toPath = path;
    //reload new directory
    this.moverData = this.directory_manager.getDirectory(path, true);
    this.buildBreadCrumbs(true);
    this.isMoveDisabled = path === this.directory_manager.root_path || this.directory_manager.getCurrPath() === path ? true : false;
  }

  buildBreadCrumbs(isMover = false) {
    if (isMover) {
      this.moverParts = this.directory_manager.getMoverBreadCrumbs();
    } else {
      this.pathParts = this.directory_manager.getBreadCrumbs();
    }
  }

  addBreadCrumb(label, path) {
    this.pathParts = this.pathParts.concat([{
      key: this.pathParts.size + 1,
      label: label,
      path: path
    }]);
  }

  handleFileUpload(event) {
    //Build path of new item
    let newItems = [];
    let total_size = 0;
    for (let index = 0; index < event.detail.metadata.files.length; index++) {
      const aFile = event.detail.metadata.files[index];
      total_size += aFile.size;
      if (total_size > MAX_UPLOAD_SIZE) {
        this.message = `Please limit total file size to ${MAX_UPLOAD_SIZE / 1000000} MB. Larger upoads must be completed by an admin within Dropbox.`;
        this.uploadedFiles = [];
        this.renderModal('info');
        return;
      }
      let path = `${this.directory_manager.getCurrPath()}/${aFile.name}`;
      newItems.push({
        path: path,
        file: aFile
      });
    }
    this.uploadedFiles = newItems;
  }

  onUploadComplete(event) {
    this.renderModal('file_upload', false);
    if (this.uploadedFiles && this.uploadedFiles.length > 0) {
      if (this.running_workflow) {
        //Running File Upload as Workflow
        const data = {
          detail: {
            files: this.uploadedFiles
          }
        };
        this.handleWorkflowSubmit(data);
        return;
      }
      //Upload Files
      this.message = 'Uploading Item(s)...';
      this.renderModal('info');
      this.directory_manager.uploadItems(this.uploadedFiles).then(result => {
        if (!result.success) {
          //An error occurred
          this.message = result.message;
          this.renderModal('error');
        } else {
          //List the new directory
          this.loadData(this.directory_manager.getDirectory());
          this.message = 'Upload successful';
          this.renderModal('success');
        }
      }).catch(e => {
        if (e.message === 'MAX_ATTEMPTS') {
          this.message = "Please refresh the manager to see the latest changes.";
          this.renderModal('info');
        } else {
          console.log('LINE 395');
          this.message = "Something went wrong. Please refresh and try again or contact support.";
          this.renderModal('error');
        }
      });
    }
    this.uploadedFiles = [];
  }

  onViewSubmit(event) {
    this.renderModal('view', false);
    if (!this.hasItemBeenModified()) {
      //Item has not been modified
      return;
    }
    // Make Item Update
    this.message = "Renaming Item...";
    this.renderModal('info');
    this.directory_manager.updateItem(this.itemViewing, this.originalItem).then((response) => {
      this.itemViewing = null;
      this.originalItem = null;
      if (response.success) {
        this.loadData(response.data);
        this.message = "Item renamed successfully";
        this.renderModal('success');
      } else {
        // Display the error
        this.message = "Something went wrong. Please refresh and try again or contact support";
        this.renderModal('error');
      }
    }).catch((e) => {
      this.itemViewing = null;
      this.originalItem = null;
      if (e.message === 'MAX_ATTEMPTS') {
        this.message = "Please refresh the manager to see the latest changes.";
        this.renderModal('info');
      } else {
        console.log('LINE 432');
        this.message = "Something went wrong. Please refresh and try again or contact support.";
        this.renderModal('error');
      }
    });
  }

  hasItemBeenModified() {
    if (this.itemViewing && this.originalItem) {
      return this.itemViewing.name !== this.originalItem.name;
    }
    return false;
  }

  /* BUTTON EVENTS */
  refresh(event) {
    this.isLoading = true;
    this.refreshComponent();
  }

  refreshComponent(recursive = false) {
    const refreshPath = recursive ? this.directory_manager.root_path : this.directory_manager.getCurrPath();
    this.directory_manager.loadDirectory(refreshPath, recursive, true).then((result) => {
      if (result.success) {
        //Success
        this.loadData(result.data);
      }
      this.isLoading = false;
    }).catch(e => {
      this.isLoading = false;
      console.debug(e);
      //An error occurred
      this.message = "An unknown error has occurred. Please refresh the Manager";
      this.renderModal('error');
    });
  }

  upload(event) {
    this.renderModal('file_upload');
  }

  move(event) {
    if (!this.selectedRows || this.selectedRows.length < 1) {
      //Error must select one or more items
      this.message = "Please select one or more items to move.";
      this.renderModal('info');
    } else {
      //Check for folders
      for (let index = 0; index < this.selectedRows.length; index++) {
        const row = this.selectedRows[index];
        if (row.node_type === 'folder') {
          this.message = 'You do not have permission to modify folders.';
          this.renderModal('warning');
          return;
        }
      }
      //Setup Mover Modal
      this.moverData = this.directory_manager.getDirectory(null, true);
      this.buildBreadCrumbs(true);
      this.isMoveDisabled = true;
      this.renderModal('move');
    }
  }

  onMoveSubmit(event) {
    this.isLoading = true;
    this.directory_manager.moveItems(this.toPath, this.selectedRows).then((result) => {
      if (result.success) {
        this.loadData(this.directory_manager.getDirectory());
      } else {
        //Error on move
        this.message = "Something went wrong, please refresh and try again.";
        this.renderModal('error');
      }
      this.isLoading = false;
      this.selectedRows = [];
    }).catch((e) => {
      //Error on move
      this.isLoading = false;
      this.selectedRows = [];
      if (e && e.message === 'MAX_ATTEMPTS') {
        this.message = "Please refresh the manager to see the latest changes.";
        this.renderModal('info');
      } else {
        console.log('LINE 516');
        this.message = "Something went wrong. Please refresh and try again or contact support.";
        this.renderModal('error');
      }
    });
    this.renderModal('move', false);
  }

  handleWorkflowSubmit(data) {
    this.message = 'Executing Workflow';
    this.renderModal('info');
    console.log('this.workflowSelected: ' + this.workflowSelected)
    this.directory_manager.executeWorkflow(this.workflowSelected, data).then(result => {
      this.postWorkflowCallout();
      this.running_workflow = false;
      if (result.success) {
        this.message = result.message;
        this.renderModal('success');
        this.loadData(this.directory_manager.getDirectory());
      } else {
        //Error on move
        this.message = "Something went wrong, please refresh and try again.";
        this.renderModal('error');
      }
    }).catch(e => {
      //Error on workflow
      this.postWorkflowCallout();
      this.running_workflow = false;
      if (e && e.message === 'MAX_ATTEMPTS') {
        this.message = "Please refresh the manager to see the latest changes.";
        this.renderModal('info');
      } else if (e && e.message === 'VALIDATION_FAIL') {
        this.message = "Please enter a valid year";
        this.renderModal('error');
      } else {
        console.log('LINE 548');
        this.message = "Something went wrong. Please refresh and try again or contact support.";
        this.renderModal('error');
      }
    });
  }

  postWorkflowCallout() {
    this.running_workflow = false;
    this.uploadedFiles = [];
    this.workflowSelected = null;
  }

  onDirectoryCreateSubmit(event) {
    this.renderModal('directory_creator', false);
    if (this.running_workflow) {
      const data = {
        detail: {
          directory_name: event.detail.metadata.directory_name
        }
      };
      this.handleWorkflowSubmit(data);
    } else {
      //Handle standard Directory Create Functionality
    }
  }

  handleDelete(event) {
    if (!this.directory_manager.isAdmin && this.directory_manager.isDeleteDisabled) { //No delete permission
      this.message = 'You do not have permission to delete items.';
      this.renderModal('warning');
      return;
    } else if (!this.selectedRows || this.selectedRows.length < 1) { //Error must select one or more items
      this.message = "Please select one or more items to delete.";
      this.renderModal('info');
      return;
    } else {
      //Handle Delete confirmation
      this.renderModal('confirm');
      this.confirmAction = 'delete';
      this.confirmMessage = "Are you sure you want to delete the selected items?";
    }
  }

  deleteItems() {
    //Check for folders
    for (let index = 0; index < this.selectedRows.length; index++) {
      const row = this.selectedRows[index];
      if (row.node_type === 'folder') {
        this.message = 'You do not have permission to modify folders.';
        this.renderModal('warning');
        return;
      }
    }

    this.message = 'Deleting Item(s)';
    this.renderModal('info');

    // Delete Items
    this.directory_manager.deleteItems(this.selectedRows).then((result) => {
      //Success
      if (result.success) {
        this.loadData(this.directory_manager.getDirectory());
        this.message = "Deletion Successful";
        this.renderModal('success');
      } else {
        //Something went wrong
        this.message = "Something went wrong, please refresh and try again.";
        this.renderModal('error');
      }
    }).catch((e) => {
      //Error on delete
      if (e.message === 'MAX_ATTEMPTS') {
        this.message = "Please refresh the manager to see the latest changes.";
        this.renderModal('info');
      } else {
        console.log('LINE 627');
        this.message = "Something went wrong. Please refresh and try again or contact support.";
        this.renderModal('error');
      }
    });
  }

  onSearchCommit(event) {
    this.searchText = event.target.value;
    if (this.searchText === "") {
      //Clear the search results
      this.isSearching = false;
      this.isLoading = true;
      this.pathParts = this.directory_manager.getBreadCrumbs();
      //Reset the search result
      this.directory_manager.search_has_more = true;
      //Display the current directory
      this.loadData(this.directory_manager.getDirectory());
      this.isLoading = false;
      return;
    }

    //Perform Search
    this.pathParts = this.searchParts;
    this.isSearching = true;
    this.isLoading = true;
    //Execute Search
    this.directory_manager.search(this.searchText).then((result) => {
      if (result.success) {
        this.loadData(result.data);
      } else {
        console.log('LINE 658');
        this.message = "Something went wrong. Please refresh and try again or contact support.";
        this.renderModal('error');
      }
      this.isLoading = false;
    }).catch((e) => {
      console.log('LINE 664');
      this.message = "Something went wrong. Please refresh and try again or contact support.";
      this.renderModal('error');
      this.isLoading = false;
    });
  }

  handleWorkflowChange(event) {
    this.workflowSelected = event.target.options.find(opt => opt.value === event.detail.value).value;
    this.workflowType = this.directory_manager.getWorkflowType(this.workflowSelected);
  }

  runWorkflow() {
    const isWorkflowRunnable = this.directory_manager.isWorkflowRunnable(this.workflowSelected);
    console.log('Line 671 isWorkflowRunnable '+isWorkflowRunnable);
    console.log('Line 672 this.workflowSelected '+this.workflowSelected);

    if (!isWorkflowRunnable) {
      console.log('HERE');
      this.message = 'This workflow cannot be run in the root directory';
      this.renderModal('info');
      return;
    }
    console.log('HERE1');
    //Start executing workflow
    this.running_workflow = true;
    this.handleWorkflowRun();
  }

  handleWorkflowRun() {
    switch (this.workflowType) {
      case 'folder_initiation':
        console.log(this.workflowType);
        console.log(this.workflowSelected);
        if(this.workflowSelected === 'Create_Homeowner_Address_Folder'){
          this.showHomeOwnerCreator =true;
          break;
        }
        else
        {
          this.showDirectoryCreator = true;
          break;
        }
        break;
      case 'upload':
        this.showFileUploader = true;
        break;
      default:
        this.message = 'Unknown Workflow Type. Please refresh and try again or contact support.';
        this.renderModal('error');
        break;
    }
  }

  initDropbox() {
    if (!this.initialized) {
      this.isLoading = true;
      this.directory_manager.initDropboxAccount().then((result) => {
        if (result.success) {
          this.loadData(result.data);
        } else {
          this.message = "Something went wrong Initializing the Account. Please refresh and try again or contact support.";
          this.renderModal('error');
        }
        this.initialized = true;
        this.isLoading = false;
      }).catch((e) => {
        this.message = "Something went wrong Initializing the Account. Please refresh and try again or contact support.";
        this.renderModal('error');
        this.isLoading = false;
      })
    }
  }

  onConfirmProceed(event) {
    this.renderModal('confirm', false);
    if (event.detail.action === 'delete') {
      this.deleteItems();
    }
  }

  onConfirmCancel(event) {
    this.renderModal('confirm', false);
  }

  closeMover(event) {
    this.renderModal('move', false);
  }

  closeViewer(event) {
    this.renderModal('view', false);
  }

  closeUpload(event) {
    this.uploadedFiles = [];
    this.running_workflow = false;
    this.renderModal('file_upload', false);
  }

  closeDirectoryCreator(event) {
    this.running_workflow = false;
    this.renderModal('directory_creator', false);
  }

  closeWorkflow(event) {
    this.isWorkflowFolderCreation = false;
    this.renderModal('workflow', false);
  }

  /* MODAL EVENTS */
  renderModal(event, open = true) {
    switch (event) {
      case 'file_upload':
        this.showFileUploader = open ? true : false;
        break;
      case 'view':
        this.showItemViewer = open ? true : false;
        break;
      case 'move':
        this.showMover = open ? true : false;
        break;
      case 'confirm':
        this.showConfirm = open ? true : false;
        break;
      case 'workflow':
        this.showWorkflow = open ? true : false;
        break;
      case 'directory_creator':
        this.showHomeOwnerCreator = open ? true : false;
        this.showDirectoryCreator = open ? true : false;
        break;
      case 'success':
      case 'info':
      case 'error':
      case 'warning':
        const toastEvent = new ShowToastEvent({
          title: event.charAt(0).toUpperCase() + event.slice(1),
          message: this.message,
          variant: event
        });
        this.dispatchEvent(toastEvent);
        break;
    }
  }
}