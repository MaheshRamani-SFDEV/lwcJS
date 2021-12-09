import { LightningElement, track, api, wire} from 'lwc';
// import server side apex class method 
import getCreateFieldList from '@salesforce/apex/customCreateNewRecordController.getCreateFieldList';
//import createRecord from '@salesforce/apex/customCreateNewRecordController.createRecord';
// import standard toast event 
//import {ShowToastEvent} from 'lightning/platformShowToastEvent'
 
export default class customCreateNewRecord extends LightningElement {
   // @api fields = ['Name', 'CIN__C', 'CRS__c', 'NAICS_Description__c','OwnerId', 'CreatedDate', 'BillingAddress'];
    @api setTheProcessName;
    @api setTheObjectName2;
    @track createFields;
    @track createScreen;
    @track searchScreen;
    @track compareScreen;
    @track choiceScreen;
    @track isAddressField = true;
    @wire(getCreateFieldList, {ProcessName : '$setTheProcessName', sObjectName : '$setTheObjectName2'}) createFields;
    //@track: Marks a property for internal monitoring. A template or function using- 
    //this property forces a component to rerender when the property’s value changes.
    @track accounts;
    //@track searchObject = {};
    sVal = '';
 
    // update sVal var when input field value change
    updateSeachKey(event) {
        this.sVal = event.target.value;
    }

   /* connectedCallback(){
        this.createFields.forEach(function(){
                    
        }); 
    }*/
 
    // call apex method on button click 
    /*handleSave() {
        // if search input value is not blank then call apex method, else display error msg 
        if (this.sVal !== '') {
        
            /*createRecord({searchKey: this.sVal})
                .then(result => {
                    // set @track accounts variable with return account list from server  
                    this.accounts = result;
                    // eslint-disable-next-line no-alert
                    //window.alert('Search result is===> '+ this.accounts);
                })
                .catch(error => {
                    // display server exception in toast msg 
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: error.body.message,
                    });
                    this.dispatchEvent(event);
                    // reset accounts var with null   
                    this.accounts = null;
                });*/
        /*} else {
            // fire toast event if input field is blank
            const event = new ShowToastEvent({
                variant: 'error',
                message: 'Search text missing..',
            });
            this.dispatchEvent(event);
        }
    }*/

    // call apex method on button click
    handleReturn() {
        this.createScreen = false;
        this.searchScreen = true;
        this.compareScreen = false;
        this.choiceScreen = false;
        this.dispatchEvent(new CustomEvent('previous', { detail: {create: this.createScreen, search : this.searchScreen, compare : this.compareScreen, choice : this.choiceScreen}}));             
    }

   
    // call apex method on button click
    handleSave() {
        if(this.setTheObjectName2 === 'Contact'){
            this.choiceScreen = true;
            this.searchScreen = false;
        }else{
            this.choiceScreen = false;
            this.searchScreen = true; 
        }
        this.createScreen = false;
        this.compareScreen = false;
        this.dispatchEvent(new CustomEvent('next', { detail: {create: this.createScreen, search : this.searchScreen, compare: this.compareScreen, choice : this.cohiceScreen}}));       
    }

    // call apex method on button click 
    handleCancel() {
        this.dispatchEvent(new CustomEvent('cancel'));
    }
    
}