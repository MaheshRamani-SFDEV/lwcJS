import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import convertLeadRecord from '@salesforce/apex/customLeadContainerController.convertLeadRecord';

export default class customOpportunityChoiceScreen extends NavigationMixin(LightningElement) {
    @api containerContext;
    @api selectedOption = '';
    @api setTheRecordId;
    @api setTheProcessName;
    @api setTheObjectName2;
    @api leadConvertResponse;
    @api leadConvertRecords;
    @track isLoadingFinish = false;
    @track continueToCreateOpportunity = false;
    @track hideFlagOption = true;
    @track options = [
        { label: 'Yes', value: 'Yes'},
        { label: 'No', value: 'No'},
    ];

    connectedCallback(){
        if((this.setTheProcessName !== 'undefined' && this.setTheProcessName !== 'null') &&
        (this.leadConvertRecords !== 'undefined' && this.leadConvertRecords !== 'null') &&
        (this.setTheRecordId !== 'undefined' && this.setTheRecordId !== 'null'))
        {  
            convertLeadRecord({ProcessName : this.setTheProcessName, recordId: this.setTheRecordId, Records : this.leadConvertRecords})
            .then(result => { 
                this.leadConvertResponse = result;
                this.error = undefined;
                if(this.leadConvertResponse.isLeadConverted){
                    this.isLoadingFinish = true;
                    if(this.containerContext === 'Visualforce'){
                        // display server exception in toast msg 
                        this.dispatchEvent(new CustomEvent('showToastMsg', 
                        {
                            detail : {isLeadConverted : this.leadConvertResponse.isLeadConverted, msgDetail : 'Your lead has been successfully converted!'},
                            bubbles: true
                        }));
                    }else{
                        // display server exception in toast msg 
                        const events = new ShowToastEvent({
                            title: 'Success',
                            variant: 'success',
                            message: 'Your lead has been successfully converted!'
                        });
                        this.dispatchEvent(events);
                    }
                }else{
                    this.isLoadingFinish = false;
                    if(this.containerContext === 'Visualforce'){
                        window.open('/'+this.setTheRecordId, "_self");
                        // display server exception in toast msg 
                        this.dispatchEvent(new CustomEvent('showToastMsg', 
                        {
                            detail : {isServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support. ['+this.leadConvertResponse.error+']'},
                            bubbles: true
                        }));
                    }else{
                        this[NavigationMixin.Navigate](
                            {
                                type: 'standard__recordPage',
                                attributes: {
                                    recordId: this.setTheRecordId,
                                    actionName: 'view'
                            },
                        });
                        // display server exception in toast msg 
                        const events = new ShowToastEvent({
                            title: 'Error',
                            variant: 'error',
                            mode: 'sticky',
                            message: 'This Lead could not be converted. Please contact the Help Desk for support. ['+this.leadConvertResponse.error+']'
                        });
                        this.dispatchEvent(events);
                    }
                }
            })
            .catch(error => {
                this.isLoadingFinish = false;
                this.error = error;
                if(this.containerContext === 'Visualforce'){
                    window.open('/'+this.setTheRecordId, "_self");
                    // display server exception in toast msg 
                    this.dispatchEvent(new CustomEvent('showToastMsg', 
                    {
                        detail : {isServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'},
                        bubbles: true
                    }));
                }else{
                    this[NavigationMixin.Navigate](
                        {
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: this.setTheRecordId,
                                actionName: 'view'
                        },
                    });
                    // display server exception in toast msg 
                    const events = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        mode: 'sticky',
                        message: 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'
                    });
                    this.dispatchEvent(events);
                }
            });
        }
    }

    changeHandler(event){
        this.selectedOption= event.detail.value;
    }

    continueHandler(){
        if(this.selectedOption === 'Yes'){
            this.hideFlagOption= false;
            this.continueToCreateOpportunity= true;
        }
        else if(this.selectedOption === 'No'){
            this.continueToCreateOpportunity= false;
            this.dispatchEvent(new CustomEvent('cancel')); 
        }
        else{
            if(this.containerContext === 'Visualforce'){
                this.dispatchEvent(new CustomEvent('showToastMsg', 
                {
                    detail : {isClientWarning : true, msgDetail : 'Please select "Yes" or "No" to proceed.'},
                    bubbles: true
                }));
            }else{
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Warning',
                    variant: 'warning',
                    message: 'Please select "Yes" or "No" to proceed.'
                });
                this.dispatchEvent(event);
            }
        }
    }
    
    cancelHandler() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    accountLinkHandler(){
        switch (this.containerContext) {
            case 'Lightning':
                this[NavigationMixin.Navigate](
                    {
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.leadConvertResponse.accountId,
                            actionName: 'view'
                    },
                });
                break;
            case 'Visualforce':
                window.open('/'+this.leadConvertResponse.accountId);
                break;
            default:
                console.log('Container Contextt Missing!');
        }
    }

    contactLinkHandler(){
        switch (this.containerContext) {
            case 'Lightning':
                this[NavigationMixin.Navigate](
                    {
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.leadConvertResponse.contactId,
                            actionName: 'view'
                    },
                });
                break;
            case 'Visualforce':
                window.open('/'+this.leadConvertResponse.contactId);
                break;
            default:
                console.log('Container Contextt Missing!');
        }
    }
}