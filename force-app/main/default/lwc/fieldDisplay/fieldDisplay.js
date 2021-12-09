import { LightningElement,api,track } from 'lwc';

export default class FieldDisplay extends LightningElement {

    @track isEditable;
    @api objectName;
    @api recordId;
    @api fieldName;


    handleValueChange() {      
        this.dispatchEvent(new CustomEvent('valueChange'));  
    }

}