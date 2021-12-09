import { LightningElement, api, track } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class einsteinOcrFileUpload extends LightningElement {
    @api recordId;
    @api isFileUploaded;
    @track isLoadingFinish = false;
    @track uploadedFileNames;
    @api imageCategory;
    @api isImageCategorySelected;
    get acceptedFormats() {
        return ['.pdf', '.png','.jpg','.jpeg'];
    }

    connectedCallback(){
        this.isLoadingFinish = true;
    }
    handleUploadFinished(event) {
        // Get the list of uploaded files
        const uploadedFiles = event.detail.files;
        this.uploadedFileNames = '';
        for(let i = 0; i < uploadedFiles.length; i++) {
            this.uploadedFileNames += uploadedFiles[i].name;
        }
        this.isFileUploaded = true;
        this.dispatchEvent(new CustomEvent('upload'));
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: uploadedFiles.length + ' Files uploaded Successfully: ' + this.uploadedFileNames,
                variant: 'success',
            }),
        );
        this.isLoadingFinish = true;
    }
}