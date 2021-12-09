import { LightningElement, api, track, wire} from 'lwc';

import getCreateFieldList from '@salesforce/apex/customCreateNewRecordController.getCreateFieldList';
import getRecordTypeId from '@salesforce/apex/customCreateNewRecordController.getRecordTypeId';
//import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//import NAME_FIELD from '@salesforce/schema/Account.Name';
//import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
//import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';


export default class customExtendedForm extends LightningElement {
    @api
    setTheObjectName2;
    @api
    setTheProcessName;
    @api
    createFields;
    @track 
    recordTypeId;
    @track 
    fields;
    @track
    createNewScreen;
    @track
    searchScreen;
    @track 
    compareScreen;
    @wire(getCreateFieldList, {ProcessName : '$setTheProcessName', sObjectName : '$setTheObjectName2'}) createFields;
    //@wire(getFieldList, {ProcessName : '$setTheProcessName', sObjectName : '$setTheObjectName'}) fields;

    @wire(getRecordTypeId, {sObjectName : '$setTheObjectName2'}) recordTypeId;
    
    fields = ['Name', 'Phone', 'BillingAddress', 'ShippingAddress', 'AnnualRevenue', 'NAICS_Description__c', 'OwnerId'];
    //fields =['FirstName', 'LastName', 'Title', 'AccountId', 'FunctionalRole__c', 'Email', 'Mobile', 'Phone', 'OwnerId', 'CIN__c'];
    //fields = [NAME_FIELD, REVENUE_FIELD, INDUSTRY_FIELD];

    
    // call apex method on button click
    handleReturn() {
        this.createNewScreen = false;
        this.searchScreen = true;
        this.compareScreen = false;
        this.dispatchEvent(new CustomEvent('previous', { detail: {create: this.createNewScreen, search : this.searchScreen}}));             
    }

   
    // call apex method on button click
    handleSave() {
        //this.setTheObjectName = 'Contact';
        this.createNewScreen = false;
        this.searchScreen = true;
        this.compareScreen = false;
        this.dispatchEvent(new CustomEvent('next', { detail: {create: this.createNewScreen, search : this.searchScreen, compare: this.compareScreen}}));       
    }

    // call apex method on button click 
    handleCancel() {
        //this.setTheObjectName = 'Case';
        this.createNewScreen = false;
        this.searchScreen = true;
        this.compareScreen = false;
        this.dispatchEvent(new CustomEvent('previous',  { detail: {create: this.createNewScreen, search : this.searchScreen, compare: this.compareScreen}}));
        //this.previousHandler();
    }

}