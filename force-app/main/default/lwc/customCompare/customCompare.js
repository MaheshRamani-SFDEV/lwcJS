import { LightningElement, track, api, wire} from 'lwc';
// import server side apex class method 
import getCompareFields from '@salesforce/apex/CustomCompareController.getCompareFields';
//import getCompareFields from '@salesforce/apex/customCompareController.getCompareFields';
import getAccountRecord from '@salesforce/apex/CustomCompareController.getAccountRecord';
import getLeadRecord from '@salesforce/apex/CustomCompareController.getLeadRecord';
// import standard toast event 
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

export default class CustomCompare extends LightningElement {
    @api processName ='Custom Lead Conversion';
   // @api selectedAccountRecordId ='001W000000pqGxMIAU'; //Test 1
   // @api leadRecordId ='00QW00000050jMuMAI'; //XYZ 123

    @api selectedAccountRecordId;
    @api leadRecordId;

    @api leadRecord;
    @api selectedAccountRecord;
    @wire(getCompareFields, {processName : '$processName'}) compareFields;
    @track selectedStep = 'Account Data';


    connectedCallback() { 
        console.log('## leadRecordId-->'+leadRecordId);
        console.log('## selectedAccountRecord-->'+selectedAccountRecord);
        getAccountRecord({accountRecordId: this.selectedAccountRecordId})
            .then(result => {
                // set @track accounts variable with return account list from server  
                this.selectedAccountRecord = result;
                // eslint-disable-next-line no-alert
                console.log('Account result is===> '+ JSON.stringify(this.selectedAccountRecord));
            })
            .catch(error => {
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message,
                });               
            });


            getLeadRecord({leadRecordId: this.leadRecordId})
            .then(result => {
                // set @track accounts variable with return account list from server  
                this.leadRecord = result;
                // eslint-disable-next-line no-alert
                console.log('Lead result is===> '+ JSON.stringify(this.leadRecord));
            })
            .catch(error => {
                // display server exception in toast msg 
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body.message,
                });              
            });
    } 

    // call apex method on button click
    handleSave() {      
        this.dispatchEvent(new CustomEvent('next')); 
        
        let compareFields = this.compareFields;
       // alert(JSON.stringify(compareFields));
        
        console.log('## Compare Fields-->'+JSON.stringify(compareFields));
        console.log('## Selected Account REcord-->'+JSON.stringify(this.selectedAccountRecord));
        console.log('## Selected Lead REcord-->'+JSON.stringify(this.leadRecord));
        
        //if(this.selectedStep === 'Account Data'){
            this.selectedStep = 'Contact Search';
       // }
    }

   
    handleCancel() {        
        this.dispatchEvent(new CustomEvent('cancel'));
        //this.previousHandler();
        //if(this.selectedStep === 'Account Data'){
            this.selectedStep = 'Account Search';
       // }
    }

    // call apex method on button click 
    handleReturn(){        
        this.dispatchEvent(new CustomEvent('previous'));
        //if(this.selectedStep === 'Account Data'){
            this.selectedStep = 'Account Search';
        //}       
    }

    selectAllLeadData(){
        console.log('## Select all lead data');
    }

    selectAllAccountData(){
        console.log('## Select all Account data');
    }

}