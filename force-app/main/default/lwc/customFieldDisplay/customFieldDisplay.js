import { LightningElement, api, track } from 'lwc';

export default class customFieldDisplay extends LightningElement {
    @track isEditable;
    @api objectName1;
    @api objectName2;
    @api recordId1;
    @api recordId2;
    @api fieldName;
    @track type = true;

    connectedCallback(){
        //this.recordId1 = '00QW0000007S41FMAS';
        //console.log('## leadRecordId1-->'+this.recordId1);
        //console.log('## selectedAccountRecord2-->'+this.recordId2);
        if(this.fieldName === 'CreatedDate' || this.fieldName === 'LastModifiedDate'){
            this.type = false;
        }else{
            this.type = true;
        }
    }
    handleValueChange() {      
        this.dispatchEvent(new CustomEvent('valueChange'));  
    }

}