import { LightningElement, api, track } from 'lwc';
//import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class einsteinVisionOCRTool extends LightningElement {
    @api recordId;
    @track isLoadingFinish = true;
    @api isFileUploaded = false;
    @api isDataExtracted = false;
    @api isImageCategorySelected = false;
    @api imageCategoryValue;
    handleFileUploadSuccess(){
        console.log('In  success');
        this.isFileUploaded = true;
        this.isDataExtracted = false;
    }

    connectedCallback(){
        this.isLoadingFinish = true;
    }
    handleSelectedValue(event){
        this.imageCategoryValue = event.detail.selectedImageCategory;
        console.log('get value of image>>>'+this.imageCategoryValue);
        if(this.imageCategoryValue === null || this.imageCategoryValue === undefined || this.imageCategoryValue === ''){
            this.isImageCategorySelected = false;
        }else{console.log('In image selected yes');
            this.isImageCategorySelected = true;
        }
    }

    handleCancel(){
        this.isLoadingFinish = false;
        //setTimeout(function() {}.bind(this), 500)
        this.isFileUploaded = false;
        this.isDataExtracted = false;
        this.isImageCategorySelected = false;
        this.isLoadingFinish = true;
    }

}