import { LightningElement, track, api, wire} from 'lwc';
// import server side apex class method 
import getColumnFieldList from '@salesforce/apex/customSearchController.getColumnFieldList';
import getRecordList from '@salesforce/apex/customSearchController.getRecordList';
import getSearchFieldMapping from '@salesforce/apex/customSearchController.getSearchFieldMapping';
// import standard toast event 
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

export default class customSearch extends LightningElement{
    @api setTheProcessName;
    @api setTheObjectName2;
    @api containerContext;
    @track selectedRecordId;
    @api setTheRecordId;
    @api setTheSearchRecordId;
    @api searchFieldMapping;
    @track tempSearchFieldMapping;
    @api searchRecords;
    @track error;
    @track searchKeyValue;
    @api columnFields;
    @api isLoadingFinish = false;
    @track isSearchResultFound = false;
    @wire(getColumnFieldList, {ProcessName : '$setTheProcessName', sObjectName : '$setTheObjectName2'}) columnFields;
    
    connectedCallback(){
        if((this.searchRecords !== undefined && this.searchRecords !== 'null') ||
        (this.searchFieldMapping !== undefined && this.searchFieldMapping !== 'null')){
            this.isLoadingFinish = true;
            if(this.searchRecords.length > 0){
                this.isSearchResultFound = true;
            }else{
                this.isSearchResultFound = false;
            }
        }else{
            if((this.setTheProcessName !== 'undefined' && this.setTheProcessName !== 'null') &&
            (this.setTheObjectName2 !== 'undefined' && this.setTheObjectName2 !== 'null') &&
            (this.setTheRecordId !== 'undefined' && this.setTheRecordId !== 'null'))
            {
                getSearchFieldMapping({ProcessName : this.setTheProcessName ,sObjectName2 :this.setTheObjectName2, RecordId : this.setTheRecordId, searchRecordId : this.setTheSearchRecordId})
                .then(data => {
                    this.searchFieldMapping = data;
                    this.searchKeyValue = JSON.stringify(this.searchFieldMapping);
                    getRecordList({ProcessName : this.setTheProcessName, sObjectName : this.setTheObjectName2, searchKey : this.searchKeyValue, isInitialCall : true, searchRecordId : this.setTheSearchRecordId})
                    .then(result => {
                        this.isLoadingFinish = true; 
                        if(result !== null){
                            this.isSearchResultFound = true;
                            if(result.length > 10){
                                this.searchRecords = result.slice(0,10);
                                if(this.containerContext === 'Visualforce'){
                                    this.dispatchEvent(new CustomEvent('showToastMsg', 
                                    {
                                        detail : {isSearchLimitExceed : true, msgDetail : 'More than 10 search records were found. Consider narrowing your search criteria.'},
                                        bubbles: true
                                    }));
                                }else{
                                // display server exception in toast msg 
                                    const event = new ShowToastEvent({
                                        title: 'Search Warning',
                                        variant: 'warning',
                                        message: 'More than 10 search records were found. Consider narrowing your search criteria.',
                                    });
                                    this.dispatchEvent(event);
                                }
                            }else{
                                this.searchRecords = result;
                                this.error = undefined;
                            }
                            for(let key in this.searchRecords) {
                                // Preventing unexcepted data
                                if (this.searchRecords.hasOwnProperty(key)) { // Filtering the data in the loop
                                    if(this.searchRecords[key].AccountId){
                                        this.searchRecords[key].AccountId = this.searchRecords[key].Account.Name;        
                                    }
                                    if(this.searchRecords[key].OwnerId){
                                        this.searchRecords[key].OwnerId = this.searchRecords[key].Owner.Name;        
                                    }
                                    if(this.searchRecords[key].NAICS_Description__c){
                                        this.searchRecords[key].NAICS_Description__c = this.searchRecords[key].NAICS_Description__r.Name;        
                                    }
                                }
                            }
                        }else {
                            this.isSearchResultFound = false;
                            if(this.containerContext === 'Visualforce'){
                                // fire toast event if input field is blank
                                this.dispatchEvent(new CustomEvent('showToastMsg', 
                                {
                                    detail : {isClientWarning : true, msgDetail : 'No records were found. Please update your search criteria and try again.'},
                                    bubbles: true
                                }));
                            }else{
                                // display server exception in toast msg 
                                const event = new ShowToastEvent({
                                    title: 'Warning',
                                    variant: 'warning',
                                    message: 'No records were found. Please update your search criteria and try again.'
                                });
                                this.dispatchEvent(event);
                            }
                        } 
                    })
                    .catch(error => {
                        this.isSearchResultFound = false;
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
                        this.error = error;
                            // reset record var with null
                            this.searchRecords = undefined;
                    });
                })
                .catch(error => {
                    this.isSearchResultFound = false;
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
                    this.error = error;
                    // reset fieldmapping var with null   
                    this.searchFieldMapping = undefined;
                });
            }
            else {
                this.isSearchResultFound = false;
                if(this.containerContext === 'Visualforce'){
                    // fire toast event if input field is blank
                    this.dispatchEvent(new CustomEvent('showToastMsg', 
                    {
                        detail : {isServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support. [Input parameter to apex method is undefined or null]'},
                        bubbles: true
                    }));
                }else{
                    // display server exception in toast msg 
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        mode: 'sticky',
                        message: 'This Lead could not be converted. Please contact the Help Desk for support. [Input parameter to apex method is undefined or null]'
                    });
                    this.dispatchEvent(event);
                }
            }
        }
    }

    updateSeachKey(event) {
        this.tempSearchFieldMapping = JSON.parse(JSON.stringify(this.searchFieldMapping)); 
        for(let key in this.tempSearchFieldMapping){
            if (this.tempSearchFieldMapping.hasOwnProperty(key)) { 
                if(event.target.name === this.tempSearchFieldMapping[key].Object2_FieldName__c){
                    this.tempSearchFieldMapping[key].Object2_FieldValue__c = event.target.value;    
                }
            }
        }
        this.searchFieldMapping = this.tempSearchFieldMapping;
    }
    
    // call apex method on button click 
    handleSearch() {
        this.searchKeyValue = JSON.stringify(this.searchFieldMapping);  
        // if search input value is not blank then call apex method, else display error msg 
        this.searchRecords = [];
        this.isLoadingFinish = false;  
        getRecordList({ProcessName : this.setTheProcessName, sObjectName : this.setTheObjectName2, searchKey : this.searchKeyValue, isInitialCall : false, searchRecordId : this.setTheSearchRecordId})
        .then(result => { 
            this.isLoadingFinish = true; 
            if(result !== null){                 
                this.isSearchResultFound = true;
                if(result.length > 10){
                    this.searchRecords = result.slice(0,10);
                    if(this.containerContext === 'Visualforce'){
                        this.dispatchEvent(new CustomEvent('showToastMsg', 
                        {
                            detail : {isSearchLimitExceed : true, msgDetail :  'More than 10 search records were found. Consider narrowing your search criteria.'},
                            bubbles: true
                        }));
                    }else{
                        // display server exception in toast msg 
                        const event = new ShowToastEvent({
                            title: 'Search Warning',
                            variant: 'warning',
                            message: 'More than 10 search records were found. Consider narrowing your search criteria.'
                        });
                        this.dispatchEvent(event);
                    }
                }else{
                    this.searchRecords = result;
                    this.error = undefined;
                } 
                for(let key in this.searchRecords) {
                    // Preventiuing unexcepted data
                    if (this.searchRecords.hasOwnProperty(key)) { // Filtering the data in the loop
                        this.isSearchResultFound = true;
                        if(this.searchRecords[key].AccountId){
                            this.searchRecords[key].AccountId = this.searchRecords[key].Account.Name;        
                        }
                        if(result[key].OwnerId){
                            this.searchRecords[key].OwnerId = this.searchRecords[key].Owner.Name;        
                        }
                        if(this.searchRecords[key].NAICS_Description__c){
                            this.searchRecords[key].NAICS_Description__c = this.searchRecords[key].NAICS_Description__r.Name;        
                        }
                    }
                }
            }else {
                this.isSearchResultFound = false;
                if(this.containerContext === 'Visualforce'){
                    // fire toast event if input field is blank
                    this.dispatchEvent(new CustomEvent('showToastMsg', 
                    {
                        detail : {isClientWarning : true, msgDetail : 'No records were found. Please update your search criteria and try again.'},
                        bubbles: true
                    }));
                }else{
                    // display server exception in toast msg 
                    const event = new ShowToastEvent({
                        title: 'Warning',
                        variant: 'warning',
                        message: 'No records were found. Please update your search criteria and try again.'
                    });
                    this.dispatchEvent(event);
                }
            } 
        })
        .catch(error => {
            this.isSearchResultFound = false;
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
            this.error = error;
            // reset records var with null   
            this.searchRecords = undefined;
        });
    }
    // call apex method on button click
    handleCreateNew() {
        this.dispatchEvent(new CustomEvent('next', { detail: {select :this.selectedRecordId, searchData : this.searchRecords, searchFieldMapping : this.searchFieldMapping}}));
    }

    // call apex method on button click 
    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    // call apex method on button click 
    handleUseSelected(event){
        this.selectedRecordId =  event.detail.select;
        this.dispatchEvent(new CustomEvent('next', { detail: {select :this.selectedRecordId, searchData : this.searchRecords, searchFieldMapping : this.searchFieldMapping}})); 
        }
}