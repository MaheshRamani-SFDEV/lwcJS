import { LightningElement, api, track } from 'lwc';

import fetchLeadRecord from '@salesforce/apex/customLeadContainerController.fetchLeadRecord';
import fetchLeadRelatedRecord from '@salesforce/apex/customLeadContainerController.fetchLeadRelatedRecord';
import { NavigationMixin } from 'lightning/navigation';
// import standard toast event 
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
export default class customLeadContainer extends NavigationMixin(LightningElement){
    @api containerContext = 'Lightning';
    @api currentProcessName = 'CustomLeadConversion';
    @api objectName1 = 'Lead';
    @api objectName2 = 'Account';
    @api recordId;
    @api objectApiName;
    @track accountId;
    @track contactId;
    @api accountName = '';
    @api leadRecord;
    @api contactRecord;
    @api compareRecord2Id;
    @api currentStepName;
    @track tempStepName;
    @track isSearchScreenEnabled;
    @track isCreateScreenEnabled;
    @track isCompareScreenEnabled;
    @track isOpportunityScreenEnabled;
    @track error;
    @api searchRecords;
    @api searchRecordId;
    @api searchFieldMapping;
    @api records = [];
    @api leadConvertRecords;
    @track isLoadingFinish = false;

    connectedCallback() { 
        // if search input value is not blank then call apex method, else display error msg
        if (this.recordId) {    
            fetchLeadRecord({ProcessName : this.currentProcessName, recordId: this.recordId})
            .then(result => {
                this.isLoadingFinish = true;
                // set @api leaadRecord variable with return lead from server
                this.leadRecord = result; 
                this.error = undefined;
                if(this.leadRecord.stintro__Related_Account__c){
                    this.accountId = this.leadRecord.stintro__Related_Account__c;
                }
                if(this.leadRecord.stintro__Related_Contact__c){
                    this.contactId = this.leadRecord.stintro__Related_Contact__c;
                }
                if(this.accountId !== undefined && this.accountId !== 'null'){
                    this.currentStepName = 'Step2';
                    this.tempStepName = 2;
                    this.isSearchScreenEnabled = false;
                    this.isCreateScreenEnabled = false;
                    this.isCompareScreenEnabled = true;
                    this.isOpportunityScreenEnabled = false;
                    this.compareRecord2Id =this.accountId;
                    this.searchRecordId = this.accountId;
                }else if((this.accountId === undefined || this.accountId === 'null') &&
                    (this.contactId !== undefined && this.contactId !== 'null')){  
                    fetchLeadRelatedRecord({ProcessName : this.currentProcessName, recordId: this.contactId})
                    .then(data => {
                        // set @api leaadRecord variable with return lead from server
                        this.contactRecord = data;
                        this.error = undefined;
                        if(this.contactRecord[0].AccountId){
                            this.accountId = this.contactRecord[0].AccountId;
                            this.compareRecord2Id =this.accountId;
                            this.searchRecordId = this.accountId;
                            this.currentStepName = 'Step2';
                            this.tempStepName = 2;
                            this.isSearchScreenEnabled = false;
                            this.isCreateScreenEnabled = false;
                            this.isCompareScreenEnabled = true;
                            this.isOpportunityScreenEnabled = false; 
                        }
                    })
                    .catch(error => {
                        this.error = error;
                        if(this.containerContext === 'Visualforce'){
                            // display server exception in toast msg 
                            this.dispatchEvent(new CustomEvent('showToastMsg', 
                            {
                                detail : {isServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support. ['+error+']'},
                                bubbles: true
                            }));
                        }else{
                            // display server exception in toast msg 
                            const event = new ShowToastEvent({
                                title: 'Error',
                                variant: 'error',
                                mode: 'sticky',
                                message: 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'
                            });
                            this.dispatchEvent(event);
                        }
                        
                        // reset lead var with null   
                        this.contactRecord = null;
                    });
                }else{          
                    this.currentStepName = 'Step1';
                    this.tempStepName = 1;
                    this.isSearchScreenEnabled = true;
                    this.isCreateScreenEnabled = false;
                    this.isCompareScreenEnabled = false;
                    this.isOpportunityScreenEnabled = false; 
                }
            })
            .catch(error => {
                this.error = error;
                if(this.containerContext === 'Visualforce'){
                    // display server exception in toast msg 
                    this.dispatchEvent(new CustomEvent('showToastMsg', 
                    {
                        detail : {isServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'},
                        bubbles: true
                    }));
                }else{
                    // display server exception in toast msg 
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        mode: 'sticky',
                        message: 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'
                    });
                    this.dispatchEvent(event);
                }
                
                // reset lead var with null   
                this.leadRecord = null;
            });
        }else {
            if(this.containerContext === 'Visualforce'){
                // fire toast event if input field is blank
                this.dispatchEvent(new CustomEvent('showToastMsg', 
                {
                    detail : {isClientError : true, errorDetail : 'This Lead could not be converted. Please contact the Help Desk for support. [Lead record id not found!]'},
                    bubbles: true
                }));
            }else{
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    mode: 'sticky',
                    message: 'This Lead could not be converted. Please contact the Help Desk for support. [Lead record id not found!]'
                });
                this.dispatchEvent(event);
            }
        }
    }
    previousHandler(){ 
        if(this.tempStepName > 1){            
            this.tempStepName = this.tempStepName - 1;
        }
        if(this.tempStepName === 1){
            this.currentStepName = 'Step1';
            this.objectName2 = 'Account';
            this.isSearchScreenEnabled = true;  
            this.isCreateScreenEnabled = false;
            this.isCompareScreenEnabled = false;
            this.isOpportunityScreenEnabled = false;
        /*}else if(this.tempStepName === 2){
            this.currentStepName = 'Step2';
            this.objectName2 = 'Account';
            this.compareRecord1Id = this.recordId;
            this.compareRecord2Id =this.accountId;
            this.isSearchScreenEnabled = false;  
            this.isCreateScreenEnabled = false;
            this.isCompareScreenEnabled = true;
            this.isOpportunityScreenEnabled = false;*/
        }else if(this.tempStepName === 3){
            this.currentStepName = 'Step3';
            this.objectName2 = 'Contact';
            this.isSearchScreenEnabled = true;  
            this.isCreateScreenEnabled = false;
            this.isCompareScreenEnabled = false;
            this.isOpportunityScreenEnabled = false;
            this.searchRecordId = this.accountId;
            console.log('In prev step 3 searchRecordId>>>'+this.searchRecordId);
        /*}else if(this.tempStepName === 4){
            this.currentStepName = 'Step4';
            this.objectName2 = 'Contact';
            this.compareRecord1Id = this.recordId;
            this.compareRecord2Id =this.contactId;
            this.isSearchScreenEnabled = false;  
            this.isCreateScreenEnabled = false;
            this.isCompareScreenEnabled = true;
            this.isOpportunityScreenEnabled = false;
        }else if(this.tempStepName === 5){
            this.currentStepName = 'Step5';
            this.objectName2 = 'Opportunity';
            this.isSearchScreenEnabled = false;  
            this.isCreateScreenEnabled = false;
            this.isCompareScreenEnabled = false;
            this.isOpportunityScreenEnabled = true;
        }*/
        }
    }
    nextHandler(event){
        if(this.tempStepName < 5){
            this.tempStepName = this.tempStepName + 1;
        }
        if(this.tempStepName === 1){
            this.currentStepName = 'Step1';
            this.objectName2 = 'Account';
            this.isSearchScreenEnabled = true;  
            this.isCreateScreenEnabled = false;
            this.isCompareScreenEnabled = false;
            this.isOpportunityScreenEnabled = false;
        }else if(this.tempStepName === 2){
            this.currentStepName = 'Step2';
            this.objectName2 = 'Account';
            if(event.detail.select){
                this.compareRecord2Id = event.detail.select;  
                this.accountId = event.detail.select;
                this.searchRecordId = event.detail.select;
                this.isCreateScreenEnabled = false;
                this.isCompareScreenEnabled = true;
            }else{
                this.isCreateScreenEnabled = true;
                this.isCompareScreenEnabled = false;
                this.accountId = undefined;
                this.contactId = undefined;
            }
            if(event.detail.searchData){
                this.searchRecords = event.detail.searchData;
                this.searchFieldMapping = event.detail.searchFieldMapping;
            }
            this.isSearchScreenEnabled = false;  
            this.isOpportunityScreenEnabled = false;
        }else if(this.tempStepName === 3){
            this.objectName2 = 'Contact';
            this.searchRecords = undefined;
            this.searchFieldMapping = undefined;
            this.records.push(event.detail.data);
            if(event.detail.isCreateScreen){ 
                if((this.accountId === undefined || this.accountId === 'null') &&
                (this.contactId === undefined || this.contactId === 'null')){
                    this.isLoadingFinish = false;
                    this.tempStepName = 4;
                    this.currentStepName = 'Step4';
                    for(let key in event.detail.data){
                        if (event.detail.data.hasOwnProperty(key)) {
                            if(key === 'Name'){
                                this.accountName = event.detail.data[key];
                            }
                        }
                    }
                    this.isCreateScreenEnabled = true;
                    this.isCompareScreenEnabled = false;
                    this.isSearchScreenEnabled = false;
                    this.isLoadingFinish = true;    
                    //firing an child method
                    this.template.querySelector("c-custom-create-screen").getCreateField(this.currentProcessName, this.objectName2, this.recordId, this.accountName);
                }
            }else if(event.detail.isCompareScreen){
                if(this.accountId !== undefined && this.accountId !== 'null' && 
                    this.contactId !== undefined && this.contactId !== 'null'){
                    this.tempStepName = 4;
                    this.currentStepName = 'Step4';
                    this.compareRecord2Id = this.contactId;
                    this.isCompareScreenEnabled = true;
                    this.isCreateScreenEnabled = false;
                    this.isSearchScreenEnabled = false;
                    //firing an child method
                    this.template.querySelector("c-stare-and-compare-screen").getCompareField(this.objectName2, this.compareRecord2Id);
                }else if((this.accountId === undefined || this.accountId === 'null') && 
                    (this.contactId !== undefined && this.contactId !== 'null')){
                    this.tempStepName = 4;
                    this.currentStepName = 'Step4';
                    this.compareRecord2Id = this.contactId;
                    this.isCompareScreenEnabled = true;
                    this.isCreateScreenEnabled = false;
                    this.isSearchScreenEnabled = false;
                    //firing an child method
                    this.template.querySelector("c-stare-and-compare-screen").getCompareField(this.objectName2, this.compareRecord2Id);
                }else{
                    this.tempStepName = 3;
                    this.currentStepName = 'Step3';
                    this.searchRecordId = this.accountId;
                    this.isCompareScreenEnabled = false;
                    this.isCreateScreenEnabled = false;
                    this.isSearchScreenEnabled = true;
                }
            }
            this.isOpportunityScreenEnabled = false;
        }else if(this.tempStepName === 4){
            this.currentStepName = 'Step4';
            this.objectName2 = 'Contact';
            if(event.detail.select){
                this.compareRecord2Id = event.detail.select; 
                this.contactId = event.detail.select;
                this.isCreateScreenEnabled = false;
                this.isCompareScreenEnabled = true;
            }else{
                this.accountName = this.compareRecord2Id;
                this.isCreateScreenEnabled = true;
                this.isCompareScreenEnabled = false;
            }
            if(event.detail.searchData){
                this.searchRecords = event.detail.searchData;
                this.searchFieldMapping = event.detail.searchFieldMapping;
            }
            this.isSearchScreenEnabled = false;
            this.isOpportunityScreenEnabled = false;
        }else if(this.tempStepName === 5){
            this.currentStepName = 'Step5';
            this.objectName2 = 'Opportunity';
            if(event.detail.data){
                this.records.push(event.detail.data);
                this.leadConvertRecords = JSON.stringify(this.records);
                this.isSearchScreenEnabled = false;  
                this.isCreateScreenEnabled = false;
                this.isCompareScreenEnabled = false;
                this.isOpportunityScreenEnabled = true;
            }
        }
    }
    
    cancelHandler() {
        switch (this.containerContext) {
            case 'Lightning':
                this[NavigationMixin.Navigate](
                    {
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.recordId,
                            actionName: 'view'
                    },
                });
                break;
            case 'Visualforce':
                window.open('/'+this.recordId, "_self");
                break;
            default:
                console.log('Container Contextt Missing!');
        }
    }
}