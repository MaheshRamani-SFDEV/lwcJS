import { LightningElement, api, wire} from 'lwc';
// import server side apex class method 
import getCompareFields from '@salesforce/apex/CustomCompareController.getCompareFields';
//import getCompareFields from '@salesforce/apex/customCompareController.getCompareFields';


export default class customStareAndCompare extends LightningElement {
    @api setTheCompareRecord1;
    @api setTheCompareRecord2;
    @api setTheProcessName;
    @api setTheObjectName1;
    @api setTheObjectName2;
    @api compareFields;

    //@api selectedAccountRecord;
    @wire(getCompareFields, {processName : '$setTheProcessName', objectName :'$setTheObjectName2'}) compareFields;
    //@track selectedStep = 'Account Data';

    /*connectedCallback() { 
        console.log('## leadRecordId-->'+this.setTheCompareRecord1);
        console.log('## selectedAccountRecord-->'+this.setTheCompareRecord2);
    } */
   
    // call apex method on button click
    handleReturn() {
        //this.setTheObjectName = 'Contact';
        this.createNewScreen = false;
        this.searchScreen = true;
        this.compareScreen = false;
        this.dispatchEvent(new CustomEvent('previous', { detail: {create: this.createNewScreen, search : this.searchScreen, compare: this.compareScreen}}));       
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
    

    // call apex method on button click 
    handleSave(){
        //this.setTheObjectName = 'Account';
        this.searchScreen = true;
        this.createNewScreen = false;
        this.compareScreen = false;
        this.dispatchEvent(new CustomEvent('next', { detail: {create: this.createNewScreen, search : this.searchScreen, compare: this.compareScreen}}));       
        //this.nextHandler();
    }
selectAllLeadData(){
    console.log('## Select all lead data');
}

selectAllAccountData(){
    console.log('## Select all Account data');
}

}