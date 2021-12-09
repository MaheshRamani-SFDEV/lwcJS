import { LightningElement, wire, track, api} from 'lwc';

import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
// import standard toast event 
import {ShowToastEvent} from 'lightning/platformShowToastEvent'
import ACCOUNT_OBJ from '@salesforce/schema/Account';
import CONTACT_OBJ from '@salesforce/schema/Contact';

export default class customAddressField extends LightningElement {
    @api isRequired = false;
    @api isEditable = false;
    @api isBillingAddress = false;
    @api isShippingAddress = false;
    @api isMailingAddress = false;
    @api containerContext;
    @track error;
    @track objectInfo;
    @track accRecordTypeId = '';
    @track conRecordTypeId = '';
    @api address;
    @track billing_country;
    @track shipping_country;
    @track mailing_country;
    @track totalBillingDependentValues=[];
    @track totalShippingDependentValues=[];
    @track totalMailingDependentValues=[];
    @track billingDependentValues = [];
    @track shippingDependentValues = [];
    @track mailingDependentValues = [];
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
    @track isLoadingFinish = false;

    @wire(getObjectInfo, { objectApiName : ACCOUNT_OBJ})
    wireObjectInfo1({ data, error }) {
        if (data) {
            let getData = data;
            // run a for-in loop and process all record types
            for (let obj in getData.recordTypeInfos) {
                if (!getData.recordTypeInfos[obj].master && getData.recordTypeInfos[obj].available) { // skip master record type
                    if(getData.recordTypeInfos[obj].name === 'Client/Prospect'){
                        this.accRecordTypeId = getData.recordTypeInfos[obj].recordTypeId;
                    }
                }
            }
        }else if (error) {
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
    @wire(getObjectInfo, { objectApiName : CONTACT_OBJ})
    wireObjectInfo2({ data, error }) {
        if (data) {
            let getData = data;
            // run a for-in loop and process all record types
            for (let obj in getData.recordTypeInfos) {
                if (!getData.recordTypeInfos[obj].master && getData.recordTypeInfos[obj].available) { // skip master record type
                    if(getData.recordTypeInfos[obj].name === 'External Contact'){
                        this.conRecordTypeId = getData.recordTypeInfos[obj].recordTypeId;
                    }
                }
            }
        }else if (error) {
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

    @wire(getPicklistValuesByRecordType, { recordTypeId: '$accRecordTypeId', objectApiName : ACCOUNT_OBJ})
     wiredRecordtypeValues1({ data, error }){
            if(data){
                let billingCountryOptions = [];
                data.picklistFieldValues.BillingCountryCode.values.forEach(key => {
                billingCountryOptions.push({
                    label : key.label,
                    value: key.value
                })
            });
            this.billing_country = billingCountryOptions;
            let billingStateOptions=[];
            this.billingControlValues  = data.picklistFieldValues.BillingStateCode.controllerValues;
            this.totalBillingDependentValues =data.picklistFieldValues.BillingStateCode.values;
            this.totalBillingDependentValues.forEach(key => {
            if(key.validFor[0] === this.billingControlValues[this.address.CountryCode]) {
                billingStateOptions.push({
                    label : key.label,
                    value: key.value
                })
            }
            });
            this.billingDependentValues = billingStateOptions;

            let shippingCountryOptions = [];
            data.picklistFieldValues.ShippingCountryCode.values.forEach(key => {
                shippingCountryOptions.push({
                    label : key.label,
                    value: key.value
                })
            });
            this.shipping_country = shippingCountryOptions;
            let shippingStateOptions=[];
            this.shippingControlValues  = data.picklistFieldValues.ShippingStateCode.controllerValues;
            this.totalShippingDependentValues =data.picklistFieldValues.ShippingStateCode.values;

            this.totalShippingDependentValues.forEach(key => {
            if(key.validFor[0] === this.shippingControlValues[this.address.CountryCode]){
                shippingStateOptions.push({
                    label : key.label,
                    value: key.value
                })
            }
            });
            this.shippingDependentValues = shippingStateOptions;
            this.isLoadingFinish = true;
        }else if(error){
            this.isLoadingFinish = false;
            this.error = error;
            this.pickListvalues = undefined;
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
        }
     }

     @wire(getPicklistValuesByRecordType, { recordTypeId: '$conRecordTypeId', objectApiName : CONTACT_OBJ})
     wiredRecordtypeValues2({ data, error }){
        if(data){
            let mailingCountryOptions = [];
            data.picklistFieldValues.MailingCountryCode.values.forEach(key => {
                mailingCountryOptions.push({
                    label : key.label,
                    value: key.value
                })
            });
            this.mailing_country = mailingCountryOptions;
            let mailingStateOptions=[];
            this.mailingControlValues  = data.picklistFieldValues.MailingStateCode.controllerValues;
            this.totalMailingDependentValues =data.picklistFieldValues.MailingStateCode.values;
            
            this.totalMailingDependentValues.forEach(key => {
            if(key.validFor[0] === this.mailingControlValues[this.address.CountryCode]) {
                mailingStateOptions.push({
                    label : key.label,
                    value: key.value
                })
            }
            });
            this.mailingDependentValues = mailingStateOptions;
            this.isLoadingFinish = true;
        }else if(error){
            this.isLoadingFinish = false;
            this.error = error;
            this.pickListvalues = undefined;
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
        }
     }

    get getBillingCountryOptions() {
        return this.billing_country;
    }
    get getShippingCountryOptions() {
        return this.shipping_country;
    }
    get getMailingCountryOptions() {
        return this.mailing_country;
    }

    get getBillingProvinceOptions() {
        return this.billingDependentValues;
    }
    get getShippingProvinceOptions() {
        return this.shippingDependentValues;
    }
    get getMailingProvinceOptions() {    
        return this.mailingDependentValues;
    }

    handleBillingChange(event) {
        let ctry=event.detail.country;
        let dependValues = [];
        this.totalBillingDependentValues.forEach(conValues => {
        if(conValues.validFor[0] === this.billingControlValues[ctry]) {
            dependValues.push({
                label: conValues.label,
                value: conValues.value
            })
        }
        })
        this.billingDependentValues = dependValues;
        this.dispatchEvent(new CustomEvent('changeaddressfield', { detail: {AddressType : 'BillingAddress', Street : event.detail.street, City : event.detail.city, State : event.detail.province, Country : event.detail.country, PostalCode : event.detail.postalCode}}));
    }

    handleShippingChange(event) {
        let ctry=event.detail.country
        let dependValues = [];
        this.totalShippingDependentValues.forEach(conValues => {
            if(conValues.validFor[0] === this.shippingControlValues[ctry]) {
                dependValues.push({
                    label: conValues.label,
                    value: conValues.value
                })
            }
        })
        this.shippingDependentValues = dependValues;
        this.dispatchEvent(new CustomEvent('changeaddressfield', { detail: {AddressType : 'ShippingAddress', Street : event.detail.street, City : event.detail.city, State : event.detail.province, Country : event.detail.country, PostalCode : event.detail.postalCode}}));
    }

    handleMailingChange(event) {
        let ctry=event.detail.country;
        let dependValues = [];
        this.totalMailingDependentValues.forEach(conValues => {
            if(conValues.validFor[0] === this.mailingControlValues[ctry]) {
                dependValues.push({
                    label: conValues.label,
                    value: conValues.value
                })
            }
        })
        this.mailingDependentValues = dependValues;
        this.dispatchEvent(new CustomEvent('changeaddressfield', { detail: {AddressType : 'MailingAddress', Street : event.detail.street, City : event.detail.city, State : event.detail.province, Country : event.detail.country, PostalCode : event.detail.postalCode}})); 
    }
}