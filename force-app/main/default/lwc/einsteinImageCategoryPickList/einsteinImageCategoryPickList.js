import {LightningElement, api, track, wire} from 'lwc';
import {getPicklistValues, getObjectInfo} from 'lightning/uiObjectInfoApi';

export default class einsteinImageCategoryPickList extends LightningElement {
    @api objAPIName;
    @api fieldAPIName;
    @track options = [];
    // pick list label
    @track picklistlabel;
    @track error;
    @track isLoadingFinish = false;
    recordTypeId;
    objfieldAPIName;
    @track selectedValue;

    connectedCallback(){
        this.selectedValue = null;
    }
    @wire(getObjectInfo, {objectApiName: '$objAPIName'})
    objectInfo(result) {
        if(result.data) {
            // Field Data
            let fieldData = result.data.fields[this.fieldAPIName];
            if(fieldData) {
                this.picklistlabel = fieldData.label;
            
                this.objfieldAPIName = {};
                this.objfieldAPIName.fieldApiName = fieldData.apiName;
                this.objfieldAPIName.objectApiName = result.data.apiName;
    
                this.recordTypeId = result.data.defaultRecordTypeId;
            }
            else {
                this.error = 'Please enter valid field api name';
            }
        }
        else if(result.error) {
            this.error = JSON.stringify(result.error);
        }
    }
    
    @wire(getPicklistValues, {recordTypeId: '$recordTypeId', fieldApiName: '$objfieldAPIName'})
    picklistValues({error, data}) {
        if (data) {

            let picklistOptions = [{ label: '--None--', value: null}];

            // Picklist values
            data.values.forEach(key => {
                picklistOptions.push({
                    label: key.label, 
                    value: key.value
                })
            });
            this.options = picklistOptions;
            this.isLoadingFinish = true;
        } else if (error) {
            this.isLoadingFinish = false;
            this.error = JSON.stringify(error);
        }
    }

    handleValueChange(event) {
        this.selectedValue = event.target.value;
        console.log('fiel value change');
        this.dispatchEvent(new CustomEvent('selected', {detail: {selectedImageCategory: this.selectedValue}}));
    }
}