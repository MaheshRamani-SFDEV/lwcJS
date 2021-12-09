import { LightningElement, wire, track, api} from 'lwc';
// import server side apex class method 
import getCreateFieldMapping from '@salesforce/apex/customCreateNewRecordController.getCreateFieldMapping';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
// import standard toast event 
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import {getRecord} from 'lightning/uiRecordApi';
import STREET_FIELD from '@salesforce/schema/Lead.Street';
import CITY_FIELD from '@salesforce/schema/Lead.City';
import COUNTRY_FIELD from '@salesforce/schema/Lead.Country';
import STATE_FIELD from '@salesforce/schema/Lead.State';
import POSTALCODE_FIELD from '@salesforce/schema/Lead.PostalCode';
//import STATECODE_FIELD from '@salesforce/schema/Lead.StateCode';
//import COUNTRYCODE_FIELD from '@salesforce/schema/Lead.CountryCode';

export default class customCreateScreen extends LightningElement {
    @api setTheProcessName;
    @api setTheObjectName2;
    @api setTheRecordId;
    @api accountName = '';
    @api containerContext;
    @api createFields;
    @track error;
    @api objectApiName;
    @track objectInfo;
    @api newData = {};
    @track lstRecordTypes; 
    @track recordTypeId = '';
    @api isLoadingFinish = false;
    @track isRenderAfterAccCreateScr = false;
    @api address;
    @api leadAddress;
    @api BillingStreet;
    @api BillingCountryCode;
    @api BillingCity;
    @api BillingStateCode;
    @api BillingPostalCode;
    @api ShippingStreet;
    @api ShippingCountryCode;
    @api ShippingCity;
    @api ShippingStateCode;
    @api ShippingPostalCode;
    @api MailingStateCode;
    @api MailingStreet;
    @api MailingCountryCode;
    @api MailingCity;
    @api MailingPostalCode;
    @wire(getObjectInfo, { objectApiName : '$setTheObjectName2'})
    wireObjectInfo({ data, error }) {
        if (data) {
            let getData = data;
            let tempRecordTypes = [];
            // run a for-in loop and process all record types
            for (let obj in getData.recordTypeInfos) {
                if (!getData.recordTypeInfos[obj].master && getData.recordTypeInfos[obj].available) { // skip master record type
                    // create picklist values in object formate with label and value
                    let oRecType = {
                        'label': getData.recordTypeInfos[obj].name,
                        'value': getData.recordTypeInfos[obj].recordTypeId
                    };
                    tempRecordTypes.push(oRecType);
                    if(getData.recordTypeInfos[obj].name === 'Client/Prospect' && this.setTheObjectName2 === 'Account' ){
                        this.recordTypeId = getData.recordTypeInfos[obj].recordTypeId;
                    }
                    if(getData.recordTypeInfos[obj].name === 'External Contact' && this.setTheObjectName2 === 'Contact' ){
                        this.recordTypeId = getData.recordTypeInfos[obj].recordTypeId;
                    }
                }
            }
            // set lstRecordTypes property with record type list    
            this.lstRecordTypes = tempRecordTypes;
        }
        else if (error) {
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
        }
    }

