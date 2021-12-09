import { LightningElement, wire, api, track } from 'lwc';
import getFieldDetails from '@salesforce/apex/ImageContentExtractorLWC.getFieldDetails';
import getImageUrlAndToken from '@salesforce/apex/ImageContentExtractorLWC.getImageUrlAndToken';
import getDataFromImage from '@salesforce/apex/ImageContentExtractorLWC.getDataFromImage';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
export default class einsteinOcrExtractedDataViewer extends LightningElement {
    @api recordId;
    @api isDataExtracted;
    @track isLoadingFinish = false;
    @track fieldDetails;
    @api imageCategory;
    @track childRecordId;
    @wire(getFieldDetails, {imageCategory : '$imageCategory'})fieldDetails
    @track imageUrlValue;
    connectedCallback() { 
        console.log('In connected callback of data'+this.fieldDetails);
        if (this.recordId) {    
            getImageUrlAndToken({recordId: this.recordId})
            .then(data => {
                this.isLoadingFinish = true;
                this.imageUrlValue = data;
                console.log('result received1>>>>>'+this.imageUrlValue+'>>>>>'+data);
                this.error = undefined;
                    getDataFromImage({recordId: this.recordId, imageCategory: this.imageCategory, imageUrl: this.imageUrlValue})
                    .then(result => {
                        this.isLoadingFinish = true;
                        this.childRecordId = result;
                        console.log('result received2>>>>>'+this.childRecordId); 
                        this.error = undefined;
                        this.isDataExtracted = true;
                        this.isDataExtracted = true;
                    })
                    .catch(error => {console.log('In errorrrrrrrrrrrr2'+JSON.stringify(this.fieldDetails));
                        this.error = error;
                        this.isDataExtracted = true;
                        // display server exception in toast msg 
                        const event = new ShowToastEvent({
                            title: 'Error',
                            variant: 'error',
                            mode: 'sticky',
                            message: error.body.message
                        });
                        this.dispatchEvent(event);
                    });
            })
            .catch(error => {console.log('In errorrrrrrrrrrrr1'+JSON.stringify(this.fieldDetails));
                this.error = error;
                this.isDataExtracted = true;
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    mode: 'sticky',
                    message: error.body.message
                });
                this.dispatchEvent(event);
            });
        }else {
            // display server exception in toast msg 
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                mode: 'sticky',
                message: 'Parent record Id not found!'
            });
            this.dispatchEvent(event);
        }
    }
    handleSave(){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Extract record successfully created',
                variant: 'success',
            }),
        );
    }

    handleCancel(){
        this.dispatchEvent(new CustomEvent('cancel'));
    }
}