    @wire(getRecord, { recordId: '$setTheRecordId', fields: [STREET_FIELD,CITY_FIELD,POSTALCODE_FIELD,STATE_FIELD,COUNTRY_FIELD]})
    fetchLead({ data, error }) {
        if (data) {
            this.address = {
                Street: data.fields.Street.value,
                City: data.fields.City.value,
                StateCode: data.fields.StateCode.value,
                PostalCode:  data.fields.PostalCode.value,
                CountryCode:  data.fields.CountryCode.value,
            };
            this.leadAddress = this.address;
            this.BillingStreet = data.fields.Street.value;
            this.BillingCity = data.fields.City.value;
            this.BillingStateCode = data.fields.StateCode.value;
            this.BillingCountryCode = data.fields.CountryCode.value;
            this.BillingPostalCode = data.fields.PostalCode.value;
            this.ShippingStreet = data.fields.Street.value;
            this.ShippingCity = data.fields.City.value;
            this.ShippingStateCode = data.fields.StateCode.value;
            this.ShippingCountryCode = data.fields.CountryCode.value;
            this.ShippingPostalCode = data.fields.PostalCode.value;
            this.MailingStreet = data.fields.Street.value;
            this.MailingCity = data.fields.City.value;
            this.MailingStateCode = data.fields.StateCode.value;
            this.MailingCountryCode = data.fields.CountryCode.value;
            this.MailingPostalCode = data.fields.PostalCode.value;
        }else if (error) {
            this.isLoadingFinish = false;
            if(this.containerContext === 'Visualforce'){
                // display server exception in toast msg
                this.dispatchEvent(new CustomEvent('showToastMsg', 
                {
                    detail : {iServerError : true, msgDetail : 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'},
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
        }
    }

    connectedCallback(){
        this.getCreateField(this.setTheProcessName, this.setTheObjectName2, this.setTheRecordId, this.accountName);
        this.isRenderAfterAccCreateScr = false;
    }

    @api
    getCreateField(currentProcessName, objectName2, recordId, accountName){
        this.setTheProcessName = currentProcessName;
        this.setTheObjectName2 = objectName2;
        this.setTheRecordId = recordId;
        this.accountName = accountName;
        if(this.accountName.startsWith('001') || this.accountName === ''){
            this.isRenderAfterAccCreateScr = false;
        }else{
            this.isRenderAfterAccCreateScr = true;
        }
        this.createFields = [];
        this.isLoadingFinish = false;
        if((this.setTheProcessName !== 'undefined' && this.setTheProcessName !== 'null') &&
        (this.setTheObjectName2 !== 'undefined' && this.setTheObjectName2 !== 'null') &&
        (this.setTheRecordId !== 'undefined' && this.setTheRecordId !== 'null')){
            getCreateFieldMapping({ProcessName : this.setTheProcessName ,sObjectName2 :this.setTheObjectName2, RecordId : this.setTheRecordId, accountName : this.accountName})
            .then(result => {
                // set @api leaadRecord variable with return lead from server  
                this.createFields = result;
                this.error = undefined;
                this.isLoadingFinish = true;
            })
            .catch(error => {
                this.isLoadingFinish = false; 
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
                        message: 'This Lead could not be converted. Please contact the Help Desk for support. ['+error.body.message+']'
                    });
                    this.dispatchEvent(event);
                }
                // reset accounts var with null   
                this.createFields = undefined;
                this.error = error;
            });
        }
    }

    // call apex method on button click
    handleReturn() {
        this.dispatchEvent(new CustomEvent('previous'));
    }
    
    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        this.newData = event.detail.fields;
        if(this.setTheObjectName2 === 'Account'){
            this.newData.BillingStreet = this.BillingStreet;
            this.newData.BillingCountryCode = this.BillingCountryCode;
            this.newData.BillingCity = this.BillingCity;
            this.newData.BillingStateCode = this.BillingStateCode;
            this.newData.BillingPostalCode = this.BillingPostalCode;
            this.newData.ShippingStreet = this.ShippingStreet;
            this.newData.ShippingCountryCode = this.ShippingCountryCode;
            this.newData.ShippingCity = this.ShippingCity;
            this.newData.ShippingStateCode = this.ShippingStateCode;
            this.newData.ShippingPostalCode = this.ShippingPostalCode;
        }else if(this.setTheObjectName2 === 'Contact'){
            this.newData.MailingStreet = this.MailingStreet;
            this.newData.MailingCountryCode = this.MailingCountryCode;
            this.newData.MailingCity = this.MailingCity;
            this.newData.MailingStateCode = this.MailingStateCode;
            this.newData.MailingPostalCode = this.MailingPostalCode;
        }
        this.newData.objectName = this.setTheObjectName2;
        this.newData.recordTypeId = this.recordTypeId;
        this.dispatchEvent(new CustomEvent('next', { detail: {data : this.newData, isCreateScreen : true, isCompareScreen : false}}));
    }

    // call apex method on button click 
    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }

    handleChangeAddressField(event){
        if(event.detail.AddressType === 'BillingAddress'){
            this.BillingStreet=event.detail.Street;
            this.BillingCountryCode=event.detail.Country;
            this.BillingCity=event.detail.City;
            this.BillingStateCode=event.detail.State;
            this.BillingPostalCode=event.detail.PostalCode;
        }else if(event.detail.AddressType === 'ShippingAddress'){
            this.ShippingStreet=event.detail.Street;
            this.ShippingCountryCode=event.detail.Country;
            this.ShippingCity=event.detail.City;
            this.ShippingStateCode=event.detail.State;
            this.ShippingPostalCode=event.detail.PostalCode;
        }else if(event.detail.AddressType === 'MailingAddress'){
            this.MailingStreet=event.detail.Street;
            this.MailingCountryCode=event.detail.Country;
            this.MailingCity=event.detail.City;
            this.MailingStateCode=event.detail.State;
            this.MailingPostalCode=event.detail.PostalCode;
        }
    }
}